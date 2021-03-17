//Original Code from https://github.com/DarthShader/Kaj-Unity-Shaders
/**MIT License

Copyright (c) 2020 DarthShader

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.**/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;
using System.Globalization;
using System.Linq;
#if VRC_SDK_VRCSDK2 || VRC_SDK_VRCSDK3
using VRC.SDKBase.Editor.BuildPipeline;
#endif
// v9

namespace Thry
{
    
    public enum LightMode
    {
        Always=1,
        ForwardBase=2,
        ForwardAdd=4,
        Deferred=8,
        ShadowCaster=16,
        MotionVectors=32,
        PrepassBase=64,
        PrepassFinal=128,
        Vertex=256,
        VertexLMRGBM=512,
        VertexLM=1024
    }

    // Static methods to generate new shader files with in-place constants based on a material's properties
    // and link that new shader to the material automatically
    public class ShaderOptimizer
    {
        // For some reason, 'if' statements with replaced constant (literal) conditions cause some compilation error
        // So until that is figured out, branches will be removed by default
        // Set to false if you want to keep UNITY_BRANCH and [branch]
        public static bool RemoveUnityBranches = true;

        // LOD Crossfade Dithing doesn't have multi_compile keyword correctly toggled at build time (its always included) so
        // this hard-coded material property will uncomment //#pragma multi_compile _ LOD_FADE_CROSSFADE in optimized .shader files
        public static readonly string LODCrossFadePropertyName = "_LODCrossfade";

        // IgnoreProjector and ForceNoShadowCasting don't work as override tags, so material properties by these names
        // will determine whether or not //"IgnoreProjector"="True" etc. will be uncommented in optimized .shader files
        public static readonly string IgnoreProjectorPropertyName = "_IgnoreProjector";
        public static readonly string ForceNoShadowCastingPropertyName = "_ForceNoShadowCasting";

        // Material property suffix that controls whether the property of the same name gets baked into the optimized shader
        // e.g. if _Color exists and _ColorAnimated = 1, _Color will not be baked in
        public static readonly string AnimatedPropertySuffix = "Animated";

        // Currently, Material.SetShaderPassEnabled doesn't work on "ShadowCaster" lightmodes,
        // and doesn't let "ForwardAdd" lights get turned into vertex lights if "ForwardAdd" is simply disabled
        // vs. if the pases didn't exist at all in the shader.
        // The Optimizer will take a mask property by this name and attempt to correct these issues
        // by hard-removing the shadowcaster and fwdadd passes from the shader being optimized.
        public static readonly string DisabledLightModesPropertyName = "_LightModes";

        // Property that determines whether or not to evaluate KSOInlineSamplerState comments.
        // Inline samplers can be used to get a wider variety of wrap/filter combinations at the cost
        // of only having 1x anisotropic filtering on all textures
        public static readonly string UseInlineSamplerStatesPropertyName = "_InlineSamplerStates";
        private static bool UseInlineSamplerStates = true;

        // Material properties are put into each CGPROGRAM as preprocessor defines when the optimizer is run.
        // This is mainly targeted at culling interpolators and lines that rely on those interpolators.
        // (The compiler is not smart enough to cull VS output that isn't used anywhere in the PS)
        // Additionally, simply enabling the optimizer can define a keyword, whose name is stored here.
        // This keyword is added to the beginning of all passes, right after CGPROGRAM
        public static readonly string OptimizerEnabledKeyword = "OPTIMIZER_ENABLED";

        // Mega shaders are expected to have geometry and tessellation shaders enabled by default,
        // but with the ability to be disabled by convention property names when the optimizer is run.
        // Additionally, they can be removed per-lightmode by the given property name plus 
        // the lightmode name as a suffix (e.g. group_toggle_GeometryShadowCaster)
        // Geometry and Tessellation shaders are REMOVED by default, but if the main gorups
        // are enabled certain pass types are assumed to be ENABLED
        public static readonly string GeometryShaderEnabledPropertyName = "group_toggle_Geometry";
        public static readonly string TessellationEnabledPropertyName = "group_toggle_Tessellation";
        private static bool UseGeometry = false;
        private static bool UseGeometryForwardBase = true;
        private static bool UseGeometryForwardAdd = true;
        private static bool UseGeometryShadowCaster = true;
        private static bool UseGeometryMeta = true;
        private static bool UseTessellation = false;
        private static bool UseTessellationForwardBase = true;
        private static bool UseTessellationForwardAdd = true;
        private static bool UseTessellationShadowCaster = true;
        private static bool UseTessellationMeta = false;

        // Tessellation can be slightly optimized with a constant max tessellation factor attribute
        // on the hull shader.  A non-animated property by this name will replace the argument of said
        // attribute if it exists.
        public static readonly string TessellationMaxFactorPropertyName = "_TessellationFactorMax";

        private static string CurrentLightmode = "";

        // In-order list of inline sampler state names that will be replaced by InlineSamplerState() lines
        public static readonly string[] InlineSamplerStateNames = new string[]
        {
            "_linear_repeat",
            "_linear_clamp",
            "_linear_mirror",
            "_linear_mirroronce",
            "_point_repeat",
            "_point_clamp",
            "_point_mirror",
            "_point_mirroronce",
            "_trilinear_repeat",
            "_trilinear_clamp",
            "_trilinear_mirror",
            "_trilinear_mirroronce"
        };

        // Would be better to dynamically parse the "C:\Program Files\UnityXXXX\Editor\Data\CGIncludes\" folder
        // to get version specific includes but eh
        public static readonly string[] DefaultUnityShaderIncludes = new string[]
        {
            "UnityUI.cginc",
            "AutoLight.cginc",
            "GLSLSupport.glslinc",
            "HLSLSupport.cginc",
            "Lighting.cginc",
            "SpeedTreeBillboardCommon.cginc",
            "SpeedTreeCommon.cginc",
            "SpeedTreeVertex.cginc",
            "SpeedTreeWind.cginc",
            "TerrainEngine.cginc",
            "TerrainSplatmapCommon.cginc",
            "Tessellation.cginc",
            "UnityBuiltin2xTreeLibrary.cginc",
            "UnityBuiltin3xTreeLibrary.cginc",
            "UnityCG.cginc",
            "UnityCG.glslinc",
            "UnityCustomRenderTexture.cginc",
            "UnityDeferredLibrary.cginc",
            "UnityDeprecated.cginc",
            "UnityGBuffer.cginc",
            "UnityGlobalIllumination.cginc",
            "UnityImageBasedLighting.cginc",
            "UnityInstancing.cginc",
            "UnityLightingCommon.cginc",
            "UnityMetaPass.cginc",
            "UnityPBSLighting.cginc",
            "UnityShaderUtilities.cginc",
            "UnityShaderVariables.cginc",
            "UnityShadowLibrary.cginc",
            "UnitySprites.cginc",
            "UnityStandardBRDF.cginc",
            "UnityStandardConfig.cginc",
            "UnityStandardCore.cginc",
            "UnityStandardCoreForward.cginc",
            "UnityStandardCoreForwardSimple.cginc",
            "UnityStandardInput.cginc",
            "UnityStandardMeta.cginc",
            "UnityStandardParticleInstancing.cginc",
            "UnityStandardParticles.cginc",
            "UnityStandardParticleShadow.cginc",
            "UnityStandardShadow.cginc",
            "UnityStandardUtils.cginc"
        };

        public static readonly char[] ValidSeparators = new char[] {' ','\t','\r','\n',';',',','.','(',')','[',']','{','}','>','<','=','!','&','|','^','+','-','*','/','#' };

        public static readonly string[] ValidPropertyDataTypes = new string[]
        {
            "float",
            "float2",
            "float3",
            "float4",
            "half",
            "half2",
            "half3",
            "half4",
            "fixed",
            "fixed2",
            "fixed3",
            "fixed4",
            "int"
        };

        public static readonly string[] IllegalPropertyRenames = new string[]
        {
            "_Color",
            "_EmissionColor",
            "_BumpScale",
            "_Cutoff",
            "_DetailNormalMapScale",
            "_DstBlend",
            "_GlossMapScale",
            "_Glossiness",
            "_GlossyReflections",
            "_Metallic",
            "_Mode",
            "_OcclusionStrength",
            "_Parallax",
            "_SmoothnessTextureChannel",
            "_SpecularHighlights",
            "_SrcBlend",
            "_UVSec",
            "_ZWrite"
        };

        public enum PropertyType
        {
            Vector,
            Float
        }

        public class PropertyData
        {
            public PropertyType type;
            public string name;
            public Vector4 value;
        }

        public class Macro
        {
            public string name;
            public string[] args;
            public string contents;
        }

        public class ParsedShaderFile
        {
            public string filePath;
            public string[] lines;
        }

        public class TextureProperty
        {
            public string name;
            public Texture texture;
            public int uv;
            public Vector2 scale;
            public Vector2 offset;
        }

        public class GrabPassReplacement
        {
            public string originalName;
            public string newName;
        }

        public static bool Lock(Material material, MaterialProperty[] props, bool applyShaderLater = false)
        {
            // File filepaths and names
            Shader shader = material.shader;
            string shaderFilePath = AssetDatabase.GetAssetPath(shader);
            string materialFilePath = AssetDatabase.GetAssetPath(material);
            string materialFolder = Path.GetDirectoryName(materialFilePath);
            string smallguid = Guid.NewGuid().ToString().Split('-')[0];
            string newShaderName = "Hidden/" + shader.name + "/" + material.name + "-" + smallguid;
            //string newShaderDirectory = materialFolder + "/OptimizedShaders/" + material.name + "-" + smallguid + "/";
            string newShaderDirectory = materialFolder + "/OptimizedShaders/" + smallguid + "/";

            // suffix for animated properties when renaming is enabled
            string animPropertySuffix = new string(material.name.Trim().ToLower().Where(char.IsLetter).ToArray());

            // Get collection of all properties to replace
            // Simultaneously build a string of #defines for each CGPROGRAM
            StringBuilder definesSB = new StringBuilder();
            // Append convention OPTIMIZER_ENABLED keyword
            definesSB.Append(Environment.NewLine);
            definesSB.Append("#define ");
            definesSB.Append(OptimizerEnabledKeyword);
            definesSB.Append(Environment.NewLine);
            // Append all keywords active on the material
            foreach (string keyword in material.shaderKeywords)
            {
                if (keyword == "") continue; // idk why but null keywords exist if _ keyword is used and not removed by the editor at some point
                definesSB.Append("#define ");
                definesSB.Append(keyword);
                definesSB.Append(Environment.NewLine);
            }

            Dictionary<string, bool> uncommentKeywords = new Dictionary<string, bool>();
            List<PropertyData> constantProps = new List<PropertyData>();
            List<MaterialProperty> animatedPropsToRename = new List<MaterialProperty>();
            List<MaterialProperty> animatedPropsToDuplicate = new List<MaterialProperty>();
            foreach (MaterialProperty prop in props)
            {
                if (prop == null) continue;

                if(Regex.IsMatch(prop.name, @".*_commentIfOne_(\d|\w)+") && prop.floatValue == 1)
                {
                    string key = Regex.Match(prop.name, @"_commentIfOne_(\d|\w)+").Value.Replace("_commentIfOne_","");
                    uncommentKeywords.Add(key, false);
                }
                if (Regex.IsMatch(prop.name, @".*_commentIfZero_(\d|\w)+") && prop.floatValue == 0)
                {
                    string key = Regex.Match(prop.name, @"_commentIfZero_(\d|\w)+").Value.Replace("_commentIfZero_", "");
                    uncommentKeywords.Add(key, false);
                }

                // Every property gets turned into a preprocessor variable
                switch (prop.type)
                {
                    case MaterialProperty.PropType.Float:
                    case MaterialProperty.PropType.Range:
                        definesSB.Append("#define PROP");
                        definesSB.Append(prop.name.ToUpper());
                        definesSB.Append(' ');
                        definesSB.Append(prop.floatValue.ToString(CultureInfo.InvariantCulture));
                        definesSB.Append(Environment.NewLine);
                        break;
                    case MaterialProperty.PropType.Texture:
                        if (prop.textureValue != null)
                        {
                            definesSB.Append("#define PROP");
                            definesSB.Append(prop.name.ToUpper());
                            definesSB.Append(Environment.NewLine);
                        }
                        break;
                }

                if (prop.name.EndsWith(AnimatedPropertySuffix)) continue;
                else if (prop.name == UseInlineSamplerStatesPropertyName)
                {
                    UseInlineSamplerStates = (prop.floatValue == 1);
                    continue;
                }
                else if (prop.name.StartsWith(GeometryShaderEnabledPropertyName))
                {
                    if (prop.name == GeometryShaderEnabledPropertyName)
                        UseGeometry = (prop.floatValue == 1);
                    else if (prop.name == GeometryShaderEnabledPropertyName + "ForwardBase")
                        UseGeometryForwardBase = (prop.floatValue == 1);
                    else if (prop.name == GeometryShaderEnabledPropertyName + "ForwardAdd")
                        UseGeometryForwardAdd = (prop.floatValue == 1);
                    else if (prop.name == GeometryShaderEnabledPropertyName + "ShadowCaster")
                        UseGeometryShadowCaster = (prop.floatValue == 1);
                    else if (prop.name == GeometryShaderEnabledPropertyName + "Meta")
                        UseGeometryMeta = (prop.floatValue == 1);
                }
                else if (prop.name.StartsWith(TessellationEnabledPropertyName))
                {
                    if (prop.name == TessellationEnabledPropertyName)
                        UseTessellation = (prop.floatValue == 1);
                    else if (prop.name == TessellationEnabledPropertyName + "ForwardBase")
                        UseTessellationForwardBase = (prop.floatValue == 1);
                    else if (prop.name == TessellationEnabledPropertyName + "ForwardAdd")
                        UseTessellationForwardAdd = (prop.floatValue == 1);
                    else if (prop.name == TessellationEnabledPropertyName + "ShadowCaster")
                        UseTessellationShadowCaster = (prop.floatValue == 1);
                    else if (prop.name == TessellationEnabledPropertyName + "Meta")
                        UseTessellationMeta = (prop.floatValue == 1);
                }



                // Check for the convention 'Animated' Property to be true otherwise assume all properties are constant
                // nlogn trash
                MaterialProperty animatedProp = Array.Find(props, x => x.name == prop.name + AnimatedPropertySuffix);
                if (animatedProp != null && animatedProp.floatValue > 0)
                {
                    // check if we're renaming the property as well
                    if (animatedProp.floatValue == 2)
                    {
                        if (prop.type != MaterialProperty.PropType.Texture &&
                                !prop.name.EndsWith("UV") && !prop.name.EndsWith("Pan")) // this property might be animated, but we're not allowed to rename it. this will break things.
                        {
                            // be sure we're not renaming stuff like _MainTex that should always be named the same
                            if (!Array.Exists(IllegalPropertyRenames, x => x.Equals(prop.name, StringComparison.InvariantCultureIgnoreCase)))
                            {
                                animatedPropsToRename.Add(prop);
                            }
                            else
                            {
                                //stuff like main tex should be duplicated instead of rename to allow for fallback
                                animatedPropsToDuplicate.Add(prop);
                            }
                        }
                    }

                    continue;
                }

                PropertyData propData;
                switch(prop.type)
                {
                    case MaterialProperty.PropType.Color:
                        propData = new PropertyData();
                        propData.type = PropertyType.Vector;
                        propData.name = prop.name;
                        if ((prop.flags & MaterialProperty.PropFlags.HDR) != 0)
                        {
                            if ((prop.flags & MaterialProperty.PropFlags.Gamma) != 0)
                                propData.value = prop.colorValue.linear;
                            else propData.value = prop.colorValue;
                        }
                        else if ((prop.flags & MaterialProperty.PropFlags.Gamma) != 0)
                            propData.value = prop.colorValue;
                        else propData.value = prop.colorValue.linear;
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Vector:
                        propData = new PropertyData();
                        propData.type = PropertyType.Vector;
                        propData.name = prop.name;
                        propData.value = prop.vectorValue;
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Float:
                    case MaterialProperty.PropType.Range:
                        propData = new PropertyData();
                        propData.type = PropertyType.Float;
                        propData.name = prop.name;
                        propData.value = new Vector4(prop.floatValue, 0, 0, 0);
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Texture:
                        animatedProp = Array.Find(props, x => x.name == prop.name + "_ST" + AnimatedPropertySuffix);
                        if (!(animatedProp != null && animatedProp.floatValue == 1))
                        {
                            PropertyData ST = new PropertyData();
                            ST.type = PropertyType.Vector;
                            ST.name = prop.name + "_ST";
                            Vector2 offset = material.GetTextureOffset(prop.name);
                            Vector2 scale = material.GetTextureScale(prop.name);
                            ST.value = new Vector4(scale.x, scale.y, offset.x, offset.y);
                            constantProps.Add(ST);
                        }
                        animatedProp = Array.Find(props, x => x.name == prop.name + "_TexelSize" + AnimatedPropertySuffix);
                        if (!(animatedProp != null && animatedProp.floatValue == 1))
                        {
                            PropertyData TexelSize = new PropertyData();
                            TexelSize.type = PropertyType.Vector;
                            TexelSize.name = prop.name + "_TexelSize";
                            Texture t = prop.textureValue;
                            if (t != null)
                                TexelSize.value = new Vector4(1.0f / t.width, 1.0f / t.height, t.width, t.height);
                            else TexelSize.value = new Vector4(1.0f, 1.0f, 1.0f, 1.0f);
                            constantProps.Add(TexelSize);
                        }
                        break;
                }
            }
            string optimizerDefines = definesSB.ToString();

            // Get list of lightmode passes to delete
            List<string> disabledLightModes = new List<string>();
            var disabledLightModesProperty = Array.Find(props, x => x.name == DisabledLightModesPropertyName);
            if (disabledLightModesProperty != null)
            {
                int lightModesMask = (int)disabledLightModesProperty.floatValue;
                if ((lightModesMask & (int)LightMode.ForwardAdd) != 0)
                    disabledLightModes.Add("ForwardAdd");
                if ((lightModesMask & (int)LightMode.ShadowCaster) != 0)
                    disabledLightModes.Add("ShadowCaster");
            }
                
            // Parse shader and cginc files, also gets preprocessor macros
            List<ParsedShaderFile> shaderFiles = new List<ParsedShaderFile>();
            List<Macro> macros = new List<Macro>();
            if (!ParseShaderFilesRecursive(shaderFiles, newShaderDirectory, shaderFilePath, macros))
                return false;

            int longestCommonDirectoryPathLength = GetLongestCommonDirectoryLength(shaderFiles.Select(s => s.filePath).ToArray());

            int commentKeywords = 0;

            List<GrabPassReplacement> grabPassVariables = new List<GrabPassReplacement>();
            // Loop back through and do macros, props, and all other things line by line as to save string ops
            // Will still be a massive n2 operation from each line * each property
            foreach (ParsedShaderFile psf in shaderFiles)
            {
                // replace property names when prop is animated
                for (int i = 0; i < psf.lines.Length; i++)
                {
                    foreach (var animProp in animatedPropsToRename)
                    {
                        // don't have to match if that prop does not even exist in that line
                        if (psf.lines[i].Contains(animProp.name))
                        {
                            // this is a terrible hack. but it makes sure we're not removing whatever comes after our property name. no idea how to do this better.
                            // there should be only 1 character after our property name which is either a whitespace, a semicolon or a bracket.
                            // this will ensure we're not removing it.
                            // let's say it like this. It just works.
                            string pattern = animProp.name + @"([^a-zA-Z\d]|$)";
                            MatchCollection matches = Regex.Matches(psf.lines[i], pattern, RegexOptions.Multiline);
                            foreach (Match match in matches)
                            {
                                psf.lines[i] = psf.lines[i].Replace(match.Groups[0].Value, animProp.name + "_" + animPropertySuffix + match.Groups[1]);
                            }
                        }
                    }
                    foreach (var animProp in animatedPropsToDuplicate)
                    {
                        if (psf.lines[i].Contains(animProp.name))
                        {
                            //if Line is property definition duplicate it
                            bool isDefinition = Regex.Match(psf.lines[i], animProp.name+@"\s*\(""[^""]+""\s*,\s*\w+\)\s*=\s").Success;
                            string og = null;
                            if (isDefinition)
                                og = psf.lines[i];
                            string pattern = animProp.name + @"([^a-zA-Z\d]|$)";
                            MatchCollection matches = Regex.Matches(psf.lines[i], pattern, RegexOptions.Multiline);
                            foreach (Match match in matches)
                            {
                                psf.lines[i] = psf.lines[i].Replace(match.Groups[0].Value, animProp.name + "_" + animPropertySuffix + match.Groups[1]);
                            }
                            if (isDefinition)
                                psf.lines[i] = og + "\r\n" + psf.lines[i];
                        }
                    }
                }

                // Shader file specific stuff
                if (psf.filePath.EndsWith(".shader"))
                {
                    for (int i=0; i<psf.lines.Length;i++)
                    {
                        string trimmedLine = psf.lines[i].TrimStart();
                        string trimmedForKeyword = trimmedLine.TrimStart(new char[] { '/' }).TrimEnd();
                        if (trimmedLine.StartsWith("Shader"))
                        {
                            string originalSgaderName = psf.lines[i].Split('\"')[1];
                            psf.lines[i] = psf.lines[i].Replace(originalSgaderName, newShaderName);
                        }
                        else if (trimmedLine.StartsWith("//#pragmamulti_compile_LOD_FADE_CROSSFADE"))
                        {
                            MaterialProperty crossfadeProp = Array.Find(props, x => x.name == LODCrossFadePropertyName);
                            if (crossfadeProp != null && crossfadeProp.floatValue == 1)
                                psf.lines[i] = psf.lines[i].Replace("//#pragma", "#pragma");
                        }
                        else if (trimmedLine.StartsWith("//\"IgnoreProjector\"=\"True\""))
                        {
                            MaterialProperty projProp = Array.Find(props, x => x.name == IgnoreProjectorPropertyName);
                            if (projProp != null && projProp.floatValue == 1)
                                psf.lines[i] = psf.lines[i].Replace("//\"IgnoreProjector", "\"IgnoreProjector");
                        }
                        else if (trimmedLine.StartsWith("//\"ForceNoShadowCasting\"=\"True\""))
                        {
                            MaterialProperty forceNoShadowsProp = Array.Find(props, x => x.name == ForceNoShadowCastingPropertyName);
                            if (forceNoShadowsProp != null && forceNoShadowsProp.floatValue == 1)
                                psf.lines[i] = psf.lines[i].Replace("//\"ForceNoShadowCasting", "\"ForceNoShadowCasting");
                        }
                        else if (trimmedLine.StartsWith("GrabPass {"))
                        {
                            GrabPassReplacement gpr = new GrabPassReplacement();
                            string[] splitLine = trimmedLine.Split('\"');
                            if (splitLine.Length == 1)
                                gpr.originalName = "_GrabTexture";
                            else
                                gpr.originalName = splitLine[1];
                            gpr.newName = material.GetTag("GrabPass" + grabPassVariables.Count, false, "_GrabTexture");
                            psf.lines[i] = "GrabPass { \"" + gpr.newName + "\" }";
                            grabPassVariables.Add(gpr);
                        }
                        else if (trimmedLine.StartsWith("CGINCLUDE"))
                        {
                            for (int j=i+1; j<psf.lines.Length;j++)
                                if (psf.lines[j].TrimStart().StartsWith("ENDCG"))
                                {
                                    ReplaceShaderValues(material, psf.lines, i+1, j, props, constantProps, macros, grabPassVariables);
                                    break;
                                }
                        }
                        else if (trimmedLine.StartsWith("CGPROGRAM"))
                        {
                            if(commentKeywords == 0)
                                psf.lines[i] += optimizerDefines;
                            for (int j=i+1; j<psf.lines.Length;j++)
                                if (psf.lines[j].TrimStart().StartsWith("ENDCG"))
                                {
                                    ReplaceShaderValues(material, psf.lines, i+1, j, props, constantProps, macros, grabPassVariables);
                                    break;
                                }
                        }
                        // Lightmode based pass removal, requires strict formatting
                        else if (trimmedLine.StartsWith("Tags"))
                        {
                            string lineFullyTrimmed = trimmedLine.Replace(" ", "").Replace("\t", "");
                            // expects lightmode tag to be on the same line like: Tags { "LightMode" = "ForwardAdd" }
                            if (lineFullyTrimmed.Contains("\"LightMode\"=\""))
                            {
                                string lightModeName = lineFullyTrimmed.Split('\"')[3];
                                // Store current lightmode name in a static, useful for per-pass geometry and tessellation removal
                                CurrentLightmode = lightModeName;
                                if (disabledLightModes.Contains(lightModeName))
                                {
                                    // Loop up from psf.lines[i] until standalone "Pass" line is found, delete it
                                    int j=i-1;
                                    for (;j>=0;j--)
                                        if (psf.lines[j].Replace(" ", "").Replace("\t", "") == "Pass")
                                            break;
                                    // then delete each line until a standalone ENDCG line is found
                                    for (;j<psf.lines.Length;j++)
                                    {
                                        if (psf.lines[j].Replace(" ", "").Replace("\t", "") == "ENDCG")
                                            break;
                                        psf.lines[j] = "";
                                    }
                                    // then delete each line until a standalone '}' line is found
                                    for (;j<psf.lines.Length;j++)
                                    {
                                        string temp = psf.lines[j];
                                        psf.lines[j] = "";
                                        if (temp.Replace(" ", "").Replace("\t", "") == "}")
                                            break;
                                    }
                                }
                            }
                        }
                        else if(uncommentKeywords.ContainsKey(trimmedForKeyword))
                        {
                            uncommentKeywords[trimmedForKeyword] = !uncommentKeywords[trimmedForKeyword];
                            if (uncommentKeywords[trimmedForKeyword])
                                commentKeywords++;
                            else
                                commentKeywords--;
                        }
                        if (commentKeywords > 0)
                        {
                            psf.lines[i] = "//" + psf.lines[i];
                        }
                    }
                }
                else // CGINC file
                    ReplaceShaderValues(material, psf.lines, 0, psf.lines.Length, props, constantProps, macros, grabPassVariables);

                // Recombine file lines into a single string
                int totalLen = psf.lines.Length*2; // extra space for newline chars
                foreach (string line in psf.lines)
                    totalLen += line.Length;
                StringBuilder sb = new StringBuilder(totalLen);
                // This appendLine function is incompatible with the '\n's that are being added elsewhere
                foreach (string line in psf.lines)
                    sb.AppendLine(line);
                string output = sb.ToString();

                //cull shader file path
                string filePath = psf.filePath.Substring(longestCommonDirectoryPathLength,psf.filePath.Length- longestCommonDirectoryPathLength);
                // Write output to file
                (new FileInfo(newShaderDirectory + filePath)).Directory.Create();
                try
                {
                    StreamWriter sw = new StreamWriter(newShaderDirectory + filePath);
                    sw.Write(output);
                    sw.Close();
                }
                catch (IOException e)
                {
                    Debug.LogError("[Kaj Shader Optimizer] Processed shader file " + newShaderDirectory + filePath + " could not be written.  " + e.ToString());
                    return false;
                }
            }
            
            AssetDatabase.Refresh();

            ApplyStruct applyStruct = new ApplyStruct();
            applyStruct.material = material;
            applyStruct.shader = shader;
            applyStruct.smallguid = smallguid;
            applyStruct.newShaderName = newShaderName;
            applyStruct.animatedPropsToRename = animatedPropsToRename;
            applyStruct.animatedPropsToDuplicate = animatedPropsToDuplicate;
            applyStruct.animPropertySuffix = animPropertySuffix;

            if (applyShaderLater)
            {
                applyStructsLater.Add(material, applyStruct);
                return true;
            }
            return LockApplyShader(applyStruct);
        }

        private static Dictionary<Material, ApplyStruct> applyStructsLater = new Dictionary<Material, ApplyStruct>();

        private struct ApplyStruct
        {
            public Material material;
            public Shader shader;
            public string smallguid;
            public string newShaderName;
            public List<MaterialProperty> animatedPropsToRename;
            public List<MaterialProperty> animatedPropsToDuplicate;
            public string animPropertySuffix;
        }

        private static bool LockApplyShader(Material material)
        {
            if (applyStructsLater.ContainsKey(material) == false) return false;
            ApplyStruct applyStruct = applyStructsLater[material];
            applyStructsLater.Remove(material);
            return LockApplyShader(applyStruct);
        }

        private static bool LockApplyShader(ApplyStruct applyStruct)
        {
            Material material = applyStruct.material;
            Shader shader = applyStruct.shader;
            string smallguid = applyStruct.smallguid;
            string newShaderName = applyStruct.newShaderName;
            List<MaterialProperty> animatedPropsToRename = applyStruct.animatedPropsToRename;
            List<MaterialProperty> animatedPropsToDuplicate = applyStruct.animatedPropsToDuplicate;
            string animPropertySuffix = applyStruct.animPropertySuffix;

            // Write original shader to override tag
            material.SetOverrideTag("OriginalShader", shader.name);
            // Write the new shader folder name in an override tag so it will be deleted 
            material.SetOverrideTag("OptimizedShaderFolder", smallguid);

            // Remove ALL keywords
            foreach (string keyword in material.shaderKeywords)
                material.DisableKeyword(keyword);

            // For some reason when shaders are swapped on a material the RenderType override tag gets completely deleted and render queue set back to -1
            // So these are saved as temp values and reassigned after switching shaders
            string renderType = material.GetTag("RenderType", false, "");
            int renderQueue = material.renderQueue;

            // Actually switch the shader
            Shader newShader = Shader.Find(newShaderName);
            if (newShader == null)
            {
                Debug.LogError("[Kaj Shader Optimizer] Generated shader " + newShaderName + " could not be found");
                return false;
            }
            material.shader = newShader;
            material.SetOverrideTag("RenderType", renderType);
            material.renderQueue = renderQueue;

            foreach (var animProp in animatedPropsToRename)
            {
                var newName = animProp.name + "_" + animPropertySuffix;
                switch (animProp.type)
                {
                    case MaterialProperty.PropType.Color:
                        material.SetColor(newName, animProp.colorValue);
                        break;
                    case MaterialProperty.PropType.Vector:
                        material.SetVector(newName, animProp.vectorValue);
                        break;
                    case MaterialProperty.PropType.Float:
                        material.SetFloat(newName, animProp.floatValue);
                        break;
                    case MaterialProperty.PropType.Range:
                        material.SetFloat(newName, animProp.floatValue);
                        break;
                    default:
                        throw new ArgumentOutOfRangeException(nameof(material), "This property type should not be renamed and can not be set.");
                }
            }

            foreach (var animProp in animatedPropsToDuplicate)
            {
                var newName = animProp.name + "_" + animPropertySuffix;
                switch (animProp.type)
                {
                    case MaterialProperty.PropType.Color:
                        material.SetColor(newName, animProp.colorValue);
                        break;
                    case MaterialProperty.PropType.Vector:
                        material.SetVector(newName, animProp.vectorValue);
                        break;
                    case MaterialProperty.PropType.Float:
                        material.SetFloat(newName, animProp.floatValue);
                        break;
                    case MaterialProperty.PropType.Range:
                        material.SetFloat(newName, animProp.floatValue);
                        break;
                    default:
                        throw new ArgumentOutOfRangeException(nameof(material), "This property type should not be renamed and can not be set.");
                }
            }
            return true;
        }

        /** <summary>Find longest common directoy</summary> */
        public static int GetLongestCommonDirectoryLength(string[] s)
        {
            int k = s[0].Length;
            for (int i = 1; i < s.Length; i++)
            {
                k = Math.Min(k, s[i].Length);
                for (int j = 0; j < k; j++)
                    if ( AreCharsInPathEqual(s[i][j] , s[0][j]) == false)
                    {
                        k = j;
                        break;
                    }
            }
            string p = s[0].Substring(0, k);
            if (Directory.Exists(p)) return p.Length;
            else return Path.GetDirectoryName(p).Length;
        }

        private static bool AreCharsInPathEqual(char c1, char c2)
        {
            return (c1 == c2) || ((c1 == '/' || c1 == '\\') && (c2 == '/' || c2 == '\\'));
        }

        // Preprocess each file for macros and includes
        // Save each file as string[], parse each macro with //KSOEvaluateMacro
        // Only editing done is replacing #include "X" filepaths where necessary
        // most of these args could be private static members of the class
        private static bool ParseShaderFilesRecursive(List<ParsedShaderFile> filesParsed, string newTopLevelDirectory, string filePath, List<Macro> macros)
        {
            // Infinite recursion check
            if (filesParsed.Exists(x => x.filePath == filePath)) return true;

            ParsedShaderFile psf = new ParsedShaderFile();
            psf.filePath = filePath;
            filesParsed.Add(psf);

            // Read file
            string fileContents = null;
            try
            {
                StreamReader sr = new StreamReader(filePath);
                fileContents = sr.ReadToEnd();
                sr.Close();
            }
            catch (FileNotFoundException e)
            {
                Debug.LogError("[Kaj Shader Optimizer] Shader file " + filePath + " not found.  " + e.ToString());
                return false;
            }
            catch (IOException e)
            {
                Debug.LogError("[Kaj Shader Optimizer] Error reading shader file.  " + e.ToString());
                return false;
            }

            // Parse file line by line
            List<String> macrosList = new List<string>();
            string[] fileLines = Regex.Split(fileContents, "\r\n|\r|\n");
            for (int i=0; i<fileLines.Length; i++)
            {
                string lineParsed = fileLines[i].TrimStart();
                // Specifically requires no whitespace between # and include, as it should be
                if (lineParsed.StartsWith("#include"))
                {
                    int firstQuotation = lineParsed.IndexOf('\"',0);
                    int lastQuotation = lineParsed.IndexOf('\"',firstQuotation+1);
                    string includeFilename = lineParsed.Substring(firstQuotation+1, lastQuotation-firstQuotation-1);

                    // Skip default includes
                    if (Array.Exists(DefaultUnityShaderIncludes, x => x.Equals(includeFilename, StringComparison.InvariantCultureIgnoreCase)))
                        continue;

                    // cginclude filepath is either absolute or relative
                    if (includeFilename.StartsWith("Assets/"))
                    {
                        if (!ParseShaderFilesRecursive(filesParsed, newTopLevelDirectory, includeFilename, macros))
                            return false;
                        // Only absolute filepaths need to be renampped in-file
                        fileLines[i] = fileLines[i].Replace(includeFilename, newTopLevelDirectory + includeFilename);
                    }
                    else
                    {
                        string includeFullpath = GetFullPath(includeFilename, Path.GetDirectoryName(filePath));
                        if (!ParseShaderFilesRecursive(filesParsed, newTopLevelDirectory, includeFullpath, macros))
                            return false;
                    }
                }
                // Specifically requires no whitespace between // and KSOEvaluateMacro
                else if (lineParsed == "//KSOEvaluateMacro")
                {
                    string macro = "";
                    string lineTrimmed = null;
                    do
                    {
                        i++;
                        lineTrimmed = fileLines[i].TrimEnd();
                        if (lineTrimmed.EndsWith("\\"))
                            macro += lineTrimmed.TrimEnd('\\') + Environment.NewLine; // keep new lines in macro to make output more readable
                        else macro += lineTrimmed;
                    } 
                    while (lineTrimmed.EndsWith("\\"));
                    macrosList.Add(macro);
                }
            }

            // Prepare the macros list into pattern matchable structs
            // Revise this later to not do so many string ops
            foreach (string macroString in macrosList)
            {
                string m = macroString;
                Macro macro = new Macro();
                m = m.TrimStart();
                if (m[0] != '#') continue;
                m = m.Remove(0, "#".Length).TrimStart();
                if (!m.StartsWith("define")) continue;
                m = m.Remove(0, "define".Length).TrimStart();
                int firstParenthesis = m.IndexOf('(');
                macro.name = m.Substring(0, firstParenthesis);
                m = m.Remove(0, firstParenthesis + "(".Length);
                int lastParenthesis = m.IndexOf(')');
                string allArgs = m.Substring(0, lastParenthesis).Replace(" ", "").Replace("\t", "");
                macro.args = allArgs.Split(',');
                m = m.Remove(0, lastParenthesis + ")".Length);
                macro.contents = m;
                macros.Add(macro);
            }

            // Save psf lines to list
            psf.lines = fileLines;
            return true;
        }

        // error CS1501: No overload for method 'Path.GetFullPath' takes 2 arguments
        // Thanks Unity
        // Could be made more efficent with stringbuilder
        public static string GetFullPath(string relativePath, string basePath)
        {
            while (relativePath.StartsWith("./"))
                relativePath = relativePath.Remove(0, "./".Length);
            while (relativePath.StartsWith("../"))
            {
                basePath = basePath.Remove(basePath.LastIndexOf(Path.DirectorySeparatorChar), basePath.Length - basePath.LastIndexOf(Path.DirectorySeparatorChar));
                relativePath = relativePath.Remove(0, "../".Length);
            }
            return basePath + '/' + relativePath;
        }
 
        // Replace properties! The meat of the shader optimization process
        // For each constantProp, pattern match and find each instance of the property that isn't a declaration
        // most of these args could be private static members of the class
        private static void ReplaceShaderValues(Material material, string[] lines, int startLine, int endLine, 
        MaterialProperty[] props, List<PropertyData> constants, List<Macro> macros, List<GrabPassReplacement> grabPassVariables)
        {
            List <TextureProperty> uniqueSampledTextures = new List<TextureProperty>();

            // Outside loop is each line
            for (int i=startLine;i<endLine;i++)
            {
                string lineTrimmed = lines[i].TrimStart();
                if (lineTrimmed.StartsWith("#pragma geometry"))
                {
                    if (!UseGeometry)
                        lines[i] = "//" + lines[i];
                    else
                    {
                        switch (CurrentLightmode)
                        {
                            case "ForwardBase":
                                if (!UseGeometryForwardBase)
                                    lines[i] = "//" + lines[i];
                                break;
                            case "ForwardAdd":
                                if (!UseGeometryForwardAdd)
                                    lines[i] = "//" + lines[i];
                                break;
                            case "ShadowCaster":
                                if (!UseGeometryShadowCaster)
                                    lines[i] = "//" + lines[i];
                                break;
                            case "Meta":
                                if (!UseGeometryMeta)
                                    lines[i] = "//" + lines[i];
                                break;
                        }
                    }
                }
                else if (lineTrimmed.StartsWith("#pragma hull") || lineTrimmed.StartsWith("#pragma domain"))
                {
                    if (!UseTessellation)
                        lines[i] = "//" + lines[i];
                    else
                    {
                        switch (CurrentLightmode)
                        {
                            case "ForwardBase":
                                if (!UseTessellationForwardBase)
                                    lines[i] = "//" + lines[i];
                                break;
                            case "ForwardAdd":
                                if (!UseTessellationForwardAdd)
                                    lines[i] = "//" + lines[i];
                                break;
                            case "ShadowCaster":
                                if (!UseTessellationShadowCaster)
                                    lines[i] = "//" + lines[i];
                                break;
                            case "Meta":
                                if (!UseTessellationMeta)
                                    lines[i] = "//" + lines[i];
                                break;
                        }
                    }
                }
                // Remove all shader_feature directives
                else if (lineTrimmed.StartsWith("#pragma shader_feature") || lineTrimmed.StartsWith("#pragma shader_feature_local"))
                    lines[i] = "//" + lines[i];
                // Replace inline smapler states
                else if (UseInlineSamplerStates && lineTrimmed.StartsWith("//KSOInlineSamplerState"))
                {
                    string lineParsed = lineTrimmed.Replace(" ", "").Replace("\t", "");
                    // Remove all whitespace
                    int firstParenthesis = lineParsed.IndexOf('(');
                    int lastParenthesis = lineParsed.IndexOf(')');
                    string argsString = lineParsed.Substring(firstParenthesis+1, lastParenthesis - firstParenthesis-1);
                    string[] args = argsString.Split(',');
                    MaterialProperty texProp = Array.Find(props, x => x.name == args[1]);
                    if (texProp != null)
                    {
                        Texture t = texProp.textureValue;
                        int inlineSamplerIndex = 0;
                        if (t != null)
                        {
                            switch (t.filterMode)
                            {
                                case FilterMode.Bilinear:
                                    break;
                                case FilterMode.Point:
                                    inlineSamplerIndex += 1 * 4;
                                    break;
                                case FilterMode.Trilinear:
                                    inlineSamplerIndex += 2 * 4;
                                    break;
                            }
                            switch (t.wrapMode)
                            {
                                case TextureWrapMode.Repeat:
                                    break;
                                case TextureWrapMode.Clamp:
                                    inlineSamplerIndex += 1;
                                    break;
                                case TextureWrapMode.Mirror:
                                    inlineSamplerIndex += 2;
                                    break;
                                case TextureWrapMode.MirrorOnce:
                                    inlineSamplerIndex += 3;
                                    break;
                            }
                        }

                        // Replace the token on the following line
                        lines[i+1] = lines[i+1].Replace(args[0], InlineSamplerStateNames[inlineSamplerIndex]);
                    }
                }
                else if (lineTrimmed.StartsWith("//KSODuplicateTextureCheckStart"))
                {
                    // Since files are not fully parsed and instead loosely processed, each shader function needs to have
                    // its sampled texture list reset somewhere before KSODuplicateTextureChecks are made.
                    // As long as textures are sampled in-order inside a single function, this method will work.
                    uniqueSampledTextures = new List<TextureProperty>();
                }
                else if (lineTrimmed.StartsWith("//KSODuplicateTextureCheck"))
                {
                    // Each KSODuplicateTextureCheck line gets evaluated when the shader is optimized
                    // If the texture given has already been sampled as another texture (i.e. one texture is used in two slots)
                    // AND has been sampled with the same UV mode - as indicated by a convention UV property,
                    // AND has been sampled with the exact same Tiling/Offset values
                    // AND has been logged by KSODuplicateTextureCheck, 
                    // then the variable corresponding to the first instance of that texture being 
                    // sampled will be assigned to the variable corresponding to the given texture.
                    // The compiler will then skip the duplicate texture sample since its variable is overwritten before being used
                    
                    // Parse line for argument texture property name
                    string lineParsed = lineTrimmed.Replace(" ", "").Replace("\t", "");
                    int firstParenthesis = lineParsed.IndexOf('(');
                    int lastParenthesis = lineParsed.IndexOf(')');
                    string argName = lineParsed.Substring(firstParenthesis+1, lastParenthesis-firstParenthesis-1);
                    // Check if texture property by argument name exists and has a texture assigned
                    if (Array.Exists(props, x => x.name == argName))
                    {
                        MaterialProperty argProp = Array.Find(props, x => x.name == argName);
                        if (argProp.textureValue != null)
                        {
                            // If no convention UV property exists, sampled UV mode is assumed to be 0 
                            // Any UV enum or mode indicator can be used for this
                            int UV = 0;
                            if (Array.Exists(props, x => x.name == argName + "UV"))
                                UV = (int)(Array.Find(props, x => x.name == argName + "UV").floatValue);

                            Vector2 texScale = material.GetTextureScale(argName);
                            Vector2 texOffset = material.GetTextureOffset(argName);

                            // Check if this texture has already been sampled
                            if (uniqueSampledTextures.Exists(x => (x.texture == argProp.textureValue) 
                                                               && (x.uv == UV)
                                                               && (x.scale == texScale)
                                                               && x.offset == texOffset))
                            {
                                string texName = uniqueSampledTextures.Find(x => (x.texture == argProp.textureValue) && (x.uv == UV)).name;
                                // convention _var variables requried. i.e. _MainTex_var and _CoverageMap_var
                                lines[i] = argName + "_var = " + texName + "_var;";
                            }
                            else
                            {
                                // Texture/UV/ST combo hasn't been sampled yet, add it to the list
                                TextureProperty tp = new TextureProperty();
                                tp.name = argName;
                                tp.texture = argProp.textureValue;
                                tp.uv = UV;
                                tp.scale = texScale;
                                tp.offset = texOffset;
                                uniqueSampledTextures.Add(tp);
                            }
                        }
                    }
                }
                else if (lineTrimmed.StartsWith("[maxtessfactor("))
                {
                    MaterialProperty maxTessFactorProperty = Array.Find(props, x => x.name == TessellationMaxFactorPropertyName);
                    if (maxTessFactorProperty != null)
                    {
                        float maxTessellation = maxTessFactorProperty.floatValue;
                        MaterialProperty maxTessFactorAnimatedProperty = Array.Find(props, x => x.name == TessellationMaxFactorPropertyName + AnimatedPropertySuffix);
                        if (maxTessFactorAnimatedProperty != null && maxTessFactorAnimatedProperty.floatValue == 1)
                            maxTessellation = 64.0f;
                        lines[i] = "[maxtessfactor(" + maxTessellation.ToString(".0######") + ")]";
                    }
                }

                // then replace macros
                foreach (Macro macro in macros)
                {
                    // Expects only one instance of a macro per line!
                    int macroIndex;
                    if ((macroIndex = lines[i].IndexOf(macro.name + "(")) != -1)
                    {
                        // Macro exists on this line, make sure its not the definition
                        string lineParsed = lineTrimmed.Replace(" ", "").Replace("\t", "");
                        if (lineParsed.StartsWith("#define")) continue;

                        // parse args between first '(' and first ')'
                        int firstParenthesis = macroIndex + macro.name.Length;
                        int lastParenthesis = lines[i].IndexOf(')', macroIndex + macro.name.Length+1);
                        string allArgs = lines[i].Substring(firstParenthesis+1, lastParenthesis-firstParenthesis-1);
                        string[] args = allArgs.Split(',');
                        
                        // Replace macro parts
                        string newContents = macro.contents;
                        for (int j=0; j<args.Length;j++)
                        {
                            args[j] = args[j].Trim();
                            int argIndex;
                            int lastIndex = 0;
                            while ((argIndex = newContents.IndexOf(macro.args[j], lastIndex)) != -1)
                            {
                                lastIndex = argIndex+1;
                                char charLeft = ' ';
                                if (argIndex-1 >= 0)
                                    charLeft = newContents[argIndex-1];
                                char charRight = ' ';
                                if (argIndex+macro.args[j].Length < newContents.Length)
                                    charRight = newContents[argIndex+macro.args[j].Length];
                                if (Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight))
                                {
                                    // Replcae the arg!
                                    StringBuilder sbm = new StringBuilder(newContents.Length - macro.args[j].Length + args[j].Length);
                                    sbm.Append(newContents, 0, argIndex);
                                    sbm.Append(args[j]);
                                    sbm.Append(newContents, argIndex + macro.args[j].Length, newContents.Length - argIndex - macro.args[j].Length);
                                    newContents = sbm.ToString();
                                }
                            }
                        }
                        newContents = newContents.Replace("##", ""); // Remove token pasting separators
                        // Replace the line with the evaluated macro
                        StringBuilder sb = new StringBuilder(lines[i].Length + newContents.Length);
                        sb.Append(lines[i], 0, macroIndex);
                        sb.Append(newContents);
                        sb.Append(lines[i], lastParenthesis+1, lines[i].Length - lastParenthesis-1);
                        lines[i] = sb.ToString();
                    }
                }
                // then replace properties
                foreach (PropertyData constant in constants)
                {
                    int constantIndex;
                    int lastIndex = 0;
                    bool declarationFound = false;
                    while ((constantIndex = lines[i].IndexOf(constant.name, lastIndex)) != -1)
                    {
                        lastIndex = constantIndex+1;
                        char charLeft = ' ';
                        if (constantIndex-1 >= 0)
                            charLeft = lines[i][constantIndex-1];
                        char charRight = ' ';
                        if (constantIndex + constant.name.Length < lines[i].Length)
                            charRight = lines[i][constantIndex + constant.name.Length];
                        // Skip invalid matches (probably a subname of another symbol)
                        if (!(Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight)))
                            continue;
                        
                        // Skip basic declarations of unity shader properties i.e. "uniform float4 _Color;"
                        if (!declarationFound)
                        {
                            string precedingText = lines[i].Substring(0, constantIndex-1).TrimEnd(); // whitespace removed string immediately to the left should be float or float4
                            string restOftheFile = lines[i].Substring(constantIndex + constant.name.Length).TrimStart(); // whitespace removed character immediately to the right should be ;
                            if (Array.Exists(ValidPropertyDataTypes, x => precedingText.EndsWith(x)) && restOftheFile.StartsWith(";"))
                            {
                                declarationFound = true;
                                continue;
                            }
                        }

                        // Replace with constant!
                        // This could technically be more efficient by being outside the IndexOf loop
                        StringBuilder sb = new StringBuilder(lines[i].Length * 2);
                        sb.Append(lines[i], 0, constantIndex);
                        switch (constant.type)
                        {
                            case PropertyType.Float:
                                sb.Append("float(" + constant.value.x.ToString(CultureInfo.InvariantCulture) + ")");
                                break;
                            case PropertyType.Vector:
                                sb.Append("float4("+constant.value.x.ToString(CultureInfo.InvariantCulture)+","
                                                   +constant.value.y.ToString(CultureInfo.InvariantCulture)+","
                                                   +constant.value.z.ToString(CultureInfo.InvariantCulture)+","
                                                   +constant.value.w.ToString(CultureInfo.InvariantCulture)+")");
                                break;
                        }
                        sb.Append(lines[i], constantIndex+constant.name.Length, lines[i].Length-constantIndex-constant.name.Length);
                        lines[i] = sb.ToString();

                        // Check for Unity branches on previous line here?
                    }
                }

                // Then replace grabpass variable names
                foreach (GrabPassReplacement gpr in grabPassVariables)
                {
                    // find indexes of all instances of gpr.originalName that exist on this line
                    int lastIndex = 0;
                    int gbIndex;
                    while ((gbIndex = lines[i].IndexOf(gpr.originalName, lastIndex)) != -1)
                    {
                        lastIndex = gbIndex+1;
                        char charLeft = ' ';
                        if (gbIndex-1 >= 0)
                            charLeft = lines[i][gbIndex-1];
                        char charRight = ' ';
                        if (gbIndex + gpr.originalName.Length < lines[i].Length)
                            charRight = lines[i][gbIndex + gpr.originalName.Length];
                        // Skip invalid matches (probably a subname of another symbol)
                        if (!(Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight)))
                            continue;
                        
                        // Replace with new variable name
                        // This could technically be more efficient by being outside the IndexOf loop
                        StringBuilder sb = new StringBuilder(lines[i].Length * 2);
                        sb.Append(lines[i], 0, gbIndex);
                        sb.Append(gpr.newName);
                        sb.Append(lines[i], gbIndex+gpr.originalName.Length, lines[i].Length-gbIndex-gpr.originalName.Length);
                        lines[i] = sb.ToString();
                    }
                }

                // Then remove Unity branches
                if (RemoveUnityBranches)
                    lines[i] = lines[i].Replace("UNITY_BRANCH", "").Replace("[branch]", "");
            }
        }

        public static bool Unlock (Material material)
        {
            // Revert to original shader
            string originalShaderName = material.GetTag("OriginalShader", false, "");
            if (originalShaderName == "")
            {
                Debug.LogError("[Kaj Shader Optimizer] Original shader not saved to material, could not unlock shader");
                return material.shader.name.StartsWith("Hidden/") == false;

            }
            Shader orignalShader = Shader.Find(originalShaderName);
            if (orignalShader == null)
            {
                Debug.LogError("[Kaj Shader Optimizer] Original shader " + originalShaderName + " could not be found");
                return false;
            }

            // For some reason when shaders are swapped on a material the RenderType override tag gets completely deleted and render queue set back to -1
            // So these are saved as temp values and reassigned after switching shaders
            string renderType = material.GetTag("RenderType", false, "");
            int renderQueue = material.renderQueue;
            material.shader = orignalShader;
            material.SetOverrideTag("RenderType", renderType);
            material.renderQueue = renderQueue;

            // Delete the variants folder and all files in it, as to not orhpan files and inflate Unity project
            string shaderDirectory = material.GetTag("OptimizedShaderFolder", false, "");
            if (shaderDirectory == "")
            {
                Debug.LogError("[Kaj Shader Optimizer] Optimized shader folder could not be found, not deleting anything");
                return false;
            }
            string materialFilePath = AssetDatabase.GetAssetPath(material);
            string materialFolder = Path.GetDirectoryName(materialFilePath);
            string newShaderDirectory = materialFolder + "/OptimizedShaders/" + shaderDirectory;
            // Both safe ways of removing the shader make the editor GUI throw an error, so just don't refresh the
            // asset database immediately
            //AssetDatabase.DeleteAsset(shaderFilePath);
            FileUtil.DeleteFileOrDirectory(newShaderDirectory + "/");
            FileUtil.DeleteFileOrDirectory(newShaderDirectory + ".meta");
            //AssetDatabase.Refresh();

            return true;
        }

        //---GameObject + Children Locking

        [MenuItem("GameObject/Thry/Materials/Unlock All", false,0)]
        static void UnlockAllChildren()
        {
            SetLockForAllChildren(Selection.gameObjects, 0, true);
        }

        [MenuItem("GameObject/Thry/Materials/Lock All", false,0)]
        static void LockAllChildren()
        {
            SetLockForAllChildren(Selection.gameObjects, 1, true);
        }

        //---Asset Unlocking

        [MenuItem("Assets/Thry/Materials/Unlock All", false, 303)]
        static void UnlockAllMaterials()
        {
            IEnumerable<Material> mats = Selection.assetGUIDs.Select(g => AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(g)));
            SetLockedForAllMaterials(mats, 0, true);
        }

        [MenuItem("Assets/Thry/Materials/Unlock All", true)]
        static bool UnlockAllMaterialsValidator()
        {
            return SelectedObjectsAreLockableMaterials();
        }

        //---Asset Locking

        [MenuItem("Assets/Thry/Materials/Lock All", false, 303)]
        static void LockAllMaterials()
        {
            IEnumerable<Material> mats = Selection.assetGUIDs.Select(g => AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(g)));
            SetLockedForAllMaterials(mats, 1, true);
        }

        [MenuItem("Assets/Thry/Materials/Lock All", true)]
        static bool LockAllMaterialsValidator()
        {
            return SelectedObjectsAreLockableMaterials();
        }

        //----Folder Lock

        [MenuItem("Assets/Thry/Materials/Lock Folder", false, 303)]
        static void LockFolder()
        {
            IEnumerable<string> folderPaths = Selection.objects.Select(o => AssetDatabase.GetAssetPath(o)).Where(p => Directory.Exists(p));
            List<Material> materials = new List<Material>();
            foreach (string f in folderPaths) FindMaterialsRecursive(f, materials);
            SetLockedForAllMaterials(materials, 1, true);
        }

        [MenuItem("Assets/Thry/Materials/Lock Folder", true)]
        static bool LockFolderValidator()
        {
            return Selection.objects.Select(o => AssetDatabase.GetAssetPath(o)).Where(p => Directory.Exists(p)).Count() == Selection.objects.Length;
        }

        //-----Folder Unlock

        [MenuItem("Assets/Thry/Materials/Unlock Folder", false, 303)]
        static void UnLockFolder()
        {
            IEnumerable<string> folderPaths = Selection.objects.Select(o => AssetDatabase.GetAssetPath(o)).Where(p => Directory.Exists(p));
            List<Material> materials = new List<Material>();
            foreach (string f in folderPaths) FindMaterialsRecursive(f, materials);
            SetLockedForAllMaterials(materials, 0, true);
        }

        [MenuItem("Assets/Thry/Materials/Unlock Folder", true)]
        static bool UnLockFolderValidator()
        {
            return Selection.objects.Select(o => AssetDatabase.GetAssetPath(o)).Where(p => Directory.Exists(p)).Count() == Selection.objects.Length;
        }

        private static void FindMaterialsRecursive(string folderPath, List<Material> materials)
        {
            foreach(string f in Directory.GetFiles(folderPath))
            {
                if(AssetDatabase.GetMainAssetTypeAtPath(f) == typeof(Material))
                {
                    materials.Add(AssetDatabase.LoadAssetAtPath<Material>(f));
                }
            }
            foreach(string f in Directory.GetDirectories(folderPath)){
                FindMaterialsRecursive(f, materials);
            }
        }

        //----Folder Unlock

        static bool SelectedObjectsAreLockableMaterials()
        {
            if (Selection.assetGUIDs != null && Selection.assetGUIDs.Length > 0)
            {
                return Selection.assetGUIDs.All(g =>
                {
                    if (AssetDatabase.GetMainAssetTypeAtPath(AssetDatabase.GUIDToAssetPath(g)) != typeof(Material))
                        return false;
                    Material m = AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(g));
                    string pName;
                    return IsShaderUsingThryOptimizer(m.shader, out pName);
                });
            }
            return false;
        }

        //----VRChat Callback to force Locking on upload

        #if VRC_SDK_VRCSDK2 || VRC_SDK_VRCSDK3
        public class LockMaterialsOnUpload : IVRCSDKPreprocessAvatarCallback
        {
            public int callbackOrder => 100;

            public bool OnPreprocessAvatar(GameObject avatarGameObject)
            {
                SetLockForAllChildren(new GameObject[] { avatarGameObject }, 1);
                return true;
            }
        }
        #endif

        public static void SetLockForAllChildren(GameObject[] objects, int lockState, bool isCancleable = false)
        {
            Material[] materials = objects.Select(o => o.GetComponentsInChildren<Renderer>(true)).SelectMany(rA => rA.SelectMany(r => r.sharedMaterials)).ToArray();
            SetLockedForAllMaterials(materials, lockState, isCancleable);
        }

        public static void SetLockedForAllMaterials(IEnumerable<Material> materials, int lockState, bool showProgressbar = false)
        {
            //first the shaders are created. compiling is suppressed with start asset editing

            AssetDatabase.StartAssetEditing();
            float i = 0;
            float length = materials.Count();
            foreach (Material m in materials)
            {
                if (m == null) continue;
                //check if material is build in material, cause built in materials and shaders suck ass. You can't even access there name here without crashing unity
                if (string.IsNullOrEmpty(AssetDatabase.GetAssetPath(m)) || string.IsNullOrEmpty(AssetDatabase.GetAssetPath(m.shader))) continue;

                //dont give it a progress bar if it is called by lockin police, else it breaks everything. why ? cause unity ...
                if (showProgressbar)
                {
                    if (EditorUtility.DisplayCancelableProgressBar((lockState == 1) ? "Locking Materials" : "Unlocking Materials", m.name, i / length))
                    {
                        break;
                    }
                }
                try
                {
                    string optimizerPropertyName;
                    //checking for drawer, since other materials / shaders could have same porperty name
                    if (IsShaderUsingThryOptimizer(m.shader, out optimizerPropertyName) == false) continue;

                    bool isLocked = m.GetFloat(optimizerPropertyName) == 1;

                    if (lockState == 1 && isLocked == false)
                    {
                        ShaderOptimizer.Lock(m, MaterialEditor.GetMaterialProperties(new UnityEngine.Object[] { m }), applyShaderLater: true);
                    }
                    else if (lockState == 0 && isLocked)
                    {
                        //if unlock success set floats. not done for locking cause the sucess is checked later when applying the shaders
                        if (ShaderOptimizer.Unlock(m))
                        {
                            m.SetFloat(optimizerPropertyName, lockState);
                        }
                    }
                }
                catch (Exception e)
                {
                    Debug.LogError("Could not un-/lock material " + m.name);
                    Debug.LogError(e);
                }
                i++;
            }
            EditorUtility.ClearProgressBar();
            AssetDatabase.StopAssetEditing();
            //unity now compiles all the shaders

            //now all new shaders are applied. this has to happen after unity compiled the shaders
            if (lockState == 1)
            {
                //Apply new shaders
                foreach (Material m in materials)
                {
                    if (m == null) continue;
                    //check if material is build in material, cause built in materials and shaders suck ass. You can't even access there name here without crashing unity
                    if (string.IsNullOrEmpty(AssetDatabase.GetAssetPath(m)) || string.IsNullOrEmpty(AssetDatabase.GetAssetPath(m.shader))) continue;

                    string propertyName;
                    if (IsShaderUsingThryOptimizer(m.shader, out propertyName))
                    {
                        bool success = ShaderOptimizer.LockApplyShader(m);
                        if (success)
                        {
                            m.SetFloat(propertyName, lockState);
                        }
                    }
                }
            }
        }

        private static Dictionary<Shader, string> shaderUsingThryOptimizerDictionary = new Dictionary<Shader, string>();
        private static bool IsShaderUsingThryOptimizer(Shader shader, out string propertyName)
        {
            if (shaderUsingThryOptimizerDictionary.ContainsKey(shader))
            {
                propertyName = shaderUsingThryOptimizerDictionary[shader];
                return propertyName != null;
            }

            //check shader code for drawer that's not commented out
            string code = FileHelper.ReadFileIntoString(AssetDatabase.GetAssetPath(shader));
            Match m = Regex.Match(code, @"\n[^(\/)]*\[ThryShaderOptimizerLockButton\].*\n");
            if (m.Success)
            {
                //get property name
                m = Regex.Match(m.Value, @"(?<=\[ThryShaderOptimizerLockButton\])\s*(\w|\d)+");
                if (m.Success)
                {
                    propertyName = m.Value.Trim();
                    shaderUsingThryOptimizerDictionary[shader] = propertyName;
                    return true;
                }
            }
            propertyName = null;
            shaderUsingThryOptimizerDictionary[shader] = propertyName;
            return false;
        }
    }
}