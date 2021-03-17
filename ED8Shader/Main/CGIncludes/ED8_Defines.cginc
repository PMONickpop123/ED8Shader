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
    #define VERTEX_COLOR_ENABLED 
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

#if !defined(CUSTOM_DIFFUSE_SUPPORT)
	#undef CUSTOM_DIFFUSE_ENABLED 
#endif // CUSTOM_DIFFUSE_SUPPORT

#if !defined(NO_ALL_LIGHTING_ENABLED) && defined(LIGHTING_ENABLED)
	#define USE_LIGHTING
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define TOON_FIRST_LIGHT_ONLY_ENABLED
#define USE_EDGE_ADDUNSAT

// é ‚ç‚¹ã‚¿ãƒ³ã‚¸ã‚§ãƒ³ãƒˆ
#if (defined(NORMAL_MAPPING_ENABLED) || defined(NORMAL_MAPPING2_ENABLED)) && !defined(USE_PER_VERTEX_LIGHTING)
	#define USE_TANGENTS
#endif // (defined(NORMAL_MAPPING_ENABLED) || defined(NORMAL_MAPPING2_ENABLED)) && !defined(USE_PER_VERTEX_LIGHTING)


// ã‚­ãƒ¥ãƒ¼ãƒ–ãƒžãƒƒãƒ—ã¾ãŸã¯ã‚¹ãƒ•ã‚£ã‚¢ãƒžãƒƒãƒ—ã¨ãƒˆã‚¥ãƒ¼ãƒ³
#if (defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)) && defined(CARTOON_SHADING_ENABLED)
	#undef USE_PER_VERTEX_LIGHTING
#endif

// ã‚¢ãƒ«ãƒ•ã‚¡ãƒ–ãƒ¬ãƒ³ãƒ‰
#if !defined(ALPHA_BLENDING_ENABLED)
	#undef ADDITIVE_BLENDING_ENABLED
	#undef SUBTRACT_BLENDING_ENABLED
	#undef MULTIPLICATIVE_BLENDING_ENABLED
#endif // !defined(ALPHA_BLENDING_ENABLED)

#if defined(ADDITIVE_BLENDING_ENABLED) || defined(SUBTRACT_BLENDING_ENABLED) || defined(MULTIPLICATIVE_BLENDING_ENABLED)
	#define USE_EXTRA_BLENDING
#endif

// 2ãƒ‘ã‚¹ã‚¢ãƒ«ãƒ•ã‚¡
#if !defined(ALPHA_BLENDING_ENABLED) || defined(USE_EXTRA_BLENDING) || defined(DCC_TOOL)
	#undef TWOPASS_ALPHA_BLENDING_ENABLED
#endif //

// ãƒˆã‚¥ãƒ¼ãƒ³ã®å ´åˆã§ã€åŠçƒç’°å¢ƒå…‰ãŒãªã‘ã‚Œã°ã¤ã‘ã‚‹ã€‚ãŸã ã€æ˜Žç¤ºçš„ã«3å€¤ã§ãªã‘ã‚Œã°
#if defined(CARTOON_SHADING_ENABLED) || !defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	#if !defined(HEMISPHERE_AMBIENT_ENABLED) && !defined(MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED)
		#define HEMISPHERE_AMBIENT_ENABLED
		#define MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	#endif
#endif

// èƒŒæ™¯ã®æ›¸å‰²ã¨ã‹ã€ã©ã†è€ƒãˆã¦ã‚‚é ‚ç‚¹å˜ä½ã®ãƒ©ã‚¤ãƒˆã§ååˆ†ãªå ´æ‰€ã‚’æ˜Žç¤ºçš„ã«æŒ‡å®šã™ã‚‹ã“ã¨ã«ã™ã‚‹

// ãƒ•ã‚§ã‚¤ã‚¯ã§ãªã„ã‚¹ãƒšã‚­ãƒ¥ãƒ©æŒã¡ã‹ã€ãƒªãƒ ãƒ©ã‚¤ãƒˆæŒã¡
#if (defined(SPECULAR_ENABLED) && !defined(FAKE_CONSTANT_SPECULAR_ENABLED)) || defined(RIM_LIGHTING_ENABLED)
    #undef USE_PER_VERTEX_LIGHTING
#endif //

// ãƒªãƒ é€æ˜Žåº¦ãŒã‚ã‚‹å ´åˆã¯vitaã§ã‚‚ãƒ”ã‚¯ã‚»ãƒ«å˜ä½
#if defined(RIM_LIGHTING_ENABLED) && defined(RIM_TRANSPARENCY_ENABLED) 
	#undef USE_PER_VERTEX_LIGHTING
#endif

// ãƒˆã‚¥ãƒ¼ãƒ³
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

// ãƒžãƒ«ãƒUV
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

// ãƒžãƒ«ãƒUV2
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
    float3 _LightDirForChar;
#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED

float _PerMaterialMainLightClampFactor;

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
    float4 UserClipPlane = {0.0, 1.0, 0.0, 0.0}; // xyzw (nx,ny,nz,height)
#endif // defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)

float _ReflectionIntensity;

#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
    #define _PortraitLightColor float3(0.55f,0.55f,0.55f)
    #define _PortraitAmbientColor float3(0.55f,0.55f,0.55f)
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#if defined(SHINING_MODE_ENABLED)
    float3 _ShiningLightColor;
#endif // defined(SHINING_MODE_ENABLED)

#if defined(CUSTOM_DIFFUSE_SUPPORT)
    float3 _CustomDiffuse_Hilight;
    float3 _CustomDiffuse_Base;
    float3 _CustomDiffuse_Middle;
    float3 _CustomDiffuse_Shadow;
#endif // CUSTOM_DIFFUSE_SUPPORT

float _GlowThreshold = 1.0;
float _GameMaterialID;
float4 _GameMaterialDiffuse;
float3 _GameMaterialEmission;
float4 _GameMaterialTexcoord;

#if defined(UVA_SCRIPT_ENABLED)
    float4 _UVaMUvColor;
    float4 _UVaProjTexcoord;
    float4 _UVaMUvTexcoord;
    float4 _UVaMUv2Texcoord;
    float4 _UVaDuDvTexcoord;
#endif // UVA_SCRIPT_ENABLED

float _GlobalTexcoordFactor;
float _AlphaTestDirection;
float _AlphaThreshold;

#if defined(FOG_ENABLED)
    float3 _FogColor;
    float2 _FogRangeParameters;

    #if defined(FOG_RATIO_ENABLED)
        float _FogRatio;
    #endif
#endif // FOG_ENABLED

#if defined(SHADOW_COLOR_SHIFT_ENABLED)
    float3 _ShadowColorShift;
#endif

#if defined(HEMISPHERE_AMBIENT_ENABLED)
    float3 _HemiSphereAmbientSkyColor;
    float3 _HemiSphereAmbientGndColor;
    float3 _HemiSphereAmbientAxis;
#endif // HEMISPHERE_AMBIENT_ENABLED

#if defined(SPECULAR_ENABLED)
    float _Shininess;
    float _SpecularPower;
    float3 _FakeSpecularDir;

   #if defined(SPECULAR_COLOR_ENABLED)
        float4 _SpecularColor;
    #endif
#endif

#if defined(RIM_LIGHTING_ENABLED)
    float3 _RimLitColor;
    float _RimLitIntensity;
    float _RimLitPower;
    float _RimLightClampFactor;
#endif 

float2 _TexCoordOffset;
float2 _TexCoordOffset2;
float2 _TexCoordOffset3;

#if !defined(NOTHING_ENABLED)
    sampler2D _DiffuseMapSampler;
#endif 
half4 _DiffuseMapSampler_ST;

#if defined(NORMAL_MAPPING_ENABLED)
    sampler2D _NormalMapSampler;
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

#if defined(DIFFUSEMAP_CHANGING_ENABLED)
    sampler2D _DiffuseMapTrans1Sampler;
    sampler2D _DiffuseMapTrans2Sampler;
#endif // DIFFUSEMAP_CHANGING_ENABLED

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

    float _ShadowReceiveOffset;
#endif // CARTOON_SHADING_ENABLED

#if defined(SPHERE_MAPPING_ENABLED)
    sampler2D _SphereMapSampler;
    float _SphereMapIntensity;
#endif // SPHERE_MAPPING_ENABLED

#if defined(CUBE_MAPPING_ENABLED)
    sampler2D _CubeMapSampler;
    float _CubeFresnelPower;
#endif // CUBE_MAPPING_ENABLED

#if !defined(CARTOON_SHADING_ENABLED)
	#if defined(PROJECTION_MAP_ENABLED)
        sampler2D _ProjectionMapSampler;
        float2 _ProjectionScale;
        float2 _ProjectionScroll;
	#endif // PROJECTION_MAP_ENABLED

	#if defined(DUDV_MAPPING_ENABLED)
        sampler2D _DuDvMapSampler;
        float2 _DuDvMapImageSize;
        float2 _DuDvScroll;
        float2 _DuDvScale;
	#endif // DUDV_MAPPING_ENABLED

    #if defined(WINDY_GRASS_ENABLED)
        float2 _WindyGrassDirection;
        float _WindyGrassSpeed;
        float _WindyGrassHomogenity;
        float _WindyGrassScale;
	#endif // WINDY_GRASS_ENABLED
#endif // CARTOON_SHADING_ENABLED

float4 _GameEdgeParameters;

#if defined(USE_SCREEN_UV)
	sampler2D _ReflectionTexture;
	sampler2D _RefractionTexture;
#endif // defined(USE_SCREEN_UV)

#if defined(GLARE_MAP_ENABLED)
    sampler2D _GlareMapSampler;
#endif // GLARE_MAP_ENABLED

float _GlareIntensity;
float3 _GlobalAmbientColor;
float _AdditionalShadowOffset;
int _Culling;

//-----------------------------------------------------------------------------
struct DefaultVPInput {
    float4 Position			: POSITION;
    float3 Normal			: NORMAL;
    float2 TexCoord			: TEXCOORD0;

    #if defined(VERTEX_COLOR_ENABLED)
        float4 Color			: COLOR0;
    #endif // VERTEX_COLOR_ENABLED

    #if defined(USE_TANGENTS)
        float3 Tangent			: TANGENT;
    #endif // USE_TANGENTS

    #if defined(MULTI_UV_ENANLED)
        float2 TexCoord2		: TEXCOORD3;
    #endif // MULTI_UV_ENANLED

    #if defined(MULTI_UV2_ENANLED)
        float2 TexCoord3		: TEXCOORD4;
    #endif // defined(MULTI_UV2_ENANLED)
};

//-----------------------------------------------------------------------------
struct DefaultVPOutput {
    float4 pos			: SV_Position;		// xyzw:[Proj]
    float4 Color0			: COLOR0;		// xyzw:VertexColor x GameDiffuse
    float4 Color1			: COLOR1;		// [V] xyz:000 w:Fog
                                // [P] xyz:SubLight w:Fog
    float2 TexCoord			: TEXCOORD0;	// xy: UV
    float4 WorldPositionDepth	: TEXCOORD1;	// xyz[World]: w[View]:z

    // TexCoord2
    #if defined(DUDV_MAPPING_ENABLED)
        float2 DuDvTexCoord	: TEXCOORD2;	// xy: DUDV
    #elif defined(MULTI_UV_ENANLED)
        float2 TexCoord2		: TEXCOORD2;	// xy: UV Vertex Alpha Lerp
    #endif // DUDV_MAPPING_ENABLED || MULTI_UV_ENANLED

    // Projection/Etc
    #if defined(PROJECTION_MAP_ENABLED)
        float2 ProjMap			: TEXCOORD3;	// xy: Projection UV
    #endif // PROJECTION_MAP_ENABLED

    float3 Normal			: TEXCOORD4;		// xyz[World]: Normals

    #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
        #if defined(USE_TANGENTS)
            float3 Tangent			: TEXCOORD6;		// xyz[World]: Tangents
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
        float2 TexCoord3		: TEXCOORD7;	// xy: UV2 Vertex Alpha Lerp
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
};

//-----------------------------------------------------------------------------
struct EdgeVPOutput {
    float4 Position			: SV_Position ;		// xyzw:[Proj] 
    float4 Color0			: COLOR0;		// xyzw:EdgeColor + GameEmission
    float3 TexCoord			: TEXCOORD0;	// xy: z:Fog
};