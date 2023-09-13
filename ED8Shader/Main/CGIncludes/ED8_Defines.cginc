#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"
#include "UnityLightingCommon.cginc"
#include "HLSLSupport.cginc"
#include "UnityShadowLibrary.cginc"

#if defined (SHADOWS_DEPTH) && !defined (SPOT)
    #define SHADOW_COORDS(idx1) unityShadowCoord2 _ShadowCoord : TEXCOORD##idx1;
#endif

//=============================================================================
// マテリアルスイッチのプリプロセス
//=============================================================================

// ブルームは常時ON
#define BLOOM_ENABLED

#if !defined(NOTHING_ENABLED)
	#if !defined(LIGHTING_ENABLED)
		#define LIGHTING_ENABLED
	#endif
#else
	#undef LIGHTING_ENABLED
#endif

#if !defined(NO_ALL_LIGHTING_ENABLED) && defined(LIGHTING_ENABLED)
	#define USE_LIGHTING
#endif

// 非マルチテクスチャなら関連スイッチを無効化
#if !defined(MULTI_UV_ENANLED)
	#undef MULTI_UV_ADDITIVE_BLENDING_ENANLED
	#undef MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED
    #undef MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED
    #undef MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED
	#undef MULTI_UV_SHADOW_ENANLED
	#undef MULTI_UV_TEXCOORD_OFFSET_ENABLED
	#undef MULTI_UV_NORMAL_MAPPING_ENABLED
	#undef MULTI_UV_OCCULUSION_MAPPING_ENABLED
	#undef MULTI_UV_SPECULAR_MAPPING_ENABLED
	#undef MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED
	#undef MULTI_UV2_ENANLED
	#undef MULTI_UV2_ADDITIVE_BLENDING_ENANLED
	#undef MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
    #undef MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED
    #undef MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED
	#undef MULTI_UV2_SHADOW_ENANLED
	#undef MULTI_UV2_TEXCOORD_OFFSET_ENABLED
	#undef MULTI_UV2_NORMAL_MAPPING_ENABLED
	#undef MULTI_UV2_OCCULUSION_MAPPING_ENABLED
	#undef MULTI_UV2_SPECULAR_MAPPING_ENABLED
	#undef MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED
#endif // !defined(MULTI_UV_ENANLED)

#if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	#undef MULTI_UV_ADDITIVE_BLENDING_ENANLED
	#undef MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED
    #undef MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED
    #undef MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED
	#undef MULTI_UV_SHADOW_ENANLED
#endif

#if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	#undef MULTI_UV2_ADDITIVE_BLENDING_ENANLED
	#undef MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
    #undef MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED
    #undef MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED
	#undef MULTI_UV2_SHADOW_ENANLED
#endif

// マルチUV2と排他なものを無効化
#if defined(MULTI_UV2_ENANLED)
	#undef SPHERE_MAPPING_ENABLED
    #undef SPHERE_MAPPING_HAIRCUTICLE_ENABLED
	#undef CUBE_MAPPING_ENABLED
#endif

#if defined(SPHERE_MAPPING_ENABLED)
	#undef SPHERE_MAPPING_HAIRCUTICLE_ENABLED
#endif

/*
#if defined(WATER_SURFACE_ENABLED)
	#undef ALPHA_BLENDING_ENABLED
	#undef ADDITIVE_BLENDING_ENABLED
	#undef SUBTRACT_BLENDING_ENABLED
	#undef MULTIPLICATIVE_BLENDING_ENABLED
#endif // defined(WATER_SURFACE_ENABLED)
*/

#if defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED)
    #define USE_SCREEN_UV
#endif // defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED)

#if defined(USE_SCREEN_UV)
    uniform UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture); uniform float4 _CameraDepthTexture_TexelSize;
#endif

#if !defined(ALPHA_BLENDING_ENABLED)
	#undef ADDITIVE_BLENDING_ENABLED
	#undef SUBTRACT_BLENDING_ENABLED
	#undef MULTIPLICATIVE_BLENDING_ENABLED
#endif

#if defined(NORMAL_MAPPING_ENABLED) || defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	#define USE_TANGENTS
#endif

#if defined(ADDITIVE_BLENDING_ENABLED) || defined(SUBTRACT_BLENDING_ENABLED) || defined(MULTIPLICATIVE_BLENDING_ENABLED)
	#define USE_EXTRA_BLENDING
#endif

// トゥーンの場合で、半球環境光がなければつける。ただ、明示的に3値でなければ
#if defined(CARTOON_SHADING_ENABLED) || !defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	#if !defined(HEMISPHERE_AMBIENT_ENABLED) && !defined(MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED)
		#define HEMISPHERE_AMBIENT_ENABLED
		#define MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	#endif
#endif

// 背景の書割とか、どう考えても頂点単位のライトで十分な場所を明示的に指定することにする
// トゥーン
#if defined(CARTOON_SHADING_ENABLED)
	#undef WINDY_GRASS_ENABLED
	#define CARTOON_AVOID_SELFSHADOW_OFFSET
#endif // defined(CARTOON_SHADING_ENABLED)

#if defined(FORCE_CHAR_LIGHT_DIRECTION_ENABLED) || defined(CARTOON_SHADING_ENABLED)
	#define LIGHT_DIRECTION_FOR_CHARACTER_ENABLED	//ゲーム内で「キャラ」パスで描画されるようになる
#endif

//-----------------------------------------------------------------------------
// テクスチャ
//-----------------------------------------------------------------------------
#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
    float3 _LightDirForChar;
#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED

half _GlobalMainLightClampFactor;

//#if defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)
half4 _UserClipPlane; //= {0.0, 1.0, 0.0, 0.0}; // xyzw (nx,ny,nz,height)
//#endif // defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)

#if defined(WATER_SURFACE_ENABLED)
    half _ReflectionFresnel;    
    half _ReflectionIntensity;
#endif

#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
    half3 _PortraitLightColor;
    half3 _PortraitAmbientColor;
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#if defined(SHINING_MODE_ENABLED)
    half3 _ShiningLightColor;
#endif // defined(SHINING_MODE_ENABLED)

uniform half _UdonShadowDensity = 1.0f;
half _GlowThreshold = 1.0;
half _GameMaterialID;
half4 _GameMaterialDiffuse;
half4 _GameMaterialEmission;
half _GameMaterialMonotone;
half4 _MonotoneMul;
half4 _MonotoneAdd;
half4 _GameMaterialTexcoord;
half4 _GameDitherParams;
half4 _UVaMUvColor; 
half4 _UVaProjTexcoord;
half4 _UVaMUvTexcoord;
half4 _UVaMUv2Texcoord;
half4 _UVaDuDvTexcoord;
half _GlobalTexcoordFactor;
half _AlphaTestDirection;
half _AlphaThreshold;

#if defined(FOG_ENABLED)
    uniform half3 _UdonFogColor = half3(0.5f, 0.5f, 0.5f);
    uniform half2 _UdonFogRangeParameters = half2(10.0f, 500.0f);
    uniform half2 _UdonHeightFogRangeParameters = half2(0.0f, 0.0f);
    uniform half _UdonFogRateClamp = 1.0f;
    uniform half _UdonHeightDepthBias = 1.0f;
    uniform half _UdonHeightCamRate = 1.0f;
    uniform half _UdonFogImageSpeedX = 0.05f;
    uniform half _UdonFogImageSpeedZ = 0.05f;
    uniform half _UdonFogImageScale = 0.05f;
    uniform half _UdonFogImageRatio = 0;

    #if defined(FOG_RATIO_ENABLED)
        half _FogRatio;
    #endif
#endif // FOG_ENABLED

#if defined(SHADOW_COLOR_SHIFT_ENABLED)
    half3 _ShadowColorShift;
#endif

#if defined(HEMISPHERE_AMBIENT_ENABLED)
    uniform half3 _UdonHemiSphereAmbientSkyColor = half3(0.55f, 0.55f, 0.55f);
    uniform half3 _UdonHemiSphereAmbientGndColor = half3(0.55f, 0.55f, 0.55f);
    uniform half3 _UdonHemiSphereAmbientAxis = half3(0, 10, 0);
#endif // HEMISPHERE_AMBIENT_ENABLED

#if defined(SPECULAR_ENABLED)
    half _Shininess;
    half _SpecularPower;
    half3 _FakeSpecularDir;

   #if defined(SPECULAR_COLOR_ENABLED)
        half4 _SpecularColor;
    #endif
#endif

#if defined(RIM_LIGHTING_ENABLED)
    half3 _RimLitColor;
    half _RimLitIntensity;
    half _RimLitPower;
    half _RimLightClampFactor;
#endif 

uniform half _UdonAllowFakeSpecularDir = 1.0f;
half2 _TexCoordOffset;
half2 _TexCoordOffset2;
half2 _TexCoordOffset3;
half _UV1;
half _UV2;
half _UV3;

uniform sampler2D _UdonDitherNoiseTexture;
uniform sampler2D _UdonLowResDepthTexture;

#if !defined(NOTHING_ENABLED)
    sampler2D _MainTex;
#endif 
half4 _MainTex_ST;

#if defined(NORMAL_MAPPING_ENABLED)
    sampler2D _BumpMap;
#endif // NORMAL_MAPPING_ENABLED

#if defined(SPECULAR_MAPPING_ENABLED)
    sampler2D _SpecularMapSampler;
#endif // SPECULAR_MAPPING_ENABLED

#if defined(OCCULUSION_MAPPING_ENABLED)
    sampler2D _OcculusionMapSampler;
#endif // OCCULUSION_MAPPING_ENABLED

#if defined(EMISSION_MAPPING_ENABLED)
    sampler2D _EmissionMapSampler;
#endif // EMISSION_MAPPING_ENABLED

#if defined(MULTI_UV_ENANLED)
    float _BlendMulScale2;
	#if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
        sampler2D _DiffuseMap2Sampler;
	#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

    #if defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
        sampler2D _NormalMap2Sampler;
	#endif // MULTI_UV_NORMAL_MAPPING_ENABLED

	#if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
        sampler2D _SpecularMap2Sampler;
	#endif // MULTI_UV_SPECULAR_MAPPING_ENABLED

	#if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
        sampler2D _OcculusionMap2Sampler;
	#endif // MULTI_UV_OCCULUSION_MAPPING_ENABLED

    #if defined(MULTI_UV_GLARE_MAP_ENABLED)
        sampler2D _GlareMap2Sampler;
    #endif
#endif // MULTI_UV_ENANLED

#if defined(MULTI_UV2_ENANLED)
    float _BlendMulScale3;
	#if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
        sampler2D _DiffuseMap3Sampler;
	#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)

    #if defined(MULTI_UV2_NORMAL_MAPPING_ENABLED)
        sampler2D _NormalMap3Sampler;
	#endif // MULTI_UV_NORMAL_MAPPING_ENABLED

	#if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
        sampler2D _SpecularMap3Sampler;
	#endif // MULTI_UV2_SPECULAR_MAPPING_ENABLED

	#if defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
        sampler2D _OcculusionMap3Sampler;
	#endif // MULTI_UV2_OCCULUSION_MAPPING_ENABLED
#endif // MULTI_UV2_ENANLED

#if defined(CARTOON_SHADING_ENABLED)
    sampler2D _CartoonMapSampler;

	#if defined(CARTOON_HILIGHT_ENABLED)
        sampler2D _HighlightMapSampler;
        float3 _HighlightColor;
        float _HighlightIntensity;
	#endif // CARTOON_HILIGHT_ENABLED

    half _ShadowReceiveOffset;
#endif // CARTOON_SHADING_ENABLED

#if defined(SPHERE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_HAIRCUTICLE_ENABLED)
    sampler2D _SphereMapSampler;
    half _SphereMapIntensity;
#endif // SPHERE_MAPPING_ENABLED

#if defined(CUBE_MAPPING_ENABLED)
    samplerCUBE _CubeMapSampler;
    half _CubeMapFresnel;
    half _CubeMapIntensity;
#endif // CUBE_MAPPING_ENABLED

#if defined(DUDV_MAPPING_ENABLED)
    sampler2D _DuDvMapSampler;
    half2 _DuDvMapImageSize;
    half2 _DuDvScroll;
    half2 _DuDvScale;
#endif // DUDV_MAPPING_ENABLED

#if !defined(CARTOON_SHADING_ENABLED)
	#if defined(PROJECTION_MAP_ENABLED)
        sampler2D _ProjectionMapSampler;
        half2 _ProjectionScale;
        half2 _ProjectionScroll;
	#endif // PROJECTION_MAP_ENABLED

    #if defined(WINDY_GRASS_ENABLED)
        half2 _WindyGrassDirection;
        half _WindyGrassSpeed;
        half _WindyGrassHomogenity;
        half _WindyGrassScale;
	#endif // WINDY_GRASS_ENABLED
#endif // CARTOON_SHADING_ENABLED

float4 _GameEdgeParameters;
float4 _OutlineColorFactor;

#if defined(USE_OUTLINE_COLOR)
    float3 _OutlineColor;
#endif

#if defined(USE_SCREEN_UV)
	uniform sampler2D _RefractionTexture; uniform float4 _RefractionTexture_TexelSize;
    uniform sampler2D _ReflectionTex0; uniform float4 _ReflectionTex0_TexelSize;
    uniform sampler2D _ReflectionTex1; uniform float4 _ReflectionTex1_TexelSize;
#endif // defined(USE_SCREEN_UV)

#if defined(GLARE_MAP_ENABLED)
    sampler2D _GlareMapSampler;
#endif // GLARE_MAP_ENABLED

half _GlareIntensity;
half _BloomIntensity;
uniform half3 _UdonGlobalAmbientColor = half3(0.50f, 0.50f, 0.50f);
uniform half3 _UdonMainLightColor = half3(1.0f, 0.9568f, 0.8392f);
uniform half4 _UdonGlobalFilterColor = half4(0, 0, 0, 0);
half _AdditionalShadowOffset;
half _MaskEps;
half4 _PointLightParams;
half4 _PointLightColor;
float _Culling;
half _SrcBlend;
half _DstBlend;

//=============================================================================
// シェーダ入出力構造体
//=============================================================================
struct DefaultVPInput {
	float3 vertex       : POSITION;
	float3 normal       : NORMAL;
	float2 uv           : TEXCOORD0;

    #if defined(VERTEX_COLOR_ENABLED)
        float4 color    : COLOR0;
    #endif

    #if defined(USE_TANGENTS)
        float4 tangent  : TANGENT;
    #endif

    #if defined(MULTI_UV_ENANLED)
        float2 uv2      : TEXCOORD1;
    #endif

    #if defined(MULTI_UV2_ENANLED)
        float2 uv3      : TEXCOORD2;
    #endif

    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct DefaultVPOutput {
    float4 pos                  : SV_POSITION;
	centroid float4 Color0      : COLOR0;
    centroid float4 Color1      : COLOR1;       // xyz = 未使用, w = フォグ計算結果
	float2 uv                   : TEXCOORD0;
	float4 WorldPositionDepth   : TEXCOORD9;    // xyz = ワールド座標, w = 視線方向のZ値

    #if defined(MULTI_UV_ENANLED)
        float2 uv2		        : TEXCOORD1;    // xy: UV Vertex Alpha Lerp
    #endif // MULTI_UV_ENANLED

    #if defined(MULTI_UV2_ENANLED)
        float2 uv3		        : TEXCOORD2;	// xy: UV2 Vertex Alpha Lerp
    #endif // defined(MULTI_UV2_ENANLED)

    // Projection/Etc
    #if defined(PROJECTION_MAP_ENABLED)
        float2 ProjMap	        : TEXCOORD3;    // xy: Projection UV
    #endif // PROJECTION_MAP_ENABLED

    float3 normal	            : TEXCOORD4;    // xyz[World]: Normals

    #if defined(DUDV_MAPPING_ENABLED)
        float2 DuDvTexCoord     : TEXCOORD5;	// xy: DUDV
    #endif

    #if defined(USE_TANGENTS)
        float3 tangent	    : TEXCOORD6;	// xyz[World]: Tangents
        float3 binormal     : TEXCOORD12;
    #endif // USE_TANGENTS

    #if defined(USE_SCREEN_UV)
        float4 screenPos        : TEXCOORD7;
    #endif // defined(USE_SCREEN_UV)

    #if defined(CARTOON_SHADING_ENABLED)
        #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
            float3 CartoonMap   : TEXCOORD11;  // xy: HiLight z:ldotn
        #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
    #endif // CUBE_MAPPING_ENABLED

    //float4 instanceParam;
	//float4 wvpPos;

    SHADOW_COORDS(8)
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

//-----------------------------------------------------------------------------
struct EdgeVPInput {
	float4 vertex			    : POSITION;
	float3 normal			    : NORMAL;
	float2 uv			        : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct EdgeVPOutput {
    UNITY_POSITION(pos);		                // xyzw:[Proj] 
    centroid float4 Color0		: COLOR0;		// xyzw:EdgeColor + GameEmission
    float4 Color1			    : COLOR1;		// [V] xyz:000 w:Fog
    float3 uv			        : TEXCOORD0;	// xy: z:Fog
    float4 worldPos             :TEXCOORD1;     // xyz = ワールド座標, w = 未使用
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

//-----------------------------------------------------------------------------
// 深度値用
//-----------------------------------------------------------------------------
struct TransparentDepthVPOutput {
	float4 Position;
	float4 Color0;
	float2 TexCoord;	// xy = テクスチャ座標, z = Fog
};