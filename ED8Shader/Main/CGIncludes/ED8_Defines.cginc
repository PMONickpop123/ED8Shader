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

/*
{
    #define WATER_SURFACE_ENABLED
    #define GLARE_MAP_ENABLED
    #define NOTHING_ENABLED
    #define CASTS_SHADOWS_ONLY
    #define CASTS_SHADOWS
    #define RECEIVE_SHADOWS
    #define GENERATE_RELFECTION_ENABLED
    #define UNDER_WATER_ENABLED
    #define ALPHA_TESTING_ENABLED
    #define ALPHA_BLENDING_ENABLED 
    #define ADDITIVE_BLENDING_ENABLED 
    #define SUBTRACT_BLENDING_ENABLED 
    #define MULTIPLICATIVE_BLENDING_ENABLED 
    #define TWOPASS_ALPHA_BLENDING_ENABLED
    #define DOUBLE_SIDED
    #define SHDOW_DOUBLE_SIDED
    #define FOG_ENABLED
    #define FOG_RATIO_ENABLED
    #define VERTEX_COLOR_ENABLED VERTEXLIGHT_ON
    #define TEXCOORD_OFFSET_ENABLED
    #define FORCE_CHAR_LIGHT_DIRECTION_ENABLED
    #define HEMISPHERE_AMBIENT_ENABLED
    #define MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
    #define SHADOW_COLOR_SHIFT_ENABLED
    #define	NO_ALL_LIGHTING_ENABLED
    #define	NO_MAIN_LIGHT_SHADING_ENABLED
    #define USE_PER_VERTEX_LIGHTING
    #define	HALF_LAMBERT_LIGHTING_ENABLED 
    #define	CARTOON_SHADING_ENABLED 
    #define	CARTOON_HILIGHT_ENABLED 
    #define	CUSTOM_DIFFUSE_ENABLED 
    #define	NORMAL_MAPPING_ENABLED 
    #define	OCCULUSION_MAPPING_ENABLED 
    #define	PROJECTION_MAP_ENABLED
    #define	EMISSION_MAPPING_ENABLED 
    #define	SPECULAR_ENABLED 
    #define	SPECULAR_MAPPING_ENABLED 
    #define	FAKE_CONSTANT_SPECULAR_ENABLED
    #define	PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED
    #define	RIM_LIGHTING_ENABLED 
    #define	RIM_TRANSPARENCY_ENABLED 
    #define	SPHERE_MAPPING_ENABLED 
    #define	CUBE_MAPPING_ENABLED 
    #define	EMVMAP_AS_IBL_ENABLED
    #define	DUDV_MAPPING_ENABLED 
    #define	WATER_SURFACE_ENABLED 
    #define	NORMAL_MAPP_DXT5_NM_ENABLED 
    #define	NORMAL_MAPP_DXT5_LP_ENABLED 
    #define	WINDY_GRASS_ENABLED 
    #define	WINDY_GRASS_TEXV_WEIGHT_ENABLED 
    #define	GLARE_HIGHTPASS_ENABLED 
    #define	GLARE_EMISSION_ENABLED 
    #define	GLARE_MAP_ENABLED 
    #define	MULTI_UV_ENANLED
    #define	MULTI_UV_ADDITIVE_BLENDING_ENANLED
    #define	MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED
    #define	MULTI_UV_SHADOW_ENANLED
    #define	MULTI_UV_FACE_ENANLED
    #define	MULTI_UV_TEXCOORD_OFFSET_ENABLED
    #define	MULTI_UV_NORMAL_MAPPING_ENABLED 
    #define	MULTI_UV_OCCULUSION_MAPPING_ENABLED 
    #define	MULTI_UV_SPECULAR_MAPPING_ENABLED 
    #define	MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED
    #define	MULTI_UV2_ENANLED
    #define	MULTI_UV2_ADDITIVE_BLENDING_ENANLED
    #define	MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
    #define	MULTI_UV2_SHADOW_ENANLED
    #define	MULTI_UV2_FACE_ENANLED
    #define	MULTI_UV2_TEXCOORD_OFFSET_ENABLED
    #define	MULTI_UV2_OCCULUSION_MAPPING_ENABLED 
    #define	MULTI_UV2_SPECULAR_MAPPING_ENABLED 
    #define	MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED
    #define	DIFFUSEMAP_CHANGING_ENABLED
}
*/

#if !defined(NOTHING_ENABLED)
	#if !defined(LIGHTING_ENABLED)
		#define LIGHTING_ENABLED
	#endif
#else
	#undef LIGHTING_ENABLED
#endif

//#if defined(CASTS_SHADOWS_ONLY)
//	#if !defined(CASTS_SHADOWS)
//		#define CASTS_SHADOWS
//	#endif
//#endif

#if !defined(NO_ALL_LIGHTING_ENABLED) && defined(LIGHTING_ENABLED)
	#define USE_LIGHTING
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define TOON_FIRST_LIGHT_ONLY_ENABLED
#define USE_EDGE_ADDUNSAT

// 頂点タンジェント
#if (defined(NORMAL_MAPPING_ENABLED) || defined(NORMAL_MAPPING2_ENABLED)) && !defined(USE_PER_VERTEX_LIGHTING)
	#define USE_TANGENTS
#endif // (defined(NORMAL_MAPPING_ENABLED) || defined(NORMAL_MAPPING2_ENABLED)) && !defined(USE_PER_VERTEX_LIGHTING)


// キューブマップまたはスフィアマップとトゥーン
#if (defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)) && defined(CARTOON_SHADING_ENABLED)
	#undef USE_PER_VERTEX_LIGHTING
#endif

// アルファブレンド
#if !defined(ALPHA_BLENDING_ENABLED)
	#undef ADDITIVE_BLENDING_ENABLED
	#undef SUBTRACT_BLENDING_ENABLED
	#undef MULTIPLICATIVE_BLENDING_ENABLED
#endif // !defined(ALPHA_BLENDING_ENABLED)

#if defined(ADDITIVE_BLENDING_ENABLED) || defined(SUBTRACT_BLENDING_ENABLED) || defined(MULTIPLICATIVE_BLENDING_ENABLED)
	#define USE_EXTRA_BLENDING
#endif

// 2パスアルファ
#if !defined(ALPHA_BLENDING_ENABLED) || defined(USE_EXTRA_BLENDING) || defined(DCC_TOOL)
	#undef TWOPASS_ALPHA_BLENDING_ENABLED
#endif //

// トゥーンの場合で、半球環境光がなければつける。ただ、明示的に3値でなければ
#if defined(CARTOON_SHADING_ENABLED) || !defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	#if !defined(HEMISPHERE_AMBIENT_ENABLED) && !defined(MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED)
		#define HEMISPHERE_AMBIENT_ENABLED
		#define MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	#endif
#endif

// 背景の書割とか、どう考えても頂点単位のライトで十分な場所を明示的に指定することにする

// フェイクでないスペキュラ持ちか、リムライト持ち
#if (defined(SPECULAR_ENABLED) && !defined(FAKE_CONSTANT_SPECULAR_ENABLED)) || defined(RIM_LIGHTING_ENABLED)
    #undef USE_PER_VERTEX_LIGHTING
#endif //

// リム透明度がある場合はvitaでもピクセル単位
#if defined(RIM_LIGHTING_ENABLED) && defined(RIM_TRANSPARENCY_ENABLED) 
	#undef USE_PER_VERTEX_LIGHTING
#endif

// トゥーン
#if defined(CARTOON_SHADING_ENABLED)
	#undef WINDY_GRASS_ENABLED
	#undef USE_PER_VERTEX_LIGHTING
	#define CARTOON_AVOID_SELFSHADOW_OFFSET

	//#if defined(CASTS_SHADOWS)
	//	#if !defined(RECEIVE_SHADOWS)
	//		#define RECEIVE_SHADOWS
	//	#endif
	//#endif
#endif // defined(CARTOON_SHADING_ENABLED)

// マルチUV
#if !defined(MULTI_UV_ENANLED)
	#undef MULTI_UV_ADDITIVE_BLENDING_ENANLED
	#undef MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED
	#undef MULTI_UV_SHADOW_ENANLED
	#undef MULTI_UV_TEXCOORD_OFFSET_ENABLED
	#undef MULTI_UV_NORMAL_MAPPING_ENABLED
	#undef MULTI_UV_OCCULUSION_MAPPING_ENABLED
	#undef MULTI_UV_SPECULAR_MAPPING_ENABLED
	#undef MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED
	#undef MULTI_UV2_ENANLED
	#undef MULTI_UV2_ADDITIVE_BLENDING_ENANLED
	#undef MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
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
	#undef MULTI_UV_SHADOW_ENANLED
#endif

#if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	#undef MULTI_UV2_ADDITIVE_BLENDING_ENANLED
	#undef MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
	#undef MULTI_UV2_SHADOW_ENANLED
#endif

// マルチUV2
#if defined(MULTI_UV2_ENANLED)
	#undef CUBE_MAPPING_ENABLED
	#undef SPHERE_MAPPING_ENABLED
	#undef CARTOON_SHADING_ENABLED
#else
	#if defined(WATER_SURFACE_ENABLED)
		#undef ALPHA_BLENDING_ENABLED
		#undef ADDITIVE_BLENDING_ENABLED
		#undef SUBTRACT_BLENDING_ENABLED
		#undef MULTIPLICATIVE_BLENDING_ENABLED
		#undef USE_EXTRA_BLENDING
	#endif // defined(WATER_SURFACE_ENABLED)

	#if defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED)
		#define USE_SCREEN_UV
	#endif // defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED)
#endif // MULTI_UV2_ENANLED

#if defined(CUBE_MAPPING_ENABLED)
	#undef SPHERE_MAPPING_ENABLED
#endif // CUBE_MAPPING_ENABLED

// DuDv
#if defined(DUDV_MAPPING_ENABLED)
	#undef MULTI_UV_ENANLED
	#undef MULTI_UV2_ENANLED
#endif // DUDV_MAPPING_ENABLED

#define MAINLIGHT_CLAMP_FACTOR_ENABLED // Global or Material

#if defined(CARTOON_SHADING_ENABLED) || defined(FORCE_CHAR_LIGHT_DIRECTION_ENABLED) || defined(CHAR_EQUIP_ENABLED)
    #define LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
    #define SHINING_MODE_ENABLED
#endif

#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
    half3 _LightDirForChar = half3(8.0f, 8.0f, 0.0f);
#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED

half _PerMaterialMainLightClampFactor;
half _GlobalMainLightClampFactor;
#if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
	#if defined(PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED)
		#define _MainLightClampFactor _PerMaterialMainLightClampFactor
	#else // PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED
		#define _MainLightClampFactor 1.5
	#endif // PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED
#endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

#if defined(USE_SCREEN_UV)
	#define _ScreenWidth _ScreenParams.x
	#define _ScreenHeight _ScreenParams.y
#endif // defined(USE_SCREEN_UV)

#if defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)
    half4 UserClipPlane = {0.0, 1.0, 0.0, 0.0}; // xyzw (nx,ny,nz,height)
#endif // defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)

half _ReflectionIntensity;

#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
    half3 _PortraitLightColor = half3(0.55f,0.55f,0.55f);
    half3 _PortraitAmbientColor = half3(0.55f,0.55f,0.55f);
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#if defined(SHINING_MODE_ENABLED)
    half3 _ShiningLightColor;
#endif // defined(SHINING_MODE_ENABLED)

half _GlowThreshold = 1.0;
half _GameMaterialID;
half4 _GameMaterialDiffuse;
half3 _GameMaterialEmission;
half4 _GameMaterialTexcoord;

#if defined(UVA_SCRIPT_ENABLED)
    half4 _UVaMUvColor;
    half4 _UVaProjTexcoord;
    half4 _UVaMUvTexcoord;
    half4 _UVaMUv2Texcoord;
    half4 _UVaDuDvTexcoord;
#endif // UVA_SCRIPT_ENABLED

half _GlobalTexcoordFactor;
half _AlphaTestDirection;
half _AlphaThreshold;

#if defined(FOG_ENABLED)
    half3 _FogColor;
    half2 _FogRangeParameters;

    #if defined(FOG_RATIO_ENABLED)
        half _FogRatio;
    #endif
#endif // FOG_ENABLED

#if defined(SHADOW_COLOR_SHIFT_ENABLED)
    half3 _ShadowColorShift;
#endif

#if defined(HEMISPHERE_AMBIENT_ENABLED)
    half3 _HemiSphereAmbientSkyColor;
    half3 _HemiSphereAmbientGndColor;
    half3 _HemiSphereAmbientAxis;
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

half2 _TexCoordOffset;
half2 _TexCoordOffset2;
half2 _TexCoordOffset3;

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

#if defined(SPHERE_MAPPING_ENABLED)
    sampler2D _SphereMapSampler;
    half _SphereMapIntensity;
#endif // SPHERE_MAPPING_ENABLED

#if defined(CUBE_MAPPING_ENABLED)
    sampler2D _CubeMapSampler;
    half _CubeFresnelPower;
#endif // CUBE_MAPPING_ENABLED

#if !defined(CARTOON_SHADING_ENABLED)
	#if defined(PROJECTION_MAP_ENABLED)
        sampler2D _ProjectionMapSampler;
        half2 _ProjectionScale;
        half2 _ProjectionScroll;
	#endif // PROJECTION_MAP_ENABLED

	#if defined(DUDV_MAPPING_ENABLED)
        sampler2D _DuDvMapSampler;
        half2 _DuDvMapImageSize;
        half2 _DuDvScroll;
        half2 _DuDvScale;
	#endif // DUDV_MAPPING_ENABLED

    #if defined(WINDY_GRASS_ENABLED)
        half2 _WindyGrassDirection;
        half _WindyGrassSpeed;
        half _WindyGrassHomogenity;
        half _WindyGrassScale;
	#endif // WINDY_GRASS_ENABLED
#endif // CARTOON_SHADING_ENABLED

half4 _GameEdgeParameters;

#if defined(USE_SCREEN_UV)
	sampler2D _ReflectionTexture;
	sampler2D _RefractionTexture;
#endif // defined(USE_SCREEN_UV)

#if defined(GLARE_MAP_ENABLED)
    sampler2D _GlareMapSampler;
#endif // GLARE_MAP_ENABLED

half _GlareIntensity;
half3 _GlobalAmbientColor;
half _AdditionalShadowOffset;
int _Culling;
half _SrcBlend;
half _DstBlend;

//-----------------------------------------------------------------------------
struct DefaultVPInput {
    float4 vertex			: POSITION;
    float3 normal			: NORMAL;
    float2 uv			: TEXCOORD0;

    #if defined(VERTEX_COLOR_ENABLED)
        float4 color			: COLOR0;
    #endif // VERTEX_COLOR_ENABLED

    #if defined(USE_TANGENTS)
        float4 tangent			: TANGENT;
    #endif // USE_TANGENTS

    #if defined(MULTI_UV_ENANLED)
        float2 uv2		: TEXCOORD3;
    #endif // MULTI_UV_ENANLED

    #if defined(MULTI_UV2_ENANLED)
        float2 uv3		: TEXCOORD4;
    #endif // defined(MULTI_UV2_ENANLED)
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

//-----------------------------------------------------------------------------
struct DefaultVPOutput {
    float4 pos			: SV_POSITION;		// xyzw:[Proj]
    float4 Color0			: COLOR0;		// xyzw:VertexColor x GameDiffuse
    float4 Color1			: COLOR1;		// [V] xyz:000 w:Fog
                                // [P] xyz:SubLight w:Fog
    float2 uv			: TEXCOORD0;	// xy: UV
    float4 WorldPositionDepth	: TEXCOORD1;	// xyz[World]: w[View]:z

    // TexCoord2
    #if defined(DUDV_MAPPING_ENABLED)
        float2 DuDvTexCoord	: TEXCOORD2;	// xy: DUDV
    #elif defined(MULTI_UV_ENANLED)
        float2 uv2		: TEXCOORD2;	// xy: UV Vertex Alpha Lerp
    #endif // DUDV_MAPPING_ENABLED || MULTI_UV_ENANLED

    // Projection/Etc
    #if defined(PROJECTION_MAP_ENABLED)
        float2 ProjMap			: TEXCOORD3;	// xy: Projection UV
    #endif // PROJECTION_MAP_ENABLED

    float3 normal			: TEXCOORD4;		// xyz[World]: Normals

    #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
        #if defined(USE_TANGENTS)
            float3 tangent			: TEXCOORD6;		// xyz[World]: Tangents
        #endif // USE_TANGENTS
    #else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
        #if defined(USE_LIGHTING)
            float3 LightingAmount	: TEXCOORD5;		// Lighting+

            #if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
                float4 ShadingAmount	: TEXCOORD6;		// Shading+
            #else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
                float3 ShadingAmount	: TEXCOORD6;		// Shading+
            #endif // defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
        #endif // USE_LIGHTING
    #endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

    #if defined(MULTI_UV2_ENANLED)
        float2 uv3		: TEXCOORD7;	// xy: UV2 Vertex Alpha Lerp
    #endif // defined(MULTI_UV2_ENANLED)

    #if defined(USE_SCREEN_UV)
        float4 ReflectionMap			: TEXCOORD7;
    #endif // defined(USE_SCREEN_UV)

    #if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
        #if defined(CUBE_MAPPING_ENABLED)
            float4 CubeMap			: TEXCOORD7;
        #elif defined(SPHERE_MAPPING_ENABLED)
            float2 SphereMap			: TEXCOORD7;
        #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
    #endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

    #if defined(CARTOON_SHADING_ENABLED)
        #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
            float3 CartoonMap	: TEXCOORD7;	// xy: HiLight z:ldotn
        #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
    #endif // CUBE_MAPPING_ENABLED

	SHADOW_COORDS(8)
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

//-----------------------------------------------------------------------------
struct EdgeVPOutput {
    float4 Position			: SV_POSITION ;		// xyzw:[Proj] 
    float4 Color0			: COLOR0;		// xyzw:EdgeColor + GameEmission
    float3 TexCoord			: TEXCOORD0;	// xy: z:Fog
};