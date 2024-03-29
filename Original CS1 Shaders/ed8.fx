#line 1 "Z:/data/shaders/ed8.fx"
// このファイルはUTF-8コードで保存してください。
// ed8_MaterialSwitches_jp.hとed8_UIName_jp.hはShiftJISコードで保存してください。

/*
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
#define	float_LAMBERT_LIGHTING_ENABLED 
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
*/


#line 1 "Z:/data/shaders/PhyreShaderPlatform.h"
/* SCE CONFIDENTIAL
PhyreEngine(TM) Package 3.4.0.0
* Copyright (C) 2012 Sony Computer Entertainment Inc.
* All Rights Reserved.
*/

#ifndef PHYRE_SHADER_PLATFORM_H
#define PHYRE_SHADER_PLATFORM_H


#ifdef PHYRE_D3DFX
	#define FRAG_OUTPUT_COLOR SV_TARGET
	#define FRAG_OUTPUT_COLOR0 SV_TARGET0
	#define FRAG_OUTPUT_COLOR1 SV_TARGET1
	#define FRAG_OUTPUT_COLOR2 SV_TARGET2
	#define FRAG_OUTPUT_COLOR3 SV_TARGET3
#endif //! _PHYRE_D3DFX

//! Define fragment shader outputs if not defined yet.
#ifndef FRAG_OUTPUT_COLOR
	#define FRAG_OUTPUT_COLOR COLOR
#endif //! FRAG_OUTPUT_COLOR

#ifndef FRAG_OUTPUT_COLOR0
	#define FRAG_OUTPUT_COLOR0 COLOR0
#endif //! FRAG_OUTPUT_COLOR0

#ifndef FRAG_OUTPUT_COLOR1
	#define FRAG_OUTPUT_COLOR1 COLOR1
#endif //! FRAG_OUTPUT_COLOR1

#ifndef FRAG_OUTPUT_COLOR2
	#define FRAG_OUTPUT_COLOR2 COLOR2
#endif //! FRAG_OUTPUT_COLOR2

#ifndef FRAG_OUTPUT_COLOR3
	#define FRAG_OUTPUT_COLOR3 COLOR3
#endif //! FRAG_OUTPUT_COLOR3

#endif //! PHYRE_SHADER_PLATFORM_H

#line 80 "Z:/data/shaders/ed8.fx"

#line 1 "Z:/data/shaders/ed8_ShaderCommon.h"
/* SCE CONFIDENTIAL
PhyreEngine(TM) Package 3.4.0.0
* Copyright (C) 2012 Sony Computer Entertainment Inc.
* All Rights Reserved.
*/

#ifndef PHYRE_SHADER_COMMON_H
#define PHYRE_SHADER_COMMON_H


#line 1 "Z:/data/shaders/ed8_ShaderDefs.h"
/* SCE CONFIDENTIAL
PhyreEngine(TM) Package 3.4.0.0
* Copyright (C) 2012 Sony Computer Entertainment Inc.
* All Rights Reserved.
*/

#ifndef PHYRE_SHADER_DEFS_H
#define PHYRE_SHADER_DEFS_H

#define ED8_PROFILE_VP	vs_5_0
#define ED8_PROFILE_FP	ps_5_0


// A list of context switches that the engine knows about.

//#define NUM_LIGHTS 3
//#define NUM_LIGHTS 1
//#define TONE_MAP_ENABLED
//#define FOG_ENABLED
//#define ZPREPASS_ENABLED
//#define SSAO_ENABLED
//#define MOTION_BLUR_ENABLED
//#define LIGHTPREPASS_ENABLED

// A list of platforms/hosts the engine might define.
//#define PS3
//#define WIN32
//#define WIN32_NVIDIA
//#define WIN32_ATI
//#define MAYA
//#define MAX
//#define LEVEL_EDITOR
//#define DCC_TOOL


// DCC tool mode - disables some context switches and e.g. shadowmapping.
#if defined(MAYA) || defined(MAX) || defined(LEVEL_EDITOR)
	#define DCC_TOOL
#endif

#define MAX_SKINNING_BONES	3

// カスケード・シャドウマップ分割数。メイン側の分割数とあわせる必要がある。ColladaDefaultShaderやPhyreDefaultLitShaderが混じっているならPhyreShaderDefs.hとも合わせる。
	#define MAX_SPLIT_CASCADED_SHADOWMAP	2
//#define MAX_SPLIT_CASCADED_SHADOWMAP	3
//#define MAX_SPLIT_CASCADED_SHADOWMAP	4

// PCFによるソフトシャドウを有効にする。PhyreShaderDefs.hとも合わせる。
//#define PCF_ENABLED

// 距離によるシャドウの減衰を有効にする
#define SHADOW_ATTENUATION_ENABLED
#define SHADOW_ATTENUATION_VERTICAL_ENABLED
#define SHADOW_ATTENUATION_POWER			3
#define SHADOW_ATTENUATION_POWER_VERTICAL	3

// A list of light structures.

struct DirectionalLight
{
	float3 m_direction		: LIGHTDIRECTIONWS;
	float3 m_colorIntensity	: LIGHTCOLORINTENSITY;
};

struct PointLight
{
	float3 m_position		: LIGHTPOSITIONWS;
	float3 m_colorIntensity	: LIGHTCOLORINTENSITY;
	float4 m_attenuation	: LIGHTATTENUATION;
};

struct SpotLight
{
	float3 m_position : LIGHTPOSITIONWS;
	float3 m_direction : LIGHTDIRECTIONWS;
	float3 m_colorIntensity : LIGHTCOLORINTENSITY;
	float4 m_spotAngles : LIGHTSPOTANGLES;
	float4 m_attenuation : LIGHTATTENUATION;
};

struct PCFShadowMap
{
	float4x4 m_shadowTransform : SHADOWTRANSFORM;
};
struct CascadedShadowMap
{
	float4x4 m_split0Transform : SHADOWTRANSFORMSPLIT0;
	float4x4 m_split1Transform : SHADOWTRANSFORMSPLIT1;
	float4x4 m_split2Transform : SHADOWTRANSFORMSPLIT2;
	float4x4 m_split3Transform : SHADOWTRANSFORMSPLIT3;
	float4 m_splitDistances : SHADOWSPLITDISTANCES;
};
struct CombinedCascadedShadowMap
{
#if MAX_SPLIT_CASCADED_SHADOWMAP == 3

	float4x4 m_split0Transform : SHADOWTRANSFORMSPLIT0;
	float4x4 m_split1Transform : SHADOWTRANSFORMSPLIT1;
	float4x4 m_split2Transform : SHADOWTRANSFORMSPLIT2;

	float4 m_splitDistances : SHADOWSPLITDISTANCES;

#elif MAX_SPLIT_CASCADED_SHADOWMAP == 2

	float4x4 m_split0Transform : SHADOWTRANSFORMSPLIT0;
	float4x4 m_split1Transform : SHADOWTRANSFORMSPLIT1;
	
	float4 m_splitDistances : SHADOWSPLITDISTANCES;

#elif MAX_SPLIT_CASCADED_SHADOWMAP == 1

	float4x4 m_split0Transform : SHADOWTRANSFORMSPLIT0;

	float4 m_splitDistances : SHADOWSPLITDISTANCES;

#else // MAX_SPLIT_CASCADED_SHADOWMAP == 3

	float4x4 m_split0Transform : SHADOWTRANSFORMSPLIT0;
	float4x4 m_split1Transform : SHADOWTRANSFORMSPLIT1;
	float4x4 m_split2Transform : SHADOWTRANSFORMSPLIT2;
	float4x4 m_split3Transform : SHADOWTRANSFORMSPLIT3;

	float4 m_splitDistances : SHADOWSPLITDISTANCES;

#endif // MAX_SPLIT_CASCADED_SHADOWMAP == 3
};

// Output structure for deferred lighting fragment shader.
struct PSDeferredOutput
{
	float4 Colour : COLOR0;
	float4 NormalDepth : COLOR1;
};

#endif // PHYRE_SHADER_DEFS_H

#line 11 "Z:/data/shaders/ed8_ShaderCommon.h"

// Common code which is likely to be used by multiple shader files is placed in here. 

SamplerComparisonState ShadowMapSampler
{
	Filter = Comparison_Min_Mag_Linear_Mip_Point;
    AddressU = Clamp;
    AddressV = Clamp;
	ComparisonFunc = Less;
};

SamplerState DiffuseMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState DiffuseMap2SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState DiffuseMap3SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState DiffuseMapTrans1SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState DiffuseMapTrans2SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState NormalMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState NormalMap2SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState SpecularMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState SpecularMap2SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState SpecularMap3SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState OcculusionMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState OcculusionMap2SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState OcculusionMap3SamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState ProjectionMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState CartoonMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Clamp;
	AddressV = Clamp;
};

SamplerState HighlightMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Clamp;
	AddressV = Clamp;
};
SamplerState GlareMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Clamp;
	AddressV = Clamp;
};
SamplerState EmissionMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState DuDvMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState CubeMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};
SamplerState SphereMapSamplerS
{
	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState LinearWrapSampler
{
	Filter = Anisotropic;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState PointWrapSampler
{
	Filter = Min_Mag_Mip_Point;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState MinimapTextureSamplerS
{
 	Filter = Anisotropic;
	AddressU = Wrap;
	AddressV = Wrap;
};

// SampleShadowMap
// Sample a shadow map with 1 sample tap. 
float SampleShadowMap(float4 shadowPosition, Texture2D <float> shadowMap)
{
#ifdef DCC_TOOL
	// no shadows in DCC TOOL mode 
	return 1.0f;
#else //! DCC_TOOL
	float4 shadowPositionProjected = shadowPosition / shadowPosition.w;
	float shad = shadowMap.SampleCmpLevelZero(ShadowMapSampler,shadowPositionProjected.xy, shadowPositionProjected.z);
	return shad;
#endif //! DCC_TOOL
}

#define SHADOWMAP_SIZE		1000
#define PCF_OFFSETU (1.0f / SHADOWMAP_SIZE)
#define PCF_OFFSETV (0.5f / SHADOWMAP_SIZE)

float SampleOrthographicShadowMapPoisson(float3 shadowPosition, Texture2D<float> shadowMap, float offsetMultiplier) {
	float shadowRslt = 0.f;
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.94201624*PCF_OFFSETU*offsetMultiplier, -0.39906216*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.94558609*PCF_OFFSETU*offsetMultiplier, -0.76890725*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.09418410*PCF_OFFSETU*offsetMultiplier, -0.92938870*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.34495938*PCF_OFFSETU*offsetMultiplier,  0.29387760*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.91588581*PCF_OFFSETU*offsetMultiplier,  0.45771432*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.81544232*PCF_OFFSETU*offsetMultiplier, -0.87912464*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.38277543*PCF_OFFSETU*offsetMultiplier,  0.27676845*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.97484398*PCF_OFFSETU*offsetMultiplier,  0.75648379*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.44323325*PCF_OFFSETU*offsetMultiplier, -0.97511554*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.53742981*PCF_OFFSETU*offsetMultiplier, -0.47373420*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.26496911*PCF_OFFSETU*offsetMultiplier, -0.41893023*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.79197514*PCF_OFFSETU*offsetMultiplier,  0.19090188*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.24188840*PCF_OFFSETU*offsetMultiplier,  0.99706507*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2(-0.81409955*PCF_OFFSETU*offsetMultiplier,  0.91437590*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.19984126*PCF_OFFSETU*offsetMultiplier,  0.78641367*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	shadowRslt += shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy + float2( 0.14383161*PCF_OFFSETU*offsetMultiplier, -0.14100790*PCF_OFFSETV*offsetMultiplier), shadowPosition.z);
	return shadowRslt / 16.f;
}

float SampleOrthographicShadowMap(float3 shadowPosition, Texture2D<float> shadowMap, uint setting, float offsetMultiplier) {
	if(setting & 2)
		return SampleOrthographicShadowMapPoisson(shadowPosition, shadowMap, offsetMultiplier);
	else
		return shadowMap.SampleCmpLevelZero(ShadowMapSampler, shadowPosition.xy, shadowPosition.z);
}


// スポットライトのフォールオフ
// EvaluateSpotFalloff
// Evaluate the directional attenuation for a spot light.
float EvaluateSpotFalloff(float dp, float cosInnerAngle, float cosOuterAngle)
{
	float a = (cosOuterAngle - dp) / (cosOuterAngle - cosInnerAngle);
	a = saturate(a);
	return a * a;
}

float3 EvaluateNormalMapNormal(float3 inNormal, float2 inUv, float3 inTangent, uniform Texture2D<float4> normalMap, SamplerState sState)
{

#ifdef NORMAL_MAPP_DXT5_NM_ENABLED

	float4 normalMapData = normalMap.Sample(sState, inUv).xyzw;

	float3 normalMapNormal = float3(0.0f,0.0f,0.0f);
	normalMapNormal.x = normalMapData.a * 2.0 - 1.0;
	normalMapNormal.y = normalMapData.r * 2.0 - 1.0;
	normalMapNormal.z = sqrt(1 - saturate(normalMapNormal.x * normalMapNormal.x - normalMapNormal.y * normalMapNormal.y));

#elif defined(NORMAL_MAPP_DXT5_LP_ENABLED)
	float4 normalMapData = normalMap.Sample(sState, inUv).xyzw;

	normalMapData = normalMapData * 2.0 - 1.0;
	float3 normalMapNormal = float3(0.0f, 0.0f, 0.0f);
	normalMapNormal.x = normalMapData.r * normalMapData.a;
	normalMapNormal.y = normalMapData.g;
	normalMapNormal.z = sqrt(1 - saturate(normalMapNormal.x * normalMapNormal.x - normalMapNormal.y * normalMapNormal.y));

#else // NORMAL_MAPP_DXT5_NM_ENABLED
	float4 normalMapData = normalMap.Sample(sState, inUv).xyzw;


	float3 normalMapNormal = normalMapData.xyz * 2.0 - 1.0;

#endif // NORMAL_MAPP_DXT5_NM_ENABLED

	inTangent = normalize(inTangent);
	inNormal = normalize(inNormal);

	float3 biTangent = cross(inNormal, inTangent);

	// xはUフリップとして負の値にしていることがある。
	normalMapNormal.x *= (inUv.x < 0.0f) ? -1.0f : 1.0f;

	float3 n =  normalize( (normalMapNormal.x * inTangent) +
						  (normalMapNormal.y * biTangent) +
						  (normalMapNormal.z * inNormal));	

	return n;

}


// 普通に法線を求める
float3 EvaluateStandardNormal(float3 inNormal)
{
	return normalize(inNormal).xyz;
}

// 拡散光を計算する
float calcDiffuseLightAmt(float3 lightDir, float3 normal)
{
	// Diffuse calcs.
	float diffuseLightAmt = dot(lightDir,normal);

#ifdef HALF_LAMBERT_LIGHTING_ENABLED
	diffuseLightAmt = diffuseLightAmt * 0.5f + 0.5f;
	diffuseLightAmt *= diffuseLightAmt;
#else //! HALF_LAMBERT_LIGHTING_ENABLED
	diffuseLightAmt = saturate(diffuseLightAmt);
#endif //! HALF_LAMBERT_LIGHTING_ENABLED

	return diffuseLightAmt;
}

// 拡散光を計算する dot(L,N)計算済み
float calcDiffuseLightAmtLdotN(float ldotn)
{
	float diffuseValue;
	#ifdef HALF_LAMBERT_LIGHTING_ENABLED
	diffuseValue = ldotn * 0.5f + 0.5f;
	diffuseValue *= diffuseValue;
	#else //! HALF_LAMBERT_LIGHTING_ENABLED
	diffuseValue = saturate(ldotn);
	#endif //! HALF_LAMBERT_LIGHTING_ENABLED
	return diffuseValue;
}

// 鏡面反射を計算する
float calcSpecularLightAmt(float3 normal, float3 lightDir, float3 eyeDirection, float shininess, float specularPower) //, half fresnelPower)
{
	// Specular calcs
	float3 halfVec = normalize(eyeDirection + lightDir);
	float nDotH = saturate(dot(normal,halfVec));

	float specularLightAmount = saturate(pow(nDotH, specularPower)) * shininess; // * fresnel

	return specularLightAmount;
}

// ライトの減衰を計算する
float calculateAttenuation(float distanceToLight, float4 attenuationProperties)
{
	// attenuationProperties contains:
	// innerRange, outerRange, 1.0f/(outerRange/innerRange), (-innerRange / (outerRange/innerRange)
	float attenValue = saturate(distanceToLight * attenuationProperties.z + attenuationProperties.w);
	return 1.0 - (float)attenValue;
}

// ライトの減衰を計算する。距離の2乗版
float calculateAttenuationQuadratic(float distanceToLightSqr, float4 attenuationProperties)
{
	// attenuationProperties contains:
	// innerRange, outerRange, 1.0f/(outerRange/innerRange), (-innerRange / (outerRange/innerRange)
	float rd = (attenuationProperties.y * attenuationProperties.y ) - (attenuationProperties.x*attenuationProperties.x);
	float b = 1.0f / rd;
	float a = attenuationProperties.x*attenuationProperties.x;
	float c = a * b + 1.0f;

	float coeff0 = (float)(-b);
	float coeff1 = (float)(c);
	float attenValuef = saturate(distanceToLightSqr * coeff0 + coeff1);
	float attenValue = (float)attenValuef;

	return attenValue;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Shadow code.

// No shadow.
float EvaluateShadow(DirectionalLight light, float dummy, float dummy2, float3 worldPosition, float viewDepth, uint setting)
{
	return 1;
}

float EvaluateShadow(PointLight light, float dummy, float dummy2, float3 worldPosition, float viewDepth, uint setting)
{
	return 1;
}
float EvaluateShadow(SpotLight light, float dummy, float dummy2, float3 worldPosition, float viewDepth, uint setting)
{
	return 1;
}

// PCF shadow.
float EvaluateShadow(SpotLight light, PCFShadowMap shadow, Texture2D <float> shadowMap, float3 worldPosition, float viewDepth, uint setting)
{
	float4 shadowPosition = mul(float4(worldPosition,1), shadow.m_shadowTransform);
	return SampleShadowMap(shadowPosition, shadowMap);
}

float EvaluateShadow(DirectionalLight light, CascadedShadowMap shadow, Texture2D <float> shadowMap, float3 worldPosition, float viewDepth, uint setting)
{
	return 1.0f;
}

float EvaluateShadow(DirectionalLight light, CombinedCascadedShadowMap shadow, Texture2D <float> shadowMap, float3 worldPosition, float viewDepth, uint setting)
{
	float result = 1;
	float3 shadowPosition = float3(0.0f, 0.0f, 0.0f);

	#if MAX_SPLIT_CASCADED_SHADOWMAP == 3

	if (viewDepth > shadow.m_splitDistances.z)
	{
		return 1.0;
	}
	if (viewDepth < shadow.m_splitDistances.y)
	{
		if (viewDepth < shadow.m_splitDistances.x)
		{
			shadowPosition = mul(float4(worldPosition.xyz, 1), shadow.m_split0Transform).xyz;
			result = (float)SampleOrthographicShadowMap(shadowPosition, shadowMap).x;
		}
		else
		{
			shadowPosition = mul(float4(worldPosition.xyz, 1), shadow.m_split1Transform).xyz;
			result = (float)SampleOrthographicShadowMap(shadowPosition, shadowMap).x;
		}
	}
	else
	{
		shadowPosition = mul(float4(worldPosition.xyz, 1), shadow.m_split2Transform).xyz;
		result = (float)SampleOrthographicShadowMap(shadowPosition, shadowMap).x;
	}
	return result;

	#elif MAX_SPLIT_CASCADED_SHADOWMAP == 2
	
	if (viewDepth > shadow.m_splitDistances.y)
	{
		return 1.0;
	}
	if (viewDepth < shadow.m_splitDistances.x)
	{
		shadowPosition = mul(float4(worldPosition.xyz, 1), shadow.m_split0Transform).xyz;
		result = (float)SampleOrthographicShadowMap(shadowPosition, shadowMap, setting, 40.f / shadow.m_splitDistances.y).x;
	}
	else
	{
		shadowPosition = mul(float4(worldPosition.xyz, 1), shadow.m_split1Transform).xyz;
		result = (float)SampleOrthographicShadowMap(shadowPosition, shadowMap, setting, 10.0f / shadow.m_splitDistances.y).x;

		#ifdef SHADOW_ATTENUATION_ENABLED
		float shadowDensityBias = saturate((viewDepth - shadow.m_splitDistances.x) / (shadow.m_splitDistances.y - shadow.m_splitDistances.x));
		shadowDensityBias = pow(shadowDensityBias, SHADOW_ATTENUATION_POWER);
		result = (float)min(result + shadowDensityBias, 1);
		#endif
	}
	return result;

	#elif MAX_SPLIT_CASCADED_SHADOWMAP == 1

	if (viewDepth > shadow.m_splitDistances.x)
	{
		return 1.0;
	}
	shadowPosition = mul(float4(worldPosition.xyz, 1), shadow.m_split0Transform).xyz;
	result = (float)SampleOrthographicShadowMap(shadowPosition, shadowMap).x;
	return result;

	#else // MAX_SPLIT_CASCADED_SHADOWMAP == 3

	shadowPosition = viewDepth < shadow.m_splitDistances.y ? 
					(viewDepth < shadow.m_splitDistances.x ? mul(float4(worldPosition.xyz, 1), shadow.m_split0Transform).xyz :
															 mul(float4(worldPosition.xyz, 1), shadow.m_split1Transform).xyz)
					:
					(viewDepth < shadow.m_splitDistances.z ? mul(float4(worldPosition.xyz, 1), shadow.m_split2Transform).xyz :
															(iewDepth < shadow.m_splitDistances.w ? mul(float4(worldPosition.xyz, 1), shadow.m_split3Transform).xyz : 1);
	result = (float)SampleOrthographicShadowMap(shadowPosition, shadowMap).x;
	return result;

	#endif // MAX_SPLIT_CASCADED_SHADOWMAP == 3
}

#endif // PHYRE_SHADER_COMMON_H

#line 82 "Z:/data/shaders/ed8.fx"


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UI名の定義 

#define LANGUAGE_MATERIAL_SWITCHES_JP		// マテリアルスイッチ日本語化

// UI名 
#define UINAME_AlphaThreshold				"Alpha Threshold"

#define UINAME_FogRangeParameters			"[x]Fog Range"
#define UINAME_FogColor						"[x]Fog Color"
#define UINAME_FogRatio						"Fog Ratio"

#define UINAME_GameMaterialID				"[x]Game MaterialID"
#define UINAME_GameMaterialDiffuse			"[x]Game Diffuse"
#define UINAME_GameMaterialEmission			"[x]Game Emission"
#define UINAME_GameMaterialTexcoord			"[x]Game TexCoord"

#define UINAME_EdgeParameters				"[x]GameEdgeParameters"

#define UINAME_LocalMaterialDiffuse			"Local Diffuse"
#define UINAME_LocalMaterialEmission		"Local Emission"
#define UINAME_LocalMaterialTexcoordOffset	"Local TexCoord"

#define UINAME_GlobalAmbientColor			"[x]Ambient Color"
#define UINAME_HemiSphereAmbientSkyColor	"[x]Hemi-Sphere Ambient Sky"
#define UINAME_HemiSphereAmbientGndColor	"[x]Hemi-Sphere Ambient Gnd"
#define UINAME_HemiSphereAmbientAxis		"[x]Hemi-Sphere Ambient Axis"
#define UINAME_ShadowColorShift				"Shadow Color Shift"

#define UINAME_CustomDiffuse_Hilight		"CustomDiffuse_Hilight(Test)"
#define UINAME_CustomDiffuse_Base			"CustomDiffuse_Base(Test)"
#define UINAME_CustomDiffuse_Middle			"CustomDiffuse_Middle(Test)"
#define UINAME_CustomDiffuse_Shadow			"CustomDiffuse_Shadow(Test)"

#define UINAME_UserClipPlane				"[x]Clip Plane(Reflection)"

#define UINAME_PerMaterialMainLightClampFactor	"Material MainLight Clamp"
#define UINAME_GlobalMainLightClampFactor		"[x]Global MainLight Clamp"

#define UINAME_Shininess					"Shininess"
#define UINAME_SpecularPower				"Specular Power"

#define UINAME_RimLightColor				"Rim Light Color"
#define UINAME_RimLightIntensity			"Rim Light Intensity"
#define UINAME_RimLightPower				"Rim Light Power"

#define UINAME_HighlightColor				"Highlight Color"
#define UINAME_HighlightIntensity			"Highlight Intensity"

#define UINAME_TexCoordOffset				"TexCoord Offset"
#define UINAME_DiffuseMapSampler			"Diffuse Map"
#define UINAME_SpecularMapSampler			"Specular Map"
#define UINAME_OcculusionMapSampler			"Occulusion Map"
#define UINAME_NormalMapSampler				"Normal Map"
#define UINAME_EmissionMapSampler			"Emission Map"

#define UINAME_TexCoordOffset2				"TexCoord Offset2"
#define UINAME_DiffuseMap2Sampler			"Diffuse Map2"
#define UINAME_SpecularMap2Sampler			"Specular Map2"
#define UINAME_OcculusionMap2Sampler		"Occulusion Map2"
#define UINAME_NormalMap2Sampler			"Normal Map2"

#define UINAME_TexCoordOffset3				"TexCoord Offset3"
#define UINAME_DiffuseMap3Sampler			"Diffuse Map3"
#define UINAME_SpecularMap3Sampler			"Specular Map3"
#define UINAME_OcculusionMap3Sampler		"Occulusion Map3"

#define UINAME_CartoonMapSampler			"Cartoon Map"
#define UINAME_HighlightMapSampler			"Highlight Map"
#define UINAME_ShadowReceiveOffset			"ToonShadowReceiveOffset"

#define UINAME_SphereMapSampler				"Sphere Map"
#define UINAME_SphereMapIntensity			"Sphere Map Intensity"

#define UINAME_CubeMapSampler				"Cube Map"
#define UINAME_CubeMapFresnelPower			"Cube Fresnel Power"

#define UINAME_ProjectionMapSampler			"Projection Map"
#define UINAME_ProjectionScale				"Projection Map Scale"
#define UINAME_ProjectionScroll				"Projection Map Scroll Speed"

#define UINAME_DuDvMapSampler				"DU/DV Map"
#define UINAME_DuDvMapImageSize				"DU/DV Map Image Size"
#define UINAME_DuDvMapScale					"DU/DV Map Scale"
#define UINAME_DuDvMapScroll				"DU/DV Map Scroll Speed"

#define UINAME_WindyGrassDirection			"Windy Grass Vector"
#define UINAME_WindyGrassSpeed				"Windy Grass Speed"
#define UINAME_WindyGrassHomogenity			"Windy Grass Homogenity"
#define UINAME_WindyGrassScale				"Windy Grass Scale"

#define UINAME_EdgeThickness				"Edge Thickness"
#define UINAME_EdgeColor					"Edge Color"

//#define UINAME_GlowThreshold				"Glow Threshold"
#define UINAME_GlowMapSampler				"Glow Map"
#define UINAME_GlowIntensity				"Glow Map Intensity"

#define UINAME_ReflectionIntensity			"ReflectionIntensity"

#define UINAME_PointLightInnerRange			"[x]Point Light Inner Range"
#define UINAME_PointLightOuterRange			"[x]Point Light Outer Range"

#define UINAME_DiffuseMapTrans1Sampler		"Diffuse Map Trans1"
#define UINAME_DiffuseMapTrans2Sampler		"Diffuse Map Trans2"
#define UINAME_DiffuseMapTransRatio			"[x]Diffuse Map Trans Ratio"

#define UINAME_PortraitLightColor			"[x]PortraitLightColor"
#define UINAME_PortraitAmbientColor			"[x]PortraitAmbientColor"

#define UINAME_UVaProjTexCoord				"[x]UVaProjTexCoord"
#define UINAME_UVaMUvTexCoord				"[x]UVaMUvTexCoord"
#define UINAME_UVaMUv2TexCoord				"[x]UVaMUv2TexCoord"
#define UINAME_UVaDuDvTexCoord				"[x]UVaDuDvTexCoord"
#define UINAME_UVaMUvColor					"[x]UVaMUvColor"


#if defined(DCC_TOOL) && defined(LANGUAGE_MATERIAL_SWITCHES_JP)


#line 1 "Z:/data/shaders/ed8_UIName_jp.h"
// '±'Ìƒtƒ@ƒCƒ‹'ÍShiftJISƒR[ƒh'Å•Û'¶'µ'Ä'­'¾'³'¢B

#undef UINAME_AlphaThreshold
#define UINAME_AlphaThreshold				"ƒAƒ‹ƒtƒ@è‡'l"

#undef UINAME_FogRangeParameters
#undef UINAME_FogColor
#undef UINAME_FogRatio
#define UINAME_FogRangeParameters			"[x]ƒtƒHƒO "ÍˆÍ"
#define UINAME_FogColor						"[x]ƒtƒHƒO ƒJƒ‰["
#define UINAME_FogRatio						"ƒtƒHƒO "K—p"x"

#undef UINAME_GameMaterialID
#undef UINAME_GameMaterialDiffuse
#undef UINAME_GameMaterialEmission
#undef UINAME_GameMaterialTexcoord
#define UINAME_GameMaterialID				"ƒQ[ƒ€ƒ}ƒeƒŠƒAƒ‹'h'c"
#define UINAME_GameMaterialDiffuse			"[x]ƒQ[ƒ€ŠgŽUƒJƒ‰["
#define UINAME_GameMaterialEmission			"[x]ƒQ[ƒ€"'"MŒõ"
#define UINAME_GameMaterialTexcoord	"[x]ƒQ[ƒ€UVƒ|ƒWƒVƒ‡ƒ""

#undef UINAME_EdgeParameters
#define UINAME_EdgeParameters				"[x]ƒQ[ƒ€ƒGƒbƒWƒpƒ‰ƒ[ƒ^"

#undef UINAME_LocalMaterialDiffuse
#undef UINAME_LocalMaterialEmission
#undef UINAME_LocalMaterialTexcoordOffset
#define UINAME_LocalMaterialDiffuse			"ƒ[ƒJƒ‹ŠgŽUƒJƒ‰["
#define UINAME_LocalMaterialEmission		"ƒ[ƒJƒ‹"'"MŒõ"
#define UINAME_LocalMaterialTexcoordOffset	"ƒ[ƒJƒ‹UVƒ|ƒWƒVƒ‡ƒ""

#undef UINAME_GlobalAmbientColor
#undef UINAME_HemiSphereAmbientSkyColor
#undef UINAME_HemiSphereAmbientGndColor
#undef UINAME_HemiSphereAmbientAxis
#undef UINAME_ShadowColorShift
#define UINAME_GlobalAmbientColor			"[x]ƒAƒ"ƒrƒGƒ"ƒg"
#define UINAME_HemiSphereAmbientSkyColor	"[x]"¼‹…ƒAƒ"ƒrƒGƒ"ƒg "V‹…ƒJƒ‰["
#define UINAME_HemiSphereAmbientGndColor	"[x]"¼‹…ƒAƒ"ƒrƒGƒ"ƒg 'n‹…ƒJƒ‰["
#define UINAME_HemiSphereAmbientAxis		"[x]"¼‹…ƒAƒ"ƒrƒGƒ"ƒg Ž²"
#define UINAME_ShadowColorShift				"‰A‰eƒJƒ‰[ƒVƒtƒg"

#undef UINAME_CustomDiffuse_Hilight
#undef UINAME_CustomDiffuse_Base
#undef UINAME_CustomDiffuse_Middle
#undef UINAME_CustomDiffuse_Shadow
#define UINAME_CustomDiffuse_Hilight		"ƒJƒXƒ^ƒ€F_ƒnƒCƒ‰ƒCƒg(Test)"
#define UINAME_CustomDiffuse_Base			"ƒJƒXƒ^ƒ€F_Šî–{F(Test)"
#define UINAME_CustomDiffuse_Middle			"ƒJƒXƒ^ƒ€F_'†ŠÔF(Test)"
#define UINAME_CustomDiffuse_Shadow			"ƒJƒXƒ^ƒ€F_‰eF(Test)"


#undef UINAME_PerMaterialMainLightClampFactor
#undef UINAME_GlobalMainLightClampFactor
#define UINAME_PerMaterialMainLightClampFactor		"ƒ}ƒeƒŠƒAƒ‹ ƒ‰ƒCƒg‹­"xãŒÀ"
#define UINAME_GlobalMainLightClampFactor			"[x]ƒOƒ[ƒoƒ‹ ƒ‰ƒCƒg‹­"xãŒÀ"



#undef UINAME_Shininess
#undef UINAME_SpecularPower
#define UINAME_Shininess					"ƒXƒyƒLƒ…ƒ‰ ‹P"x"
#define UINAME_SpecularPower				"ƒXƒyƒLƒ…ƒ‰ •ÎS"

#undef UINAME_RimLightColor
#undef UINAME_RimLightIntensity
#undef UINAME_RimLightPower
#define UINAME_RimLightColor				"ƒŠƒ€ƒ‰ƒCƒg ƒJƒ‰["
#define UINAME_RimLightIntensity			"ƒŠƒ€ƒ‰ƒCƒg ‹­"x"
#define UINAME_RimLightPower				"ƒŠƒ€ƒ‰ƒCƒg —£S"

#undef UINAME_HighlightColor
#undef UINAME_HighlightIntensity
#define UINAME_HighlightColor				"ƒnƒCƒ‰ƒCƒg ƒJƒ‰["
#define UINAME_HighlightIntensity			"ƒnƒCƒ‰ƒCƒg ‹­"x"

#undef UINAME_TexCoordOffset
#undef UINAME_DiffuseMapSampler
#undef UINAME_SpecularMapSampler
#undef UINAME_OcculusionMapSampler
#undef UINAME_NormalMapSampler
#define UINAME_TexCoordOffset				"ƒeƒNƒXƒ`ƒƒ ƒXƒNƒ[ƒ‹'¬"x"
#define UINAME_DiffuseMapSampler			"ƒfƒBƒtƒ…[ƒYƒ}ƒbƒv"
#define UINAME_SpecularMapSampler			"ƒXƒyƒLƒ…ƒ‰ƒ}ƒbƒv"
#define UINAME_OcculusionMapSampler			"ƒIƒNƒ‹[ƒWƒ‡ƒ"ƒ}ƒbƒv"
#define UINAME_NormalMapSampler				"ƒm[ƒ}ƒ‹ƒ}ƒbƒv"

#undef UINAME_TexCoordOffset2
#undef UINAME_DiffuseMap2Sampler
#undef UINAME_SpecularMap2Sampler
#undef UINAME_OcculusionMap2Sampler
#undef UINAME_NormalMap2Sampler
#define UINAME_TexCoordOffset2				"ƒ}ƒ‹ƒ`UV ƒXƒNƒ[ƒ‹'¬"x"
#define UINAME_DiffuseMap2Sampler			"ƒ}ƒ‹ƒ`UV ƒfƒBƒtƒ…[ƒYƒ}ƒbƒv"
#define UINAME_SpecularMap2Sampler			"ƒ}ƒ‹ƒ`UV ƒXƒyƒLƒ…ƒ‰ƒ}ƒbƒv"
#define UINAME_OcculusionMap2Sampler		"ƒ}ƒ‹ƒ`UV ƒIƒNƒ‹[ƒWƒ‡ƒ"ƒ}ƒbƒv"
#define UINAME_NormalMap2Sampler			"ƒ}ƒ‹ƒ`UV ƒm[ƒ}ƒ‹ƒ}ƒbƒv"

#undef UINAME_TexCoordOffset3
#undef UINAME_DiffuseMap3Sampler
#undef UINAME_SpecularMap3Sampler
#undef UINAME_OcculusionMap3Sampler
#define UINAME_TexCoordOffset3				"ƒ}ƒ‹ƒ`UV2 ƒXƒNƒ[ƒ‹'¬"x"
#define UINAME_DiffuseMap3Sampler			"ƒ}ƒ‹ƒ`UV2 ƒfƒBƒtƒ…[ƒYƒ}ƒbƒv"
#define UINAME_SpecularMap3Sampler			"ƒ}ƒ‹ƒ`UV2 ƒXƒyƒLƒ…ƒ‰ƒ}ƒbƒv"
#define UINAME_OcculusionMap3Sampler		"ƒ}ƒ‹ƒ`UV2 ƒIƒNƒ‹[ƒWƒ‡ƒ"ƒ}ƒbƒv"

#undef UINAME_CartoonMapSampler
#undef UINAME_HighlightMapSampler
#undef UINAME_ShadowReceiveOffset
#define UINAME_CartoonMapSampler			"ƒJ[ƒgƒD[ƒ"ƒ}ƒbƒv"
#define UINAME_HighlightMapSampler			"ƒnƒCƒ‰ƒCƒgƒ}ƒbƒv"
#define UINAME_ShadowReceiveOffset			"ƒgƒD[ƒ"‰eŽó'¯ˆÊ'u'¸'ç'µ"

#undef UINAME_SphereMapSampler
#undef UINAME_SphereMapIntensity
#define UINAME_SphereMapSampler				"ƒXƒtƒBƒAƒ}ƒbƒv"
#define UINAME_SphereMapIntensity			"ƒXƒtƒBƒAƒ}ƒbƒv ‹­"x"

#undef UINAME_CubeMapSampler
#undef UINAME_CubeMapFresnelPower
#define UINAME_CubeMapSampler				"ƒLƒ…[ƒuƒ}ƒbƒv"
#define UINAME_CubeMapFresnelPower			"ƒLƒ…[ƒuƒ}ƒbƒv ƒtƒŒƒlƒ‹—£S"

#undef UINAME_ProjectionMapSampler
#undef UINAME_ProjectionScale
#undef UINAME_ProjectionScroll
#define UINAME_ProjectionMapSampler			"ŽË‰eƒ}ƒbƒv"
#define UINAME_ProjectionScale				"ŽË‰eƒ}ƒbƒv ƒXƒP[ƒ‹"
#define UINAME_ProjectionScroll				"ŽË‰eƒ}ƒbƒv ƒXƒNƒ[ƒ‹'¬"x"

#undef UINAME_DuDvMapSampler
#undef UINAME_DuDvMapImageSize
#undef UINAME_DuDvMapScale
#undef UINAME_DuDvMapScroll
#define UINAME_DuDvMapSampler				"DU/DVƒ}ƒbƒv"
#define UINAME_DuDvMapImageSize				"DU/DVƒ}ƒbƒv ‰æ'œƒTƒCƒY"
#define UINAME_DuDvMapScale					"DU/DVƒ}ƒbƒv ƒXƒP[ƒ‹"
#define UINAME_DuDvMapScroll				"DU/DVƒ}ƒbƒv ƒXƒNƒ[ƒ‹'¬"x"

#undef UINAME_WindyGrassDirection
#undef UINAME_WindyGrassSpeed
#undef UINAME_WindyGrassHomogenity	
#undef UINAME_WindyGrassScale
#define UINAME_WindyGrassDirection			"''ä'ê Œü'«'Æ'å'«'³"
#define UINAME_WindyGrassSpeed				"''ä'ê '¬"x"
#define UINAME_WindyGrassHomogenity			"''ä'ê ‹Ïˆê«"
#define UINAME_WindyGrassScale				"''ä'ê ƒXƒP[ƒ‹"

#undef UINAME_EdgeThickness
#undef UINAME_EdgeColor
#define UINAME_EdgeThickness				"ƒGƒbƒW '¾'³"
#define UINAME_EdgeColor					"ƒGƒbƒW ƒJƒ‰["

#undef UINAME_GlowThreshold
#undef UINAME_GlowMapSampler
#undef UINAME_GlowIntensity
#define UINAME_GlowThreshold				"ƒOƒ[ è‡'l"
#define UINAME_GlowMapSampler				"ƒOƒ[ƒ}ƒbƒv"
#define UINAME_GlowIntensity				"ƒOƒ[ ‹­'³"

#undef UINAME_ReflectionIntensity
#define UINAME_ReflectionIntensity			"‰f'èž'Ý ‹­'³"

#undef UINAME_UserClipPlane
#define UINAME_UserClipPlane				"[x]ƒNƒŠƒbƒv•½–Ê(‹¾–Ê)"

#undef UINAME_PointLightInnerRange
#undef UINAME_PointLightOuterRange
#define UINAME_PointLightInnerRange			"[x]ƒ|ƒCƒ"ƒgƒ‰ƒCƒg"à‰"
#define UINAME_PointLightOuterRange			"[x]ƒ|ƒCƒ"ƒgƒ‰ƒCƒgŠO‰"

#undef UINAME_DiffuseMapTrans1Sampler
#undef UINAME_DiffuseMapTrans2Sampler
#undef UINAME_DiffuseMapTransRatio
#define UINAME_DiffuseMapTrans1Sampler		"ƒfƒBƒtƒ…[ƒYƒ}ƒbƒv'JˆÚ1"
#define UINAME_DiffuseMapTrans2Sampler		"ƒfƒBƒtƒ…[ƒYƒ}ƒbƒv'JˆÚ2"
#define UINAME_DiffuseMapTransRatio			"ƒfƒBƒtƒ…[ƒYƒ}ƒbƒv'JˆÚ—¦"

#undef UINAME_PortraitLightColor
#undef UINAME_PortraitAmbientColor
#define UINAME_PortraitLightColor			"[x]PortraitLightColor"
#define UINAME_PortraitAmbientColor			"[x]PortraitAmbientColor"

#line 205 "Z:/data/shaders/ed8.fx"

#endif // defined(DCC_TOOL) && defined(LANGUAGE_MATERIAL_SWITCHES_JP)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//#define POINT_LIGHT_TEST					// ポイントライトのテスト。maya上のポイントライトで範囲指定がないため
#ifndef DCC_TOOL
	#define OWN_POINTLIGHT_ENABLED
#endif // DCC_TOOL

#if !defined(__psp2__)
	#define USE_POINT_LIGHT_0
	#define USE_POINT_LIGHT_1
	#define USE_POINT_LIGHT_2
#endif

#ifdef POINT_LIGHT_TEST
	#ifndef DCC_TOOL
		#define POINT_LIGHT_INNTER_RANGE	0.0f
		#define POINT_LIGHT_OUTER_RANGE		0.50f
	#else
		#define POINT_LIGHT_INNTER_RANGE	0.0f
		#define POINT_LIGHT_OUTER_RANGE		50.0f
	#endif
#endif // POINT_LIGHT_TEST


#line 1 "Z:/data/shaders/ed8_SceneWideParameters.h"
/* SCE CONFIDENTIAL
PhyreEngine(TM) Package 3.4.0.0
* Copyright (C) 2012 Sony Computer Entertainment Inc.
* All Rights Reserved.
*/

#ifndef PHYRE_SCENE_WIDE_PARAMETERS_H
#define PHYRE_SCENE_WIDE_PARAMETERS_H

///////////////////////////////////////////////////////////////////////////////
// Scene wide parameters
///////////////////////////////////////////////////////////////////////////////

//struct SceneWideParameters
//{
	float3		scene_EyePosition				: EYEPOSITIONWS;

	float4x4	scene_View					: View;
	float4x4	scene_ViewProjection			: ViewProjection;

	float4		scene_cameraNearFarParameters		: CameraNearFarParameters;	// near, far, near*far, far-near
	float4		scene_viewportSizeParameters		: ViewportSizeParameters;	// viewportWidth, viewportHeight, 1/viewportWidth, 1/viewportHeight

	float3		scene_FakeRimLightDir			: FakeRimLightDir;
	float3		scene_GlobalAmbientColor		: GlobalAmbientColor;
	float3		scene_FogColor				: FOGCOLOR;
	float4		scene_FogRangeParameters		: FogRangeParameters;

	// ※高さフォグ廃止後、別用途で使用
	float3		scene_MiscParameters1			: HeightFogColor;				// xyzw = 未使用
	float4		scene_MiscParameters2			: HeightFogRangeParameters;		// x = 1 / シャドウマップの減衰距離(垂直方向), y = シャドウマップ減衰の基準高さ, zw = 未使用

	float		AdditionalShadowOffset	: AdditionalShadowOffset;

	#ifdef USE_POINT_LIGHT_0
	float4		scene_light1_position			: LIGHT1_POSITIONANDCOUNT;

	float3		scene_light1_colorIntensity	: LIGHT1_COLORINTENSITY;
	float4		scene_light1_attenuation		: LIGHT1_ATTENUATION;

		#ifdef USE_POINT_LIGHT_1
	float3		scene_light2_position			: LIGHT2_POSITION;
	float3		scene_light2_colorIntensity	: LIGHT2_COLORINTENSITY;
	float4		scene_light2_attenuation		: LIGHT2_ATTENUATION;

//			#ifdef USE_POINT_LIGHT_2
//	float3		light3_position			: LIGHT3_POSITION;
//	half3		light3_colorIntensity	: LIGHT3_COLORINTENSITY;
//	float4		light3_attenuation		: LIGHT3_ATTENUATION;
//
//			#endif // USE_POINT_LIGHT_2
		#endif // USE_POINT_LIGHT_1
	#endif // USE_POINT_LIGHT_0

//};

#ifdef DCC_TOOL
/*
float3 GlobalAmbientColor : AMBIENT
<
    string UIName = UINAME_GlobalAmbientColor;
	string UIWidget = "Color";
> = {0.50, 0.50, 0.50 };

float Timer : Time
<
	string UIWidget = "None";
>;
*/
#endif // DCC_TOOL

//sampler2D	DitherNoiseTexture : DITHERNOISETEXTURE;


//SceneWideParameters scene;


float3 getGlobalAmbientColor()
{
	return scene_GlobalAmbientColor.rgb;
}

float4 PackNormalAndViewSpaceDepth(float3 normal, float viewSpaceZ)
{
	float normalizedViewZ = viewSpaceZ / scene_cameraNearFarParameters.y;
	float2 depthPacked = float2( floor(normalizedViewZ * 256.0f) / 255.0f,  frac(normalizedViewZ * 256.0f) );
	float4 rslt = float4(normal.xy, depthPacked.xy);
	return rslt;
}
float4 PackNormalAndDepth(float3 normal, float depth)
{
	float viewSpaceZ = -(scene_cameraNearFarParameters.z / (depth * scene_cameraNearFarParameters.w - scene_cameraNearFarParameters.y));	// near*far / (depth * (far-near) - far)
	return PackNormalAndViewSpaceDepth(normal,viewSpaceZ);
}


#endif //! PHYRE_SCENE_WIDE_PARAMETERS_H

#line 232 "Z:/data/shaders/ed8.fx"


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// コンテキストスイッチの定義

// サポートするライトの総数。(マップ担当者が作業用のライトを多数おいているので、Maya上では1にする)
#ifdef DCC_TOOL
	#ifdef POINT_LIGHT_TEST
		#define MAX_NUM_LIGHTS 3
	#else
		#define MAX_NUM_LIGHTS 1
	#endif
#else // DCC_TOOL
//	#if defined(LIGHTING_ENABLED)
		#define MAX_NUM_LIGHTS 1
//		#define MAX_NUM_LIGHTS 3
//	#else //
//		#define MAX_NUM_LIGHTS 1
//	#endif //
#endif // DCC_TOOL


// Context switches
bool PhyreContextSwitches
<
//	string ContextSwitchNames[] = {"INSTANCING_ENABLED", "SHADER_LOD_LEVEL" };
	string ContextSwitchNames[] = {"NUM_LIGHTS", "INSTANCING_ENABLED", "SHADER_LOD_LEVEL" };
//	string ContextSwitchNames[] = {"NUM_LIGHTS", "INSTANCING_ENABLED" };
	int MaxNumLights = MAX_NUM_LIGHTS;
	string SupportedLightTypes[] = {"DirectionalLight"};//, "PointLight", "SpotLight"};
	string SupportedShadowTypes[] = {"CombinedCascadedShadowMap"};
//	string SupportedShadowTypes[] = {"PCFShadowMap", "CombinedCascadedShadowMap"};
	int NumSupportedShaderLODLevels = 1;
>;

///////////////////////////////////////////////////////////////////////////////
// Material switch definitions
bool PhyreMaterialSwitches
<
string MaterialSwitchNames[] =
{
	"NOTHING_ENABLED",
	"CASTS_SHADOWS_ONLY",
//	"USAGE_CHARACTER_ENABLED",
//	"USAGE_TERRAIN_ENABLED",

	"CASTS_SHADOWS",
	"RECEIVE_SHADOWS",
	"GENERATE_RELFECTION_ENABLED", 
	"UNDER_WATER_ENABLED",
//	"EDGE_ENABLED", 

	"ALPHA_TESTING_ENABLED",
	"ALPHA_BLENDING_ENABLED", 
	"ADDITIVE_BLENDING_ENABLED", 
	"SUBTRACT_BLENDING_ENABLED", 
	"MULTIPLICATIVE_BLENDING_ENABLED", 
	"TWOPASS_ALPHA_BLENDING_ENABLED",

	"DOUBLE_SIDED", 
	"SHDOW_DOUBLE_SIDED", 
	"FOG_ENABLED",
	"FOG_RATIO_ENABLED",
	"VERTEX_COLOR_ENABLED", 
	"TEXCOORD_OFFSET_ENABLED",
//	Additive Height Fog
	"FORCE_CHAR_LIGHT_DIRECTION_ENABLED",
//	"LIGHTING_ENABLED", 

	"HEMISPHERE_AMBIENT_ENABLED",
	"MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED",
	"SHADOW_COLOR_SHIFT_ENABLED",

	"NO_ALL_LIGHTING_ENABLED",
	"NO_MAIN_LIGHT_SHADING_ENABLED",
	"HALF_LAMBERT_LIGHTING_ENABLED", 
	"CARTOON_SHADING_ENABLED", 
	"CARTOON_HILIGHT_ENABLED", 
//	"CUSTOM_DIFFUSE_ENABLED", 
	"NORMAL_MAPPING_ENABLED", 
	"OCCULUSION_MAPPING_ENABLED", 
	"PROJECTION_MAP_ENABLED",
	"EMISSION_MAPPING_ENABLED", 

	"SPECULAR_ENABLED", 
//	"PER_PIXEL_SPECULAR_ENABLED", 
	"SPECULAR_MAPPING_ENABLED", 
	"FAKE_CONSTANT_SPECULAR_ENABLED",
	"PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED",

	"RIM_LIGHTING_ENABLED", 
	"RIM_TRANSPARENCY_ENABLED", 

	"SPHERE_MAPPING_ENABLED", 
	"CUBE_MAPPING_ENABLED", 
	"EMVMAP_AS_IBL_ENABLED",

	"DUDV_MAPPING_ENABLED", 
	"WATER_SURFACE_ENABLED", 

	"NORMAL_MAPP_DXT5_NM_ENABLED", 
	"NORMAL_MAPP_DXT5_LP_ENABLED", 

	"WINDY_GRASS_ENABLED", 
	"WINDY_GRASS_TEXV_WEIGHT_ENABLED", 
//	"BILLBOARD_ENABLED", 
//	"PERSPECTIVE_BILLBOARD_ENABLED", 
//	"CYLINDRICAL_BILLBOARD_ENABLED", 
//	"SPHERICAL_BILLBOARD_ENABLED", 

	"GLARE_HIGHTPASS_ENABLED", 
	"GLARE_EMISSION_ENABLED", 
	"GLARE_MAP_ENABLED", 
//	"GLARE_OVERFLOW_ENABLED", 

	"MULTI_UV_ENANLED",
	"MULTI_UV_ADDITIVE_BLENDING_ENANLED",
	"MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED",
	"MULTI_UV_SHADOW_ENANLED",
	"MULTI_UV_FACE_ENANLED",
	"MULTI_UV_TEXCOORD_OFFSET_ENABLED",
	"MULTI_UV_NORMAL_MAPPING_ENABLED", 
	"MULTI_UV_OCCULUSION_MAPPING_ENABLED", 
	"MULTI_UV_SPECULAR_MAPPING_ENABLED", 
	"MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED",

	"MULTI_UV2_ENANLED",
	"MULTI_UV2_ADDITIVE_BLENDING_ENANLED",
	"MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED",
	"MULTI_UV2_SHADOW_ENANLED",
	"MULTI_UV2_FACE_ENANLED",
	"MULTI_UV2_TEXCOORD_OFFSET_ENABLED",
	"MULTI_UV2_OCCULUSION_MAPPING_ENABLED", 
	"MULTI_UV2_SPECULAR_MAPPING_ENABLED", 
	"MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED",

	"DIFFUSEMAP_CHANGING_ENABLED",
	"FOR_EFFECT",	//ForceTransparent_forEffect
	"UVA_SCRIPT_ENABLED",
//	"SHINING_MODE_ENABLED",
};

string MaterialSwitchUiNames[] =
{
#if !defined(DCC_TOOL) || !defined(LANGUAGE_MATERIAL_SWITCHES_JP)

	"Nothing",
	"Casts Shadows Only",
//	"Usage Character",
//	"Usage Terrain",

	"Casts Shadows",
	"Receive Shadows",
	"Generate Reflection",
	"Under Water",
//	"Edge", 

	"Alpha Testing", 
	"Alpha Blending", 
	"Additive Blending", 
	"Subtract Blending", 
	"Multiplicative Blending", 
	"2Pass Alpha Blending",

	"Double Sided", 
	"Double Sided-Casts Shadows", 
	"Fog",
	"ZFog ZFactor",
	"Vertex Color", 
	"TexCoord Offset", 
//	"Additive Height Fog", 
	"Force Char Light Direction",
//	"Lighting", 

	"HS Ambient",
	"MHS Ambient",
	"Shadow Color Shift",

	"No All Lighting Shading",
	"No MainLight Shading",
	"Half Lambert Lighting", 
	"Cartoon Shading", 
	"Cartoon Hilight Mapping", 
//	"Custom Diffuse", 
	"Normal Mapping", 
	"Occulusion Mapping", 
	"Projection Mapping",
	"Emission Mapping", 

	"Specular", 
//	"Per Pixel Specular", 
	"Specular Mapping", 
	"Fake Constant Specular",
	"Per Material Main Light Clamp",

	"Rim Lightng", 
	"Rim Transparency", 

	"Sphere Mapping", 
	"Cube Mapping", 
	"EnvMap as IBL",

	"DUDV Mapping(Refrection)",
	"Water Surface",

	"Normal Mapp DXT5_NM", 
	"Normal Mapp DXT5_LP", 

	"Windy Grass", 
	"Windy Grass - TexV Weight", 
//	"Billboard", 
//	"Perspectibe Billboard", 
//	"Cylindrical Billboard", 
//	"Spherical Billboard", 

	"Glow(High-Pass)", 
	"Glow(Alpha as Emission)", 
	"Glow Map",
//	"Glow(Overflow)", 

	"Multi UV",
	"Multi UV Additive Blending",
	"Multi UV Multiplicative Blending",
	"Multi UV Shadow",
	"Multi UV Face",
	"Multi UV TexCoord Offset", 
	"Multi UV Normal Mapping", 
	"Multi UV Occulusion Mapping", 
	"Multi UV Specular Mapping", 
	"Multi UV No Diffuse Mapping", 

	"Multi UV2",
	"Multi UV2 Additive Blending",
	"Multi UV2 Multiplicative Blending",
	"Multi UV2 Shadow",
	"Multi UV2 Face",
	"Multi UV2 TexCoord Offset", 
	"Multi UV2 Occulusion Mapping", 
	"Multi UV2 Specular Mapping", 
	"Multi UV2 No Diffuse Mapping", 

	"Diffuse Map Changing", 
	"For Effect", // FOR_EFFECT
	"UVa Script",
//	"Shining Mode",

#else // !defined(DCC_TOOL) || !defined(LANGUAGE_MATERIAL_SWITCHES_JP)


#line 1 "Z:/data/shaders/ed8_MaterialSwitches_jp.h"
// '±'Ìƒtƒ@ƒCƒ‹'ÍShiftJISƒR[ƒh'Å•Û'¶'µ'Ä'­'¾'³'¢B

	"‰½'à'È'µ",						//"Nothing",
	"‰eê—pƒ'ƒfƒ‹",					//"Casts Shadows Only",
//	"—p"r-ƒLƒƒƒ‰",					//"Usage Character",
//	"—p"r-'nŒ`",					//"Usage Terrain",

	"‰e'ð—Ž'Æ'·",					//"Casts Shadows",
	"‰e'ðŽó'¯'é",					//"Receive Shadows",
	"‹¾–Ê'É‰f'èž'Þ",				//"Generate Reflection",
	"[x]…–Ê‰º' 'è",				//"Under Water"
//	"—ÖŠsü", 						//"Edge", 

	"ƒAƒ‹ƒtƒ@ƒeƒXƒg", 				//"Alpha Testing", 
	"ƒAƒ‹ƒtƒ@ƒuƒŒƒ"ƒh", 			//"Alpha Blending", 
	"‰ÁŽZƒuƒŒƒ"ƒh", 				//"Additive Blending", 
	"Œ¸ŽZƒuƒŒƒ"ƒh", 				//"Subtract Blending", 
	"æŽZƒuƒŒƒ"ƒh",					//"Multiplicative Blending",
	"2ƒpƒXƒAƒ‹ƒtƒ@ƒuƒŒƒ"ƒh",		//"2Pass Alpha Blending",

	"—¼–Ê", 						//"Double Sided", 
	"—¼–Ê(‰e¶¬Žž'Ì'Ý)",	 		//"Double Sided-Casts Shadows", 
	"ƒtƒHƒO",						//"Fog",
	"ƒtƒHƒO"K—p"x",					//"FogFactor",
	"'¸"_ƒJƒ‰[", 					//"Vertex Color", 
	"ƒeƒNƒXƒ`ƒƒƒXƒNƒ[ƒ‹",			//"TexCoord Offset", 
//	"‰ÁŽZ''³ƒtƒHƒO(€"õ'†)",		//"Additive Height Fog",
	"‹­§ƒLƒƒƒ‰ƒ‰ƒCƒg•ûŒü",			//"Force Char Light Direction"
//	"ƒ‰ƒCƒeƒBƒ"ƒO",					//"Lighting",

	""¼‹…ŠÂ‹«Œõ",					//"HS Ambient",
	""¼‹…ŠÂ‹«Œõ('†‰›'l' 'è)",		//"MHS Ambient",
	"‰A‰eƒJƒ‰[ƒVƒtƒg",				//"Shadow Color Shift",

	"'SÆ–¾'È'µ",					//"No All Lighting Shading",
	"ŽåŒõŒ¹'Ì‰A‰e'È'µ",				//"No MainLight Shading",
	"ƒn[ƒtƒ‰ƒ"ƒo[ƒg", 			//"Half Lambert Lighting", 
	"ƒgƒD[ƒ"ƒVƒF[ƒfƒBƒ"ƒO", 		//"Cartoon Shading", 
	"ƒgƒD[ƒ"ƒnƒCƒ‰ƒCƒg", 			//"Cartoon Hilight Mapping", 
//	"ƒJƒXƒ^ƒ€ƒfƒtƒ…[ƒY", 			//"Custom Diffuse", 
	"ƒm[ƒ}ƒ‹ƒ}ƒbƒv", 				//"Normal Mapping", 
	"ƒIƒNƒ‹[ƒWƒ‡ƒ"ƒ}ƒbƒv",			//"Occulusion Mapping", 
	"ŽË‰eƒ}ƒbƒv(‰_'Ì‰e)",			//"Projection Mapping",
	"Ž©ŒÈ"­Œõ"xƒ}ƒbƒv", 			//"Emission Mapping", 

	"ƒXƒyƒLƒ…ƒ‰", 					//"Specular", 
//	"ƒsƒNƒZƒ‹¸"xƒXƒyƒLƒ…ƒ‰",		//"Per Pixel Specular"
	"ƒXƒyƒLƒ…ƒ‰ƒ}ƒbƒv", 			//"Specular Mapping", 
	"ƒtƒFƒCƒNíÝƒXƒyƒLƒ…ƒ‰",		//"Fake Everexisting Specular",
	"ƒ}ƒeƒŠƒAƒ‹'PˆÊƒ‰ƒCƒgãŒÀ",		//"Per Material Main Light Clamp".

	"ƒŠƒ€ƒ‰ƒCƒg", 					//"Rim Lightng", 
	"ƒŠƒ€"§–¾"x", 					//"Rim Transparency", 

	"ƒXƒtƒBƒAƒ}ƒbƒv", 				//"Sphere Mapping", 
	"ƒLƒ…[ƒuƒ}ƒbƒv", 				//"Cube Mapping", 
	"ŠÂ‹«ƒ}ƒbƒv'ðIBL'Æ'µ'ÄŽg—p",	//"EnvMap as IBL",

	"DUDVƒ}ƒbƒv(‹üÜ)",				//"DUDV Mapping(Refrection)",
	"…–Ê",							//"Water Surface",

	"ƒm[ƒ}ƒ‹ƒ}ƒbƒvDXT5_NM", 		//"Normal Mapping DXT5_NM", 
	"ƒm[ƒ}ƒ‹ƒ}ƒbƒvDXT5_LP",		//"Normal Mapping DXT5_LP", 

	"•—'É'È'Ñ'­'", 				//"Windy Grass", 
	"•—'É'È'Ñ'­' - TexVd'Ý•t'¯",	//"Windy Grass - TexV Weight", 
//	"ƒrƒ‹ƒ{[ƒh", 					//"Billboard", 
//	""§Ž‹}–@ƒrƒ‹ƒ{[ƒh",			//"Perspective Billboard", 
//	"‰~'Œƒrƒ‹ƒ{[ƒh(YŽ²)",			//"Cylindrical Billboard(Y-Axis)", 
//	"‹…–Êƒrƒ‹ƒ{[ƒh", 				//"Spherical Billboard", 

	"ƒOƒ[(ƒnƒCƒpƒX)",				//"Glow(High-Pass)", 
	"ƒOƒ[(ƒAƒ‹ƒtƒ@"­Œõ)",			//"Glow(Alpha Emission)", 
	"ƒOƒ[ƒ}ƒbƒv",					//"Glow Map", 
//	"ƒOƒ[(ƒI[ƒo[ƒtƒ[)",		//"Glow(Overflow)", 

	"ƒ}ƒ‹ƒ`UV",							//"Multi UV",
	"‰ÁŽZƒuƒŒƒ"ƒh]ƒ}ƒ‹ƒ`UV",			//"Multi UV Additive Blending",
	"æŽZƒuƒŒƒ"ƒh]ƒ}ƒ‹ƒ`UV",			//"Multi UV Multiplicative Blending",
	"‰e]ƒ}ƒ‹ƒ`UV",						//"Multi UV Shadow",
	"ƒtƒFƒCƒX]ƒ}ƒ‹ƒ`UV",				//"Multi UV Face",
	"ƒXƒNƒ[ƒ‹]ƒ}ƒ‹ƒ`UV", 			//"Multi UV TexCoord Offset",
	"ƒm[ƒ}ƒ‹ƒ}ƒbƒv]ƒ}ƒ‹ƒ`UV", 		//"Multi UV Normal Mapping", 
	"ƒIƒNƒ‹[ƒWƒ‡ƒ"ƒ}ƒbƒv]ƒ}ƒ‹ƒ`UV",	//"Multi UV Occulusion Mapping", 
	"ƒXƒyƒLƒ…ƒ‰ƒ}ƒbƒv-ƒ}ƒ‹ƒ`UV", 		//"Multi UV Specular Mapping", 
	"ƒfƒtƒ…[ƒY•s—v-ƒ}ƒ‹ƒ`UV", 			//"Multi UV No Diffuse Mapping", 

	"ƒ}ƒ‹ƒ`UV2",						//"Multi UV2",
	"‰ÁŽZƒuƒŒƒ"ƒh]ƒ}ƒ‹ƒ`UV2",			//"Multi UV2 Additive Blending",
	"æŽZƒuƒŒƒ"ƒh]ƒ}ƒ‹ƒ`UV2",			//"Multi UV2 Multiplicative Blending",
	"‰e]ƒ}ƒ‹ƒ`UV2",					//"Multi UV2 Shadow",
	"ƒtƒFƒCƒX]ƒ}ƒ‹ƒ`UV2",				//"Multi UV2 Face",
	"ƒXƒNƒ[ƒ‹]ƒ}ƒ‹ƒ`UV2", 			//"Multi UV2 TexCoord Offset",
	"ƒIƒNƒ‹[ƒWƒ‡ƒ"ƒ}ƒbƒv]ƒ}ƒ‹ƒ`UV2",	//"Multi UV2 Occulusion Mapping", 
	"ƒXƒyƒLƒ…ƒ‰ƒ}ƒbƒv-ƒ}ƒ‹ƒ`UV2", 		//"Multi UV2 Specular Mapping", 
	"ƒfƒtƒ…[ƒY•s—v-ƒ}ƒ‹ƒ`UV2", 		//"Multi UV2 No Diffuse Mapping", 

	"ƒfƒBƒtƒ…[ƒYƒ}ƒbƒv'JˆÚ",	 		//"DiffuseMapChanging", 
	"ƒGƒtƒFƒNƒg—p",						//"No DepthMask for effect"
	"UVaƒXƒNƒŠƒvƒg",					// UVA Script"
//	"ƒVƒƒƒCƒjƒ"ƒO",						// Shining Mode"

#line 482 "Z:/data/shaders/ed8.fx"

#endif // !defined(DCC_TOOL) || !defined(LANGUAGE_MATERIAL_SWITCHES_JP)

};

#ifdef DCC_TOOL
string MaterialSwitchDefaultValues[] =
{
	"",		// NOTHING_ENABLED
	"",		// CASTS_SHADOWS_ONLY
//	"",		// USAGE_CHARACTER_ENABLED
//	"",		// USAGE_TERRAIN_ENABLED

	"1",	// CASTS_SHADOWS
	"1",	// RECEIVE_SHADOWS
	"",		// GENERATE_RELFECTION_ENABLED
	"",		// UNDER_WATER_ENABLED
//	"",		// EDGE_ENABLED

	"",		// ALPHA_TESTING_ENABLED
	"",		// ALPHA_BLENDING_ENABLED
	"",		// ADDITIVE_BLENDING_ENABLED
	"",		// SUBTRACT_BLENDING_ENABLED
	"",		// MULTIPLICATIVE_BLENDING_ENABLED
	"",		// TWOPASS_ALPHA_BLENDING_ENABLED

	"",		// DOUBLE_SIDED
	"",		// SHDOW_DOUBLE_SIDED
	"",		// FOG_ENABLED
	"",		// FOG_RATIO_ENABLED
	"",		// VERTEX_COLOR_ENABLED
	"",		// TEXCOORD_OFFSET_ENABLED
//
	"",		// FORCE_CHAR_LIGHT_DIRECTION_ENABLED
//	"",		// LIGHTING_ENABLED

	"",		// HEMISPHERE_AMBIENT_ENABLED
	"",		// MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	"",		// SHADOW_COLOR_SHIFT_ENABLED

	"",		// NO_ALL_LIGHTING_ENABLED
	"",		// NO_MAIN_LIGHT_SHADING_ENABLED
	"",		// HALF_LAMBERT_LIGHTING_ENABLED
	"",		// CARTOON_SHADING_ENABLED
	"",		// CARTOON_HILIGHT_ENABLED
//	"",		// CUSTOM_DIFFUSE_ENABLED 
	"",		// NORMAL_MAPPING_ENABLED
	"",		// OCCULUSION_MAPPING_ENABLED
	"",		// PROJECTION_MAP_ENABLED
	"",		// EMISSION_MAPPING_ENABLED

	"",		// SPECULAR_ENABLED
//	"",		// PER_PIXEL_SPECULAR_ENABLED
	"",		// SPECULAR_MAPPING_ENABLED
	"",		// FAKE_CONSTANT_SPECULAR_ENABLED
	"",		// PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED

	"",		// RIM_LIGHTING_ENABLED
	"",		// RIM_TRANSPARENCY_ENABLED

	"",		// SPHERE_MAPPING_ENABLED
	"",		// CUBE_MAPPING_ENABLED
	"",		// EMVMAP_AS_IBL_ENABLED

	"",		// DUDV_MAPPING_ENABLED
	"",		// WATER_SURFACE_ENABLED

	"",		// NORMAL_MAPPING_DXT5_NM_ENABLED
	"",		// NORMAL_MAPPING_DXT5_LOSPLA_ENABLED

	"",		// WINDY_GRASS_ENABLED
	"",		// WINDY_GRASS_TEXV_WEIGHT_ENABLED
//	"",		// BILLBOARD_ENABLED
//	"",		// PERSPECTIVE_BILLBOARD_ENABLED
//	"",		// CYLINDRICAL_BILLBOARD_ENABLED
//	"",		// SPHERICAL_BILLBOARD_ENABLED

	"",		// GLARE_HIGHTPASS_ENABLED
	"",		// GLARE_EMISSION_ENABLED
	"",		// GLARE_MAP_ENABLED
//	"",		// GLARE_OVERFLOW_ENABLED

	"",		// MULTI_UV_ENANLED
	"",		// MULTI_UV_ADDITIVE_BLENDING_ENANLED
	"",		// MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED
	"",		// MULTI_UV_SHADOW_ENANLED
	"",		// MULTI_UV_FACE_ENANLED
	"",		// MULTI_UV_TEXCOORD_OFFSET_ENANLED
	"",		// MULTI_UV_NORMAL_MAPPING_ENABLED
	"",		// MULTI_UV_OCCULUSION_MAPPING_ENABLED
	"",		// MULTI_UV_SPECULAR_MAPPING_ENABLED
	"",		// MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED

	"",		// MULTI_UV2_ENANLED
	"",		// MULTI_UV2_ADDITIVE_BLENDING_ENANLED
	"",		// MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
	"",		// MULTI_UV2_SHADOW_ENANLED
	"",		// MULTI_UV2_FACE_ENANLED
	"",		// MULTI_UV2_TEXCOORD_OFFSET_ENANLED
	"",		// MULTI_UV2_OCCULUSION_MAPPING_ENABLED
	"",		// MULTI_UV2_SPECULAR_MAPPING_ENABLED
	"",		// MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED

	"",		// DIFFUSEMAP_CHANGING_ENABLED
	"",		// FOR_EFFECT
	"",		// UVA_SCRIPT_ENABLED
//	"",		// SHINING_MODE_ENABLED
};
#endif // DCC_TOOL

>;

#ifndef NOTHING_ENABLED
	#ifndef LIGHTING_ENABLED
		#define LIGHTING_ENABLED
	#endif
#else
	#undef LIGHTING_ENABLED
#endif

#ifdef CASTS_SHADOWS_ONLY
	#ifndef CASTS_SHADOWS
		#define CASTS_SHADOWS
	#endif
#endif

//#define CUSTOM_DIFFUSE_SUPPORT
#ifndef CUSTOM_DIFFUSE_SUPPORT
	#undef CUSTOM_DIFFUSE_ENABLED 
#endif // CUSTOM_DIFFUSE_SUPPORT

#if !defined(CARTOON_HILIGHT_ENABLED)
	#ifndef UVA_SCRIPT_ENABLED
//		#define UVA_SCRIPT_ENABLED
	#endif
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// context switch 

#ifdef SHADER_LOD_LEVEL

	#if SHADER_LOD_LEVEL > 0
		#ifdef NORMAL_MAPPING_ENABLED
			#undef NORMAL_MAPPING_ENABLED
		#endif // NORMAL_MAPPING_ENABLED
	#endif

#endif // SHADER_LOD_LEVEL

#ifdef NUM_LIGHTS
	#if NUM_LIGHTS > MAX_NUM_LIGHTS
		#error Maximum number of supported lights exceeded.
	#endif // NUM_LIGHTS > MAX_NUM_LIGHTS
#endif // NUM_LIGHTS

#ifdef NUM_LIGHTS
	#if !defined(NO_ALL_LIGHTING_ENABLED) && defined(LIGHTING_ENABLED) && (NUM_LIGHTS > 0)
		#define USE_LIGHTING
	#endif
#endif // NUM_LIGHTS


// ビルボード廃止
#undef BILLBOARD_ENABLED
#undef PERSPECTIVE_BILLBOARD_ENABLED
#undef CYLINDRICAL_BILLBOARD_ENABLED
#undef SPHERICAL_BILLBOARD_ENABLED

#ifdef DCC_TOOL
	#undef UVA_SCRIPT_ENABLED
#endif

#if defined(__psp2__) && defined(WATER_SURFACE_ENABLED) && defined(PROJECTION_MAP_ENABLED)
	#undef RECEIVE_SHADOWS
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 採用設定
//#define USE_POSITION_HALF					// ワールド空間頂点位置
//#define USE_TEXCOORD_SCROLLABLE_HALF		// スクロールする可能性のあるテクスチャ座標。halfでは精度が足りない。
#define TOON_FIRST_LIGHT_ONLY_ENABLED		// トゥーンフィルタを掛けるのは最初のライトのみ
//#define USE_FORCE_VERTEX_RIM_LIGHTING		// リムライトを強制的に頂点単位で計算
//#define FORCE_PER_VERTEX_ENVIRON_MAP		// キューブマップ・スフィアマップ・トゥーンハイライトは法線マップがあろうとも頂点単位に求める。[Vita向け]

#define VERTEX_COLOR_AS_AMBIENT_OCCULUSION	// 頂点カラーの役割。(onのときは環境光遮蔽としてライティングの最後にかける。offのときはアンビエント+メインライトの直後)

#define GAME_MATERIAL_ENABLED

#define USE_EDGE_ADDUNSAT

//#undef CARTOON_HILIGHT_ENABLED

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
#if !defined(__psp2__)
	#if (defined(SPECULAR_ENABLED) && !defined(FAKE_CONSTANT_SPECULAR_ENABLED)) || defined(RIM_LIGHTING_ENABLED)
		#undef USE_PER_VERTEX_LIGHTING
	#endif //
#endif // !defined(__psp2__)
// リム透明度がある場合はvitaでもピクセル単位
#if defined(RIM_LIGHTING_ENABLED) && defined(RIM_TRANSPARENCY_ENABLED) 
	#undef USE_PER_VERTEX_LIGHTING
#endif

// トゥーン
#if defined(CARTOON_SHADING_ENABLED)
	#undef WINDY_GRASS_ENABLED
	#undef USE_PER_VERTEX_LIGHTING
	#define CARTOON_AVOID_SELFSHADOW_OFFSET
	#ifdef CASTS_SHADOWS
		#ifndef RECEIVE_SHADOWS
			#define RECEIVE_SHADOWS
		#endif
	#endif
//	#ifndef RIM_LIGHTING_ENABLED
//		#define RIM_LIGHTING_ENABLED
//	#endif
#endif // defined(CARTOON_SHADING_ENABLED)

// 地形
#if defined(LIGHTING_ENABLED)
	#ifndef GLARE_OVERFLOW_ENABLED
//		#define GLARE_OVERFLOW_ENABLED
	#endif
#endif // defined(CARTOON_SHADING_ENABLED)

/*
// 派生ビルボード
#ifdef CYLINDRICAL_BILLBOARD_ENABLED
	#undef PERSPECTIVE_BILLBOARD_ENABLED
#endif // CYLINDRICAL_BILLBOARD_ENABLED
#ifdef SPHERICAL_BILLBOARD_ENABLED
	#undef CYLINDRICAL_BILLBOARD_ENABLED
#endif // SPHERICAL_BILLBOARD_ENABLED
*/


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

// 水面
	#if defined(WATER_SURFACE_ENABLED)
		#if !defined(DCC_TOOL)
			#undef ALPHA_BLENDING_ENABLED
		#else
			#ifndef ALPHA_BLENDING_ENABLED
				#define ALPHA_BLENDING_ENABLED
			#endif
		#endif
		#undef ADDITIVE_BLENDING_ENABLED
		#undef SUBTRACT_BLENDING_ENABLED
		#undef MULTIPLICATIVE_BLENDING_ENABLED
		#undef USE_EXTRA_BLENDING
	#endif // defined(WATER_SURFACE_ENABLED)

	#if defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED)
		#define USE_SCREEN_UV
	#endif // defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED)

#endif // MULTI_UV2_ENANLED

// Vita用の高速化措置
#if defined(__psp2__)
	#if defined(RECEIVE_SHADOWS)
		#if !defined(DUDV_MAPPING_ENABLED)
			#if NUM_LIGHTS > 0
				#ifdef SHADOWTYPE_0
					#if MAX_SPLIT_CASCADED_SHADOWMAP == 1
						#define PRECALC_SHADOWMAP_POSITION		// シャドウマップ座標の計算をVP側で行う
					#endif
				#endif
			#endif
		#endif
	#endif
#endif // defined(__psp2__)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// スイッチのプリプロセス

// キューブマップ・スフィアマップ・グラディエントマップは排他
#ifdef CUBE_MAPPING_ENABLED
	#undef SPHERE_MAPPING_ENABLED
#endif // CUBE_MAPPING_ENABLED

// DuDvはマルチテクスチャ無効
#ifdef DUDV_MAPPING_ENABLED
	#undef MULTI_UV_ENANLED
	#undef MULTI_UV2_ENANLED
#endif // DUDV_MAPPING_ENABLED


#define MAINLIGHT_CLAMP_FACTOR_ENABLED		// Global or Materalライトクランプ

#ifndef DCC_TOOL
	#if defined(CARTOON_SHADING_ENABLED) || defined(FORCE_CHAR_LIGHT_DIRECTION_ENABLED) || defined(CHAR_EQUIP_ENABLED)
		#define LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
		#define SHINING_MODE_ENABLED
	#endif
#endif // DCC_TOOL

///////////////////////////////////////////////////////////////////////////////
// グローバルシェーダパラメータ

#define GlowThreshold	1.0

float4x4 World					: World;
#ifdef CASTS_SHADOWS
float4x4 WorldViewProjection	: WorldViewProjection;
#endif // CASTS_SHADOWS

#ifdef SKINNING_ENABLED
	#define MATERIAL_SKINNING_MAX_GPU_BONE_COUNT 60 
float4x4 BoneTransforms[MATERIAL_SKINNING_MAX_GPU_BONE_COUNT] : BONETRANSFORMS;
#endif // SKINNING_ENABLED

#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
float3 LightDirForChar			: LightDirForChar;
#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED

// マテリアル別ライト上限 - マテリアル毎Uniform - ifdefで囲まないこと。
float PerMaterialMainLightClampFactor
<
    string UIName = UINAME_PerMaterialMainLightClampFactor;
    string UIWidget = "Slider";
    float UIMin = 00;
    float UIMax = 2.0;
    float UIStep = 0.1;
> = 1.50;

#ifdef MAINLIGHT_CLAMP_FACTOR_ENABLED
	#ifdef PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED

		#define MainLightClampFactor		PerMaterialMainLightClampFactor

	#else // PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED

		#ifdef DCC_TOOL
float GlobalMainLightClampFactor
<
    string UIName = UINAME_GlobalMainLightClampFactor;
    string UIWidget = "Slider";
    float UIMin = 00;
    float UIMax = 2.0;
    float UIStep = 0.1;
> = 1.50;
		#else // DCC_TOOL
float GlobalMainLightClampFactor	: GlobalMainLightClampFactor = 1.5f;
		#endif // DCC_TOOL

		#define MainLightClampFactor		GlobalMainLightClampFactor

	#endif // PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED
#endif // MAINLIGHT_CLAMP_FACTOR_ENABLED


#ifdef DCC_TOOL
float4x4 ViewIXf				: ViewInverse;
#endif // DCC_TOOL

#if defined(USE_SCREEN_UV)
	#ifdef DCC_TOOL
		#define ScreenWidth		(1280.0)
		#define ScreenHeight	(720.0)
	#else

		#define ScreenWidth		scene_viewportSizeParameters.x
		#define ScreenHeight	scene_viewportSizeParameters.y

	#endif
#endif // defined(USE_SCREEN_UV)

#if defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)
	#ifdef DCC_TOOL
float4 UserClipPlane
<
    string UIName = UINAME_UserClipPlane;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = {0.0, 1.0, 0.0, 0.0 };
	#else // DCC_TOOL
float4 UserClipPlane			: UserClipPlane = {0.0, 1.0, 0.0, 0.0 };	// xyzw (nx,ny,nz,height)
	#endif // DCC_TOOL
#endif // defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)

// 反射強さ - マテリアル毎Uniform - ifdefで囲まないこと。
float ReflectionIntensity
<
    string UIName = UINAME_ReflectionIntensity;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = 0.75;

//-----------------------------------------------------------------------------
#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#define PortraitLightColor		float3(0.55f,0.55f,0.55f)
#define PortraitAmbientColor	float3(0.55f,0.55f,0.55f)

/*
float3 PortraitLightColor //: PortraitLightColor
<
    string UIName = UINAME_PortraitLightColor;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = {0.55, 0.55, 0.55 };

float3 PortraitAmbientColor //: PortraitAmbientColor
<
    string UIName = UINAME_PortraitAmbientColor;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = {0.55, 0.55, 0.55 };
*/
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#if defined(SHINING_MODE_ENABLED)
float3 ShiningLightColor
<
    string UIName = "[x]ShiningLightColor";
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 10.0;
    float UIStep = 0.001;
> = { 0.345*3.5, 0.875*3.5, 1.0*3.5 };
#endif // defined(SHINING_MODE_ENABLED)

//-----------------------------------------------------------------------------
// カスタムディフューズ
#ifdef CUSTOM_DIFFUSE_SUPPORT

//	#ifdef DCC_TOOL
float3 CustomDiffuse_Hilight
<
    string UIName = UINAME_CustomDiffuse_Hilight;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = {1.0, 1.0, 1.0 };

float3 CustomDiffuse_Base
<
    string UIName = UINAME_CustomDiffuse_Base;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = {0.80, 0.80, 0.80 };

float3 CustomDiffuse_Middle
<
    string UIName = UINAME_CustomDiffuse_Middle;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = {0.60, 0.60, 0.60 };

float3 CustomDiffuse_Shadow
<
    string UIName = UINAME_CustomDiffuse_Shadow;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = {0.40, 0.40, 0.40 };
/*
	#else // DCC_TOOL
float4 CustomDiffuse_Hilight : NodeCustomDiffuse0;
float4 CustomDiffuse_Base    : NodeCustomDiffuse1;
float4 CustomDiffuse_Middle  : NodeCustomDiffuse2;
float4 CustomDiffuse_Shadow  : NodeCustomDiffuse3;
	#endif // DCC_TOOL
	*/
#endif // CUSTOM_DIFFUSE_SUPPORT

//-----------------------------------------------------------------------------
// ライティング
// Light0はディレクショナルライト固定

struct LightValue
{
	float3 direction;
	float attenuation;
};

#if defined(USE_LIGHTING) || defined(RECEIVE_SHADOWS)

	#if NUM_LIGHTS > 0
LIGHTTYPE_0 Light0 : LIGHT0;
		#ifndef SHADOWTYPE_0
			#define LightShadow0 1.0
			#define LightShadowMap0 1.0f
		#else // SHADOWTYPE_0
SHADOWTYPE_0 LightShadow0 : LIGHTSHADOW0;
Texture2D <float> LightShadowMap0 : LIGHTSHADOWMAP0;
		#endif // SHADOWTYPE_0
	#endif
#endif // USE_LIGHTING || RECEIVE_SHADOWS

#if defined(USE_LIGHTING)
	#if NUM_LIGHTS > 1
LIGHTTYPE_1 Light1 : LIGHT1;
		#ifndef SHADOWTYPE_1
			#define LightShadow1 1.0
			#define LightShadowMap1 1.0f
		#else // SHADOWTYPE_1
SHADOWTYPE_1 LightShadow1 : LIGHTSHADOW1;
Texture2D <float> LightShadowMap1 : LIGHTSHADOWMAP1;
		#endif // SHADOWTYPE_1
	#endif
	#if NUM_LIGHTS > 2
LIGHTTYPE_2 Light2 : LIGHT2;
		#ifndef SHADOWTYPE_2
			#define LightShadow2 1.0
			#define LightShadowMap2 1.0f
		#else // SHADOWTYPE_2
SHADOWTYPE_2 LightShadow2 : LIGHTSHADOW2;
Texture2D <float> LightShadowMap2 : LIGHTSHADOWMAP2;
		#endif // SHADOWTYPE_2
	#endif
	#if NUM_LIGHTS > 3
LIGHTTYPE_3 Light3 : LIGHT3;
		#ifndef SHADOWTYPE_3
			#define LightShadow3 1.0
			#define LightShadowMap3 1.0f
		#else // SHADOWTYPE_3
SHADOWTYPE_3 LightShadow3 : LIGHTSHADOW3;
Texture2D <float> LightShadowMap3 : LIGHTSHADOWMAP3;
		#endif // SHADOWTYPE_3
	#endif

#endif // defined(USE_LIGHTING)

//-----------------------------------------------------------------------------
// ゲームマテリアル関連 - マテリアル毎Uniform - ifdefで囲まないこと。
float GameMaterialID
<
	string UIName = UINAME_GameMaterialID;
	string UIWidget = "None";
    float UIMin = 0.0;
    float UIMax = 100.0;
    float UIStep = 1.0;
> = 0;

	#if defined(GAME_MATERIAL_ENABLED)
float4 GameMaterialDiffuse : NodeMaterialDiffuse
<
    string UIName = UINAME_GameMaterialDiffuse;
	string UIWidget = "Color";
> = {1.0, 1.0, 1.0, 1.0};

float3 GameMaterialEmission : NodeMaterialEmission
<
    string UIName = UINAME_GameMaterialEmission;
	string UIWidget = "Color";
> = {0.0, 0.0, 0.0};

float4 GameMaterialTexcoord //: NodeMaterialTexcoord
<
    string UIName = UINAME_GameMaterialTexcoord;
	string UIWidget = "Color";
> = {0.0, 0.0, 1.0, 1.0};

		#ifdef UVA_SCRIPT_ENABLED

float4 UVaMUvColor
<
    string UIName = UINAME_UVaMUvColor;
	string UIWidget = "Color";
> = {1.0, 1.0, 1.0, 1.0};

float4 UVaProjTexcoord //: UVaProjTexcoord
<
//	string UIName = UINAME_UVaProjTexcoord;
	string UIWidget = "Color";
> = {0.0, 0.0, 1.0, 1.0};

float4 UVaMUvTexcoord //: UVaMUvTexcoord
<
//	string UIName = UINAME_UVaMUvTexcoord;
	string UIWidget = "Color";
> = {0.0, 0.0, 1.0, 1.0};

float4 UVaMUv2Texcoord //: UVaMUv2Texcoord
<
//	string UIName = UINAME_UVaMUv2Texcoord;
	string UIWidget = "Color";
> = {0.0, 0.0, 1.0, 1.0};

float4 UVaDuDvTexcoord //: UVaDuDvTexcoord
<
//	string UIName = UINAME_UVaDuDvTexcoord;
	string UIWidget = "Color";
> = {0.0, 0.0, 1.0, 1.0};
		#endif // UVA_SCRIPT_ENABLED

	#endif // GAME_MATERIAL_ENABLED

//-----------------------------------------------------------------------------
#ifndef DCC_TOOL
float GlobalTexcoordFactor : GlobalTexcoordFactor;
float AlphaTestDirection : AlphaTestDirection;
#else // DCC_TOOL
#endif // DCC_TOOL

//-----------------------------------------------------------------------------
// アルファ閾値 - マテリアル毎Uniform - ifdefで囲まないこと。
float AlphaThreshold : ALPHATHRESHOLD
<
    string UIName = UINAME_AlphaThreshold;
    string UIWidget = "Slider";
    float UIMin = 0.004;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = 0.500;

//-----------------------------------------------------------------------------
// フォグ関連
//
#if defined(FOG_ENABLED)

	#ifdef DCC_TOOL
float3 FogColor : FOGCOLOR
<
    string UIName = UINAME_FogColor;
	string UIWidget = "Color";
> = { 0.5,0.5,0.5 };

// FogRangeParameters : x = Near, y = Far //, z = 1 / (Far - Near)
float2 FogRangeParameters : FogRangeParameters
<
    string UIName = UINAME_FogRangeParameters;
	string UIWidget = "float2";
> = {10.0, 500.0 };
	#endif // DCC_TOOL
#endif // FOG_ENABLED

// フォグ適用率 - マテリアル毎Uniform - ifdefで囲まないこと。
float FogRatio
<
    string UIName = UINAME_FogRatio;
    string UIWidget = "Slider";
    float UIMin = 0.0;
    float UIMax = 1.0;
    float UIStep = 0.1;
> = 0.5;

//-----------------------------------------------------------------------------
// 環境光関連

// 影カラーシフト - マテリアル毎Uniform - ifdefで囲まないこと。
float3 ShadowColorShift
<
    string UIName = UINAME_ShadowColorShift;
	string UIWidget = "Color";
> = {0.10, 0.02, 0.02};

#ifdef HEMISPHERE_AMBIENT_ENABLED
float3 HemiSphereAmbientSkyColor
<
    string UIName = UINAME_HemiSphereAmbientSkyColor;
	string UIWidget = "Color";
> = {0.667, 0.667, 0.667};

float3 HemiSphereAmbientGndColor
<
    string UIName = UINAME_HemiSphereAmbientGndColor;
	string UIWidget = "Color";
> = {0.333, 0.333, 0.333};

float3 HemiSphereAmbientAxis : HemiSphereAxis
<
	string UIName = UINAME_HemiSphereAmbientAxis;
	string UIWidget = "Color";
> = { 0, 1, 0 };

#endif // HEMISPHERE_AMBIENT_ENABLED

//-----------------------------------------------------------------------------
// スペキュラ関連 - マテリアル毎Uniform - ifdefで囲まないこと。

// スペキュラ偏心
float Shininess
<
    string UIName = UINAME_Shininess;
    string UIWidget = "Slider";
	float UIMin = 0.0;
	float UIMax = 10.0;
> = 0.50;

// スペキュラ強さ
float SpecularPower
<
    string UIName = UINAME_SpecularPower;
    string UIWidget = "Slider";
	float UIMin = 0.001;
	float UIMax = 100.0;
> = 50.0;

//-----------------------------------------------------------------------------
// リムライト関連 - マテリアル毎Uniform - ifdefで囲まないこと。
float3 RimLitColor
<
    string UIName = UINAME_RimLightColor;
	string UIWidget = "Color";
> = {1.0, 1.0, 1.0};

float RimLitIntensity
<
    string UIName = UINAME_RimLightIntensity;
	string UIWidget = "Slider";
	float UIMin = 0.001;
	float UIMax = 10;
> = 4.0;

float RimLitPower
<
    string UIName = UINAME_RimLightPower;
    string UIWidget = "Slider";
	float UIMin = 0.001;
	float UIMax = 20;
> = 2.0;

//-----------------------------------------------------------------------------
float2 TexCoordOffset
<
    string UIName = UINAME_TexCoordOffset;
	string UIWidget = "float2";
> = {0.0, 0.0};

float2 TexCoordOffset2
<
    string UIName = UINAME_TexCoordOffset2;
	string UIWidget = "float2";
> = {0.0, 0.0};

float2 TexCoordOffset3
<
    string UIName = UINAME_TexCoordOffset3;
	string UIWidget = "float2";
> = {0.0, 0.0};

//-----------------------------------------------------------------------------
// テクスチャ関連

// ディフューズテクスチャ 
#if defined(DCC_TOOL) || !defined(NOTHING_ENABLED)
Texture2D<float4> DiffuseMapSampler
<
	string UIName = UINAME_DiffuseMapSampler;
>;
#endif // defined(DCC_TOOL) || !defined(NOTHING_ENABLED)

#if defined(NORMAL_MAPPING_ENABLED)
// ノーマルマップ・スペキュラマップ・アンビエントオクルージョンマップ
Texture2D<float4> NormalMapSampler
<
	string UIName = UINAME_NormalMapSampler;
>;
#endif // NORMAL_MAPPING_ENABLED

#if defined(SPECULAR_MAPPING_ENABLED)
Texture2D<float4> SpecularMapSampler
<
	string UIName = UINAME_SpecularMapSampler;
>;
#endif // SPECULAR_MAPPING_ENABLED

#if defined(OCCULUSION_MAPPING_ENABLED)
Texture2D<float4> OcculusionMapSampler
<
	string UIName = UINAME_OcculusionMapSampler;
>;
#endif // OCCULUSION_MAPPING_ENABLED

#if defined(EMISSION_MAPPING_ENABLED)
Texture2D<float4> EmissionMapSampler
<
string UIName = UINAME_EmissionMapSampler;
>;
#endif // EMISSION_MAPPING_ENABLED

#ifdef DIFFUSEMAP_CHANGING_ENABLED
Texture2D<float4> DiffuseMapTrans1Sampler
<
	string UIName = UINAME_DiffuseMapTrans1Sampler;
>;
Texture2D<float4> DiffuseMapTrans2Sampler
<
	string UIName = UINAME_DiffuseMapTrans2Sampler;
>;
	#ifdef DCC_TOOL
// スペキュラ強さ
float DiffuseMapTransRatio
<
    string UIName = UINAME_DiffuseMapTransRatio;
    string UIWidget = "Slider";
	float UIMin = 0.0;
	float UIMax = 3.0;
> = 0.0;
	#endif // DCC_TOOL

#endif // DIFFUSEMAP_CHANGING_ENABLED

//-----------------------------------------------------------------------------
// マルチUV テクスチャ関連
#ifdef MULTI_UV_ENANLED

	#if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
Texture2D<float4> DiffuseMap2Sampler
<
	string UIName = UINAME_DiffuseMap2Sampler;
>;
	#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	// スペキュラマップ・アンビエントオクルージョンマップ
	#if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
Texture2D<float4> SpecularMap2Sampler
<
	string UIName = UINAME_SpecularMap2Sampler;
>;
	#endif // MULTI_UV_SPECULAR_MAPPING_ENABLED

	#if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
Texture2D<float4> OcculusionMap2Sampler
<
	string UIName = UINAME_OcculusionMap2Sampler;
>;
	#endif // MULTI_UV_OCCULUSION_MAPPING_ENABLED

	#if defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
Texture2D<float4> NormalMap2Sampler
<
	string UIName = UINAME_NormalMap2Sampler;
>;
	#endif // MULTI_UV_NORMAL_MAPPING_ENABLED

#endif // MULTI_UV_ENANLED

//-----------------------------------------------------------------------------
// マルチUV テクスチャ関連
#ifdef MULTI_UV2_ENANLED 

	#if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
Texture2D<float4> DiffuseMap3Sampler
<
	string UIName = UINAME_DiffuseMap3Sampler;
>;
	#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)

	// スペキュラマップ・アンビエントオクルージョンマップ
	#if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
Texture2D<float4> SpecularMap3Sampler
<
	string UIName = UINAME_SpecularMap3Sampler;
>;
	#endif // MULTI_UV2_SPECULAR_MAPPING_ENABLED

	#if defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
Texture2D<float4> OcculusionMap3Sampler
<
	string UIName = UINAME_OcculusionMap3Sampler;
>;
	#endif // MULTI_UV2_OCCULUSION_MAPPING_ENABLED

#endif // MULTI_UV2_ENANLED

//-----------------------------------------------------------------------------
// トゥーンシェーディング用テクスチャ関連
#if defined(CARTOON_SHADING_ENABLED)

Texture2D<float4> CartoonMapSampler
<
	string UIName = UINAME_CartoonMapSampler;
>;

	#if defined(CARTOON_HILIGHT_ENABLED)

Texture2D<float4> HighlightMapSampler
<
	string UIName = UINAME_HighlightMapSampler;
>;
	#endif // CARTOON_HILIGHT_ENABLED

float3 HighlightColor
<
    string UIName = UINAME_HighlightColor;
	string UIWidget = "Color";
> = {1.0, 1.0, 1.0};

float HighlightIntensity
<
    string UIName = UINAME_HighlightIntensity;
	string UIWidget = "Slider";
	float UIMin = 0.001;
	float UIMax = 10;
> = 2.0;

float ShadowReceiveOffset
<
    string UIName = UINAME_ShadowReceiveOffset;
	string UIWidget = "Slider";
	float UIMin = 0.00;
	float UIMax = 10;
> = 0.75;

#endif // CARTOON_SHADING_ENABLED

//-----------------------------------------------------------------------------
// スフィアマップ関連
#if defined(SPHERE_MAPPING_ENABLED)
Texture2D<float4> SphereMapSampler
<
	string UIName = UINAME_SphereMapSampler	;
>;
#endif // SPHERE_MAPPING_ENABLED

// スフィアマップ強さ - マテリアル毎Uniform - ifdefで囲まないこと。
float SphereMapIntensity
<
    string UIName = UINAME_SphereMapIntensity;
    string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 10;
> = 1.0;


//-----------------------------------------------------------------------------
// キューブマップ関連
#if defined(CUBE_MAPPING_ENABLED)
TextureCube<float4> CubeMapSampler
<
	string UIName = UINAME_CubeMapSampler;
>;
#endif // CUBE_MAPPING_ENABLED

// キューブマップフレネル項 - マテリアル毎Uniform - ifdefで囲まないこと。
float CubeFresnelPower
<
    string UIName = UINAME_CubeMapFresnelPower;
    string UIWidget = "Slider";
	float UIMin = 0;
	float UIMax = 1;
> = 0.0;

#ifndef CARTOON_SHADING_ENABLED
//-----------------------------------------------------------------------------
// 射影マップ関連

	#ifdef PROJECTION_MAP_ENABLED

Texture2D<float4> ProjectionMapSampler
<
	string UIName = UINAME_ProjectionMapSampler;
>;
	#endif // PROJECTION_MAP_ENABLED

// 射影マップ関連 - マテリアル毎Uniform - ifdefで囲まないこと。
float2 ProjectionScale
<
    string UIName = UINAME_ProjectionScale;
	string UIWidget = "float2";
	float UIMin = 0;
	float UIMax = 1000;
> = {1.0, 1.0};

float2 ProjectionScroll
<
    string UIName = UINAME_ProjectionScroll;
	string UIWidget = "float2";
> = {0.00, 0.00};

//-----------------------------------------------------------------------------
// DU/DVマップ関連
	#ifdef DUDV_MAPPING_ENABLED

Texture2D<float4> DuDvMapSampler
<
	string UIName = UINAME_DuDvMapSampler;
>;
	#endif // DUDV_MAPPING_ENABLED

	#define DUDVMAP_SIZE	(256.0)
// サイズ固定し他の関連する変数ScreenWidth,ScreenHeightと合わせて事前に計算しておくのが望ましい
// DuDvScaleもゲーム全体で固定値にしてしまいたい。
//

// DU/DVマップ関連 - マテリアル毎Uniform - ifdefで囲まないこと。
float2 DuDvMapImageSize
<
    string UIName = UINAME_DuDvMapImageSize;
	string UIWidget = "float2";
	float UIMin = 32;
	float UIMax = 512;
> = { DUDVMAP_SIZE, DUDVMAP_SIZE };


float2 DuDvScroll
<
    string UIName = UINAME_DuDvMapScroll;
	string UIWidget = "float2";
> = { 1.0, 1.0};

float2 DuDvScale
<
    string UIName = UINAME_DuDvMapScale;
	string UIWidget = "float2";
	float UIMin = 0;
	float UIMax = 1000;
> = { 4.0, 4.0};


//-----------------------------------------------------------------------------
// 草ゆれ

// 草ゆれ関連 - マテリアル毎Uniform - ifdefで囲まないこと。
float2 WindyGrassDirection
<
    string UIName = UINAME_WindyGrassDirection;
	string UIWidget = "float2";
	float UIMin = 0;
	float UIMax = 1;
> = {0.0, 0.0};

float WindyGrassSpeed
<
    string UIName = UINAME_WindyGrassSpeed;
    string UIWidget = "Slider";
    float UIMin = 0.01;
    float UIMax = 20.0;
    float UIStep = 0.01;
> = 2.0;

float WindyGrassHomogenity
<
    string UIName = UINAME_WindyGrassHomogenity;
    string UIWidget = "Slider";
    float UIMin = 1.0;
    float UIMax = 10.0;
    float UIStep = 0.1;
> = 2.0;

float WindyGrassScale
<
    string UIName = UINAME_WindyGrassScale;
    string UIWidget = "Slider";
    float UIMin = 1.0;
    float UIMax = 10.0;
    float UIStep = 0.1;
> = 1.0;

#endif // CARTOON_SHADING_ENABLED

//-----------------------------------------------------------------------------
// エッジ関連
#if !defined(DCC_TOOL)
float4 GameEdgeParameters : NodeEdgeParameters
<
    string UIName = UINAME_EdgeParameters;
    string UIWidget = "Slider";
    float UIMin = 0.001;
    float UIMax = 1.0;
    float UIStep = 0.001;
> = { 0.00, 0.00, 1.00, 0.004 };
#endif // defined(DCC_TOOL)

//-----------------------------------------------------------------------------
#if !defined(DCC_TOOL)
	#if defined(USE_SCREEN_UV)
	Texture2D<float4> ReflectionTexture : ReflectionTexture;
	Texture2D<float4> RefractionTexture : RefractionTexture;
	#endif // defined(USE_SCREEN_UV)
#endif // defined(DCC_TOOL)

//-----------------------------------------------------------------------------

#ifdef GLARE_MAP_ENABLED

Texture2D<float4> GlareMapSampler
<
	string UIName = UINAME_GlowMapSampler;
>;
#endif // GLARE_MAP_ENABLED

// グロー強さ - マテリアル毎Uniform - ifdefで囲まないこと。
float GlareIntensity
<
    string UIName = UINAME_GlowIntensity;
    string UIWidget = "Slider";
    float UIMin = 0.004;
    float UIMax = 5.0;
    float UIStep = 0.001;
> = 1.00;


#ifndef DCC_TOOL
uint4 DuranteSettings : DuranteSettings;
#endif

// その他Mayaでサポートされないもの
#ifdef DCC_TOOL
	#undef CASTS_SHADOWS
	#undef RECEIVE_SHADOWS
	#undef GENERATE_RELFECTION_ENABLED
	#undef GLARE_OVERFLOW_ENABLED
	#undef GLARE_HIGHTPASS_ENABLED
	#undef GLARE_MAP_ENABLED
#endif // DCC_TOOL

///////////////////////////////////////////////////////////////////////////////
// シェーダIn/Out構造体


#ifdef INSTANCING_ENABLED
/*
struct InstancingInput
{
	float4	InstanceTransform0	: TEXCOORD5;
	float4	InstanceTransform1	: TEXCOORD6;
	float4	InstanceTransform2	: TEXCOORD7;
};
*/
#endif // INSTANCING_ENABLED

//-----------------------------------------------------------------------------
struct DefaultVPInput
{
#ifdef SKINNING_ENABLED
	float3 SkinnableVertex	: POSITION;
	float3 SkinnableNormal	: NORMAL;
#else // SKINNING_ENABLED
	float4 Position			: POSITION;
	float3 Normal			: NORMAL;
#endif // SKINNING_ENABLED

	float2 TexCoord			: TEXCOORD0;

#ifdef VERTEX_COLOR_ENABLED
	float4 Color			: COLOR0;
#endif // VERTEX_COLOR_ENABLED

#ifdef USE_TANGENTS
	#ifdef SKINNING_ENABLED
	float3 SkinnableTangent	: TANGENT;
	#else // SKINNING_ENABLED
	float3 Tangent			: TANGENT;
	#endif // SKINNING_ENABLED
#endif // USE_TANGENTS

#ifdef SKINNING_ENABLED
	uint4 SkinIndices		: BLENDINDICES;
	float4 SkinWeights		: BLENDWEIGHTS;
#endif // SKINNING_ENABLED

#ifdef MULTI_UV_ENANLED
	float2 TexCoord2		: TEXCOORD3;
#endif // MULTI_UV_ENANLED

#if defined(MULTI_UV2_ENANLED)
	float2	TexCoord3		: TEXCOORD4;
#endif // defined(MULTI_UV2_ENANLED)

//#ifdef INSTANCING_ENABLED
//	InstancingInput instancingInput;
//#endif // INSTANCING_ENABLED
};

//-----------------------------------------------------------------------------

struct DefaultVPOutput
{
	float4 Position			: SV_Position ;		// xyzw:[Proj]射影座標

	float4 Color0			: COLOR0;		// xyzw:VertexColor x GameDiffuse
	float4 Color1			: COLOR1;		// [V] xyz:000 w:Fog
											// [P] xyz:SubLight要素総計 w:Fog

	float2 TexCoord			: TEXCOORD0;	// xy: テクスチャ座標

	float4	WorldPositionDepth	: TEXCOORD1;	// xyz[World]:座標 w[View]:z

	// TexCoord2
#if defined(DUDV_MAPPING_ENABLED)
	float2	DuDvTexCoord	: TEXCOORD2;	// xy: テクスチャ座標
#elif defined(MULTI_UV_ENANLED)
	float2	TexCoord2		: TEXCOORD2;	// xy: テクスチャ座標
#endif // DUDV_MAPPING_ENABLED || MULTI_UV_ENANLED


	// Projection/Etc
#if defined(PROJECTION_MAP_ENABLED)
	float2	ProjMap			: TEXCOORD3;	// xy: 投影テクスチャ	現状は 雲の影なのでxyしか使ってない
#endif // PROJECTION_MAP_ENABLED

	float3	Normal			: TEXCOORD4;		// xyz[World]:法線
	
#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
// [P] ピクセル単位ライティング
	#ifdef USE_TANGENTS
	float3	Tangent			: TEXCOORD6;		// xyz[World]:正接
	#endif // USE_TANGENTS

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
// [V] 頂点単位ライティング
	#ifdef USE_LIGHTING
	float3	LightingAmount	: TEXCOORD5;		// スペキュラ要素総計

		#if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	float4	ShadingAmount	: TEXCOORD6;		// ディフィーズ要素総計
		#else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	float3	ShadingAmount	: TEXCOORD6;		// ディフィーズ要素総計
		#endif // defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)

	#endif // USE_LIGHTING

#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

	#if defined(MULTI_UV2_ENANLED)
		float2	TexCoord3		: TEXCOORD7;	// xy: テクスチャ座標
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

#ifdef PRECALC_SHADOWMAP_POSITION
	float4 shadowPos	: TEXCOORD8;
#endif // PRECALC_SHADOWMAP_POSITION

#ifdef INSTANCING_ENABLED
//	InstancingInput instancingInput;
#endif // INSTANCING_ENABLED
};

//-----------------------------------------------------------------------------
#define DefaultFPInput DefaultVPOutput 

//-----------------------------------------------------------------------------
struct EdgeVPInput
{
#ifdef SKINNING_ENABLED
	float3 SkinnableVertex	: POSITION;
	float3 SkinnableNormal	: NORMAL;
#else // SKINNING_ENABLED
	float4 Position			: POSITION;
	float3 Normal			: NORMAL;
#endif // SKINNING_ENABLED

	float2 TexCoord			: TEXCOORD0;

#ifdef SKINNING_ENABLED
	uint4 SkinIndices		: BLENDINDICES;
	float4 SkinWeights		: BLENDWEIGHTS;
#endif // SKINNING_ENABLED

};

//-----------------------------------------------------------------------------

struct EdgeVPOutput
{
	float4 Position			: SV_Position ;		// xyzw:[Proj]射影座標

	float4 Color0			: COLOR0;		// xyzw:EdgeColor + GameEmission
	float3 TexCoord			: TEXCOORD0;	// xy: テクスチャ座標 z:Fog
};

//-----------------------------------------------------------------------------
#define EdgeFPInput EdgeVPOutput
/*
struct EdgeFPInput
{
	float4 Color0			: COLOR0;		// xyzw:
	float3 TexCoord			: TEXCOORD0;	// xy: テクスチャ座標 z:Fog
};
*/

//-----------------------------------------------------------------------------
struct DepthVPInput
{
#ifdef SKINNING_ENABLED
	float3	SkinnableVertex	: POSITION;
#else // SKINNING_ENABLED
	float4	Position		: POSITION;
#endif // SKINNING_ENABLED

#ifdef SKINNING_ENABLED
	uint4 SkinIndices		: BLENDINDICES;
	float4 SkinWeights		: BLENDWEIGHTS;
#endif // SKINNING_ENABLED

#ifdef WINDY_GRASS_ENABLED
	float2 TexCoord			: TEXCOORD0;
#endif // WINDY_GRASS_ENABLED

//#ifdef INSTANCING_ENABLED
//	InstancingInput	instancingInput;
//#endif // INSTANCING_ENABLED
};

struct DepthVPOutput
{
	float4 Position			: SV_Position;
};

//-----------------------------------------------------------------------------
struct ShadowTexturedVPInput
{
#ifdef SKINNING_ENABLED
	float3 SkinnableVertex	: POSITION;
#else // SKINNING_ENABLED
	float4 Position			: POSITION;
#endif // SKINNING_ENABLED

	float2 TexCoord			: TEXCOORD0;

#ifdef SKINNING_ENABLED
	uint4 SkinIndices		: BLENDINDICES;
	float4 SkinWeights		: BLENDWEIGHTS;
#endif // SKINNING_ENABLED
};

//-----------------------------------------------------------------------------
struct ShadowTexturedVPOutput
{
	float4 Position			: SV_Position;
	float2 TexCoord			: TEXCOORD0;
};

///////////////////////////////////////////////////////////////////////////////
// サブルーチン
#ifdef SKINNING_ENABLED
// 3ボーンの位置と法線と接線を計算する。
//
void EvaluateSkinPositionNormalTangent3Bones( inout float3 position, inout float3 normal, inout float3 tangent, float4 weights, uint4 boneIndices)
{
	int indexArray[3] = {boneIndices.x,boneIndices.y,boneIndices.z};

	float4 inPosition = float4(position.xyz,1);
	float4 inNormal = float4(normal.xyz,0);
	float4 inTangent = float4(tangent.xyz,0);
	float scale = 1.0f / (weights.x + weights.y + weights.z);
	
 	position = 
		mul(inPosition, BoneTransforms[indexArray[0]]).xyz * (weights.x * scale)
	+	mul(inPosition, BoneTransforms[indexArray[1]]).xyz * (weights.y * scale)
	+	mul(inPosition, BoneTransforms[indexArray[2]]).xyz * (weights.z * scale);
	
	normal = 
		mul(inNormal, BoneTransforms[indexArray[0]]).xyz * (weights.x * scale)
	+	mul(inNormal, BoneTransforms[indexArray[1]]).xyz * (weights.y * scale)
	+	mul(inNormal, BoneTransforms[indexArray[2]]).xyz * (weights.z * scale);

	tangent = 
		mul(inTangent, BoneTransforms[indexArray[0]]).xyz * (weights.x * scale)
	+	mul(inTangent, BoneTransforms[indexArray[1]]).xyz * (weights.y * scale)
	+	mul(inTangent, BoneTransforms[indexArray[2]]).xyz * (weights.z * scale);
}

// Evaluate skin for position, normal and tangent, for 4 bone weights.
void EvaluateSkinPositionNormalTangent4Bones( inout float3 position, inout float3 normal, inout float3 tangent, float4 weights, uint4 boneIndices )
{
	int indexArray[4] = {boneIndices.x,boneIndices.y,boneIndices.z,boneIndices.w};

	float4 inPosition = float4(position.xyz,1);
	float4 inNormal = float4(normal.xyz,0);
	float4 inTangent = float4(tangent.xyz,0);
	
 	position = 
		mul(inPosition, BoneTransforms[indexArray[0]]).xyz * weights.x
	+	mul(inPosition, BoneTransforms[indexArray[1]]).xyz * weights.y
	+	mul(inPosition, BoneTransforms[indexArray[2]]).xyz * weights.z
	+	mul(inPosition, BoneTransforms[indexArray[3]]).xyz * weights.w;
	
	normal = 
		mul(inNormal, BoneTransforms[indexArray[0]]).xyz * weights.x
	+	mul(inNormal, BoneTransforms[indexArray[1]]).xyz * weights.y
	+	mul(inNormal, BoneTransforms[indexArray[2]]).xyz * weights.z
	+	mul(inNormal, BoneTransforms[indexArray[3]]).xyz * weights.w;

	tangent = 
		mul(inTangent, BoneTransforms[indexArray[0]]).xyz * weights.x
	+	mul(inTangent, BoneTransforms[indexArray[1]]).xyz * weights.y
	+	mul(inTangent, BoneTransforms[indexArray[2]]).xyz * weights.z
	+	mul(inTangent, BoneTransforms[indexArray[3]]).xyz * weights.w;
		
}

// 3ボーンの位置と法線を計算する。
//
void EvaluateSkinPositionNormal3Bones( inout float3 position, inout float3 normal, float4 weights, uint4 boneIndices)
{
	int indexArray[3] = {boneIndices.x,boneIndices.y,boneIndices.z};

	float4 inPosition = float4(position.xyz,1);
	float4 inNormal = float4(normal.xyz,0);
	float scale = 1.0f / (weights.x + weights.y + weights.z);
	
 	position = 
		mul(inPosition, BoneTransforms[indexArray[0]]).xyz * (weights.x * scale)
	+	mul(inPosition, BoneTransforms[indexArray[1]]).xyz * (weights.y * scale)
	+	mul(inPosition, BoneTransforms[indexArray[2]]).xyz * (weights.z * scale);
	
	normal = 
		mul(inNormal, BoneTransforms[indexArray[0]]).xyz * (weights.x * scale)
	+	mul(inNormal, BoneTransforms[indexArray[1]]).xyz * (weights.y * scale)
	+	mul(inNormal, BoneTransforms[indexArray[2]]).xyz * (weights.z * scale);
}

void EvaluateSkinPositionNormal4Bones( inout float3 position, inout float3 normal, float4 weights, uint4 boneIndices)
{
	int indexArray[4] = {boneIndices.x,boneIndices.y,boneIndices.z,boneIndices.w};

	float4 inPosition = float4(position.xyz,1);
	float4 inNormal = float4(normal.xyz,0);
	
 	position = 
		mul(inPosition, BoneTransforms[indexArray[0]]).xyz * weights.x
	+	mul(inPosition, BoneTransforms[indexArray[1]]).xyz * weights.y
	+	mul(inPosition, BoneTransforms[indexArray[2]]).xyz * weights.z
	+	mul(inPosition, BoneTransforms[indexArray[3]]).xyz * weights.w;
	
	normal = 
		mul(inNormal, BoneTransforms[indexArray[0]]).xyz * weights.x
	+	mul(inNormal, BoneTransforms[indexArray[1]]).xyz * weights.y
	+	mul(inNormal, BoneTransforms[indexArray[2]]).xyz * weights.z
	+	mul(inNormal, BoneTransforms[indexArray[3]]).xyz * weights.w;
}

void EvaluateSkinPosition1Bone( inout float3 position, float4 weights, uint4 boneIndices)
{
	int index = boneIndices.x;

	float4 inPosition = float4(position.xyz,1.0);
	position = mul(inPosition, BoneTransforms[index]).xyz;		
}

void EvaluateSkinPosition2Bones( inout float3 position, float4 weights, uint4 boneIndices)
{
	int indexArray[2] = {boneIndices.x,boneIndices.y};

	float4 inPosition = float4(position.xyz,1);
	float scale = 1.0f / (weights.x + weights.y);
 	position = 
		mul(inPosition, BoneTransforms[indexArray[0]]).xyz * (weights.x * scale)
	+	mul(inPosition, BoneTransforms[indexArray[1]]).xyz * (weights.y * scale);
}

void EvaluateSkinPosition3Bones( inout float3 position, float4 weights, uint4 boneIndices)
{
	int indexArray[3] = {boneIndices.x,boneIndices.y,boneIndices.z};

	float4 inPosition = float4(position.xyz,1);
	float scale = 1.0f / (weights.x + weights.y + weights.z);
 	position = 
		mul(inPosition, BoneTransforms[indexArray[0]]).xyz * (weights.x * scale)
	+	mul(inPosition, BoneTransforms[indexArray[1]]).xyz * (weights.y * scale)
	+	mul(inPosition, BoneTransforms[indexArray[2]]).xyz * (weights.z * scale);
}

void EvaluateSkinPosition4Bones( inout float3 position, float4 weights, uint4 boneIndices)
{
	int indexArray[4] = {boneIndices.x,boneIndices.y,boneIndices.z,boneIndices.w};

	float4 inPosition = float4(position.xyz,1);
	
 	position = 
		mul(inPosition, BoneTransforms[indexArray[0]]).xyz * weights.x
	+	mul(inPosition, BoneTransforms[indexArray[1]]).xyz * weights.y
	+	mul(inPosition, BoneTransforms[indexArray[2]]).xyz * weights.z
	+	mul(inPosition, BoneTransforms[indexArray[3]]).xyz * weights.w;
}

#if (MAX_SKINNING_BONES == 3)
	#define EvaluateSkinPositionNormalTangentXBones	EvaluateSkinPositionNormalTangent3Bones
	#define EvaluateSkinPositionNormalXBones 		EvaluateSkinPositionNormal3Bones
	#define EvaluateSkinPositionXBones				EvaluateSkinPosition3Bones
#else
	#define EvaluateSkinPositionNormalTangentXBones	EvaluateSkinPositionNormalTangent4Bones
	#define EvaluateSkinPositionNormalXBones 		EvaluateSkinPositionNormal4Bones
	#define EvaluateSkinPositionXBones				EvaluateSkinPosition4Bones
#endif
#endif //SKINNING_ENABLED

//-----------------------------------------------------------------------------
// 視点の位置
//
float3 getEyePosition()
{
#ifdef DCC_TOOL
	return float3(ViewIXf[0].w, ViewIXf[1].w, ViewIXf[2].w);
#else // DCC_TOOL
	return scene_EyePosition;
#endif // DCC_TOOL
}

//-----------------------------------------------------------------------------
#ifdef FAKE_CONSTANT_SPECULAR_ENABLED
float3 getFakeSpecularLightDir(float3 trueLightDir)
{
#ifdef DCC_TOOL
	float3 v0 = mul(float4(0,0,0,1), ViewIXf).xyz;
	float3 v1 = mul(float4(0,0,-1,1), ViewIXf).xyz;
	float3 cameraEyeDir = normalize(v1 - v0);
	return normalize(trueLightDir + 2 * (cameraEyeDir * 1.5f + float3(0,1,0)));
#else // DCC_TOOL
	return scene_FakeRimLightDir;
#endif // DCC_TOOL
}
#endif // SPECULAR_ENABLED


//-----------------------------------------------------------------------------
// グローバルテクスチャスクロール
//
//#ifndef UVA_SCRIPT_ENABLED
float2 getGlobalTextureFactor()
{
	#ifdef DCC_TOOL
	return (float2)Timer * 0.25f;
	#else // DCC_TOOL
	return GlobalTexcoordFactor;
	#endif // DCC_TOOL
}
//#endif // UVA_SCRIPT_ENABLED

//-----------------------------------------------------------------------------
// 射影後のスクリーン座標
#if defined(USE_SCREEN_UV)
float4 GenerateScreenProjectedUv(float4 projPosition)
{
	float2 clipSpaceDivided = projPosition.xy / float2(projPosition.w, -projPosition.w);
	float2 tc = clipSpaceDivided.xy * 0.5f + 0.5f;
	return float4(tc * projPosition.w, 0, projPosition.w);	
}
#endif // defined(USE_SCREEN_UV)

//-----------------------------------------------------------------------------
#ifdef WINDY_GRASS_ENABLED
	#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
float3 calcWindyGrass(float3 position, float weight)
	#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
float3 calcWindyGrass(float3 position)
	#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
{
//#ifndef UVA_SCRIPT_ENABLED
	float2 time = getGlobalTextureFactor();
//#else // UVA_SCRIPT_ENABLED
//	float2 time = UVaDuDvTexcoord.xx;
//#endif // UVA_SCRIPT_ENABLED

	#ifdef DCC_TOOL
	float k = (position.x + position.z) * (1/100.0f);
	#else // DCC_TOOL
	float k = position.x + position.z;
	#endif // DCC_TOOL
	float a = k * (1.0f / (WindyGrassHomogenity * WindyGrassHomogenity));
	float t = a * 0.25f + frac(a) + time.x * WindyGrassSpeed;

	#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
	float2 dd = WindyGrassDirection * sin(t) * WindyGrassScale * weight;
	#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	float2 dd = WindyGrassDirection * sin(t) * WindyGrassScale;
	#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	#ifdef DCC_TOOL
	dd *= 100.0f;
	#endif // DCC_TOOL
	return position.xyz + float3(dd.x, 0, dd.y);
}
#endif // WINDY_GRASS_ENABLED

// ライティング 最終的な計算 Directional
void EvaluateDiffuseAndSpecular_Directional(out float3 diffuseValue, out float ldotn, float3 normal, float3 lightDir, float3 lightColor
#ifdef SPECULAR_ENABLED
	, out float3 specularValue, float3 specularLightDir, float3 eyeDirection, float shininess, float specularPower//, half fresnelPower
#endif // SPECULAR_ENABLED
	)
{
#if defined(CARTOON_SHADING_ENABLED)
	ldotn = dot(lightDir, normal);
	diffuseValue = lightColor;
#elif defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	ldotn = dot(lightDir, normal);
//	ldotn = 1;
	diffuseValue = lightColor / max(max(lightColor.r, lightColor.g), max(lightColor.b, 0.001f));	// 一番大きい色成分で正規化
//	diffuseValue = half3(1);
#else
	ldotn = dot(lightDir, normal);
	diffuseValue = lightColor * calcDiffuseLightAmtLdotN(ldotn);
#endif

#ifdef SPECULAR_ENABLED
	specularValue = lightColor * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, specularPower//, fresnelPower
		);
#endif // SPECULAR_ENABLED
}

// ライティング 最終的な計算 Point/Spot
void EvaluateDiffuseAndSpecular_PointOrSpot(out float3 diffuseValue, out float ldotn, float3 normal, float3 lightDir, float3 lightColor, float attenuation
#ifdef SPECULAR_ENABLED
	, out float3 specularValue, float3 specularLightDir, float3 eyeDirection, float shininess, float specularPower//, half fresnelPower
#endif // SPECULAR_ENABLED
	)
{
	ldotn = dot(lightDir, normal);

	float3 lightAmt = lightColor * attenuation;
	diffuseValue = lightAmt * calcDiffuseLightAmtLdotN(ldotn);

#ifdef SPECULAR_ENABLED
	specularValue = lightAmt * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, specularPower//, fresnelPower
		);
#endif // SPECULAR_ENABLED
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Lighting code - could/should be defined in an external .h file. 

// ライティング - 平行光
// フェイク常在スペキュラはメインライト用
void EvaluateLight(DirectionalLight light, out float ldotn, out float3 diffuseValue,
	out float3 lightDir, float3 worldSpacePosition, float3 normal
#ifdef SPECULAR_ENABLED
	, out float3 specularValue, float3 eyeDirection, float shininess, float specularPower/*, half fresnelPower*/
#endif // SPECULAR_ENABLED
	)
{
#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	float3 lightDirTmp = LightDirForChar;
#else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	float3 lightDirTmp = light.m_direction;
#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	lightDir = lightDirTmp;

#ifdef FAKE_CONSTANT_SPECULAR_ENABLED
	float3 specularLightDir = getFakeSpecularLightDir(lightDirTmp);
#else // FAKE_CONSTANT_SPECULAR_ENABLED
	float3 specularLightDir = lightDirTmp;
#endif // FAKE_CONSTANT_SPECULAR_ENABLED
	EvaluateDiffuseAndSpecular_Directional(diffuseValue, ldotn, normal, lightDirTmp, light.m_colorIntensity
#ifdef SPECULAR_ENABLED
		, specularValue, specularLightDir, eyeDirection, shininess, specularPower//, fresnelPower
#endif // SPECULAR_ENABLED
		);
}

// ライティング - ポイントライト
void EvaluateLight(PointLight light, out float ldotn, out float3 diffuseValue,
	out float3 lightDir, float3 worldSpacePosition, float3 normal
#ifdef SPECULAR_ENABLED
	, out float3 specularValue, float3 eyeDirection, float shininess, float specularPower/*, half fresnelPower*/
#endif // SPECULAR_ENABLED
	)
{
	float3 offset = light.m_position - worldSpacePosition;
	float vecLengthSqr = dot(offset, offset);
	float vecLength = sqrt(vecLengthSqr);
	lightDir = offset / vecLength;

	float atten = calculateAttenuationQuadratic(vecLengthSqr, light.m_attenuation);

	EvaluateDiffuseAndSpecular_PointOrSpot(diffuseValue, ldotn, normal, lightDir, light.m_colorIntensity, atten
#ifdef SPECULAR_ENABLED
		, specularValue, lightDir, eyeDirection, shininess, specularPower//, fresnelPower
#endif // SPECULAR_ENABLED
		);
}


// ライトの方向のみ取得 - 平行光
float3 EvaluateLightDirection(DirectionalLight light, float3 worldSpacePosition)
{
#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	return LightDirForChar;
#else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	return light.m_direction;
#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
}

// ライトの方向のみ取得 - ポイントライト
float3 EvaluateLightDirection(PointLight light, float3 worldSpacePosition)
{
	float3 offset = light.m_position - worldSpacePosition;
	float vecLengthSqr = dot(offset, offset);
	return offset / sqrt(vecLengthSqr);
}

#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
// ライティング - 平行光
void PortraitEvaluateLight(out float ldotn, out float3 diffuseValue,
	out float3 lightDir, float3 worldSpacePosition, float3 normal
#ifdef SPECULAR_ENABLED
	, out float3 specularValue, float3 eyeDirection, float shininess, float specularPower/*, half fresnelPower*/
#endif // SPECULAR_ENABLED
	)
{
	float3 lightDirTmp = LightDirForChar;
	lightDir = lightDirTmp;

#ifdef FAKE_CONSTANT_SPECULAR_ENABLED
	float3 specularLightDir = getFakeSpecularLightDir(lightDirTmp);
#else // FAKE_CONSTANT_SPECULAR_ENABLED
	float3 specularLightDir = lightDirTmp;
#endif // FAKE_CONSTANT_SPECULAR_ENABLED
	EvaluateDiffuseAndSpecular_Directional(diffuseValue, ldotn, normal, lightDirTmp, PortraitLightColor
#ifdef SPECULAR_ENABLED
		, specularValue, specularLightDir, eyeDirection, shininess, specularPower//, fresnelPower
#endif // SPECULAR_ENABLED
		);
		
}
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

//-----------------------------------------------------------------------------
// アンビエント
float3 EvaluateAmbient(float3 normal)
{
	#ifdef HEMISPHERE_AMBIENT_ENABLED
	// 半球
	float amt = (dot(normal, HemiSphereAmbientAxis) + 1.0f) * 0.5f;
		#ifdef MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	float3 L = HemiSphereAmbientGndColor.rgb;
	float3 U = HemiSphereAmbientSkyColor.rgb;
	float3 M = getGlobalAmbientColor();
	return L + (2*M-2*L)*amt + (U-2*M+L)*amt*amt;

		#else // MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	return lerp(HemiSphereAmbientGndColor.rgb, HemiSphereAmbientSkyColor.rgb, amt);
		#endif // MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED

	#else // HEMISPHERE_AMBIENT_ENABLED

	return getGlobalAmbientColor();

	#endif // HEMISPHERE_AMBIENT_ENABLED
}

//-----------------------------------------------------------------------------
#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
float3 PortraitEvaluateAmbient(float3 normal)
{
	return PortraitAmbientColor;
}
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

//-----------------------------------------------------------------------------
// フォグ係数
//
#ifdef FOG_ENABLED
float EvaluateFogVP(float3 viewPosition)
{
	#ifdef DCC_TOOL
	float f = saturate((-viewPosition.z - FogRangeParameters.x / 100.0f) / ((FogRangeParameters.y - FogRangeParameters.x) * 100.0f));	// cm -> m
	#else // DCC_TOOL
	float f = saturate((-viewPosition.z - scene_FogRangeParameters.x) * scene_FogRangeParameters.z);
	#endif // DCC_TOOL
	#ifdef FOG_RATIO_ENABLED
	f *= FogRatio;
	#endif // FOG_RATIO_ENABLED
	return f;
}

void EvaluateFogFP(inout float3 resultColor, float3 fogColor, float fogValue)
{
	#if defined(USE_EXTRA_BLENDING)
	fogColor = float3(0.0f,0.0f,0.0f);
	#endif // defined(USE_EXTRA_BLENDING)
	
	resultColor.rgb = lerp(resultColor.rgb, fogColor.rgb, fogValue);
}

#endif // FOG_ENABLED

//-----------------------------------------------------------------------------
// FP内での法線
//
#if defined(NORMAL_MAPPING_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormalFP(In) EvaluateNormalMapNormal(In.Normal.xyz, In.DuDvTexCoord.xy, In.Tangent, NormalMapSampler, NormalMapSamplerS)
	#else // defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormalFP(In) EvaluateNormalMapNormal(In.Normal.xyz, In.TexCoord.xy, In.Tangent, NormalMapSampler, NormalMapSamplerS)
	#endif // defined(DUDV_MAPPING_ENABLED)
#else
	#define EvaluateNormalFP(In) EvaluateStandardNormal(In.Normal.xyz)
#endif

#if defined(NORMAL_MAPPING2_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormal2FP(In) EvaluateNormalMapNormal(In.Normal.xyz, In.DuDvTexCoord.xy, In.Tangent, NormalMap2Sampler, NormalMap2SamplerS)
	#else // defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormal2FP(In) EvaluateNormalMapNormal(In.Normal.xyz, In.TexCoord.xy, In.Tangent, NormalMap2Sampler, NormalMap2SamplerS)
	#endif // defined(DUDV_MAPPING_ENABLED)
#else
	#define EvaluateNormal2FP(In) EvaluateStandardNormal(In.Normal.xyz)
#endif

//-----------------------------------------------------------------------------
// 
#ifdef RIM_LIGHTING_ENABLED
float EvaluateRimLightValue(float ndote)
{
	float rimLightvalue = pow(1.0f - abs(ndote), RimLitPower);
	return rimLightvalue * RimLitIntensity;
}
#endif // RIM_LIGHTING_ENABLED

//-----------------------------------------------------------------------------
#ifdef CARTOON_SHADING_ENABLED
float calcToonShadingValueFP(float ldotn, float shadowValue)
{
	float u = (ldotn * 0.5f + 0.5f) * shadowValue;
	float r = CartoonMapSampler.Sample(CartoonMapSamplerS, float2(u, 0.0f)).r;
	return r;
}
#endif // CARTOON_SHADING_ENABLED

//-----------------------------------------------------------------------------
#ifdef CUSTOM_DIFFUSE_ENABLED
float3 calcCustomDiffuse(float value)
{
	#define CDE_F1	0.60
	#define CDE_F2	0.30

	if (value >= 0.60f)
	{
		value = min(1.0f, value);
		return lerp(CustomDiffuse_Base, CustomDiffuse_Hilight, (value - CDE_F1) * (1.f/(1.0f - CDE_F1)) );
	}
	else
	{
		value = max(0.0f, value);
		if (value >= CDE_F2)
		{
			return lerp(CustomDiffuse_Middle, CustomDiffuse_Base, (value - CDE_F2) * (1.f/(CDE_F1 - CDE_F2)) );
		}
		else
		{
			return lerp(CustomDiffuse_Shadow, CustomDiffuse_Middle, value * (1.f/CDE_F2) );
		}
	}
}
#endif // CUSTOM_DIFFUSE_ENABLED

//-----------------------------------------------------------------------------
// ピクセル単位ライティング-FP
//
#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)

float3 EvaluateLightingPerPixelFP(inout float3 sublightAmount, DefaultFPInput In, float3 worldSpacePosition, float3 normal, float glossValue, float shadowValue, float3 ambientAmount, float3 eyeDirection)
{
	// Lighting
	//float3 lightingResult = float3(0.0f, 0.0f, 0.0f);
	#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	float3 lightingResult = float3(0.0f, 0.0f, 0.0f);
	#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	float3 lightingResult = ambientAmount;
	#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	float3 shadingAmount = float3(0.0f, 0.0f, 0.0f);
	float3 lightingAmount = float3(0.0f, 0.0f, 0.0f);

	#ifdef SPECULAR_ENABLED
	float shininess_ = Shininess * glossValue;
	#endif // SPECULAR_ENABLED

	#if NUM_LIGHTS > 0
	{
		float3 lightDir_ = float3(0.0f, 0.0f, 0.0f);
		float3 diffuseValue_ = float3(0.0f, 0.0f, 0.0f);
		float3 specularValue_ = float3(0.0f, 0.0f, 0.0f);
		float ldotn_ = 0;
		EvaluateLight(Light0, ldotn_, diffuseValue_, lightDir_, worldSpacePosition, normal
		#ifdef SPECULAR_ENABLED
			, specularValue_, eyeDirection, shininess_, SpecularPower //, FresnelPower
		#endif // SPECULAR_ENABLED
			);

		#ifdef CARTOON_SHADING_ENABLED
		diffuseValue_ *= calcToonShadingValueFP(ldotn_, shadowValue);
		#else // CARTOON_SHADING_ENABLED
		diffuseValue_ *= shadowValue;
		#endif // CARTOON_SHADING_ENABLED

		#ifdef SPECULAR_ENABLED
		lightingAmount += specularValue_;
		lightingAmount *= shadowValue;
		#endif // SPECULAR_ENABLED

		shadingAmount += diffuseValue_;

		lightingResult += shadingAmount;

		#ifdef MAINLIGHT_CLAMP_FACTOR_ENABLED
		lightingResult = min(lightingResult, (float3)MainLightClampFactor);
		#endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

		#ifdef USE_POINT_LIGHT_0
			#ifndef DCC_TOOL
		if (scene_light1_position.w > 0.0f)
		{
			#endif // DCC_TOOL
		
			#ifdef USE_POINT_LIGHT_1
				#if (NUM_LIGHTS > 2) || defined(OWN_POINTLIGHT_ENABLED)
					#ifndef DCC_TOOL
			if (scene_light1_position.w > 1.0f)
					#endif // DCC_TOOL
			{
				float3 lightDir = float3(0.0f, 0.0f, 0.0f);
				float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
				float3 specularValue = float3(0.0f, 0.0f, 0.0f);
				float ldotn = 0;
					#ifdef OWN_POINTLIGHT_ENABLED
				PointLight light2;
						#ifdef DCC_TOOL
				light2.m_position		= Light2.m_position;
				light2.m_colorIntensity = Light2.m_colorIntensity;
				light2.m_attenuation	= Light2.m_attenuation;
						#else // DCC_TOOL
				light2.m_position		= scene_light2_position.xyz;
				light2.m_colorIntensity = scene_light2_colorIntensity;
				light2.m_attenuation	= scene_light2_attenuation;
						#endif // DCC_TOOL
						#ifdef POINT_LIGHT_TEST
				light2.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
						#endif // POINT_LIGHT_TEST
				EvaluateLight(light2, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
					#else // OWN_POINTLIGHT_ENABLED
						#ifdef POINT_LIGHT_TEST
				Light2.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
						#endif // POINT_LIGHT_TEST
				EvaluateLight(Light2, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
					#endif // OWN_POINTLIGHT_ENABLED
					#ifdef SPECULAR_ENABLED
					, specularValue, eyeDirection, shininess_, SpecularPower //, FresnelPower
					#endif // SPECULAR_ENABLED
					);

					#if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
				diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
					#else // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED
					#endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

				sublightAmount += diffuseValue;
					#ifdef SPECULAR_ENABLED
				sublightAmount += specularValue;
					#endif // SPECULAR_ENABLED
			}
				#endif
			#endif // USE_POINT_LIGHT_1

			#if (NUM_LIGHTS > 1) || defined(OWN_POINTLIGHT_ENABLED)
			{
				float3 lightDir = float3(0.0f, 0.0f, 0.0f);
				float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
				float3 specularValue = float3(0.0f, 0.0f, 0.0f);
				float ldotn = 0;
				#ifdef OWN_POINTLIGHT_ENABLED
				PointLight light1;
					#ifdef DCC_TOOL
				light1.m_position		= Light1.m_position;
				light1.m_colorIntensity = Light1.m_colorIntensity;
				light1.m_attenuation	= Light1.m_attenuation;
					#else // DCC_TOOL
				light1.m_position		= scene_light1_position.xyz;
				light1.m_colorIntensity = scene_light1_colorIntensity;
				light1.m_attenuation	= scene_light1_attenuation;
					#endif // DCC_TOOL
					#ifdef POINT_LIGHT_TEST
				light1.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
					#endif // POINT_LIGHT_TEST
				EvaluateLight(light1, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
				#else // OWN_POINTLIGHT_ENABLED
					#ifdef POINT_LIGHT_TEST
				Light1.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
					#endif // POINT_LIGHT_TEST
				EvaluateLight(Light1, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
				#endif // OWN_POINTLIGHT_ENABLED
				#ifdef SPECULAR_ENABLED
					, specularValue, eyeDirection, shininess_, SpecularPower //, FresnelPower
				#endif // SPECULAR_ENABLED
					); 

				#if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
				diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
				#else // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED
//				diffuseValue *= shadowValue;
				#endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

				sublightAmount += diffuseValue;
				#ifdef SPECULAR_ENABLED
				sublightAmount += specularValue;
				#endif // SPECULAR_ENABLED
			}
			#endif

			#ifndef DCC_TOOL
		}
			#endif // DCC_TOOL
		#endif // USE_POINT_LIGHT_0

		#ifdef SPECULAR_ENABLED
		lightingResult += lightingAmount;
		#endif // SPECULAR_ENABLED
	}
	#endif

	return lightingResult;
}

	#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
float3 PortraitEvaluateLightingPerPixelFP(inout float3 sublightAmount, float3 worldSpacePosition, float3 normal, float glossValue, float shadowValue, float3 ambientAmount, float3 eyeDirection)
{
	// Lighting
	//float3 lightingResult;

	#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	float3 lightingResult = float3(0.0f, 0.0f, 0.0f);
	#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	float3 lightingResult = ambientAmount;
	#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	float3 shadingAmount = float3(0.0f, 0.0f, 0.0f);
	float3 lightingAmount = float3(0.0f, 0.0f, 0.0f);

	#ifdef SPECULAR_ENABLED
	float shininess_ = Shininess * glossValue;
	#endif // SPECULAR_ENABLED

	#if NUM_LIGHTS > 0
	{
		float3 lightDir_ = float3(0.0f, 0.0f, 0.0f);
		float3 diffuseValue_ = float3(0.0f, 0.0f, 0.0f);
		float3 specularValue_ = float3(0.0f, 0.0f, 0.0f);
		float ldotn_ = 0.0f;
		PortraitEvaluateLight(ldotn_, diffuseValue_, lightDir_, worldSpacePosition, normal
		#ifdef SPECULAR_ENABLED
			, specularValue_, eyeDirection, shininess_, SpecularPower //, FresnelPower
		#endif // SPECULAR_ENABLED
			);

		#ifdef CARTOON_SHADING_ENABLED
		diffuseValue_ *= calcToonShadingValueFP(ldotn_, shadowValue);
		#else // CARTOON_SHADING_ENABLED
		diffuseValue_ *= shadowValue;
		#endif // CARTOON_SHADING_ENABLED

		#ifdef SPECULAR_ENABLED
		lightingAmount += specularValue_;
		lightingAmount *= shadowValue;
		#endif // SPECULAR_ENABLED

		shadingAmount += diffuseValue_;

		lightingResult += shadingAmount;

		#ifdef MAINLIGHT_CLAMP_FACTOR_ENABLED
		lightingResult = min(lightingResult, (float3)MainLightClampFactor);
		#endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

		#ifdef SPECULAR_ENABLED
		lightingResult += lightingAmount;
		#endif // SPECULAR_ENABLED
	}
	#endif

	return lightingResult;
}
	#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

//-----------------------------------------------------------------------------
// 頂点単位ライティング-VP
//
#ifdef USE_LIGHTING

void EvaluateLightingPerVertexVP(out float3 shadingAmount, out float3 lightingAmount, out float3 subLightingAmount, out float3 light0dir, DefaultVPInput In, float3 worldSpacePosition, float3 normal
	#ifdef SPECULAR_ENABLED
	, float3 eyeDirection //, half fresnelPower
	#endif // SPECULAR_ENABLED
	)
{
	shadingAmount = float3(0.0f, 0.0f, 0.0f);
	lightingAmount = float3(0.0f, 0.0f, 0.0f);
	subLightingAmount = float3(0.0f, 0.0f, 0.0f);

	#ifdef SPECULAR_ENABLED
	float shininess_ = Shininess;
	#endif // SPECULAR_ENABLED

	#if NUM_LIGHTS > 0
	{
		float3 lightDir_ = float3(0.0f, 0.0f, 0.0f);
		float3 diffuseValue_ = float3(0.0f, 0.0f, 0.0f);
		float3 specularValue_ = float3(0.0f, 0.0f, 0.0f);
		float ldotn_ = 0.0f;
		EvaluateLight(Light0, ldotn_, diffuseValue_, lightDir_, worldSpacePosition, normal
		#ifdef SPECULAR_ENABLED
			, specularValue_, eyeDirection, shininess_, SpecularPower //, FresnelPower
		#endif // SPECULAR_ENABLED
			);

		shadingAmount += diffuseValue_;
		#ifdef SPECULAR_ENABLED
		lightingAmount += specularValue_;
		#endif // SPECULAR_ENABLED
		light0dir = lightDir_;

		#ifdef USE_POINT_LIGHT_0
			#ifndef DCC_TOOL
		if (scene_light1_position.w > 0.0f)
		{
			#endif // DCC_TOOL

			#ifdef USE_POINT_LIGHT_1
				#if (NUM_LIGHTS > 2) || defined(OWN_POINTLIGHT_ENABLED)
					#ifndef DCC_TOOL
			if (scene_light1_position.w > 1.0f)
					#endif // DCC_TOOL
			{
				float3 lightDir = float3(0.0f, 0.0f, 0.0f);
				float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
				float3 specularValue = float3(0.0f, 0.0f, 0.0f);
				float ldotn = 0.0f;
					#ifdef OWN_POINTLIGHT_ENABLED
				PointLight light2;
						#ifdef DCC_TOOL
				light2.m_position		= Light2.m_position;
				light2.m_colorIntensity = Light2.m_colorIntensity;
				light2.m_attenuation	= Light2.m_attenuation;
						#else // DCC_TOOL
				light2.m_position		= scene_light2_position.xyz;
				light2.m_colorIntensity = scene_light2_colorIntensity;
				light2.m_attenuation	= scene_light2_attenuation;
						#endif // DCC_TOOL
						#ifdef POINT_LIGHT_TEST
				light2.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
						#endif // POINT_LIGHT_TEST
				EvaluateLight(light2, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
					#else // OWN_POINTLIGHT_ENABLED
						#ifdef POINT_LIGHT_TEST
				Light2.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
						#endif // POINT_LIGHT_TEST
				EvaluateLight(Light2, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
					#endif // OWN_POINTLIGHT_ENABLED
					#ifdef SPECULAR_ENABLED
					, specularValue, eyeDirection, shininess_, SpecularPower //, FresnelPower
					#endif // SPECULAR_ENABLED
					);

				subLightingAmount += diffuseValue;
					#ifdef SPECULAR_ENABLED
				subLightingAmount += specularValue;
					#endif // SPECULAR_ENABLED
			}
				#endif // (NUM_LIGHTS > 2) || defined(OWN_POINTLIGHT_ENABLED)
			#endif // USE_POINT_LIGHT_1

			#if (NUM_LIGHTS > 1) || defined(OWN_POINTLIGHT_ENABLED)
			{
				float3 lightDir = float3(0.0f, 0.0f, 0.0f);
				float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
				float3 specularValue = float3(0.0f, 0.0f, 0.0f);
				float ldotn = 0.0f;
				#ifdef OWN_POINTLIGHT_ENABLED
				PointLight light1;
					#ifdef DCC_TOOL
				light1.m_position		= Light1.m_position;
				light1.m_colorIntensity = Light1.m_colorIntensity;
				light1.m_attenuation	= Light1.m_attenuation;
					#else // DCC_TOOL
				light1.m_position		= scene_light1_position.xyz;
				light1.m_colorIntensity = scene_light1_colorIntensity;
				light1.m_attenuation	= scene_light1_attenuation;
					#endif // DCC_TOOL
					#ifdef POINT_LIGHT_TEST
				light1.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
					#endif // POINT_LIGHT_TEST
				EvaluateLight(light1, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
				#else // OWN_POINTLIGHT_ENABLED
					#ifdef POINT_LIGHT_TEST
				Light1.m_attenuation	= float4(POINT_LIGHT_INNTER_RANGE, POINT_LIGHT_OUTER_RANGE, 1.0f/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE), -POINT_LIGHT_INNTER_RANGE/(POINT_LIGHT_OUTER_RANGE-POINT_LIGHT_INNTER_RANGE));
					#endif // POINT_LIGHT_TEST
				EvaluateLight(Light1, ldotn, diffuseValue, lightDir, worldSpacePosition, normal
				#endif // OWN_POINTLIGHT_ENABLED
				#ifdef SPECULAR_ENABLED
					, specularValue, eyeDirection, shininess_, SpecularPower //, FresnelPower
				#endif // SPECULAR_ENABLED
					); 

				subLightingAmount += diffuseValue;
				#ifdef SPECULAR_ENABLED
				subLightingAmount += specularValue;
				#endif // SPECULAR_ENABLED
			}
			#endif // (NUM_LIGHTS > 1) || defined(OWN_POINTLIGHT_ENABLED)

			#ifndef DCC_TOOL
		}
			#endif // DCC_TOOL
		#else
			#ifdef PRECALC_EVALUATE_AMBIENT
				subLightingAmount = EvaluateAmbient(normal);	// Color1.rgbを別の用途に利用する
			#endif
		#endif // USE_POINT_LIGHT_0
	}
	#endif
}

#endif // USE_LIGHTING

//-----------------------------------------------------------------------------
// 頂点単位ライティング-FP
//
float3 EvaluateLightingPerVertexFP(DefaultFPInput In, float3 worldSpacePosition, float glossValue, float shadowValue, float3 ambientAmount, float3 shadingAmount, float3 lightingAmount, float3 subLight)
{
	float3 lightingResult = float3(0.0f, 0.0f, 0.0f);

#ifdef USE_LIGHTING
	lightingResult = ambientAmount;

	#if NUM_LIGHTS > 0
	{
		#ifdef SPECULAR_ENABLED
		lightingAmount *= shadowValue * glossValue;
		#endif // SPECULAR_ENABLED

		// トゥーン
		#ifdef CARTOON_SHADING_ENABLED
		shadingAmount *= calcToonShadingValueFP(In.CartoonMap.z, shadowValue);
		#else // CARTOON_SHADING_ENABLED
		shadingAmount *= shadowValue;
		#endif // CARTOON_SHADING_ENABLED

		lightingResult += shadingAmount;

		#ifdef MAINLIGHT_CLAMP_FACTOR_ENABLED
		lightingResult = min(lightingResult, (float3)MainLightClampFactor);
		#endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

		#ifdef SPECULAR_ENABLED
		lightingResult += lightingAmount;
		#endif // SPECULAR_ENABLED
		lightingResult += subLight;
	}
	#endif

#else // USE_LIGHTING

	#if defined(MULTIPLICATIVE_BLENDING_ENABLED)
	shadowValue = 1.0f;
	#endif

	lightingResult = max(getGlobalAmbientColor(), (float3)shadowValue);

	#ifdef MAINLIGHT_CLAMP_FACTOR_ENABLED
	lightingResult = min(lightingResult, (float3)MainLightClampFactor);
	#endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

#endif // USE_LIGHTING

	return lightingResult;
}

#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
// 通常VP
//
#define VP_DEFAULT
#undef VP_PORTRAIT

#line 1 "Z:/data/shaders/ed8_vp_main.h"
// このファイルはUTF-8コードで保存してください。

// VP_DEFAULT
// VP_PORTRAIT
//-----------------------------------------------------------------------------
//
#ifdef VP_DEFAULT
DefaultVPOutput DefaultVPShader(DefaultVPInput IN)
#endif // VP_DEFAULT
#ifdef VP_PORTRAIT
DefaultVPOutput PortraitVPShader(DefaultVPInput IN)
#endif // VP_PORTRAIT
{
	DefaultVPOutput OUT;

	// Grab tangent
#ifdef USE_TANGENTS
	#ifdef SKINNING_ENABLED
	float3 tangent = IN.SkinnableTangent;
	#else //! SKINNING_ENABLED
	float3 tangent = IN.Tangent;
	#endif //! SKINNING_ENABLED
#endif //! USE_TANGENTS

	// Get normal
#ifdef SKINNING_ENABLED
	float3 normal = IN.SkinnableNormal;
#else //! SKINNING_ENABLED
	float3 normal = IN.Normal;
#endif //! SKINNING_ENABLED

	// Get position.
#ifdef SKINNING_ENABLED
	float3 position = IN.SkinnableVertex.xyz;
#else //! SKINNING_ENABLED
	float3 position = IN.Position.xyz;
#endif //! SKINNING_ENABLED


#ifdef SKINNING_ENABLED
	float4 skinIndices = IN.SkinIndices;
	float4 skinWeights = IN.SkinWeights;

	#ifdef USE_LIGHTING
		#if defined(USE_TANGENTS)
	EvaluateSkinPositionNormalTangentXBones(position, normal, tangent, skinWeights, skinIndices);
		#else // USE_TANGENTS
	EvaluateSkinPositionNormalXBones(position, normal, skinWeights, skinIndices);
		#endif // USE_TANGENTS
	#else // USE_LIGHTING
	EvaluateSkinPositionXBones(position, skinWeights, skinIndices);
	#endif // USE_LIGHTING

	float3 worldSpacePosition = position;
	float3 worldSpaceNormal = normalize(normal);

	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
		#ifdef USE_TANGENTS
	tangent = normalize(tangent);
		#endif // USE_TANGENTS
	#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

#else //! SKINNING_ENABLED

	float3 worldSpacePosition = mul(float4(position.xyz,1.0f), World).xyz;
	float3 worldSpaceNormal = normalize(mul(float4(normal.xyz,0.0f), World).xyz);
	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
		#ifdef USE_TANGENTS
	tangent = normalize(mul(float4(tangent.xyz,0.0f), World).xyz);
		#endif // USE_TANGENTS
	#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

#endif //! SKINNING_ENABLED


	#ifdef WINDY_GRASS_ENABLED
		#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, IN.TexCoord.y);
		#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
		#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	#endif // WINDY_GRASS_ENABLED

	OUT.Position = mul(float4(worldSpacePosition.xyz, 1.0f), scene_ViewProjection);

	OUT.WorldPositionDepth = float4(worldSpacePosition.xyz, -mul(float4(worldSpacePosition.xyz, 1.0f), scene_View).z);
	OUT.Normal = (float3)worldSpaceNormal;
	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
		#ifdef USE_TANGENTS
	OUT.Tangent = (float3)tangent;
		#endif // USE_TANGENTS
	#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

	float3 viewSpacePosition = mul(float4(worldSpacePosition.xyz, 1.0f), scene_View).xyz;

	OUT.TexCoord.xy = (float2)IN.TexCoord.xy * (float2)GameMaterialTexcoord.zw + (float2)GameMaterialTexcoord.xy;
	#ifndef UVA_SCRIPT_ENABLED
		#ifdef TEXCOORD_OFFSET_ENABLED
	OUT.TexCoord.xy += (float2)(TexCoordOffset * getGlobalTextureFactor());
		#endif // TEXCOORD_OFFSET_ENABLED
	#endif // UVA_SCRIPT_ENABLED

	// TexCoord2
#if defined(DUDV_MAPPING_ENABLED) && !defined(CARTOON_SHADING_ENABLED)

	#ifndef UVA_SCRIPT_ENABLED
	OUT.DuDvTexCoord.xy = (float2)IN.TexCoord.xy;
	OUT.DuDvTexCoord.xy += (float2)(DuDvScroll * getGlobalTextureFactor());
	#else // UVA_SCRIPT_ENABLED
	OUT.DuDvTexCoord.xy = IN.TexCoord.xy * (float2)UVaDuDvTexcoord.zw + (float2)UVaDuDvTexcoord.xy;
	#endif // UVA_SCRIPT_ENABLED

#elif defined(MULTI_UV_ENANLED)
	#ifndef UVA_SCRIPT_ENABLED
	OUT.TexCoord2.xy = (float2)IN.TexCoord2.xy;
		#ifdef MULTI_UV_TEXCOORD_OFFSET_ENABLED
	OUT.TexCoord2.xy += (float2)(TexCoordOffset2 * getGlobalTextureFactor());
		#endif // MULTI_UV_TEXCOORD_OFFSET_ENABLED
		#ifdef GAME_MATERIAL_ENABLED
	OUT.TexCoord2.xy += (float2)GameMaterialTexcoord.xy;
		#endif // GAME_MATERIAL_ENABLED
	#else // UVA_SCRIPT_ENABLED
	OUT.TexCoord2.xy = IN.TexCoord2.xy * (float2)UVaMUvTexcoord.zw + (float2)UVaMUvTexcoord.xy;
	#endif // UVA_SCRIPT_ENABLED

#endif // MULTI_UV_ENANLED

	// TexCoord3
#if defined(MULTI_UV2_ENANLED)
	#ifndef UVA_SCRIPT_ENABLED
	OUT.TexCoord3.xy = (float2)IN.TexCoord3.xy;
		#ifdef MULTI_UV2_TEXCOORD_OFFSET_ENABLED
	OUT.TexCoord3.xy += (float2)(TexCoordOffset3 * getGlobalTextureFactor());
		#endif // MULTI_UV2_TEXCOORD_OFFSET_ENABLED
	#else // UVA_SCRIPT_ENABLED
	OUT.TexCoord3.xy = IN.TexCoord3.xy * (float2)UVaMUv2Texcoord.zw + (float2)UVaMUv2Texcoord.xy;
	#endif // UVA_SCRIPT_ENABLED
#endif // defined(MULTI_UV2_ENANLED)


	// 投影影
#if defined(PROJECTION_MAP_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
	#ifndef UVA_SCRIPT_ENABLED
		#if defined(DCC_TOOL)
	OUT.ProjMap.xy = float2(worldSpacePosition.xz / (ProjectionScale * 100.0f) + ProjectionScroll * getGlobalTextureFactor());
		#else // DCC_TOOL
	OUT.ProjMap.xy = float2(worldSpacePosition.xz / ProjectionScale + ProjectionScroll * getGlobalTextureFactor());
		#endif // DCC_TOOL
	#else // UVA_SCRIPT_ENABLED
	OUT.ProjMap.xy = float2(worldSpacePosition.xz / ProjectionScale) + UVaProjTexcoord.xy;
//x	OUT.ProjMap.xy = half2(worldSpacePosition.xz / ProjectionScale) + ProjectionScroll * UVaProjTexcoord.xy;
	#endif // UVA_SCRIPT_ENABLED
#endif // 

#ifdef VERTEX_COLOR_ENABLED
	#ifdef USE_UV_ANIMATION
	OUT.Color0 = float4(IN.Color.r, IN.Color.g, IN.Color.b, IN.Color.a * AlphaGain);
	#else // USE_UV_ANIMATION
	OUT.Color0 = float4(IN.Color.r, IN.Color.g, IN.Color.b, IN.Color.a);
	#endif // USE_UV_ANIMATION
#else // VERTEX_COLOR_ENABLED
	#ifdef USE_UV_ANIMATION
	OUT.Color0 = float4(1.0f, 1.0f, 1.0f, AlphaGain);
	#else // USE_UV_ANIMATION
	OUT.Color0 = float4(1.0f, 1.0f, 1.0f, 1.0f);
	#endif // USE_UV_ANIMATION
#endif // VERTEX_COLOR_ENABLED
	OUT.Color0 = saturate(OUT.Color0);
	
//#ifdef GAME_MATERIAL_ENABLED
//	OUT.Color0 *= (half4)GameMaterialDiffuse;
//#endif // GAME_MATERIAL_ENABLED

	OUT.Color1.rgb = float3(1.0f, 1.0f, 1.0f);
#ifdef FOG_ENABLED
	OUT.Color1.a = EvaluateFogVP(viewSpacePosition);
#else // FOG_ENABLED
	OUT.Color1.a = 0.0f;
#endif // FOG_ENABLED

	// ワールド空間視線
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - worldSpacePosition);

	// VPでの光源計算が必要か
	#if ((defined(USE_LIGHTING) && !defined(USE_PER_VERTEX_LIGHTING)) || (defined(CARTOON_SHADING_ENABLED) && !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED) ) || defined(RECEIVE_SHADOWS))
		#define VP_LIGHTPROCESS
	#endif

	float3 light0dir = float3(0.0f, 0.0f, 0.0f);
	#if defined(VP_LIGHTPROCESS) && (NUM_LIGHTS > 0)
		#ifdef VP_PORTRAIT
			#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	light0dir = LightDirForChar;
			#else
	light0dir = float3(0.0f,1.0f,0.0f);	// エラー回避
			#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
		#else // VP_PORTRAIT
	light0dir = EvaluateLightDirection(Light0, OUT.WorldPositionDepth.xyz);
			#ifdef RECEIVE_SHADOWS
				#if defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
	OUT.WorldPositionDepth.xyz += light0dir * ShadowReceiveOffset + worldSpaceNormal * -0.02f;
				#else // defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
	OUT.WorldPositionDepth.xyz += light0dir * 0.02f + worldSpaceNormal * -0.01f;
				#endif // defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
			#endif // RECEIVE_SHADOWS
		#endif // VP_PORTRAIT
	#else
		light0dir = float3(0.0f,-1.0f,0.0f);
	#endif

	// 
	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	#else
		#if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
			#define VP_NDOTE_1
		#endif
	#endif
	#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
		#if defined(CUBE_MAPPING_ENABLED)

			#define VP_NDOTE_2
		#elif defined(SPHERE_MAPPING_ENABLED)
		#endif // defined(CUBE_MAPPING_ENABLED) // defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			#define VP_NDOTE_3
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(CARTOON_SHADING_ENABLED)
	#if defined(VP_NDOTE_1) || defined(VP_NDOTE_2) || defined(VP_NDOTE_3)
		float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
	#endif


#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	// Per-Pixel
	// ピクセル単位ライティング-VP

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	// Per-Vertex
	#ifdef USE_LIGHTING
	// 頂点単位ライティング-VP
	EvaluateLightingPerVertexVP(OUT.ShadingAmount.rgb, OUT.LightingAmount.rgb, OUT.Color1.rgb, light0dir, IN, worldSpacePosition, worldSpaceNormal
		#ifdef SPECULAR_ENABLED
		, worldSpaceEyeDirection	//, FresnelPower
		#endif // SPECULAR_ENABLED
		);

		#if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
			#ifdef RIM_TRANSPARENCY_ENABLED
	OUT.ShadingAmount.a = EvaluateRimLightValue(ndote);
//x	OUT.ShadingAmount.a = 1.0 - EvaluateRimLightValue(ndote);
			#else // RIM_TRANSPARENCY_ENABLED
	OUT.ShadingAmount.a = EvaluateRimLightValue(ndote);
			#endif // RIM_TRANSPARENCY_ENABLED
		#endif // defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	#endif // USE_LIGHTING

#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

	// 水面
	#if defined(USE_SCREEN_UV)
	OUT.ReflectionMap = GenerateScreenProjectedUv(OUT.Position);
	#endif // defined(USE_SCREEN_UV)

	#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
		#if defined(CUBE_MAPPING_ENABLED)
	OUT.CubeMap = float4(reflect(-worldSpaceEyeDirection, worldSpaceNormal),
						1.0f - max(0.0f, ndote) * (float)CubeFresnelPower);
		#elif defined(SPHERE_MAPPING_ENABLED)
	float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)scene_View);
	OUT.SphereMap = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
		#endif // defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	float ldotn = dot(light0dir, worldSpaceNormal);
			#ifdef CARTOON_HILIGHT_ENABLED
	float hilit_u = (1.0f - abs(ndote) * 0.667f) * max(ldotn, 0.0f);
	OUT.CartoonMap.xyz = float3(hilit_u, 0.5f, ldotn);
			#else // CARTOON_HILIGHT_ENABLED
	OUT.CartoonMap.xyz = float3(0.0f, 0.0f, ldotn);
			#endif // CARTOON_HILIGHT_ENABLED
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(CARTOON_SHADING_ENABLED)

	// シャドウマップ座標の事前計算(MAX_SPLIT_CASCADED_SHADOWMAP == 1 限定)
#ifdef PRECALC_SHADOWMAP_POSITION
	OUT.shadowPos.xyz = mul(float4(OUT.WorldPositionDepth.xyz, 1.0f), LightShadow0.m_splitTransformArray[0]).xyz;
	OUT.shadowPos.w = saturate(OUT.WorldPositionDepth.w / LightShadow0.m_splitDistances.x);
	#ifdef SHADOW_ATTENUATION_ENABLED
	OUT.shadowPos.w = pow(OUT.shadowPos.w, SHADOW_ATTENUATION_POWER);
	#endif
	#ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
	if (scene_MiscParameters2.x > 0.0f)
	{
		float shadowMinBias = min(abs(OUT.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
		shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
		OUT.shadowPos.w = min(OUT.shadowPos.w + shadowMinBias, 1.0f);
	}
	#endif
#endif // PRECALC_SHADOWMAP_POSITION

	return OUT;

	
}
#undef VP_LIGHTPROCESS
#undef VP_NDOTE_1
#undef VP_NDOTE_2
#undef VP_NDOTE_3

#line 2849 "Z:/data/shaders/ed8.fx"

// フェイスVP
//
#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED) || defined(SHINING_MODE_ENABLED)
	#undef VP_DEFAULT
	#define VP_PORTRAIT

#line 1 "Z:/data/shaders/ed8_vp_main.h"
// このファイルはUTF-8コードで保存してください。

// VP_DEFAULT
// VP_PORTRAIT
//-----------------------------------------------------------------------------
//
#ifdef VP_DEFAULT
DefaultVPOutput DefaultVPShader(DefaultVPInput IN)
#endif // VP_DEFAULT
#ifdef VP_PORTRAIT
DefaultVPOutput PortraitVPShader(DefaultVPInput IN)
#endif // VP_PORTRAIT
{
	DefaultVPOutput OUT;

	// Grab tangent
#ifdef USE_TANGENTS
	#ifdef SKINNING_ENABLED
	float3 tangent = IN.SkinnableTangent;
	#else //! SKINNING_ENABLED
	float3 tangent = IN.Tangent;
	#endif //! SKINNING_ENABLED
#endif //! USE_TANGENTS

	// Get normal
#ifdef SKINNING_ENABLED
	float3 normal = IN.SkinnableNormal;
#else //! SKINNING_ENABLED
	float3 normal = IN.Normal;
#endif //! SKINNING_ENABLED

	// Get position.
#ifdef SKINNING_ENABLED
	float3 position = IN.SkinnableVertex.xyz;
#else //! SKINNING_ENABLED
	float3 position = IN.Position.xyz;
#endif //! SKINNING_ENABLED


#ifdef SKINNING_ENABLED
	float4 skinIndices = IN.SkinIndices;
	float4 skinWeights = IN.SkinWeights;

	#ifdef USE_LIGHTING
		#if defined(USE_TANGENTS)
	EvaluateSkinPositionNormalTangentXBones(position, normal, tangent, skinWeights, skinIndices);
		#else // USE_TANGENTS
	EvaluateSkinPositionNormalXBones(position, normal, skinWeights, skinIndices);
		#endif // USE_TANGENTS
	#else // USE_LIGHTING
	EvaluateSkinPositionXBones(position, skinWeights, skinIndices);
	#endif // USE_LIGHTING

	float3 worldSpacePosition = position;
	float3 worldSpaceNormal = normalize(normal);

	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
		#ifdef USE_TANGENTS
	tangent = normalize(tangent);
		#endif // USE_TANGENTS
	#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

#else //! SKINNING_ENABLED

	float3 worldSpacePosition = mul(float4(position.xyz,1.0f), World).xyz;
	float3 worldSpaceNormal = normalize(mul(float4(normal.xyz,0.0f), World).xyz);
	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
		#ifdef USE_TANGENTS
	tangent = normalize(mul(float4(tangent.xyz,0.0f), World).xyz);
		#endif // USE_TANGENTS
	#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

#endif //! SKINNING_ENABLED


	#ifdef WINDY_GRASS_ENABLED
		#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, IN.TexCoord.y);
		#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
		#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	#endif // WINDY_GRASS_ENABLED

	OUT.Position = mul(float4(worldSpacePosition.xyz, 1.0f), scene_ViewProjection);

	OUT.WorldPositionDepth = float4(worldSpacePosition.xyz, -mul(float4(worldSpacePosition.xyz, 1.0f), scene_View).z);
	OUT.Normal = (float3)worldSpaceNormal;
	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
		#ifdef USE_TANGENTS
	OUT.Tangent = (float3)tangent;
		#endif // USE_TANGENTS
	#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

	float3 viewSpacePosition = mul(float4(worldSpacePosition.xyz, 1.0f), scene_View).xyz;

	OUT.TexCoord.xy = (float2)IN.TexCoord.xy * (float2)GameMaterialTexcoord.zw + (float2)GameMaterialTexcoord.xy;
	#ifndef UVA_SCRIPT_ENABLED
		#ifdef TEXCOORD_OFFSET_ENABLED
	OUT.TexCoord.xy += (float2)(TexCoordOffset * getGlobalTextureFactor());
		#endif // TEXCOORD_OFFSET_ENABLED
	#endif // UVA_SCRIPT_ENABLED

	// TexCoord2
#if defined(DUDV_MAPPING_ENABLED) && !defined(CARTOON_SHADING_ENABLED)

	#ifndef UVA_SCRIPT_ENABLED
	OUT.DuDvTexCoord.xy = (float2)IN.TexCoord.xy;
	OUT.DuDvTexCoord.xy += (float2)(DuDvScroll * getGlobalTextureFactor());
	#else // UVA_SCRIPT_ENABLED
	OUT.DuDvTexCoord.xy = IN.TexCoord.xy * (float2)UVaDuDvTexcoord.zw + (float2)UVaDuDvTexcoord.xy;
	#endif // UVA_SCRIPT_ENABLED

#elif defined(MULTI_UV_ENANLED)
	#ifndef UVA_SCRIPT_ENABLED
	OUT.TexCoord2.xy = (float2)IN.TexCoord2.xy;
		#ifdef MULTI_UV_TEXCOORD_OFFSET_ENABLED
	OUT.TexCoord2.xy += (float2)(TexCoordOffset2 * getGlobalTextureFactor());
		#endif // MULTI_UV_TEXCOORD_OFFSET_ENABLED
		#ifdef GAME_MATERIAL_ENABLED
	OUT.TexCoord2.xy += (float2)GameMaterialTexcoord.xy;
		#endif // GAME_MATERIAL_ENABLED
	#else // UVA_SCRIPT_ENABLED
	OUT.TexCoord2.xy = IN.TexCoord2.xy * (float2)UVaMUvTexcoord.zw + (float2)UVaMUvTexcoord.xy;
	#endif // UVA_SCRIPT_ENABLED

#endif // MULTI_UV_ENANLED

	// TexCoord3
#if defined(MULTI_UV2_ENANLED)
	#ifndef UVA_SCRIPT_ENABLED
	OUT.TexCoord3.xy = (float2)IN.TexCoord3.xy;
		#ifdef MULTI_UV2_TEXCOORD_OFFSET_ENABLED
	OUT.TexCoord3.xy += (float2)(TexCoordOffset3 * getGlobalTextureFactor());
		#endif // MULTI_UV2_TEXCOORD_OFFSET_ENABLED
	#else // UVA_SCRIPT_ENABLED
	OUT.TexCoord3.xy = IN.TexCoord3.xy * (float2)UVaMUv2Texcoord.zw + (float2)UVaMUv2Texcoord.xy;
	#endif // UVA_SCRIPT_ENABLED
#endif // defined(MULTI_UV2_ENANLED)


	// 投影影
#if defined(PROJECTION_MAP_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
	#ifndef UVA_SCRIPT_ENABLED
		#if defined(DCC_TOOL)
	OUT.ProjMap.xy = float2(worldSpacePosition.xz / (ProjectionScale * 100.0f) + ProjectionScroll * getGlobalTextureFactor());
		#else // DCC_TOOL
	OUT.ProjMap.xy = float2(worldSpacePosition.xz / ProjectionScale + ProjectionScroll * getGlobalTextureFactor());
		#endif // DCC_TOOL
	#else // UVA_SCRIPT_ENABLED
	OUT.ProjMap.xy = float2(worldSpacePosition.xz / ProjectionScale) + UVaProjTexcoord.xy;
//x	OUT.ProjMap.xy = half2(worldSpacePosition.xz / ProjectionScale) + ProjectionScroll * UVaProjTexcoord.xy;
	#endif // UVA_SCRIPT_ENABLED
#endif // 

#ifdef VERTEX_COLOR_ENABLED
	#ifdef USE_UV_ANIMATION
	OUT.Color0 = float4(IN.Color.r, IN.Color.g, IN.Color.b, IN.Color.a * AlphaGain);
	#else // USE_UV_ANIMATION
	OUT.Color0 = float4(IN.Color.r, IN.Color.g, IN.Color.b, IN.Color.a);
	#endif // USE_UV_ANIMATION
#else // VERTEX_COLOR_ENABLED
	#ifdef USE_UV_ANIMATION
	OUT.Color0 = float4(1.0f, 1.0f, 1.0f, AlphaGain);
	#else // USE_UV_ANIMATION
	OUT.Color0 = float4(1.0f, 1.0f, 1.0f, 1.0f);
	#endif // USE_UV_ANIMATION
#endif // VERTEX_COLOR_ENABLED
	OUT.Color0 = saturate(OUT.Color0);
	
//#ifdef GAME_MATERIAL_ENABLED
//	OUT.Color0 *= (half4)GameMaterialDiffuse;
//#endif // GAME_MATERIAL_ENABLED

	OUT.Color1.rgb = float3(1.0f, 1.0f, 1.0f);
#ifdef FOG_ENABLED
	OUT.Color1.a = EvaluateFogVP(viewSpacePosition);
#else // FOG_ENABLED
	OUT.Color1.a = 0.0f;
#endif // FOG_ENABLED

	// ワールド空間視線
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - worldSpacePosition);

	// VPでの光源計算が必要か
	#if ((defined(USE_LIGHTING) && !defined(USE_PER_VERTEX_LIGHTING)) || (defined(CARTOON_SHADING_ENABLED) && !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED) ) || defined(RECEIVE_SHADOWS))
		#define VP_LIGHTPROCESS
	#endif

	float3 light0dir = float3(0.0f, 0.0f, 0.0f);
	#if defined(VP_LIGHTPROCESS) && (NUM_LIGHTS > 0)
		#ifdef VP_PORTRAIT
			#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	light0dir = LightDirForChar;
			#else
	light0dir = float3(0.0f,1.0f,0.0f);	// エラー回避
			#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
		#else // VP_PORTRAIT
	light0dir = EvaluateLightDirection(Light0, OUT.WorldPositionDepth.xyz);
			#ifdef RECEIVE_SHADOWS
				#if defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
	OUT.WorldPositionDepth.xyz += light0dir * ShadowReceiveOffset + worldSpaceNormal * -0.02f;
				#else // defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
	OUT.WorldPositionDepth.xyz += light0dir * 0.02f + worldSpaceNormal * -0.01f;
				#endif // defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
			#endif // RECEIVE_SHADOWS
		#endif // VP_PORTRAIT
	#else
		light0dir = float3(0.0f,-1.0f,0.0f);
	#endif

	// 
	#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	#else
		#if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
			#define VP_NDOTE_1
		#endif
	#endif
	#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
		#if defined(CUBE_MAPPING_ENABLED)

			#define VP_NDOTE_2
		#elif defined(SPHERE_MAPPING_ENABLED)
		#endif // defined(CUBE_MAPPING_ENABLED) // defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			#define VP_NDOTE_3
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(CARTOON_SHADING_ENABLED)
	#if defined(VP_NDOTE_1) || defined(VP_NDOTE_2) || defined(VP_NDOTE_3)
		float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
	#endif


#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	// Per-Pixel
	// ピクセル単位ライティング-VP

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	// Per-Vertex
	#ifdef USE_LIGHTING
	// 頂点単位ライティング-VP
	EvaluateLightingPerVertexVP(OUT.ShadingAmount.rgb, OUT.LightingAmount.rgb, OUT.Color1.rgb, light0dir, IN, worldSpacePosition, worldSpaceNormal
		#ifdef SPECULAR_ENABLED
		, worldSpaceEyeDirection	//, FresnelPower
		#endif // SPECULAR_ENABLED
		);

		#if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
			#ifdef RIM_TRANSPARENCY_ENABLED
	OUT.ShadingAmount.a = EvaluateRimLightValue(ndote);
//x	OUT.ShadingAmount.a = 1.0 - EvaluateRimLightValue(ndote);
			#else // RIM_TRANSPARENCY_ENABLED
	OUT.ShadingAmount.a = EvaluateRimLightValue(ndote);
			#endif // RIM_TRANSPARENCY_ENABLED
		#endif // defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	#endif // USE_LIGHTING

#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

	// 水面
	#if defined(USE_SCREEN_UV)
	OUT.ReflectionMap = GenerateScreenProjectedUv(OUT.Position);
	#endif // defined(USE_SCREEN_UV)

	#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
		#if defined(CUBE_MAPPING_ENABLED)
	OUT.CubeMap = float4(reflect(-worldSpaceEyeDirection, worldSpaceNormal),
						1.0f - max(0.0f, ndote) * (float)CubeFresnelPower);
		#elif defined(SPHERE_MAPPING_ENABLED)
	float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)scene_View);
	OUT.SphereMap = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
		#endif // defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	float ldotn = dot(light0dir, worldSpaceNormal);
			#ifdef CARTOON_HILIGHT_ENABLED
	float hilit_u = (1.0f - abs(ndote) * 0.667f) * max(ldotn, 0.0f);
	OUT.CartoonMap.xyz = float3(hilit_u, 0.5f, ldotn);
			#else // CARTOON_HILIGHT_ENABLED
	OUT.CartoonMap.xyz = float3(0.0f, 0.0f, ldotn);
			#endif // CARTOON_HILIGHT_ENABLED
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // defined(CARTOON_SHADING_ENABLED)

	// シャドウマップ座標の事前計算(MAX_SPLIT_CASCADED_SHADOWMAP == 1 限定)
#ifdef PRECALC_SHADOWMAP_POSITION
	OUT.shadowPos.xyz = mul(float4(OUT.WorldPositionDepth.xyz, 1.0f), LightShadow0.m_splitTransformArray[0]).xyz;
	OUT.shadowPos.w = saturate(OUT.WorldPositionDepth.w / LightShadow0.m_splitDistances.x);
	#ifdef SHADOW_ATTENUATION_ENABLED
	OUT.shadowPos.w = pow(OUT.shadowPos.w, SHADOW_ATTENUATION_POWER);
	#endif
	#ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
	if (scene_MiscParameters2.x > 0.0f)
	{
		float shadowMinBias = min(abs(OUT.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
		shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
		OUT.shadowPos.w = min(OUT.shadowPos.w + shadowMinBias, 1.0f);
	}
	#endif
#endif // PRECALC_SHADOWMAP_POSITION

	return OUT;

	
}
#undef VP_LIGHTPROCESS
#undef VP_NDOTE_1
#undef VP_NDOTE_2
#undef VP_NDOTE_3

#line 2857 "Z:/data/shaders/ed8.fx"
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
// 通常FP
//
#define FP_DEFAULT
#undef FP_DEFAULTRT
#undef FP_FORCETRANSPARENT
#undef FP_PORTRAIT
#undef FP_SHINING

#line 1 "Z:/data/shaders/ed8_fp_main.h"
// このファイルはUTF-8コードで保存してください。

// FP_DEFAULT
// FP_DEFAULTRT
// FP_FORCETRANSPARENT
// FP_PORTRAIT
//-----------------------------------------------------------------------------
//

// ALPHA trSSAA
#ifdef ALPHA_TESTING_ENABLED
#define _FPINPUT DefaultFPInput IN, uint s_index : SV_SampleIndex
#else 
#define _FPINPUT DefaultFPInput IN
#endif ALPHA_TESTING_ENABLED

#ifdef FP_DEFAULT
float4 DefaultFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULT
#ifdef FP_DEFAULTRT
float4 DefaultFPShaderRT(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULTRT
#ifdef FP_FORCETRANSPARENT
float4 ForceTransparentFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_FORCETRANSPARENT
#ifdef FP_PORTRAIT
float4 PortraitFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_PORTRAIT
#ifdef FP_SHINING
float4 ShiningFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_SHINING
{
#ifdef NOTHING_ENABLED
	float4 resultColor = IN.Color0;
	#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT)
	return resultColor;
	#endif // FP_FORCETRANSPARENT
	#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
		#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
	return float4(resultColor.rgb, 0.0f);
		#else // !defined(ALPHA_BLENDING_ENABLED)
	return resultColor;
		#endif // !defined(ALPHA_BLENDING_ENABLED)
	#endif // FP_DEFAULT || FP_DEFAULTRT
#else // NOTHING_ENABLED

#ifdef FP_DEFAULTRT
	// 水面下をクリップ - (Z軸回転がないとか条件をつければ oblique frustum clippingのような射影行列を加工する手法がある)
	float3 waterNorm = float3(IN.WorldPositionDepth.x, IN.WorldPositionDepth.y - UserClipPlane.w, IN.WorldPositionDepth.z);
	clip(dot(UserClipPlane.xyz, normalize(waterNorm)));
#endif // FP_DEFAULTRT

#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvValue = (DuDvMapSampler.SampleLevel(DuDvMapSamplerS, IN.DuDvTexCoord.xy, 0).xy * 2.0f - 1.0f) * (DuDvScale / DuDvMapImageSize);
#endif // DUDV_MAPPING_ENABLED

	float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);
#ifdef ALPHA_TESTING_ENABLED
	static const float2 vMSAAOffsets[9][8] = {  
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.25, 0.25), float2(-0.25, -0.25), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(-0.125, -0.375), float2(0.375, -0.125), float2(-0.375,  0.125), float2(0.125,  0.375), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(0.0625, -0.1875), float2(-0.0625,  0.1875), float2(0.3125,  0.0625), float2(-0.1875, -0.3125), float2(-0.3125,  0.3125), float2(-0.4375, -0.0625), float2(0.1875,  0.4375), float2(0.4375, -0.4375), },
	};
	if(DuranteSettings.x & 1) {
		const float2 vDDX = ddx(IN.TexCoord.xy);
		const float2 vDDY = ddy(IN.TexCoord.xy);
		float2 vTexOffset = vMSAAOffsets[DuranteSettings.y][s_index].x * vDDX + (vMSAAOffsets[DuranteSettings.y][s_index].y * vDDY);
		IN.TexCoord.xy += vTexOffset;
	}
#endif ALPHA_TESTING_ENABLED
	float4 materialDiffuse = (float4)GameMaterialDiffuse;

#ifndef DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
	#if defined(DUDV_MAPPING_ENABLED)
		+ dudvValue
	#endif // DUDV_MAPPING_ENABLED
		);
#else // DIFFUSEMAP_CHANGING_ENABLED

	#ifdef DCC_TOOL
	float diffuseTxRatio = (float)DiffuseMapTransRatio;
	#else // DCC_TOOL
		#ifdef GAME_MATERIAL_ENABLED
	float diffuseTxRatio = (float)materialDiffuse.a - 1.0f;
		#else // GAME_MATERIAL_ENABLED
	float diffuseTxRatio = 1.0f;
		#endif // GAME_MATERIAL_ENABLED
	#endif // DCC_TOOL

	materialDiffuse.a = min(1.0f, materialDiffuse.a);

	if (diffuseTxRatio < 1.0f)
	{
		float t = max(0.0f, diffuseTxRatio);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx0, diffuseTx1, t);
	}
	else if (diffuseTxRatio < 2.0f)
	{
		float t = diffuseTxRatio - 1.0f;
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx1, diffuseTx2, t);
	}
	else // if (diffuseTxRatio < 3.0)
	{
		float t = (min(3.0f, diffuseTxRatio) - 2.0f);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx2, diffuseTx0, t);
	}
#endif // DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt.a *= (float)IN.Color0.a;

#if !defined(DCC_TOOL)
	#if defined(USE_SCREEN_UV)
	float4 dudvTex = IN.ReflectionMap;
		#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvAmt = dudvValue * float2(ScreenWidth/DuDvMapImageSize.x, ScreenHeight/DuDvMapImageSize.y);
	dudvTex.xy += dudvAmt;
			#define FP_DUDV_AMT_EXIST
		#endif // DUDV_MAPPING_ENABLED

		#if defined(WATER_SURFACE_ENABLED)
			float4 reflColor = ReflectionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;
		#endif // defined(WATER_SURFACE_ENABLED)

	float4 refrColor = RefractionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;


	#endif // defined(USE_SCREEN_UV)
#endif // defined(DCC_TOOL)

	// アルファテスト
#ifdef FP_FORCETRANSPARENT
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
		#else
	clip(diffuseAmt.a - 0.004f);
		#endif
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_FORCETRANSPARENT
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	float alphaAmt = diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a;
	clip((alphaAmt > 0.0f) ? (alphaAmt * AlphaTestDirection) : (-1.0f/255.0f));
		#else // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
			#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
			#else
	clip(diffuseAmt.a - 0.004f);
			#endif
		#endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_DEFAULT || FP_DEFAULTRT || FP_PORTRAIT

	// マルチUV
#ifdef MULTI_UV_ENANLED
	#if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse2Amt = DiffuseMap2Sampler.Sample(DiffuseMap2SamplerS, IN.TexCoord2.xy);
		#ifdef UVA_SCRIPT_ENABLED
	diffuse2Amt *= (float4)UVaMUvColor;
		#endif // UVA_SCRIPT_ENABLED

		#if defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)diffuse2Amt.a;
		#else // defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)IN.Color0.a * diffuse2Amt.a;
		#endif // defined(MULTI_UV_FACE_ENANLED)

		#if defined(MULTI_UV_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add = diffuse2Amt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv_alpha);
	float3 muvtex_add = (diffuse2Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
		#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
		#endif //

	#else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	float multi_uv_alpha = (float)IN.Color0.a;

	#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	#ifdef MULTI_UV2_ENANLED 
		#if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse3Amt = DiffuseMap3Sampler.Sample(DiffuseMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)diffuse3Amt.a;
			#else // defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)IN.Color0.a * diffuse3Amt.a;
			#endif // defined(MULTI_UV_FACE_ENANLED)

			#if defined(MULTI_UV2_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add2 = diffuse3Amt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv2_alpha);
	float3 muvtex_add2 = (diffuse3Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
			#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
			#endif //
//		#else // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
//	float multi_uv2_alpha = IN.Color0.a;
		#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	#endif // MULTI_UV2_ENANLED

#endif // MULTI_UV_ENANLED

#ifdef GAME_MATERIAL_ENABLED
	diffuseAmt *= materialDiffuse;
#endif // GAME_MATERIAL_ENABLED

	// シャドウマップ
#if defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
	// 複数ライトのときはどれがディレクショナルかはシステムしだい
	// 2012/08/30 現在は追加のライトは自前。
	float shadowValue = 1.0f;
//	#if NUM_LIGHTS > 2
//	shadowValue = min(shadowValue, EvaluateShadow(Light2, LightShadow2, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
//	#if NUM_LIGHTS > 1
//	shadowValue = min(shadowValue, EvaluateShadow(Light1, LightShadow1, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
	#if NUM_LIGHTS > 0
		#ifdef PRECALC_SHADOWMAP_POSITION
			if (IN.shadowPos.w < 1.0f)
			{
				float shadowMin = SampleOrthographicShadowMap(IN.shadowPos.xyz, LightShadowMap0, DuranteSettings.x, 1.f);
			#ifdef SHADOW_ATTENUATION_ENABLED
				shadowMin = (float)min(shadowMin + IN.shadowPos.w, 1.0f);
			#endif
				shadowValue = min(shadowValue, shadowMin);
			}
		#else // PRECALC_SHADOWMAP_POSITION
			#if defined(DUDV_MAPPING_ENABLED)
	float3 dudv0 = float3(dudvValue.x, dudvValue.y, 0.0f);
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz + dudv0, IN.WorldPositionDepth.w, DuranteSettings.x));
			#else // DUDV_MAPPING_ENABLED
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w, DuranteSettings.x));
			#endif // DUDV_MAPPING_ENABLED
			#ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
	if (scene_MiscParameters2.x > 0.0f)
	{
		float shadowMinBias = min(abs(IN.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
		shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
		shadowMin = min(shadowMin + shadowMinBias, 1.0f);
	}
			#endif
	shadowValue = min(shadowValue, shadowMin);
		#endif // PRECALC_SHADOWMAP_POSITION

	#endif
	#ifdef FP_DUDV_AMT_EXIST
	shadowValue = (shadowValue + 1.0f) * 0.5f;
	#endif

#else // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)
	float shadowValue = 1.0f;
#endif // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)

#ifdef MULTI_UV_ENANLED 
	#if defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse2Amt.r * multi_uv_alpha));
	#endif //
	#if defined(MULTI_UV2_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse3Amt.r * multi_uv2_alpha));
	#endif //
#endif // MULTI_UV_ENANLED

#if defined(PROJECTION_MAP_ENABLED)
	float4 projTex = ProjectionMapSampler.Sample(ProjectionMapSamplerS, IN.ProjMap.xy);
	// 雲の影
//	shadowValue = max(shadowValue - (1 - (projTex.r * projTex.a)), 0);
	shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
#endif // PROJECTION_MAP_ENABLED

	// スペキュラマップ
#if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
 
	float glossValue = 1.0f;
	#ifdef SPECULAR_MAPPING_ENABLED
	glossValue = SpecularMapSampler.Sample(SpecularMapSamplerS, IN.TexCoord.xy).x;
	#endif // SPECULAR_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
	float glossValue2 = SpecularMap2Sampler.Sample(SpecularMap2SamplerS, IN.TexCoord2.xy).x;
	glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
		#endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
		#if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
	float glossValue3 = SpecularMap3Sampler.Sample(SpecularMap3SamplerS, IN.TexCoord3.xy).x;
	glossValue = lerp(glossValue, glossValue3, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // 
#else // SPECULAR_MAPPING_ENABLED
	float glossValue = 1.0f;
#endif // SPECULAR_MAPPING_ENABLED

	// 環境光遮蔽マップ
#if defined(OCCULUSION_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV_OCCULUSION2_MAPPING_ENABLED))

	float occulusionValue = 1.0f;
	#ifdef OCCULUSION_MAPPING_ENABLED
	occulusionValue = OcculusionMapSampler.Sample(OcculusionMapSamplerS, IN.TexCoord.xy).x;
	#endif // OCCULUSION_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue2 = OcculusionMap2Sampler.Sample(OcculusionMap2SamplerS, IN.TexCoord2.xy);
			#if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	multi_uv_alpha = occulusionValue2.a;
			#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		#endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
		#if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue3 = OcculusionMap3Sampler.Sample(OcculusionMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float multi_uv2_alpha = occulusionValue3.a;
			#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // defined(MULTI_UV_ENANLED)

	float3 ambientOcclusion = (float3)IN.Color0.rgb * occulusionValue;
#else // OCCULUSION_MAPPING_ENABLED
	float3 ambientOcclusion = (float3)IN.Color0.rgb;
#endif // OCCULUSION_MAPPING_ENABLED

	// インチキライトへの影やスペキュラマップの影響
#if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	#if (NUM_LIGHTS > 0) && defined(USE_LIGHTING)
		#ifdef FP_PORTRAIT
	float3 subLightColor = PortraitLightColor;
		#else // FP_PORTRAIT
	float3 subLightColor = Light0.m_colorIntensity;
		#endif // FP_PORTRAIT
	#else
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	#endif
	#if defined(SPECULAR_MAPPING_ENABLED)
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (glossValue + shadowValue + 1.0f) * (1.0f/3.0f);
		#endif
	#else
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (shadowValue + 1.0f) * 0.5f;
		#endif
	#endif

#else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
#endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	// キューブマップ/スフィアマップ-PerVertex
#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	#if defined(CUBE_MAPPING_ENABLED)
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(IN.CubeMap.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(IN.CubeMap.xyz)).rgba; //TODO : check
	float cubeMapIntensity = IN.CubeMap.w;
	#elif defined(SPHERE_MAPPING_ENABLED)
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, IN.SphereMap.xy).rgba;
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
#else // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)


	// ライティング
	float4 resultColor = diffuseAmt;
	float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);

 	float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	// [PerPixel]

	float3 worldSpaceNormal = EvaluateNormalFP(IN);

	#if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	worldSpaceNormal = normalize(lerp(worldSpaceNormal, EvaluateNormal2FP(IN), multi_uv_alpha));
	#endif //

	float3 ambient = float3(0.0f, 0.0f, 0.0f);
	#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
	#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
		#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
			#define FP_NEED_AFTER_MAX_AMBIENT
		#else // NO_MAIN_LIGHT_SHADING_ENABLED
			#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
			#else // FP_PORTRAIT
	ambient = EvaluateAmbient(worldSpaceNormal);
			#endif // FP_PORTRAIT
		#endif // NO_MAIN_LIGHT_SHADING_ENABLED
	#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	#define FP_WS_EYEDIR_EXIST

	// リムライトや環境マップの準備
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#define FP_NDOTE_1
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		#if defined(CUBE_MAPPING_ENABLED)
			#define FP_NDOTE_2
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
	#if defined(FP_NDOTE_1) || defined(FP_NDOTE_2) || defined(FP_SHINING)
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

	#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
	#endif // DOUBLE_SIDED

	#endif // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

	// リムライト
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= 1.0f - EvaluateRimLightValue(ndote);
			#else // RIM_TRANSPARENCY_ENABLED
	float rimLightvalue = EvaluateRimLightValue(ndote);
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
			#endif // RIM_TRANSPARENCY_ENABLED
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)

	// 環境マップ
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		// キューブマップ/スフィアマップ-PerPixel
		#if defined(CUBE_MAPPING_ENABLED)
	float3 cubeMapParams = reflect(-worldSpaceEyeDirection, worldSpaceNormal);
	float cubeMapIntensity = 1.0f - max(0.0f, ndote) * (float)CubeFresnelPower;
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(cubeMapParams.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(cubeMapParams.xyz)).rgba;
		#elif defined(SPHERE_MAPPING_ENABLED)
	float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)scene_View);
	float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, sphereMapParams.xy).rgba;
		#else
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
	shadingAmt = (1.0f - float3(ndote,ndote,ndote)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );
//	shadingAmt = (1 - half3(ndote)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote)) * Light0.m_colorIntensity;
	resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#elif defined(FP_PORTRAIT)
	shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#else // FP_PORTRAIT
	shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, IN, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#endif // FP_PORTRAIT

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	// [PerVertex]

	#ifdef USE_LIGHTING
		#ifdef PRECALC_EVALUATE_AMBIENT
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
		#else
	float3 subLight = IN.Color1.rgb;
		#endif
	float3 diffuse = IN.ShadingAmount.rgb;
	float3 specular = IN.LightingAmount.rgb;
	#else // USE_LIGHTING
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
	float3 diffuse = float3(1.0f, 1.0f, 1.0f);
	float3 specular = float3(0.0f, 0.0f, 0.0f);
	#endif // USE_LIGHTING

	float3 ambient = float3(0.0f, 0.0f, 0.0f);;

	// リムライト
	#if defined(USE_LIGHTING)

	float3 worldSpaceNormal = normalize(IN.Normal);
		#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
		#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
			#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
				#define FP_NEED_AFTER_MAX_AMBIENT
			#else // NO_MAIN_LIGHT_SHADING_ENABLED
				#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
				#else // FP_PORTRAIT
					#ifdef PRECALC_EVALUATE_AMBIENT
	ambient = IN.Color1.rgb;
					#else
	ambient = EvaluateAmbient(worldSpaceNormal);
					#endif
				#endif // FP_PORTRAIT
			#endif // NO_MAIN_LIGHT_SHADING_ENABLED
		#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

		#ifdef RIM_LIGHTING_ENABLED
			#if defined(USE_FORCE_VERTEX_RIM_LIGHTING)

	float rimLightvalue = IN.ShadingAmount.a;
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED

			#else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);

				#define FP_WS_EYEDIR_EXIST
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

				#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
				#endif // DOUBLE_SIDED

	float rimLightvalue = EvaluateRimLightValue(ndote);
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED
			#endif // defined(USE_FORCE_VERTEX_RIM_LIGHTING)

		#endif // RIM_LIGHTING_ENABLED
	#else
	ambient = float3(0.0f, 0.0f, 0.0f);
	#endif // defined(USE_LIGHTING)

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
		#if !defined(USE_LIGHTING)
	float3 worldSpaceNormal = normalize(IN.Normal);
		#endif
	float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);
		#if !defined(USE_LIGHTING)
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;//最適化できる
		#else
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );//最適化できる
//	shadingAmt = (1 - half3(ndote2)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote2)) * Light0.m_colorIntensity;
		#endif
//	resultColor.rgb = dot(resultColor.rgb, half3(0.299, 0.587, 0.114));
	#else
	shadingAmt = EvaluateLightingPerVertexFP(IN, IN.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	#endif

#endif // !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)

#ifdef CUSTOM_DIFFUSE_ENABLED
	float grayscale = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#if NUM_LIGHTS > 0
		#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
			#ifdef FP_PORTRAIT
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
			#else // FP_PORTRAIT
	float ldotn = (float)dot(Light0.m_direction, worldSpaceNormal);
			#endif // FP_PORTRAIT
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	#else
	resultColor.rgb = float3(grayscale, grayscale, grayscale);
	#endif
#endif // CUSTOM_DIFFUSE_ENABLED

#ifdef FP_NEED_AFTER_MAX_AMBIENT
	#ifdef FP_PORTRAIT
	shadingAmt = max(shadingAmt, PortraitEvaluateAmbient(worldSpaceNormal));
	#else // FP_PORTRAIT
		#if defined(USE_PER_VERTEX_LIGHTING) && defined(PRECALC_EVALUATE_AMBIENT)
	shadingAmt = max(shadingAmt, IN.Color1.rgb);
		#else
	shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
		#endif
	#endif // FP_PORTRAIT
#endif

#ifdef GAME_MATERIAL_ENABLED
	shadingAmt += (float3)GameMaterialEmission;
#endif

#if !defined(DCC_TOOL)
	#if defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
		#if defined(WATER_SURFACE_ENABLED)
			#ifndef FP_WS_EYEDIR_EXIST
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
			#endif // FP_WS_EYEDIR_EXIST
	float water_ndote = dot(UserClipPlane.xyz, worldSpaceEyeDirection);
	float waterAlpha = pow(1.0f - abs(water_ndote), 4.0f);
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a) + reflColor.rgb * waterAlpha * ReflectionIntensity;
	float waterGlowValue = reflColor.a + refrColor.a;
		#else // defined(WATER_SURFACE_ENABLED)
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
		#endif // defined(WATER_SURFACE_ENABLED)
	#endif // defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
#endif // defined(DCC_TOOL)

	// トゥーン・ハイライト-適用
	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			#ifdef CARTOON_HILIGHT_ENABLED
	float hilightValue = HighlightMapSampler.Sample(HighlightMapSamplerS, IN.CartoonMap.xy).r;
	float3 hilightAmt = hilightValue * HighlightIntensity * HighlightColor * subLightColor;
				#define FP_HAS_HILIGHT
			#endif // CARTOON_HILIGHT_ENABLED
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // CARTOON_SHADING_ENABLED
	#ifdef FP_HAS_HILIGHT
	sublightAmount += hilightAmt;
	#endif // FP_HAS_HILIGHT

	// 影カラーシフト
#if defined(SHADOW_COLOR_SHIFT_ENABLED)
	// [Not Toon] 表面下散乱のような使い方
	float3 subLightColor2 = max(float3(1.0f,1.0f,1.0f), subLightColor * 2.0f);
	shadingAmt.rgb += (float3(1.0f,1.0f,1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * ShadowColorShift * subLightColor2;
#endif // SHADOW_COLOR_SHIFT_ENABLED

	#if defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 envMapColor = ambientOcclusion;
	#else // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	float3 envMapColor = float3(1.0f, 1.0f, 1.0f);
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

	// キューブマップ/スフィアマップ-適用 (非IBL)
#ifdef EMVMAP_AS_IBL_ENABLED
	// キューブマップ/スフィアマップ-適用 (IBL)
	#if defined(CUBE_MAPPING_ENABLED)
	shadingAmt.rgb	+= cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	shadingAmt.rgb	+= sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#else // EMVMAP_AS_IBL_ENABLED
	#if defined(CUBE_MAPPING_ENABLED)
	resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	resultColor.rgb += sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#endif // EMVMAP_AS_IBL_ENABLED

	shadingAmt *= ambientOcclusion;
	shadingAmt += sublightAmount;

	// 自己発光度マップ ライトやシャドウを打ち消す値という解釈
#if defined(EMISSION_MAPPING_ENABLED)
	float4 emiTex = EmissionMapSampler.Sample(EmissionMapSamplerS, IN.TexCoord.xy);
	shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r,emiTex.r,emiTex.r));
#endif // EMISSION_MAPPING_ENABLED

	// ライトの合計
	resultColor.rgb *= shadingAmt;

#if defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
#endif

	// フォグ
	//
#ifdef FOG_ENABLED
	#if !defined(FP_PORTRAIT)
		#ifdef DCC_TOOL
	EvaluateFogFP(resultColor.rgb, FogColor.rgb, IN.Color1.a);
		#else // DCC_TOOL
	EvaluateFogFP(resultColor.rgb, scene_FogColor.rgb, IN.Color1.a);
		#endif // DCC_TOOL
	#endif // !defined(FP_PORTRAIT)
#endif // FOG_ENABLED


	#if defined(SUBTRACT_BLENDING_ENABLED)
	resultColor.rgb = resultColor.rgb * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#endif


	// 出力
#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
	return resultColor;
#endif // defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
	#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
//		#if defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
		#if defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	float glowValue = 0.0f;

			#if defined(GLARE_MAP_ENABLED)
	glowValue += GlareMapSampler.Sample(GlareMapSamplerS, IN.TexCoord.xy).x;
			#endif
			#if defined(GLARE_HIGHTPASS_ENABLED)
	float lumi = dot(resultColor.rgb, float3(1.0f,1.0f,1.0f));
	glowValue += max(lumi - 1.0f, 0.0f);
//	glowValue += (lumi > GlowThreshold) ? 1.0h : 0.0h;
			#endif
			#if defined(GLARE_OVERFLOW_ENABLED)
	float3 glowof = max(float3(0.0f, 0.0f, 0.0f), resultColor.rgb - GlowThreshold); //GlowThreshold float3に?
	glowValue += dot(glowof, 1.0f);
			#endif

			#if defined(WATER_SURFACE_ENABLED)
	glowValue += waterGlowValue;
	return float4(resultColor.rgb, glowValue * GlareIntensity);
			#else 
	return float4(resultColor.rgb, glowValue * GlareIntensity * resultColor.a);
			#endif
		#else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#else // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)

	return float4(resultColor.rgb, 0.0f);

		#endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#endif // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	#else // !defined(ALPHA_BLENDING_ENABLED)
	// Mayaではアルファを他の用途で使うとスウォッチの色が変になる
	return resultColor;
	#endif // !defined(ALPHA_BLENDING_ENABLED)
#endif // FP_DEFAULT || FP_DEFAULTRT

#endif // NOTHING_ENABLED

}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2

#line 2870 "Z:/data/shaders/ed8.fx"

// 強制透過FP
//
#undef FP_DEFAULT
#undef FP_DEFAULTRT
#define FP_FORCETRANSPARENT
#undef FP_PORTRAIT
#undef FP_SHINING

#line 1 "Z:/data/shaders/ed8_fp_main.h"
// このファイルはUTF-8コードで保存してください。

// FP_DEFAULT
// FP_DEFAULTRT
// FP_FORCETRANSPARENT
// FP_PORTRAIT
//-----------------------------------------------------------------------------
//

// ALPHA trSSAA
#ifdef ALPHA_TESTING_ENABLED
#define _FPINPUT DefaultFPInput IN, uint s_index : SV_SampleIndex
#else 
#define _FPINPUT DefaultFPInput IN
#endif ALPHA_TESTING_ENABLED

#ifdef FP_DEFAULT
float4 DefaultFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULT
#ifdef FP_DEFAULTRT
float4 DefaultFPShaderRT(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULTRT
#ifdef FP_FORCETRANSPARENT
float4 ForceTransparentFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_FORCETRANSPARENT
#ifdef FP_PORTRAIT
float4 PortraitFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_PORTRAIT
#ifdef FP_SHINING
float4 ShiningFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_SHINING
{
#ifdef NOTHING_ENABLED
	float4 resultColor = IN.Color0;
	#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT)
	return resultColor;
	#endif // FP_FORCETRANSPARENT
	#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
		#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
	return float4(resultColor.rgb, 0.0f);
		#else // !defined(ALPHA_BLENDING_ENABLED)
	return resultColor;
		#endif // !defined(ALPHA_BLENDING_ENABLED)
	#endif // FP_DEFAULT || FP_DEFAULTRT
#else // NOTHING_ENABLED

#ifdef FP_DEFAULTRT
	// 水面下をクリップ - (Z軸回転がないとか条件をつければ oblique frustum clippingのような射影行列を加工する手法がある)
	float3 waterNorm = float3(IN.WorldPositionDepth.x, IN.WorldPositionDepth.y - UserClipPlane.w, IN.WorldPositionDepth.z);
	clip(dot(UserClipPlane.xyz, normalize(waterNorm)));
#endif // FP_DEFAULTRT

#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvValue = (DuDvMapSampler.SampleLevel(DuDvMapSamplerS, IN.DuDvTexCoord.xy, 0).xy * 2.0f - 1.0f) * (DuDvScale / DuDvMapImageSize);
#endif // DUDV_MAPPING_ENABLED

	float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);
#ifdef ALPHA_TESTING_ENABLED
	static const float2 vMSAAOffsets[9][8] = {  
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.25, 0.25), float2(-0.25, -0.25), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(-0.125, -0.375), float2(0.375, -0.125), float2(-0.375,  0.125), float2(0.125,  0.375), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(0.0625, -0.1875), float2(-0.0625,  0.1875), float2(0.3125,  0.0625), float2(-0.1875, -0.3125), float2(-0.3125,  0.3125), float2(-0.4375, -0.0625), float2(0.1875,  0.4375), float2(0.4375, -0.4375), },
	};
	if(DuranteSettings.x & 1) {
		const float2 vDDX = ddx(IN.TexCoord.xy);
		const float2 vDDY = ddy(IN.TexCoord.xy);
		float2 vTexOffset = vMSAAOffsets[DuranteSettings.y][s_index].x * vDDX + (vMSAAOffsets[DuranteSettings.y][s_index].y * vDDY);
		IN.TexCoord.xy += vTexOffset;
	}
#endif ALPHA_TESTING_ENABLED
	float4 materialDiffuse = (float4)GameMaterialDiffuse;

#ifndef DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
	#if defined(DUDV_MAPPING_ENABLED)
		+ dudvValue
	#endif // DUDV_MAPPING_ENABLED
		);
#else // DIFFUSEMAP_CHANGING_ENABLED

	#ifdef DCC_TOOL
	float diffuseTxRatio = (float)DiffuseMapTransRatio;
	#else // DCC_TOOL
		#ifdef GAME_MATERIAL_ENABLED
	float diffuseTxRatio = (float)materialDiffuse.a - 1.0f;
		#else // GAME_MATERIAL_ENABLED
	float diffuseTxRatio = 1.0f;
		#endif // GAME_MATERIAL_ENABLED
	#endif // DCC_TOOL

	materialDiffuse.a = min(1.0f, materialDiffuse.a);

	if (diffuseTxRatio < 1.0f)
	{
		float t = max(0.0f, diffuseTxRatio);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx0, diffuseTx1, t);
	}
	else if (diffuseTxRatio < 2.0f)
	{
		float t = diffuseTxRatio - 1.0f;
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx1, diffuseTx2, t);
	}
	else // if (diffuseTxRatio < 3.0)
	{
		float t = (min(3.0f, diffuseTxRatio) - 2.0f);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx2, diffuseTx0, t);
	}
#endif // DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt.a *= (float)IN.Color0.a;

#if !defined(DCC_TOOL)
	#if defined(USE_SCREEN_UV)
	float4 dudvTex = IN.ReflectionMap;
		#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvAmt = dudvValue * float2(ScreenWidth/DuDvMapImageSize.x, ScreenHeight/DuDvMapImageSize.y);
	dudvTex.xy += dudvAmt;
			#define FP_DUDV_AMT_EXIST
		#endif // DUDV_MAPPING_ENABLED

		#if defined(WATER_SURFACE_ENABLED)
			float4 reflColor = ReflectionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;
		#endif // defined(WATER_SURFACE_ENABLED)

	float4 refrColor = RefractionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;


	#endif // defined(USE_SCREEN_UV)
#endif // defined(DCC_TOOL)

	// アルファテスト
#ifdef FP_FORCETRANSPARENT
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
		#else
	clip(diffuseAmt.a - 0.004f);
		#endif
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_FORCETRANSPARENT
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	float alphaAmt = diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a;
	clip((alphaAmt > 0.0f) ? (alphaAmt * AlphaTestDirection) : (-1.0f/255.0f));
		#else // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
			#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
			#else
	clip(diffuseAmt.a - 0.004f);
			#endif
		#endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_DEFAULT || FP_DEFAULTRT || FP_PORTRAIT

	// マルチUV
#ifdef MULTI_UV_ENANLED
	#if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse2Amt = DiffuseMap2Sampler.Sample(DiffuseMap2SamplerS, IN.TexCoord2.xy);
		#ifdef UVA_SCRIPT_ENABLED
	diffuse2Amt *= (float4)UVaMUvColor;
		#endif // UVA_SCRIPT_ENABLED

		#if defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)diffuse2Amt.a;
		#else // defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)IN.Color0.a * diffuse2Amt.a;
		#endif // defined(MULTI_UV_FACE_ENANLED)

		#if defined(MULTI_UV_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add = diffuse2Amt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv_alpha);
	float3 muvtex_add = (diffuse2Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
		#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
		#endif //

	#else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	float multi_uv_alpha = (float)IN.Color0.a;

	#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	#ifdef MULTI_UV2_ENANLED 
		#if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse3Amt = DiffuseMap3Sampler.Sample(DiffuseMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)diffuse3Amt.a;
			#else // defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)IN.Color0.a * diffuse3Amt.a;
			#endif // defined(MULTI_UV_FACE_ENANLED)

			#if defined(MULTI_UV2_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add2 = diffuse3Amt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv2_alpha);
	float3 muvtex_add2 = (diffuse3Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
			#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
			#endif //
//		#else // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
//	float multi_uv2_alpha = IN.Color0.a;
		#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	#endif // MULTI_UV2_ENANLED

#endif // MULTI_UV_ENANLED

#ifdef GAME_MATERIAL_ENABLED
	diffuseAmt *= materialDiffuse;
#endif // GAME_MATERIAL_ENABLED

	// シャドウマップ
#if defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
	// 複数ライトのときはどれがディレクショナルかはシステムしだい
	// 2012/08/30 現在は追加のライトは自前。
	float shadowValue = 1.0f;
//	#if NUM_LIGHTS > 2
//	shadowValue = min(shadowValue, EvaluateShadow(Light2, LightShadow2, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
//	#if NUM_LIGHTS > 1
//	shadowValue = min(shadowValue, EvaluateShadow(Light1, LightShadow1, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
	#if NUM_LIGHTS > 0
		#ifdef PRECALC_SHADOWMAP_POSITION
			if (IN.shadowPos.w < 1.0f)
			{
				float shadowMin = SampleOrthographicShadowMap(IN.shadowPos.xyz, LightShadowMap0, DuranteSettings.x, 1.f);
			#ifdef SHADOW_ATTENUATION_ENABLED
				shadowMin = (float)min(shadowMin + IN.shadowPos.w, 1.0f);
			#endif
				shadowValue = min(shadowValue, shadowMin);
			}
		#else // PRECALC_SHADOWMAP_POSITION
			#if defined(DUDV_MAPPING_ENABLED)
	float3 dudv0 = float3(dudvValue.x, dudvValue.y, 0.0f);
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz + dudv0, IN.WorldPositionDepth.w, DuranteSettings.x));
			#else // DUDV_MAPPING_ENABLED
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w, DuranteSettings.x));
			#endif // DUDV_MAPPING_ENABLED
			#ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
	if (scene_MiscParameters2.x > 0.0f)
	{
		float shadowMinBias = min(abs(IN.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
		shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
		shadowMin = min(shadowMin + shadowMinBias, 1.0f);
	}
			#endif
	shadowValue = min(shadowValue, shadowMin);
		#endif // PRECALC_SHADOWMAP_POSITION

	#endif
	#ifdef FP_DUDV_AMT_EXIST
	shadowValue = (shadowValue + 1.0f) * 0.5f;
	#endif

#else // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)
	float shadowValue = 1.0f;
#endif // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)

#ifdef MULTI_UV_ENANLED 
	#if defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse2Amt.r * multi_uv_alpha));
	#endif //
	#if defined(MULTI_UV2_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse3Amt.r * multi_uv2_alpha));
	#endif //
#endif // MULTI_UV_ENANLED

#if defined(PROJECTION_MAP_ENABLED)
	float4 projTex = ProjectionMapSampler.Sample(ProjectionMapSamplerS, IN.ProjMap.xy);
	// 雲の影
//	shadowValue = max(shadowValue - (1 - (projTex.r * projTex.a)), 0);
	shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
#endif // PROJECTION_MAP_ENABLED

	// スペキュラマップ
#if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
 
	float glossValue = 1.0f;
	#ifdef SPECULAR_MAPPING_ENABLED
	glossValue = SpecularMapSampler.Sample(SpecularMapSamplerS, IN.TexCoord.xy).x;
	#endif // SPECULAR_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
	float glossValue2 = SpecularMap2Sampler.Sample(SpecularMap2SamplerS, IN.TexCoord2.xy).x;
	glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
		#endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
		#if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
	float glossValue3 = SpecularMap3Sampler.Sample(SpecularMap3SamplerS, IN.TexCoord3.xy).x;
	glossValue = lerp(glossValue, glossValue3, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // 
#else // SPECULAR_MAPPING_ENABLED
	float glossValue = 1.0f;
#endif // SPECULAR_MAPPING_ENABLED

	// 環境光遮蔽マップ
#if defined(OCCULUSION_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV_OCCULUSION2_MAPPING_ENABLED))

	float occulusionValue = 1.0f;
	#ifdef OCCULUSION_MAPPING_ENABLED
	occulusionValue = OcculusionMapSampler.Sample(OcculusionMapSamplerS, IN.TexCoord.xy).x;
	#endif // OCCULUSION_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue2 = OcculusionMap2Sampler.Sample(OcculusionMap2SamplerS, IN.TexCoord2.xy);
			#if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	multi_uv_alpha = occulusionValue2.a;
			#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		#endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
		#if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue3 = OcculusionMap3Sampler.Sample(OcculusionMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float multi_uv2_alpha = occulusionValue3.a;
			#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // defined(MULTI_UV_ENANLED)

	float3 ambientOcclusion = (float3)IN.Color0.rgb * occulusionValue;
#else // OCCULUSION_MAPPING_ENABLED
	float3 ambientOcclusion = (float3)IN.Color0.rgb;
#endif // OCCULUSION_MAPPING_ENABLED

	// インチキライトへの影やスペキュラマップの影響
#if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	#if (NUM_LIGHTS > 0) && defined(USE_LIGHTING)
		#ifdef FP_PORTRAIT
	float3 subLightColor = PortraitLightColor;
		#else // FP_PORTRAIT
	float3 subLightColor = Light0.m_colorIntensity;
		#endif // FP_PORTRAIT
	#else
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	#endif
	#if defined(SPECULAR_MAPPING_ENABLED)
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (glossValue + shadowValue + 1.0f) * (1.0f/3.0f);
		#endif
	#else
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (shadowValue + 1.0f) * 0.5f;
		#endif
	#endif

#else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
#endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	// キューブマップ/スフィアマップ-PerVertex
#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	#if defined(CUBE_MAPPING_ENABLED)
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(IN.CubeMap.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(IN.CubeMap.xyz)).rgba; //TODO : check
	float cubeMapIntensity = IN.CubeMap.w;
	#elif defined(SPHERE_MAPPING_ENABLED)
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, IN.SphereMap.xy).rgba;
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
#else // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)


	// ライティング
	float4 resultColor = diffuseAmt;
	float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);

 	float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	// [PerPixel]

	float3 worldSpaceNormal = EvaluateNormalFP(IN);

	#if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	worldSpaceNormal = normalize(lerp(worldSpaceNormal, EvaluateNormal2FP(IN), multi_uv_alpha));
	#endif //

	float3 ambient = float3(0.0f, 0.0f, 0.0f);
	#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
	#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
		#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
			#define FP_NEED_AFTER_MAX_AMBIENT
		#else // NO_MAIN_LIGHT_SHADING_ENABLED
			#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
			#else // FP_PORTRAIT
	ambient = EvaluateAmbient(worldSpaceNormal);
			#endif // FP_PORTRAIT
		#endif // NO_MAIN_LIGHT_SHADING_ENABLED
	#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	#define FP_WS_EYEDIR_EXIST

	// リムライトや環境マップの準備
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#define FP_NDOTE_1
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		#if defined(CUBE_MAPPING_ENABLED)
			#define FP_NDOTE_2
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
	#if defined(FP_NDOTE_1) || defined(FP_NDOTE_2) || defined(FP_SHINING)
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

	#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
	#endif // DOUBLE_SIDED

	#endif // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

	// リムライト
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= 1.0f - EvaluateRimLightValue(ndote);
			#else // RIM_TRANSPARENCY_ENABLED
	float rimLightvalue = EvaluateRimLightValue(ndote);
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
			#endif // RIM_TRANSPARENCY_ENABLED
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)

	// 環境マップ
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		// キューブマップ/スフィアマップ-PerPixel
		#if defined(CUBE_MAPPING_ENABLED)
	float3 cubeMapParams = reflect(-worldSpaceEyeDirection, worldSpaceNormal);
	float cubeMapIntensity = 1.0f - max(0.0f, ndote) * (float)CubeFresnelPower;
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(cubeMapParams.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(cubeMapParams.xyz)).rgba;
		#elif defined(SPHERE_MAPPING_ENABLED)
	float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)scene_View);
	float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, sphereMapParams.xy).rgba;
		#else
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
	shadingAmt = (1.0f - float3(ndote,ndote,ndote)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );
//	shadingAmt = (1 - half3(ndote)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote)) * Light0.m_colorIntensity;
	resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#elif defined(FP_PORTRAIT)
	shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#else // FP_PORTRAIT
	shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, IN, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#endif // FP_PORTRAIT

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	// [PerVertex]

	#ifdef USE_LIGHTING
		#ifdef PRECALC_EVALUATE_AMBIENT
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
		#else
	float3 subLight = IN.Color1.rgb;
		#endif
	float3 diffuse = IN.ShadingAmount.rgb;
	float3 specular = IN.LightingAmount.rgb;
	#else // USE_LIGHTING
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
	float3 diffuse = float3(1.0f, 1.0f, 1.0f);
	float3 specular = float3(0.0f, 0.0f, 0.0f);
	#endif // USE_LIGHTING

	float3 ambient = float3(0.0f, 0.0f, 0.0f);;

	// リムライト
	#if defined(USE_LIGHTING)

	float3 worldSpaceNormal = normalize(IN.Normal);
		#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
		#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
			#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
				#define FP_NEED_AFTER_MAX_AMBIENT
			#else // NO_MAIN_LIGHT_SHADING_ENABLED
				#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
				#else // FP_PORTRAIT
					#ifdef PRECALC_EVALUATE_AMBIENT
	ambient = IN.Color1.rgb;
					#else
	ambient = EvaluateAmbient(worldSpaceNormal);
					#endif
				#endif // FP_PORTRAIT
			#endif // NO_MAIN_LIGHT_SHADING_ENABLED
		#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

		#ifdef RIM_LIGHTING_ENABLED
			#if defined(USE_FORCE_VERTEX_RIM_LIGHTING)

	float rimLightvalue = IN.ShadingAmount.a;
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED

			#else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);

				#define FP_WS_EYEDIR_EXIST
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

				#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
				#endif // DOUBLE_SIDED

	float rimLightvalue = EvaluateRimLightValue(ndote);
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED
			#endif // defined(USE_FORCE_VERTEX_RIM_LIGHTING)

		#endif // RIM_LIGHTING_ENABLED
	#else
	ambient = float3(0.0f, 0.0f, 0.0f);
	#endif // defined(USE_LIGHTING)

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
		#if !defined(USE_LIGHTING)
	float3 worldSpaceNormal = normalize(IN.Normal);
		#endif
	float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);
		#if !defined(USE_LIGHTING)
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;//最適化できる
		#else
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );//最適化できる
//	shadingAmt = (1 - half3(ndote2)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote2)) * Light0.m_colorIntensity;
		#endif
//	resultColor.rgb = dot(resultColor.rgb, half3(0.299, 0.587, 0.114));
	#else
	shadingAmt = EvaluateLightingPerVertexFP(IN, IN.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	#endif

#endif // !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)

#ifdef CUSTOM_DIFFUSE_ENABLED
	float grayscale = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#if NUM_LIGHTS > 0
		#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
			#ifdef FP_PORTRAIT
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
			#else // FP_PORTRAIT
	float ldotn = (float)dot(Light0.m_direction, worldSpaceNormal);
			#endif // FP_PORTRAIT
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	#else
	resultColor.rgb = float3(grayscale, grayscale, grayscale);
	#endif
#endif // CUSTOM_DIFFUSE_ENABLED

#ifdef FP_NEED_AFTER_MAX_AMBIENT
	#ifdef FP_PORTRAIT
	shadingAmt = max(shadingAmt, PortraitEvaluateAmbient(worldSpaceNormal));
	#else // FP_PORTRAIT
		#if defined(USE_PER_VERTEX_LIGHTING) && defined(PRECALC_EVALUATE_AMBIENT)
	shadingAmt = max(shadingAmt, IN.Color1.rgb);
		#else
	shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
		#endif
	#endif // FP_PORTRAIT
#endif

#ifdef GAME_MATERIAL_ENABLED
	shadingAmt += (float3)GameMaterialEmission;
#endif

#if !defined(DCC_TOOL)
	#if defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
		#if defined(WATER_SURFACE_ENABLED)
			#ifndef FP_WS_EYEDIR_EXIST
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
			#endif // FP_WS_EYEDIR_EXIST
	float water_ndote = dot(UserClipPlane.xyz, worldSpaceEyeDirection);
	float waterAlpha = pow(1.0f - abs(water_ndote), 4.0f);
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a) + reflColor.rgb * waterAlpha * ReflectionIntensity;
	float waterGlowValue = reflColor.a + refrColor.a;
		#else // defined(WATER_SURFACE_ENABLED)
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
		#endif // defined(WATER_SURFACE_ENABLED)
	#endif // defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
#endif // defined(DCC_TOOL)

	// トゥーン・ハイライト-適用
	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			#ifdef CARTOON_HILIGHT_ENABLED
	float hilightValue = HighlightMapSampler.Sample(HighlightMapSamplerS, IN.CartoonMap.xy).r;
	float3 hilightAmt = hilightValue * HighlightIntensity * HighlightColor * subLightColor;
				#define FP_HAS_HILIGHT
			#endif // CARTOON_HILIGHT_ENABLED
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // CARTOON_SHADING_ENABLED
	#ifdef FP_HAS_HILIGHT
	sublightAmount += hilightAmt;
	#endif // FP_HAS_HILIGHT

	// 影カラーシフト
#if defined(SHADOW_COLOR_SHIFT_ENABLED)
	// [Not Toon] 表面下散乱のような使い方
	float3 subLightColor2 = max(float3(1.0f,1.0f,1.0f), subLightColor * 2.0f);
	shadingAmt.rgb += (float3(1.0f,1.0f,1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * ShadowColorShift * subLightColor2;
#endif // SHADOW_COLOR_SHIFT_ENABLED

	#if defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 envMapColor = ambientOcclusion;
	#else // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	float3 envMapColor = float3(1.0f, 1.0f, 1.0f);
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

	// キューブマップ/スフィアマップ-適用 (非IBL)
#ifdef EMVMAP_AS_IBL_ENABLED
	// キューブマップ/スフィアマップ-適用 (IBL)
	#if defined(CUBE_MAPPING_ENABLED)
	shadingAmt.rgb	+= cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	shadingAmt.rgb	+= sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#else // EMVMAP_AS_IBL_ENABLED
	#if defined(CUBE_MAPPING_ENABLED)
	resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	resultColor.rgb += sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#endif // EMVMAP_AS_IBL_ENABLED

	shadingAmt *= ambientOcclusion;
	shadingAmt += sublightAmount;

	// 自己発光度マップ ライトやシャドウを打ち消す値という解釈
#if defined(EMISSION_MAPPING_ENABLED)
	float4 emiTex = EmissionMapSampler.Sample(EmissionMapSamplerS, IN.TexCoord.xy);
	shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r,emiTex.r,emiTex.r));
#endif // EMISSION_MAPPING_ENABLED

	// ライトの合計
	resultColor.rgb *= shadingAmt;

#if defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
#endif

	// フォグ
	//
#ifdef FOG_ENABLED
	#if !defined(FP_PORTRAIT)
		#ifdef DCC_TOOL
	EvaluateFogFP(resultColor.rgb, FogColor.rgb, IN.Color1.a);
		#else // DCC_TOOL
	EvaluateFogFP(resultColor.rgb, scene_FogColor.rgb, IN.Color1.a);
		#endif // DCC_TOOL
	#endif // !defined(FP_PORTRAIT)
#endif // FOG_ENABLED


	#if defined(SUBTRACT_BLENDING_ENABLED)
	resultColor.rgb = resultColor.rgb * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#endif


	// 出力
#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
	return resultColor;
#endif // defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
	#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
//		#if defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
		#if defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	float glowValue = 0.0f;

			#if defined(GLARE_MAP_ENABLED)
	glowValue += GlareMapSampler.Sample(GlareMapSamplerS, IN.TexCoord.xy).x;
			#endif
			#if defined(GLARE_HIGHTPASS_ENABLED)
	float lumi = dot(resultColor.rgb, float3(1.0f,1.0f,1.0f));
	glowValue += max(lumi - 1.0f, 0.0f);
//	glowValue += (lumi > GlowThreshold) ? 1.0h : 0.0h;
			#endif
			#if defined(GLARE_OVERFLOW_ENABLED)
	float3 glowof = max(float3(0.0f, 0.0f, 0.0f), resultColor.rgb - GlowThreshold); //GlowThreshold float3に?
	glowValue += dot(glowof, 1.0f);
			#endif

			#if defined(WATER_SURFACE_ENABLED)
	glowValue += waterGlowValue;
	return float4(resultColor.rgb, glowValue * GlareIntensity);
			#else 
	return float4(resultColor.rgb, glowValue * GlareIntensity * resultColor.a);
			#endif
		#else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#else // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)

	return float4(resultColor.rgb, 0.0f);

		#endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#endif // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	#else // !defined(ALPHA_BLENDING_ENABLED)
	// Mayaではアルファを他の用途で使うとスウォッチの色が変になる
	return resultColor;
	#endif // !defined(ALPHA_BLENDING_ENABLED)
#endif // FP_DEFAULT || FP_DEFAULTRT

#endif // NOTHING_ENABLED

}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2

#line 2880 "Z:/data/shaders/ed8.fx"

// 通常FP レンダーターゲット用 ※映り込み用。一部簡略化
#if defined(GENERATE_RELFECTION_ENABLED)
	#undef FP_DEFAULT
	#define FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#undef FP_PORTRAIT
	#undef FP_SHINING

#line 1 "Z:/data/shaders/ed8_fp_main.h"
// このファイルはUTF-8コードで保存してください。

// FP_DEFAULT
// FP_DEFAULTRT
// FP_FORCETRANSPARENT
// FP_PORTRAIT
//-----------------------------------------------------------------------------
//

// ALPHA trSSAA
#ifdef ALPHA_TESTING_ENABLED
#define _FPINPUT DefaultFPInput IN, uint s_index : SV_SampleIndex
#else 
#define _FPINPUT DefaultFPInput IN
#endif ALPHA_TESTING_ENABLED

#ifdef FP_DEFAULT
float4 DefaultFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULT
#ifdef FP_DEFAULTRT
float4 DefaultFPShaderRT(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULTRT
#ifdef FP_FORCETRANSPARENT
float4 ForceTransparentFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_FORCETRANSPARENT
#ifdef FP_PORTRAIT
float4 PortraitFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_PORTRAIT
#ifdef FP_SHINING
float4 ShiningFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_SHINING
{
#ifdef NOTHING_ENABLED
	float4 resultColor = IN.Color0;
	#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT)
	return resultColor;
	#endif // FP_FORCETRANSPARENT
	#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
		#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
	return float4(resultColor.rgb, 0.0f);
		#else // !defined(ALPHA_BLENDING_ENABLED)
	return resultColor;
		#endif // !defined(ALPHA_BLENDING_ENABLED)
	#endif // FP_DEFAULT || FP_DEFAULTRT
#else // NOTHING_ENABLED

#ifdef FP_DEFAULTRT
	// 水面下をクリップ - (Z軸回転がないとか条件をつければ oblique frustum clippingのような射影行列を加工する手法がある)
	float3 waterNorm = float3(IN.WorldPositionDepth.x, IN.WorldPositionDepth.y - UserClipPlane.w, IN.WorldPositionDepth.z);
	clip(dot(UserClipPlane.xyz, normalize(waterNorm)));
#endif // FP_DEFAULTRT

#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvValue = (DuDvMapSampler.SampleLevel(DuDvMapSamplerS, IN.DuDvTexCoord.xy, 0).xy * 2.0f - 1.0f) * (DuDvScale / DuDvMapImageSize);
#endif // DUDV_MAPPING_ENABLED

	float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);
#ifdef ALPHA_TESTING_ENABLED
	static const float2 vMSAAOffsets[9][8] = {  
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.25, 0.25), float2(-0.25, -0.25), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(-0.125, -0.375), float2(0.375, -0.125), float2(-0.375,  0.125), float2(0.125,  0.375), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(0.0625, -0.1875), float2(-0.0625,  0.1875), float2(0.3125,  0.0625), float2(-0.1875, -0.3125), float2(-0.3125,  0.3125), float2(-0.4375, -0.0625), float2(0.1875,  0.4375), float2(0.4375, -0.4375), },
	};
	if(DuranteSettings.x & 1) {
		const float2 vDDX = ddx(IN.TexCoord.xy);
		const float2 vDDY = ddy(IN.TexCoord.xy);
		float2 vTexOffset = vMSAAOffsets[DuranteSettings.y][s_index].x * vDDX + (vMSAAOffsets[DuranteSettings.y][s_index].y * vDDY);
		IN.TexCoord.xy += vTexOffset;
	}
#endif ALPHA_TESTING_ENABLED
	float4 materialDiffuse = (float4)GameMaterialDiffuse;

#ifndef DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
	#if defined(DUDV_MAPPING_ENABLED)
		+ dudvValue
	#endif // DUDV_MAPPING_ENABLED
		);
#else // DIFFUSEMAP_CHANGING_ENABLED

	#ifdef DCC_TOOL
	float diffuseTxRatio = (float)DiffuseMapTransRatio;
	#else // DCC_TOOL
		#ifdef GAME_MATERIAL_ENABLED
	float diffuseTxRatio = (float)materialDiffuse.a - 1.0f;
		#else // GAME_MATERIAL_ENABLED
	float diffuseTxRatio = 1.0f;
		#endif // GAME_MATERIAL_ENABLED
	#endif // DCC_TOOL

	materialDiffuse.a = min(1.0f, materialDiffuse.a);

	if (diffuseTxRatio < 1.0f)
	{
		float t = max(0.0f, diffuseTxRatio);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx0, diffuseTx1, t);
	}
	else if (diffuseTxRatio < 2.0f)
	{
		float t = diffuseTxRatio - 1.0f;
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx1, diffuseTx2, t);
	}
	else // if (diffuseTxRatio < 3.0)
	{
		float t = (min(3.0f, diffuseTxRatio) - 2.0f);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx2, diffuseTx0, t);
	}
#endif // DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt.a *= (float)IN.Color0.a;

#if !defined(DCC_TOOL)
	#if defined(USE_SCREEN_UV)
	float4 dudvTex = IN.ReflectionMap;
		#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvAmt = dudvValue * float2(ScreenWidth/DuDvMapImageSize.x, ScreenHeight/DuDvMapImageSize.y);
	dudvTex.xy += dudvAmt;
			#define FP_DUDV_AMT_EXIST
		#endif // DUDV_MAPPING_ENABLED

		#if defined(WATER_SURFACE_ENABLED)
			float4 reflColor = ReflectionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;
		#endif // defined(WATER_SURFACE_ENABLED)

	float4 refrColor = RefractionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;


	#endif // defined(USE_SCREEN_UV)
#endif // defined(DCC_TOOL)

	// アルファテスト
#ifdef FP_FORCETRANSPARENT
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
		#else
	clip(diffuseAmt.a - 0.004f);
		#endif
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_FORCETRANSPARENT
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	float alphaAmt = diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a;
	clip((alphaAmt > 0.0f) ? (alphaAmt * AlphaTestDirection) : (-1.0f/255.0f));
		#else // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
			#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
			#else
	clip(diffuseAmt.a - 0.004f);
			#endif
		#endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_DEFAULT || FP_DEFAULTRT || FP_PORTRAIT

	// マルチUV
#ifdef MULTI_UV_ENANLED
	#if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse2Amt = DiffuseMap2Sampler.Sample(DiffuseMap2SamplerS, IN.TexCoord2.xy);
		#ifdef UVA_SCRIPT_ENABLED
	diffuse2Amt *= (float4)UVaMUvColor;
		#endif // UVA_SCRIPT_ENABLED

		#if defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)diffuse2Amt.a;
		#else // defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)IN.Color0.a * diffuse2Amt.a;
		#endif // defined(MULTI_UV_FACE_ENANLED)

		#if defined(MULTI_UV_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add = diffuse2Amt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv_alpha);
	float3 muvtex_add = (diffuse2Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
		#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
		#endif //

	#else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	float multi_uv_alpha = (float)IN.Color0.a;

	#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	#ifdef MULTI_UV2_ENANLED 
		#if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse3Amt = DiffuseMap3Sampler.Sample(DiffuseMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)diffuse3Amt.a;
			#else // defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)IN.Color0.a * diffuse3Amt.a;
			#endif // defined(MULTI_UV_FACE_ENANLED)

			#if defined(MULTI_UV2_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add2 = diffuse3Amt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv2_alpha);
	float3 muvtex_add2 = (diffuse3Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
			#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
			#endif //
//		#else // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
//	float multi_uv2_alpha = IN.Color0.a;
		#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	#endif // MULTI_UV2_ENANLED

#endif // MULTI_UV_ENANLED

#ifdef GAME_MATERIAL_ENABLED
	diffuseAmt *= materialDiffuse;
#endif // GAME_MATERIAL_ENABLED

	// シャドウマップ
#if defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
	// 複数ライトのときはどれがディレクショナルかはシステムしだい
	// 2012/08/30 現在は追加のライトは自前。
	float shadowValue = 1.0f;
//	#if NUM_LIGHTS > 2
//	shadowValue = min(shadowValue, EvaluateShadow(Light2, LightShadow2, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
//	#if NUM_LIGHTS > 1
//	shadowValue = min(shadowValue, EvaluateShadow(Light1, LightShadow1, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
	#if NUM_LIGHTS > 0
		#ifdef PRECALC_SHADOWMAP_POSITION
			if (IN.shadowPos.w < 1.0f)
			{
				float shadowMin = SampleOrthographicShadowMap(IN.shadowPos.xyz, LightShadowMap0, DuranteSettings.x, 1.f);
			#ifdef SHADOW_ATTENUATION_ENABLED
				shadowMin = (float)min(shadowMin + IN.shadowPos.w, 1.0f);
			#endif
				shadowValue = min(shadowValue, shadowMin);
			}
		#else // PRECALC_SHADOWMAP_POSITION
			#if defined(DUDV_MAPPING_ENABLED)
	float3 dudv0 = float3(dudvValue.x, dudvValue.y, 0.0f);
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz + dudv0, IN.WorldPositionDepth.w, DuranteSettings.x));
			#else // DUDV_MAPPING_ENABLED
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w, DuranteSettings.x));
			#endif // DUDV_MAPPING_ENABLED
			#ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
	if (scene_MiscParameters2.x > 0.0f)
	{
		float shadowMinBias = min(abs(IN.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
		shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
		shadowMin = min(shadowMin + shadowMinBias, 1.0f);
	}
			#endif
	shadowValue = min(shadowValue, shadowMin);
		#endif // PRECALC_SHADOWMAP_POSITION

	#endif
	#ifdef FP_DUDV_AMT_EXIST
	shadowValue = (shadowValue + 1.0f) * 0.5f;
	#endif

#else // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)
	float shadowValue = 1.0f;
#endif // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)

#ifdef MULTI_UV_ENANLED 
	#if defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse2Amt.r * multi_uv_alpha));
	#endif //
	#if defined(MULTI_UV2_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse3Amt.r * multi_uv2_alpha));
	#endif //
#endif // MULTI_UV_ENANLED

#if defined(PROJECTION_MAP_ENABLED)
	float4 projTex = ProjectionMapSampler.Sample(ProjectionMapSamplerS, IN.ProjMap.xy);
	// 雲の影
//	shadowValue = max(shadowValue - (1 - (projTex.r * projTex.a)), 0);
	shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
#endif // PROJECTION_MAP_ENABLED

	// スペキュラマップ
#if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
 
	float glossValue = 1.0f;
	#ifdef SPECULAR_MAPPING_ENABLED
	glossValue = SpecularMapSampler.Sample(SpecularMapSamplerS, IN.TexCoord.xy).x;
	#endif // SPECULAR_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
	float glossValue2 = SpecularMap2Sampler.Sample(SpecularMap2SamplerS, IN.TexCoord2.xy).x;
	glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
		#endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
		#if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
	float glossValue3 = SpecularMap3Sampler.Sample(SpecularMap3SamplerS, IN.TexCoord3.xy).x;
	glossValue = lerp(glossValue, glossValue3, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // 
#else // SPECULAR_MAPPING_ENABLED
	float glossValue = 1.0f;
#endif // SPECULAR_MAPPING_ENABLED

	// 環境光遮蔽マップ
#if defined(OCCULUSION_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV_OCCULUSION2_MAPPING_ENABLED))

	float occulusionValue = 1.0f;
	#ifdef OCCULUSION_MAPPING_ENABLED
	occulusionValue = OcculusionMapSampler.Sample(OcculusionMapSamplerS, IN.TexCoord.xy).x;
	#endif // OCCULUSION_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue2 = OcculusionMap2Sampler.Sample(OcculusionMap2SamplerS, IN.TexCoord2.xy);
			#if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	multi_uv_alpha = occulusionValue2.a;
			#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		#endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
		#if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue3 = OcculusionMap3Sampler.Sample(OcculusionMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float multi_uv2_alpha = occulusionValue3.a;
			#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // defined(MULTI_UV_ENANLED)

	float3 ambientOcclusion = (float3)IN.Color0.rgb * occulusionValue;
#else // OCCULUSION_MAPPING_ENABLED
	float3 ambientOcclusion = (float3)IN.Color0.rgb;
#endif // OCCULUSION_MAPPING_ENABLED

	// インチキライトへの影やスペキュラマップの影響
#if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	#if (NUM_LIGHTS > 0) && defined(USE_LIGHTING)
		#ifdef FP_PORTRAIT
	float3 subLightColor = PortraitLightColor;
		#else // FP_PORTRAIT
	float3 subLightColor = Light0.m_colorIntensity;
		#endif // FP_PORTRAIT
	#else
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	#endif
	#if defined(SPECULAR_MAPPING_ENABLED)
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (glossValue + shadowValue + 1.0f) * (1.0f/3.0f);
		#endif
	#else
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (shadowValue + 1.0f) * 0.5f;
		#endif
	#endif

#else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
#endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	// キューブマップ/スフィアマップ-PerVertex
#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	#if defined(CUBE_MAPPING_ENABLED)
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(IN.CubeMap.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(IN.CubeMap.xyz)).rgba; //TODO : check
	float cubeMapIntensity = IN.CubeMap.w;
	#elif defined(SPHERE_MAPPING_ENABLED)
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, IN.SphereMap.xy).rgba;
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
#else // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)


	// ライティング
	float4 resultColor = diffuseAmt;
	float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);

 	float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	// [PerPixel]

	float3 worldSpaceNormal = EvaluateNormalFP(IN);

	#if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	worldSpaceNormal = normalize(lerp(worldSpaceNormal, EvaluateNormal2FP(IN), multi_uv_alpha));
	#endif //

	float3 ambient = float3(0.0f, 0.0f, 0.0f);
	#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
	#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
		#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
			#define FP_NEED_AFTER_MAX_AMBIENT
		#else // NO_MAIN_LIGHT_SHADING_ENABLED
			#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
			#else // FP_PORTRAIT
	ambient = EvaluateAmbient(worldSpaceNormal);
			#endif // FP_PORTRAIT
		#endif // NO_MAIN_LIGHT_SHADING_ENABLED
	#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	#define FP_WS_EYEDIR_EXIST

	// リムライトや環境マップの準備
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#define FP_NDOTE_1
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		#if defined(CUBE_MAPPING_ENABLED)
			#define FP_NDOTE_2
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
	#if defined(FP_NDOTE_1) || defined(FP_NDOTE_2) || defined(FP_SHINING)
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

	#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
	#endif // DOUBLE_SIDED

	#endif // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

	// リムライト
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= 1.0f - EvaluateRimLightValue(ndote);
			#else // RIM_TRANSPARENCY_ENABLED
	float rimLightvalue = EvaluateRimLightValue(ndote);
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
			#endif // RIM_TRANSPARENCY_ENABLED
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)

	// 環境マップ
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		// キューブマップ/スフィアマップ-PerPixel
		#if defined(CUBE_MAPPING_ENABLED)
	float3 cubeMapParams = reflect(-worldSpaceEyeDirection, worldSpaceNormal);
	float cubeMapIntensity = 1.0f - max(0.0f, ndote) * (float)CubeFresnelPower;
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(cubeMapParams.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(cubeMapParams.xyz)).rgba;
		#elif defined(SPHERE_MAPPING_ENABLED)
	float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)scene_View);
	float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, sphereMapParams.xy).rgba;
		#else
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
	shadingAmt = (1.0f - float3(ndote,ndote,ndote)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );
//	shadingAmt = (1 - half3(ndote)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote)) * Light0.m_colorIntensity;
	resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#elif defined(FP_PORTRAIT)
	shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#else // FP_PORTRAIT
	shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, IN, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#endif // FP_PORTRAIT

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	// [PerVertex]

	#ifdef USE_LIGHTING
		#ifdef PRECALC_EVALUATE_AMBIENT
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
		#else
	float3 subLight = IN.Color1.rgb;
		#endif
	float3 diffuse = IN.ShadingAmount.rgb;
	float3 specular = IN.LightingAmount.rgb;
	#else // USE_LIGHTING
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
	float3 diffuse = float3(1.0f, 1.0f, 1.0f);
	float3 specular = float3(0.0f, 0.0f, 0.0f);
	#endif // USE_LIGHTING

	float3 ambient = float3(0.0f, 0.0f, 0.0f);;

	// リムライト
	#if defined(USE_LIGHTING)

	float3 worldSpaceNormal = normalize(IN.Normal);
		#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
		#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
			#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
				#define FP_NEED_AFTER_MAX_AMBIENT
			#else // NO_MAIN_LIGHT_SHADING_ENABLED
				#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
				#else // FP_PORTRAIT
					#ifdef PRECALC_EVALUATE_AMBIENT
	ambient = IN.Color1.rgb;
					#else
	ambient = EvaluateAmbient(worldSpaceNormal);
					#endif
				#endif // FP_PORTRAIT
			#endif // NO_MAIN_LIGHT_SHADING_ENABLED
		#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

		#ifdef RIM_LIGHTING_ENABLED
			#if defined(USE_FORCE_VERTEX_RIM_LIGHTING)

	float rimLightvalue = IN.ShadingAmount.a;
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED

			#else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);

				#define FP_WS_EYEDIR_EXIST
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

				#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
				#endif // DOUBLE_SIDED

	float rimLightvalue = EvaluateRimLightValue(ndote);
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED
			#endif // defined(USE_FORCE_VERTEX_RIM_LIGHTING)

		#endif // RIM_LIGHTING_ENABLED
	#else
	ambient = float3(0.0f, 0.0f, 0.0f);
	#endif // defined(USE_LIGHTING)

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
		#if !defined(USE_LIGHTING)
	float3 worldSpaceNormal = normalize(IN.Normal);
		#endif
	float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);
		#if !defined(USE_LIGHTING)
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;//最適化できる
		#else
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );//最適化できる
//	shadingAmt = (1 - half3(ndote2)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote2)) * Light0.m_colorIntensity;
		#endif
//	resultColor.rgb = dot(resultColor.rgb, half3(0.299, 0.587, 0.114));
	#else
	shadingAmt = EvaluateLightingPerVertexFP(IN, IN.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	#endif

#endif // !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)

#ifdef CUSTOM_DIFFUSE_ENABLED
	float grayscale = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#if NUM_LIGHTS > 0
		#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
			#ifdef FP_PORTRAIT
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
			#else // FP_PORTRAIT
	float ldotn = (float)dot(Light0.m_direction, worldSpaceNormal);
			#endif // FP_PORTRAIT
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	#else
	resultColor.rgb = float3(grayscale, grayscale, grayscale);
	#endif
#endif // CUSTOM_DIFFUSE_ENABLED

#ifdef FP_NEED_AFTER_MAX_AMBIENT
	#ifdef FP_PORTRAIT
	shadingAmt = max(shadingAmt, PortraitEvaluateAmbient(worldSpaceNormal));
	#else // FP_PORTRAIT
		#if defined(USE_PER_VERTEX_LIGHTING) && defined(PRECALC_EVALUATE_AMBIENT)
	shadingAmt = max(shadingAmt, IN.Color1.rgb);
		#else
	shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
		#endif
	#endif // FP_PORTRAIT
#endif

#ifdef GAME_MATERIAL_ENABLED
	shadingAmt += (float3)GameMaterialEmission;
#endif

#if !defined(DCC_TOOL)
	#if defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
		#if defined(WATER_SURFACE_ENABLED)
			#ifndef FP_WS_EYEDIR_EXIST
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
			#endif // FP_WS_EYEDIR_EXIST
	float water_ndote = dot(UserClipPlane.xyz, worldSpaceEyeDirection);
	float waterAlpha = pow(1.0f - abs(water_ndote), 4.0f);
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a) + reflColor.rgb * waterAlpha * ReflectionIntensity;
	float waterGlowValue = reflColor.a + refrColor.a;
		#else // defined(WATER_SURFACE_ENABLED)
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
		#endif // defined(WATER_SURFACE_ENABLED)
	#endif // defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
#endif // defined(DCC_TOOL)

	// トゥーン・ハイライト-適用
	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			#ifdef CARTOON_HILIGHT_ENABLED
	float hilightValue = HighlightMapSampler.Sample(HighlightMapSamplerS, IN.CartoonMap.xy).r;
	float3 hilightAmt = hilightValue * HighlightIntensity * HighlightColor * subLightColor;
				#define FP_HAS_HILIGHT
			#endif // CARTOON_HILIGHT_ENABLED
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // CARTOON_SHADING_ENABLED
	#ifdef FP_HAS_HILIGHT
	sublightAmount += hilightAmt;
	#endif // FP_HAS_HILIGHT

	// 影カラーシフト
#if defined(SHADOW_COLOR_SHIFT_ENABLED)
	// [Not Toon] 表面下散乱のような使い方
	float3 subLightColor2 = max(float3(1.0f,1.0f,1.0f), subLightColor * 2.0f);
	shadingAmt.rgb += (float3(1.0f,1.0f,1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * ShadowColorShift * subLightColor2;
#endif // SHADOW_COLOR_SHIFT_ENABLED

	#if defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 envMapColor = ambientOcclusion;
	#else // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	float3 envMapColor = float3(1.0f, 1.0f, 1.0f);
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

	// キューブマップ/スフィアマップ-適用 (非IBL)
#ifdef EMVMAP_AS_IBL_ENABLED
	// キューブマップ/スフィアマップ-適用 (IBL)
	#if defined(CUBE_MAPPING_ENABLED)
	shadingAmt.rgb	+= cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	shadingAmt.rgb	+= sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#else // EMVMAP_AS_IBL_ENABLED
	#if defined(CUBE_MAPPING_ENABLED)
	resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	resultColor.rgb += sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#endif // EMVMAP_AS_IBL_ENABLED

	shadingAmt *= ambientOcclusion;
	shadingAmt += sublightAmount;

	// 自己発光度マップ ライトやシャドウを打ち消す値という解釈
#if defined(EMISSION_MAPPING_ENABLED)
	float4 emiTex = EmissionMapSampler.Sample(EmissionMapSamplerS, IN.TexCoord.xy);
	shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r,emiTex.r,emiTex.r));
#endif // EMISSION_MAPPING_ENABLED

	// ライトの合計
	resultColor.rgb *= shadingAmt;

#if defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
#endif

	// フォグ
	//
#ifdef FOG_ENABLED
	#if !defined(FP_PORTRAIT)
		#ifdef DCC_TOOL
	EvaluateFogFP(resultColor.rgb, FogColor.rgb, IN.Color1.a);
		#else // DCC_TOOL
	EvaluateFogFP(resultColor.rgb, scene_FogColor.rgb, IN.Color1.a);
		#endif // DCC_TOOL
	#endif // !defined(FP_PORTRAIT)
#endif // FOG_ENABLED


	#if defined(SUBTRACT_BLENDING_ENABLED)
	resultColor.rgb = resultColor.rgb * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#endif


	// 出力
#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
	return resultColor;
#endif // defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
	#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
//		#if defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
		#if defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	float glowValue = 0.0f;

			#if defined(GLARE_MAP_ENABLED)
	glowValue += GlareMapSampler.Sample(GlareMapSamplerS, IN.TexCoord.xy).x;
			#endif
			#if defined(GLARE_HIGHTPASS_ENABLED)
	float lumi = dot(resultColor.rgb, float3(1.0f,1.0f,1.0f));
	glowValue += max(lumi - 1.0f, 0.0f);
//	glowValue += (lumi > GlowThreshold) ? 1.0h : 0.0h;
			#endif
			#if defined(GLARE_OVERFLOW_ENABLED)
	float3 glowof = max(float3(0.0f, 0.0f, 0.0f), resultColor.rgb - GlowThreshold); //GlowThreshold float3に?
	glowValue += dot(glowof, 1.0f);
			#endif

			#if defined(WATER_SURFACE_ENABLED)
	glowValue += waterGlowValue;
	return float4(resultColor.rgb, glowValue * GlareIntensity);
			#else 
	return float4(resultColor.rgb, glowValue * GlareIntensity * resultColor.a);
			#endif
		#else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#else // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)

	return float4(resultColor.rgb, 0.0f);

		#endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#endif // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	#else // !defined(ALPHA_BLENDING_ENABLED)
	// Mayaではアルファを他の用途で使うとスウォッチの色が変になる
	return resultColor;
	#endif // !defined(ALPHA_BLENDING_ENABLED)
#endif // FP_DEFAULT || FP_DEFAULTRT

#endif // NOTHING_ENABLED

}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2

#line 2890 "Z:/data/shaders/ed8.fx"
#endif // defined(GENERATE_RELFECTION_ENABLEDD)

// フェイスFP
#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
	#undef FP_DEFAULT
	#undef FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#define FP_PORTRAIT
	#undef FP_SHINING

#line 1 "Z:/data/shaders/ed8_fp_main.h"
// このファイルはUTF-8コードで保存してください。

// FP_DEFAULT
// FP_DEFAULTRT
// FP_FORCETRANSPARENT
// FP_PORTRAIT
//-----------------------------------------------------------------------------
//

// ALPHA trSSAA
#ifdef ALPHA_TESTING_ENABLED
#define _FPINPUT DefaultFPInput IN, uint s_index : SV_SampleIndex
#else 
#define _FPINPUT DefaultFPInput IN
#endif ALPHA_TESTING_ENABLED

#ifdef FP_DEFAULT
float4 DefaultFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULT
#ifdef FP_DEFAULTRT
float4 DefaultFPShaderRT(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_DEFAULTRT
#ifdef FP_FORCETRANSPARENT
float4 ForceTransparentFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_FORCETRANSPARENT
#ifdef FP_PORTRAIT
float4 PortraitFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_PORTRAIT
#ifdef FP_SHINING
float4 ShiningFPShader(_FPINPUT) : FRAG_OUTPUT_COLOR0
#endif // FP_SHINING
{
#ifdef NOTHING_ENABLED
	float4 resultColor = IN.Color0;
	#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT)
	return resultColor;
	#endif // FP_FORCETRANSPARENT
	#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
		#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
	return float4(resultColor.rgb, 0.0f);
		#else // !defined(ALPHA_BLENDING_ENABLED)
	return resultColor;
		#endif // !defined(ALPHA_BLENDING_ENABLED)
	#endif // FP_DEFAULT || FP_DEFAULTRT
#else // NOTHING_ENABLED

#ifdef FP_DEFAULTRT
	// 水面下をクリップ - (Z軸回転がないとか条件をつければ oblique frustum clippingのような射影行列を加工する手法がある)
	float3 waterNorm = float3(IN.WorldPositionDepth.x, IN.WorldPositionDepth.y - UserClipPlane.w, IN.WorldPositionDepth.z);
	clip(dot(UserClipPlane.xyz, normalize(waterNorm)));
#endif // FP_DEFAULTRT

#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvValue = (DuDvMapSampler.SampleLevel(DuDvMapSamplerS, IN.DuDvTexCoord.xy, 0).xy * 2.0f - 1.0f) * (DuDvScale / DuDvMapImageSize);
#endif // DUDV_MAPPING_ENABLED

	float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);
#ifdef ALPHA_TESTING_ENABLED
	static const float2 vMSAAOffsets[9][8] = {  
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.25, 0.25), float2(-0.25, -0.25), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(-0.125, -0.375), float2(0.375, -0.125), float2(-0.375,  0.125), float2(0.125,  0.375), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), float2( 0.00, 0.00), },
		{ float2(0.0625, -0.1875), float2(-0.0625,  0.1875), float2(0.3125,  0.0625), float2(-0.1875, -0.3125), float2(-0.3125,  0.3125), float2(-0.4375, -0.0625), float2(0.1875,  0.4375), float2(0.4375, -0.4375), },
	};
	if(DuranteSettings.x & 1) {
		const float2 vDDX = ddx(IN.TexCoord.xy);
		const float2 vDDY = ddy(IN.TexCoord.xy);
		float2 vTexOffset = vMSAAOffsets[DuranteSettings.y][s_index].x * vDDX + (vMSAAOffsets[DuranteSettings.y][s_index].y * vDDY);
		IN.TexCoord.xy += vTexOffset;
	}
#endif ALPHA_TESTING_ENABLED
	float4 materialDiffuse = (float4)GameMaterialDiffuse;

#ifndef DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
	#if defined(DUDV_MAPPING_ENABLED)
		+ dudvValue
	#endif // DUDV_MAPPING_ENABLED
		);
#else // DIFFUSEMAP_CHANGING_ENABLED

	#ifdef DCC_TOOL
	float diffuseTxRatio = (float)DiffuseMapTransRatio;
	#else // DCC_TOOL
		#ifdef GAME_MATERIAL_ENABLED
	float diffuseTxRatio = (float)materialDiffuse.a - 1.0f;
		#else // GAME_MATERIAL_ENABLED
	float diffuseTxRatio = 1.0f;
		#endif // GAME_MATERIAL_ENABLED
	#endif // DCC_TOOL

	materialDiffuse.a = min(1.0f, materialDiffuse.a);

	if (diffuseTxRatio < 1.0f)
	{
		float t = max(0.0f, diffuseTxRatio);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy 
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx0, diffuseTx1, t);
	}
	else if (diffuseTxRatio < 2.0f)
	{
		float t = diffuseTxRatio - 1.0f;
		float4 diffuseTx1 = DiffuseMapTrans1Sampler.Sample(DiffuseMapTrans1SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx1, diffuseTx2, t);
	}
	else // if (diffuseTxRatio < 3.0)
	{
		float t = (min(3.0f, diffuseTxRatio) - 2.0f);
		float4 diffuseTx2 = DiffuseMapTrans2Sampler.Sample(DiffuseMapTrans2SamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
			+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		float4 diffuseTx0 = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy
		#if defined(DUDV_MAPPING_ENABLED)
				+ dudvValue
		#endif // DUDV_MAPPING_ENABLED
			);
		diffuseAmt = lerp(diffuseTx2, diffuseTx0, t);
	}
#endif // DIFFUSEMAP_CHANGING_ENABLED

	diffuseAmt.a *= (float)IN.Color0.a;

#if !defined(DCC_TOOL)
	#if defined(USE_SCREEN_UV)
	float4 dudvTex = IN.ReflectionMap;
		#if defined(DUDV_MAPPING_ENABLED)
	float2 dudvAmt = dudvValue * float2(ScreenWidth/DuDvMapImageSize.x, ScreenHeight/DuDvMapImageSize.y);
	dudvTex.xy += dudvAmt;
			#define FP_DUDV_AMT_EXIST
		#endif // DUDV_MAPPING_ENABLED

		#if defined(WATER_SURFACE_ENABLED)
			float4 reflColor = ReflectionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;
		#endif // defined(WATER_SURFACE_ENABLED)

	float4 refrColor = RefractionTexture.Sample(LinearWrapSampler, dudvTex.xy / dudvTex.w).xyzw;


	#endif // defined(USE_SCREEN_UV)
#endif // defined(DCC_TOOL)

	// アルファテスト
#ifdef FP_FORCETRANSPARENT
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
		#else
	clip(diffuseAmt.a - 0.004f);
		#endif
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_FORCETRANSPARENT
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
		#if defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	float alphaAmt = diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a;
	clip((alphaAmt > 0.0f) ? (alphaAmt * AlphaTestDirection) : (-1.0f/255.0f));
		#else // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
			#if defined(ALPHA_TESTING_ENABLED)
	clip(diffuseAmt.a - AlphaThreshold * (float)IN.Color0.a);
			#else
	clip(diffuseAmt.a - 0.004f);
			#endif
		#endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
#endif // FP_DEFAULT || FP_DEFAULTRT || FP_PORTRAIT

	// マルチUV
#ifdef MULTI_UV_ENANLED
	#if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse2Amt = DiffuseMap2Sampler.Sample(DiffuseMap2SamplerS, IN.TexCoord2.xy);
		#ifdef UVA_SCRIPT_ENABLED
	diffuse2Amt *= (float4)UVaMUvColor;
		#endif // UVA_SCRIPT_ENABLED

		#if defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)diffuse2Amt.a;
		#else // defined(MULTI_UV_FACE_ENANLED)
	float multi_uv_alpha = (float)IN.Color0.a * diffuse2Amt.a;
		#endif // defined(MULTI_UV_FACE_ENANLED)

		#if defined(MULTI_UV_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add = diffuse2Amt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv_alpha);
	float3 muvtex_add = (diffuse2Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv_alpha;
	diffuseAmt.rgb += muvtex_add;
		#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
		#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
		#endif //

	#else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	float multi_uv_alpha = (float)IN.Color0.a;

	#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	#ifdef MULTI_UV2_ENANLED 
		#if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float4 diffuse3Amt = DiffuseMap3Sampler.Sample(DiffuseMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)diffuse3Amt.a;
			#else // defined(MULTI_UV2_FACE_ENANLED)
	float multi_uv2_alpha = (float)IN.Color0.a * diffuse3Amt.a;
			#endif // defined(MULTI_UV_FACE_ENANLED)

			#if defined(MULTI_UV2_ADDITIVE_BLENDING_ENANLED)
	// 加算
	float3 muvtex_add2 = diffuse3Amt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED)
	// 乗算
	// v = lerp(x, x*y, t)
	// v = x + (x*y - x) * t;
	// v = x + (y - 1) * x * t;
//	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv2_alpha);
	float3 muvtex_add2 = (diffuse3Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv2_alpha;
	diffuseAmt.rgb += muvtex_add2;
			#elif defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
			#else
	// アルファ
	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
			#endif //
//		#else // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
//	float multi_uv2_alpha = IN.Color0.a;
		#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	#endif // MULTI_UV2_ENANLED

#endif // MULTI_UV_ENANLED

#ifdef GAME_MATERIAL_ENABLED
	diffuseAmt *= materialDiffuse;
#endif // GAME_MATERIAL_ENABLED

	// シャドウマップ
#if defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
	// 複数ライトのときはどれがディレクショナルかはシステムしだい
	// 2012/08/30 現在は追加のライトは自前。
	float shadowValue = 1.0f;
//	#if NUM_LIGHTS > 2
//	shadowValue = min(shadowValue, EvaluateShadow(Light2, LightShadow2, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
//	#if NUM_LIGHTS > 1
//	shadowValue = min(shadowValue, EvaluateShadow(Light1, LightShadow1, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w));
//	#endif
	#if NUM_LIGHTS > 0
		#ifdef PRECALC_SHADOWMAP_POSITION
			if (IN.shadowPos.w < 1.0f)
			{
				float shadowMin = SampleOrthographicShadowMap(IN.shadowPos.xyz, LightShadowMap0, DuranteSettings.x, 1.f);
			#ifdef SHADOW_ATTENUATION_ENABLED
				shadowMin = (float)min(shadowMin + IN.shadowPos.w, 1.0f);
			#endif
				shadowValue = min(shadowValue, shadowMin);
			}
		#else // PRECALC_SHADOWMAP_POSITION
			#if defined(DUDV_MAPPING_ENABLED)
	float3 dudv0 = float3(dudvValue.x, dudvValue.y, 0.0f);
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz + dudv0, IN.WorldPositionDepth.w, DuranteSettings.x));
			#else // DUDV_MAPPING_ENABLED
	float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, IN.WorldPositionDepth.xyz, IN.WorldPositionDepth.w, DuranteSettings.x));
			#endif // DUDV_MAPPING_ENABLED
			#ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
	if (scene_MiscParameters2.x > 0.0f)
	{
		float shadowMinBias = min(abs(IN.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
		shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
		shadowMin = min(shadowMin + shadowMinBias, 1.0f);
	}
			#endif
	shadowValue = min(shadowValue, shadowMin);
		#endif // PRECALC_SHADOWMAP_POSITION

	#endif
	#ifdef FP_DUDV_AMT_EXIST
	shadowValue = (shadowValue + 1.0f) * 0.5f;
	#endif

#else // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)
	float shadowValue = 1.0f;
#endif // defined(RECEIVE_SHADOWS) && defined(USE_LIGHTING) && !defined(FP_DEFAULTRT)

#ifdef MULTI_UV_ENANLED 
	#if defined(MULTI_UV_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse2Amt.r * multi_uv_alpha));
	#endif //
	#if defined(MULTI_UV2_SHADOW_ENANLED)
	// 影領域として扱う
	shadowValue = min(shadowValue, 1.0f - (diffuse3Amt.r * multi_uv2_alpha));
	#endif //
#endif // MULTI_UV_ENANLED

#if defined(PROJECTION_MAP_ENABLED)
	float4 projTex = ProjectionMapSampler.Sample(ProjectionMapSamplerS, IN.ProjMap.xy);
	// 雲の影
//	shadowValue = max(shadowValue - (1 - (projTex.r * projTex.a)), 0);
	shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
#endif // PROJECTION_MAP_ENABLED

	// スペキュラマップ
#if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
 
	float glossValue = 1.0f;
	#ifdef SPECULAR_MAPPING_ENABLED
	glossValue = SpecularMapSampler.Sample(SpecularMapSamplerS, IN.TexCoord.xy).x;
	#endif // SPECULAR_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
	float glossValue2 = SpecularMap2Sampler.Sample(SpecularMap2SamplerS, IN.TexCoord2.xy).x;
	glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
		#endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
		#if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
	float glossValue3 = SpecularMap3Sampler.Sample(SpecularMap3SamplerS, IN.TexCoord3.xy).x;
	glossValue = lerp(glossValue, glossValue3, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // 
#else // SPECULAR_MAPPING_ENABLED
	float glossValue = 1.0f;
#endif // SPECULAR_MAPPING_ENABLED

	// 環境光遮蔽マップ
#if defined(OCCULUSION_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV_OCCULUSION2_MAPPING_ENABLED))

	float occulusionValue = 1.0f;
	#ifdef OCCULUSION_MAPPING_ENABLED
	occulusionValue = OcculusionMapSampler.Sample(OcculusionMapSamplerS, IN.TexCoord.xy).x;
	#endif // OCCULUSION_MAPPING_ENABLED
	#if defined(MULTI_UV_ENANLED)
		#if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue2 = OcculusionMap2Sampler.Sample(OcculusionMap2SamplerS, IN.TexCoord2.xy);
			#if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	multi_uv_alpha = occulusionValue2.a;
			#endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		#endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
		#if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	float4 occulusionValue3 = OcculusionMap3Sampler.Sample(OcculusionMap3SamplerS, IN.TexCoord3.xy);
			#if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	float multi_uv2_alpha = occulusionValue3.a;
			#endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		#endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	#endif // defined(MULTI_UV_ENANLED)

	float3 ambientOcclusion = (float3)IN.Color0.rgb * occulusionValue;
#else // OCCULUSION_MAPPING_ENABLED
	float3 ambientOcclusion = (float3)IN.Color0.rgb;
#endif // OCCULUSION_MAPPING_ENABLED

	// インチキライトへの影やスペキュラマップの影響
#if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	#if (NUM_LIGHTS > 0) && defined(USE_LIGHTING)
		#ifdef FP_PORTRAIT
	float3 subLightColor = PortraitLightColor;
		#else // FP_PORTRAIT
	float3 subLightColor = Light0.m_colorIntensity;
		#endif // FP_PORTRAIT
	#else
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	#endif
	#if defined(SPECULAR_MAPPING_ENABLED)
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (glossValue + shadowValue + 1.0f) * (1.0f/3.0f);
		#endif
	#else
		#if defined(RECEIVE_SHADOWS) && (NUM_LIGHTS > 0)
	subLightColor *= (shadowValue + 1.0f) * 0.5f;
		#endif
	#endif

#else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
#endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

	// キューブマップ/スフィアマップ-PerVertex
#if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	#if defined(CUBE_MAPPING_ENABLED)
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(IN.CubeMap.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(IN.CubeMap.xyz)).rgba; //TODO : check
	float cubeMapIntensity = IN.CubeMap.w;
	#elif defined(SPHERE_MAPPING_ENABLED)
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, IN.SphereMap.xy).rgba;
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
#else // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
#endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)


	// ライティング
	float4 resultColor = diffuseAmt;
	float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);

 	float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	// [PerPixel]

	float3 worldSpaceNormal = EvaluateNormalFP(IN);

	#if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	worldSpaceNormal = normalize(lerp(worldSpaceNormal, EvaluateNormal2FP(IN), multi_uv_alpha));
	#endif //

	float3 ambient = float3(0.0f, 0.0f, 0.0f);
	#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
	#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
		#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
			#define FP_NEED_AFTER_MAX_AMBIENT
		#else // NO_MAIN_LIGHT_SHADING_ENABLED
			#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
			#else // FP_PORTRAIT
	ambient = EvaluateAmbient(worldSpaceNormal);
			#endif // FP_PORTRAIT
		#endif // NO_MAIN_LIGHT_SHADING_ENABLED
	#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	#define FP_WS_EYEDIR_EXIST

	// リムライトや環境マップの準備
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#define FP_NDOTE_1
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		#if defined(CUBE_MAPPING_ENABLED)
			#define FP_NDOTE_2
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
	#if defined(FP_NDOTE_1) || defined(FP_NDOTE_2) || defined(FP_SHINING)
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

	#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
	#endif // DOUBLE_SIDED

	#endif // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

	// リムライト
	#if defined(USE_LIGHTING)
		#ifdef RIM_LIGHTING_ENABLED
			#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= 1.0f - EvaluateRimLightValue(ndote);
			#else // RIM_TRANSPARENCY_ENABLED
	float rimLightvalue = EvaluateRimLightValue(ndote);
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
			#endif // RIM_TRANSPARENCY_ENABLED
		#endif // RIM_LIGHTING_ENABLED
	#endif // defined(USE_LIGHTING)

	// 環境マップ
	#if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		// キューブマップ/スフィアマップ-PerPixel
		#if defined(CUBE_MAPPING_ENABLED)
	float3 cubeMapParams = reflect(-worldSpaceEyeDirection, worldSpaceNormal);
	float cubeMapIntensity = 1.0f - max(0.0f, ndote) * (float)CubeFresnelPower;
	//float4 cubeMapColor = h4texCUBE(CubeMapSampler, normalize(cubeMapParams.xyz)).rgba;
	float4 cubeMapColor = CubeMapSampler.Sample(CubeMapSamplerS, normalize(cubeMapParams.xyz)).rgba;
		#elif defined(SPHERE_MAPPING_ENABLED)
	float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)scene_View);
	float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
	float4 sphereMapColor = SphereMapSampler.Sample(SphereMapSamplerS, sphereMapParams.xy).rgba;
		#else
		#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	#endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
	shadingAmt = (1.0f - float3(ndote,ndote,ndote)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );
//	shadingAmt = (1 - half3(ndote)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote)) * Light0.m_colorIntensity;
	resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#elif defined(FP_PORTRAIT)
	shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#else // FP_PORTRAIT
	shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, IN, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
	#endif // FP_PORTRAIT

#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	// [PerVertex]

	#ifdef USE_LIGHTING
		#ifdef PRECALC_EVALUATE_AMBIENT
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
		#else
	float3 subLight = IN.Color1.rgb;
		#endif
	float3 diffuse = IN.ShadingAmount.rgb;
	float3 specular = IN.LightingAmount.rgb;
	#else // USE_LIGHTING
	float3 subLight = float3(0.0f, 0.0f, 0.0f);
	float3 diffuse = float3(1.0f, 1.0f, 1.0f);
	float3 specular = float3(0.0f, 0.0f, 0.0f);
	#endif // USE_LIGHTING

	float3 ambient = float3(0.0f, 0.0f, 0.0f);;

	// リムライト
	#if defined(USE_LIGHTING)

	float3 worldSpaceNormal = normalize(IN.Normal);
		#if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	//ambient = float3(0.0f, 0.0f, 0.0f);
		#else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
			#if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	//ambient = float3(0.0f, 0.0f, 0.0f);
				#define FP_NEED_AFTER_MAX_AMBIENT
			#else // NO_MAIN_LIGHT_SHADING_ENABLED
				#ifdef FP_PORTRAIT
	ambient = PortraitEvaluateAmbient(worldSpaceNormal);
				#else // FP_PORTRAIT
					#ifdef PRECALC_EVALUATE_AMBIENT
	ambient = IN.Color1.rgb;
					#else
	ambient = EvaluateAmbient(worldSpaceNormal);
					#endif
				#endif // FP_PORTRAIT
			#endif // NO_MAIN_LIGHT_SHADING_ENABLED
		#endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

		#ifdef RIM_LIGHTING_ENABLED
			#if defined(USE_FORCE_VERTEX_RIM_LIGHTING)

	float rimLightvalue = IN.ShadingAmount.a;
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED

			#else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);

				#define FP_WS_EYEDIR_EXIST
	float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

				#ifdef DOUBLE_SIDED
	if (ndote < 0.0f)
	{
		ndote *= -1.0f;
		worldSpaceNormal *= -1.0f;
	}
				#endif // DOUBLE_SIDED

	float rimLightvalue = EvaluateRimLightValue(ndote);
				#ifdef RIM_TRANSPARENCY_ENABLED
	resultColor.a *= rimLightvalue;
				#else // RIM_TRANSPARENCY_ENABLED
	ambient += rimLightvalue * (float3)RimLitColor * subLightColor;
				#endif // RIM_TRANSPARENCY_ENABLED
			#endif // defined(USE_FORCE_VERTEX_RIM_LIGHTING)

		#endif // RIM_LIGHTING_ENABLED
	#else
	ambient = float3(0.0f, 0.0f, 0.0f);
	#endif // defined(USE_LIGHTING)

//	#if defined(SHINING_MODE_ENABLED)
	#if defined(FP_SHINING)
		#if !defined(USE_LIGHTING)
	float3 worldSpaceNormal = normalize(IN.Normal);
		#endif
	float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);
		#if !defined(USE_LIGHTING)
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;//最適化できる
		#else
	shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * float3( 0.345f*3.5f, 0.875f*3.5f, 1.0f*3.5f );//最適化できる
//	shadingAmt = (1 - half3(ndote2)) * ShiningLightColor;
//	shadingAmt = (1 - half3(ndote2)) * Light0.m_colorIntensity;
		#endif
//	resultColor.rgb = dot(resultColor.rgb, half3(0.299, 0.587, 0.114));
	#else
	shadingAmt = EvaluateLightingPerVertexFP(IN, IN.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	#endif

#endif // !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)

#ifdef CUSTOM_DIFFUSE_ENABLED
	float grayscale = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
	#if NUM_LIGHTS > 0
		#ifdef LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
			#ifdef FP_PORTRAIT
	float ldotn = (float)dot(LightDirForChar, worldSpaceNormal);
			#else // FP_PORTRAIT
	float ldotn = (float)dot(Light0.m_direction, worldSpaceNormal);
			#endif // FP_PORTRAIT
	resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
		#endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
	#else
	resultColor.rgb = float3(grayscale, grayscale, grayscale);
	#endif
#endif // CUSTOM_DIFFUSE_ENABLED

#ifdef FP_NEED_AFTER_MAX_AMBIENT
	#ifdef FP_PORTRAIT
	shadingAmt = max(shadingAmt, PortraitEvaluateAmbient(worldSpaceNormal));
	#else // FP_PORTRAIT
		#if defined(USE_PER_VERTEX_LIGHTING) && defined(PRECALC_EVALUATE_AMBIENT)
	shadingAmt = max(shadingAmt, IN.Color1.rgb);
		#else
	shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
		#endif
	#endif // FP_PORTRAIT
#endif

#ifdef GAME_MATERIAL_ENABLED
	shadingAmt += (float3)GameMaterialEmission;
#endif

#if !defined(DCC_TOOL)
	#if defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
		#if defined(WATER_SURFACE_ENABLED)
			#ifndef FP_WS_EYEDIR_EXIST
	float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
			#endif // FP_WS_EYEDIR_EXIST
	float water_ndote = dot(UserClipPlane.xyz, worldSpaceEyeDirection);
	float waterAlpha = pow(1.0f - abs(water_ndote), 4.0f);
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a) + reflColor.rgb * waterAlpha * ReflectionIntensity;
	float waterGlowValue = reflColor.a + refrColor.a;
		#else // defined(WATER_SURFACE_ENABLED)
	resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
		#endif // defined(WATER_SURFACE_ENABLED)
	#endif // defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
#endif // defined(DCC_TOOL)

	// トゥーン・ハイライト-適用
	#if defined(CARTOON_SHADING_ENABLED)
		#if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			#ifdef CARTOON_HILIGHT_ENABLED
	float hilightValue = HighlightMapSampler.Sample(HighlightMapSamplerS, IN.CartoonMap.xy).r;
	float3 hilightAmt = hilightValue * HighlightIntensity * HighlightColor * subLightColor;
				#define FP_HAS_HILIGHT
			#endif // CARTOON_HILIGHT_ENABLED
		#endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	#endif // CARTOON_SHADING_ENABLED
	#ifdef FP_HAS_HILIGHT
	sublightAmount += hilightAmt;
	#endif // FP_HAS_HILIGHT

	// 影カラーシフト
#if defined(SHADOW_COLOR_SHIFT_ENABLED)
	// [Not Toon] 表面下散乱のような使い方
	float3 subLightColor2 = max(float3(1.0f,1.0f,1.0f), subLightColor * 2.0f);
	shadingAmt.rgb += (float3(1.0f,1.0f,1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * ShadowColorShift * subLightColor2;
#endif // SHADOW_COLOR_SHIFT_ENABLED

	#if defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	float3 envMapColor = ambientOcclusion;
	#else // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	float3 envMapColor = float3(1.0f, 1.0f, 1.0f);
	#endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

	// キューブマップ/スフィアマップ-適用 (非IBL)
#ifdef EMVMAP_AS_IBL_ENABLED
	// キューブマップ/スフィアマップ-適用 (IBL)
	#if defined(CUBE_MAPPING_ENABLED)
	shadingAmt.rgb	+= cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	shadingAmt.rgb	+= sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#else // EMVMAP_AS_IBL_ENABLED
	#if defined(CUBE_MAPPING_ENABLED)
	resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	#elif defined(SPHERE_MAPPING_ENABLED)
	resultColor.rgb += sphereMapColor.rgb * SphereMapIntensity * envMapColor * glossValue;
	#endif // CUBE_MAPPING_ENABLED
#endif // EMVMAP_AS_IBL_ENABLED

	shadingAmt *= ambientOcclusion;
	shadingAmt += sublightAmount;

	// 自己発光度マップ ライトやシャドウを打ち消す値という解釈
#if defined(EMISSION_MAPPING_ENABLED)
	float4 emiTex = EmissionMapSampler.Sample(EmissionMapSamplerS, IN.TexCoord.xy);
	shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r,emiTex.r,emiTex.r));
#endif // EMISSION_MAPPING_ENABLED

	// ライトの合計
	resultColor.rgb *= shadingAmt;

#if defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
#endif

	// フォグ
	//
#ifdef FOG_ENABLED
	#if !defined(FP_PORTRAIT)
		#ifdef DCC_TOOL
	EvaluateFogFP(resultColor.rgb, FogColor.rgb, IN.Color1.a);
		#else // DCC_TOOL
	EvaluateFogFP(resultColor.rgb, scene_FogColor.rgb, IN.Color1.a);
		#endif // DCC_TOOL
	#endif // !defined(FP_PORTRAIT)
#endif // FOG_ENABLED


	#if defined(SUBTRACT_BLENDING_ENABLED)
	resultColor.rgb = resultColor.rgb * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
	resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
//x	resultColor.rgb *= resultColor.a;
	#endif


	// 出力
#if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
	return resultColor;
#endif // defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
#if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
	#if !defined(ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
//		#if defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
		#if defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	float glowValue = 0.0f;

			#if defined(GLARE_MAP_ENABLED)
	glowValue += GlareMapSampler.Sample(GlareMapSamplerS, IN.TexCoord.xy).x;
			#endif
			#if defined(GLARE_HIGHTPASS_ENABLED)
	float lumi = dot(resultColor.rgb, float3(1.0f,1.0f,1.0f));
	glowValue += max(lumi - 1.0f, 0.0f);
//	glowValue += (lumi > GlowThreshold) ? 1.0h : 0.0h;
			#endif
			#if defined(GLARE_OVERFLOW_ENABLED)
	float3 glowof = max(float3(0.0f, 0.0f, 0.0f), resultColor.rgb - GlowThreshold); //GlowThreshold float3に?
	glowValue += dot(glowof, 1.0f);
			#endif

			#if defined(WATER_SURFACE_ENABLED)
	glowValue += waterGlowValue;
	return float4(resultColor.rgb, glowValue * GlareIntensity);
			#else 
	return float4(resultColor.rgb, glowValue * GlareIntensity * resultColor.a);
			#endif
		#else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#else // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)

	return float4(resultColor.rgb, 0.0f);

		#endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
//		#endif // defined(WATER_SURFACE_ENABLED) || defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
	#else // !defined(ALPHA_BLENDING_ENABLED)
	// Mayaではアルファを他の用途で使うとスウォッチの色が変になる
	return resultColor;
	#endif // !defined(ALPHA_BLENDING_ENABLED)
#endif // FP_DEFAULT || FP_DEFAULTRT

#endif // NOTHING_ENABLED

}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2

#line 2901 "Z:/data/shaders/ed8.fx"
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

// スーパー状態
#if defined(SHINING_MODE_ENABLED)
	#undef FP_DEFAULT
	#undef FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#undef FP_PORTRAIT
	#define FP_SHINING
#endif // defined(SHINING_MODE_ENABLED)

///////////////////////////////////////////////////////////////////////////////

#ifdef GLARE_EMISSION_ENABLED
float4 GlowFPShader(DefaultFPInput IN) : FRAG_OUTPUT_COLOR0
{
	#ifdef NOTHING_ENABLED
	return float4(0.0f,0.0f,0.0f,0.0f);
	#else // NOTHING_ENABLED

	float4 resultColor = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy);
	resultColor *= (float4)IN.Color0;

		#if defined(ALPHA_TESTING_ENABLED)
	clip(resultColor.a - AlphaThreshold);
		#endif // defined(ALPHA_TESTING_ENABLED)

	// フォグ
	//
		#ifdef FOG_ENABLED
			#if defined(DCC_TOOL)
	EvaluateFogFP(resultColor.rgb, FogColor.rgb, IN.Color1.a);
			#else // defined(DCC_TOOL)
	EvaluateFogFP(resultColor.rgb, scene_FogColor.rgb, IN.Color1.a);
			#endif // defined(DCC_TOOL)
		#endif // FOG_ENABLED

	return float4(resultColor.rgb, resultColor.a * GlareIntensity);

	#endif // NOTHING_ENABLED
}
#endif // GLARE_EMISSION_ENABLED


#if !defined(DCC_TOOL) && !defined(NOTHING_ENABLED) && !defined(CASTS_SHADOWS_ONLY)

	#ifdef GLARE_EMISSION_ENABLED
		#if defined(GENERATE_RELFECTION_ENABLED)
float4 GlowFPShaderRT(DefaultFPInput IN) : FRAG_OUTPUT_COLOR0
{
	// 水面下をクリップ - (Z軸回転がないとか条件をつければ oblique frustum clippingのような射影行列を加工する手法がある)
	float3 waterNorm = float3(IN.WorldPositionDepth.x, IN.WorldPositionDepth.y - UserClipPlane.w, IN.WorldPositionDepth.z);
	clip(dot(UserClipPlane.xyz, normalize(waterNorm) ));

	float4 resultColor = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy);
	resultColor *= (float4)IN.Color0;

			#if defined(ALPHA_TESTING_ENABLED)
	clip(resultColor.a - AlphaThreshold);
			#endif // defined(ALPHA_TESTING_ENABLED)

	// フォグ
	//
			#ifdef FOG_ENABLED
				#if defined(DCC_TOOL)
	EvaluateFogFP(resultColor.rgb, FogColor.rgb, IN.Color1.a);
				#else // defined(DCC_TOOL)
	EvaluateFogFP(resultColor.rgb, scene_FogColor.rgb, IN.Color1.a);
				#endif // defined(DCC_TOOL)
			#endif // FOG_ENABLED

	return float4(resultColor.rgb, resultColor.a * GlareIntensity);
}
		#endif // defined(GENERATE_RELFECTION_ENABLEDD)
	#endif // GLARE_EMISSION_ENABLED

///////////////////////////////////////////////////////////////////////////////

// エッジVP
//
	#if !defined(DCC_TOOL)
EdgeVPOutput EdgeVPShader(EdgeVPInput IN)
{
	EdgeVPOutput OUT;

	#ifdef SKINNING_ENABLED
	EvaluateSkinPositionNormalXBones(IN.SkinnableVertex, IN.SkinnableNormal, IN.SkinWeights, IN.SkinIndices);
	float3 worldSpaceNormal = normalize(IN.SkinnableNormal);
	float3 worldSpacePosition = IN.SkinnableVertex;
	OUT.Position = mul(float4(worldSpacePosition.xyz, 1.0f), scene_ViewProjection);
	#else // SKINNING_ENABLED
	OUT.Position = mul(float4(IN.Position.xyz, 1.0f), World);
	float3 worldSpacePosition = OUT.Position.xyz;
	OUT.Position = mul(float4(worldSpacePosition.xyz, 1.0f), scene_ViewProjection);	
	float3 worldSpaceNormal = normalize(mul(float4(IN.Normal.xyz, 0.0f), World).xyz);
	#endif // SKINNING_ENABLED

	// 法線方向に頂点を膨らませる(プロジェクション空間上)
	//
	float2 projSpaceNormal = mul(float4(worldSpaceNormal.xyz, 0.0), scene_ViewProjection).xy;
	projSpaceNormal = normalize(projSpaceNormal);
	

	projSpaceNormal *= OUT.Position.w;		// カメラ距離を考慮
	OUT.Position.xy += (float2)(projSpaceNormal * GameEdgeParameters.w);

	OUT.TexCoord.xyz = float3(IN.TexCoord.xy, 0.0f);

	#ifdef GAME_MATERIAL_ENABLED
	OUT.Color0 = float4(GameEdgeParameters.xyz + (float3)GameMaterialEmission, 1.0f);
	#else // GAME_MATERIAL_ENABLED
	OUT.Color0 = float4(GameEdgeParameters.xyz, 1.0f);
	#endif // GAME_MATERIAL_ENABLED

	OUT.Color0 = saturate(OUT.Color0);

	return OUT;
}

//-----------------------------------------------------------------------------
// エッジFP
//
// 非飽和加算 - [シェーダモデル1.1シングルパスで醜い加算合成の飽和をなんとかする]のやつ
float4 EvaluateAddUnsaturation(float4 color)
{
	float4 t0 = color;
	t0.rgb *= t0.a;
	float4 r0 = t0 * t0;
	r0 = r0 * r0 + float4(-0.11f,-0.11f,-0.11f, 1.0f);
	r0 = lerp(t0, r0, float4(1.0f,0.6f,0.0f,1.0f));
	float r1a = min(t0.b + 0.75f, 1.0f);
	r0.a = r1a + 1.0f * -0.75f;
	return r0;
}

float4 EdgeFPShader(EdgeFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float4 resultColor = (float4)IN.Color0;
	resultColor.a *= DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy).a;

	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
	clip(resultColor.a - AlphaThreshold);
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED

	#ifdef USE_EDGE_ADDUNSAT
	return EvaluateAddUnsaturation(resultColor);

	#else // USE_EDGE_ADDUNSAT

	return resultColor;
	#endif // USE_EDGE_ADDUNSAT
}
	#endif // defined(DCC_TOOL)

#endif // !defined(DCC_TOOL) && !defined(NOTHING_ENABLED) && !defined(CASTS_SHADOWS_ONLY)

#if !defined(DCC_TOOL) && !defined(NOTHING_ENABLED)

	#ifdef CASTS_SHADOWS

///////////////////////////////////////////////////////////////////////////////
// シャドウVP(テクスチャなし)
//
DepthVPOutput ShadowVPShader(DepthVPInput IN)
{
	DepthVPOutput OUT;
	// Get position.
		#ifdef SKINNING_ENABLED
	float3 position = IN.SkinnableVertex.xyz;
		#else //! SKINNING_ENABLED
	float3 position = IN.Position.xyz;
		#endif //! SKINNING_ENABLED

		#ifdef SKINNING_ENABLED
	float4 skinIndices = IN.SkinIndices;
	float4 skinWeights = IN.SkinWeights;

	EvaluateSkinPositionXBones(position.xyz, skinWeights, skinIndices);

			#ifdef WINDY_GRASS_ENABLED
				#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
	position = calcWindyGrass(position.xyz, IN.TexCoord.y);
				#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	position = calcWindyGrass(position.xyz);
				#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED

			#endif // WINDY_GRASS_ENABLED

	OUT.Position = mul(float4(position.xyz,1.0f), scene_ViewProjection);

		#else  // SKINNING_ENABLED

			#ifdef WINDY_GRASS_ENABLED
	float3 worldSpacePosition = mul(float4(IN.Position.xyz,1.0f), World).xyz;
				#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, IN.TexCoord.y);
				#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
				#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	OUT.Position = mul(float4(worldSpacePosition.xyz,1.0f), scene_ViewProjection);

			#else // WINDY_GRASS_ENABLED

	OUT.Position = mul(float4(IN.Position.xyz,1.0f), WorldViewProjection);

			#endif // WINDY_GRASS_ENABLED

		#endif // SKINNING_ENABLED

	return OUT;
}

//-----------------------------------------------------------------------------
// シャドウFP(テクスチャなし)
//
float4 ShadowFPShader(DepthVPOutput IN) : FRAG_OUTPUT_COLOR0
{
	return float4(0.0f, 0.0f, 0.0f, 0.0f);
}

///////////////////////////////////////////////////////////////////////////////
// シャドウVP(テクスチャあり)
//
ShadowTexturedVPOutput ShadowTexturedVPShader(ShadowTexturedVPInput IN)
{
	ShadowTexturedVPOutput OUT = (ShadowTexturedVPOutput)0;	

	// Get position.
		#ifdef SKINNING_ENABLED
	float3 position = IN.SkinnableVertex.xyz;
		#else //! SKINNING_ENABLED
	float3 position = IN.Position.xyz;
		#endif //! SKINNING_ENABLED

		#ifdef SKINNING_ENABLED
	float4 skinIndices = IN.SkinIndices;
	float4 skinWeights = IN.SkinWeights;

	EvaluateSkinPositionXBones(position.xyz, skinWeights, skinIndices);

			#ifdef WINDY_GRASS_ENABLED
				#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
	position = calcWindyGrass(position.xyz, IN.TexCoord.y);
				#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	position = calcWindyGrass(position.xyz);
				#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
			#endif // WINDY_GRASS_ENABLED

	OUT.Position = mul(float4(position.xyz,1.0f), scene_ViewProjection);

		#else  // SKINNING_ENABLED

			#ifdef WINDY_GRASS_ENABLED
	float3 worldSpacePosition = mul(float4(IN.Position.xyz,1.0f), World).xyz;
				#ifndef WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, IN.TexCoord.y);
				#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
				#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	OUT.Position = mul(float4(worldSpacePosition.xyz,1.0f), scene_ViewProjection);

			#else // WINDY_GRASS_ENABLED

	OUT.Position = mul(float4(IN.Position.xyz,1.0f), WorldViewProjection);

			#endif // WINDY_GRASS_ENABLED

		#endif // SKINNING_ENABLED

		#ifndef UVA_SCRIPT_ENABLED
	OUT.TexCoord.xy = IN.TexCoord.xy;
			#ifdef TEXCOORD_OFFSET_ENABLED
	OUT.TexCoord.xy += (float2)(TexCoordOffset * getGlobalTextureFactor());
			#endif // TEXCOORD_OFFSET_ENABLED
			#ifdef GAME_MATERIAL_ENABLED
	OUT.TexCoord.xy += (float2)GameMaterialTexcoord.xy;
			#endif // GAME_MATERIAL_ENABLED
		#else // UVA_SCRIPT_ENABLED
			#ifdef GAME_MATERIAL_ENABLED
	OUT.TexCoord.xy = IN.TexCoord.xy * (float2)GameMaterialTexcoord.zw + (float2)GameMaterialTexcoord.xy;
			#else // GAME_MATERIAL_ENABLED
	OUT.TexCoord.xy = IN.TexCoord.xy;
			#endif // GAME_MATERIAL_ENABLED
		#endif // UVA_SCRIPT_ENABLED

	return OUT;
}

//-----------------------------------------------------------------------------
// シャドウFP(テクスチャあり)
//
float4 ShadowTexturedFPShader(ShadowTexturedVPOutput IN/*, float4 ScreenPosition : WPOS*/) : FRAG_OUTPUT_COLOR0
{
		#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
	float4 diffuseAmt = DiffuseMapSampler.Sample(DiffuseMapSamplerS, IN.TexCoord.xy);
	clip(diffuseAmt.a - AlphaThreshold);
		#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
	return 0;
}
	#endif // CASTS_SHADOWS

#endif // !defined(DCC_TOOL) && !defined(NOTHING_ENABLED)

///////////////////////////////////////////////////////////////////////////////
// Techniques
#define GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES	\
	string VpIgnoreContextSwitches[] = {""};	\
	string FpIgnoreContextSwitches[] = {"INSTANCING_ENABLED"};

#if !defined(DCC_TOOL) && defined(CASTS_SHADOWS_ONLY)
#else

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// State blocks
BlendState NoBlend 
{
  BlendEnable[0] = FALSE;
};

//BlendEnable = true;
//BlendFunc = {srcAlpha,oneMinusSrcAlpha};
//ColorMask = bool4(true,true,true,true);
BlendState LinearBlend 
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = SRC_ALPHA;
	DestBlend[0] = INV_SRC_ALPHA;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = MAX;
};

BlendState OneInvSrcAlphaBlend 
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = ONE;
	DestBlend[0] = INV_SRC_ALPHA;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = MAX;
};

BlendState SrcAlphaOneBlend 
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = SRC_ALPHA;
	DestBlend[0] = ONE;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = MAX;
};

BlendState ZeroInvSrcColorBlend 
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = ZERO;
	DestBlend[0] = INV_SRC_COLOR;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = MAX;
};

BlendState SrcAlphaOneMinusSrcAlphaBlend 
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = SRC_ALPHA;
	DestBlend[0] = INV_SRC_ALPHA;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = MAX;
};

BlendState NoColourBlend 
{
	BlendEnable[0] = FALSE;
};

DepthStencilState DepthState {
  DepthEnable = TRUE;
  DepthWriteMask = All;
  DepthFunc = Less;
  StencilEnable = FALSE; 
};

DepthStencilState DepthStateLessEqu {
  DepthEnable = TRUE;
  DepthWriteMask = All;
  DepthFunc = LESS_EQUAL;
  StencilEnable = FALSE; 
};

DepthStencilState DepthStateNOMask {
  DepthEnable = TRUE;
  DepthWriteMask = Zero;
  DepthFunc = Less;
  StencilEnable = FALSE; 
};

RasterizerState DefaultRasterState 
{
	CullMode = None;
};

RasterizerState CullRasterState 
{
	CullMode = Front;
};

RasterizerState ReverseCullRasterState 
{
	CullMode = Back;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
//-----------------------------------------------------------------------------
// 通常
#if !defined(ALPHA_BLENDING_ENABLED) || defined(TWOPASS_ALPHA_BLENDING_ENABLED)

	#if defined(WATER_SURFACE_ENABLED) && !defined(DCC_TOOL)
technique11 DefaultWaterSurface
<
	string PhyreRenderPass = "OpaqueReflection";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
	#else // defined(WATER_SURFACE_ENABLED) && !defined(DCC_TOOL)

		#if defined(DCC_TOOL)
technique11 Default
<
		#else // defined(DCC_TOOL)
			#ifndef ALPHA_TESTING_ENABLED
				#ifdef UNDER_WATER_ENABLED
technique11 UnderWaterDefault //Opaque
<
				#else // UNDER_WATER_ENABLED
					#ifdef CARTOON_SHADING_ENABLED
technique11 OpaqueChr //Opaque
<
					#else // CARTOON_SHADING_ENABLED
technique11 Default //Opaque
<
					#endif // CARTOON_SHADING_ENABLED
				#endif // UNDER_WATER_ENABLED

			#else // ALPHA_TESTING_ENABLED
				#ifdef UNDER_WATER_ENABLED
technique11 UnderWaterOpaqueAlphaTest
<
				#else // UNDER_WATER_ENABLED
					#ifdef CARTOON_SHADING_ENABLED
technique11 OpaqueChrAlphaTest
<
					#else // CARTOON_SHADING_ENABLED
technique11 OpaqueAlphaTest
<
					#endif // CARTOON_SHADING_ENABLED
				#endif // UNDER_WATER_ENABLED
			#endif // ALPHA_TESTING_ENABLED
		#endif // defined(DCC_TOOL)

		#ifdef UNDER_WATER_ENABLED
			#ifndef ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "UnderWaterOpaque";
			#else // ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "UnderWaterOpaqueAlphaTest";
			#endif // ALPHA_TESTING_ENABLED
		#else // UNDER_WATER_ENABLED
			#ifndef ALPHA_TESTING_ENABLED
				#ifdef CARTOON_SHADING_ENABLED
	string PhyreRenderPass = "OpaqueChr";
				#else // CARTOON_SHADING_ENABLED
	string PhyreRenderPass = "Opaque";
				#endif // CARTOON_SHADING_ENABLED
			#else // ALPHA_TESTING_ENABLED
				#ifdef CARTOON_SHADING_ENABLED
	string PhyreRenderPass = "OpaqueChrAlphaTest";
				#else // CARTOON_SHADING_ENABLED
	string PhyreRenderPass = "OpaqueAlphaTest";
				#endif // CARTOON_SHADING_ENABLED
			#endif // ALPHA_TESTING_ENABLED
		#endif // UNDER_WATER_ENABLED

	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
	#endif // defined(WATER_SURFACE_ENABLED) && !defined(DCC_TOOL)

{
	pass pass0
	{		
		SetVertexShader( CompileShader( ED8_PROFILE_VP, DefaultVPShader() ) );
	#ifdef GLARE_EMISSION_ENABLED
		SetPixelShader( CompileShader( ED8_PROFILE_FP, GlowFPShader() ) );
	#else // GLARE_EMISSION_ENABLED
		SetPixelShader( CompileShader( ED8_PROFILE_FP, DefaultFPShader() ) );
	#endif // GLARE_EMISSION_ENABLED
	
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
	#ifdef DOUBLE_SIDED
		SetRasterizerState( DefaultRasterState );	
	#else // DOUBLE_SIDED
		SetRasterizerState( CullRasterState );	
	#endif // DOUBLE_SIDED
	}
}
#endif // !defined(ALPHA_BLENDING_ENABLED) || defined(TWOPASS_ALPHA_BLENDING_ENABLED)

#if defined(ALPHA_BLENDING_ENABLED) || defined(TWOPASS_ALPHA_BLENDING_ENABLED)

	#if defined(TWOPASS_ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
technique11 TransparentNDM
<
	string PhyreRenderPass = "TransparentNoDepthMask";
			#define USE_TRANSPARENT_NODEPTHMASK
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
	#elif defined(USE_EXTRA_BLENDING) && !defined(DCC_TOOL)
technique11 TransparentNDM2
<
	string PhyreRenderPass = "TransparentNoDepthMask";
			#define USE_TRANSPARENT_NODEPTHMASK
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
	#else

		#if defined(DCC_TOOL)
technique11 Default
<
		#else // defined(DCC_TOOL)
			#if defined(USE_EXTRA_BLENDING)
				#ifdef UNDER_WATER_ENABLED
technique11 UnderWaterTransparentNoDepthMask
<
				#else // UNDER_WATER_ENABLED
technique11 TransparentNoDepthMask
<
				#endif // UNDER_WATER_ENABLED
			#else // defined(USE_EXTRA_BLENDING)
				#ifdef UNDER_WATER_ENABLED
technique11 UnderWaterTransparent
<
				#else // UNDER_WATER_ENABLED
technique11 Transparent
<
				#endif // UNDER_WATER_ENABLED
			#endif // defined(USE_EXTRA_BLENDING)
		#endif // defined(DCC_TOOL)

		#ifdef UNDER_WATER_ENABLED
			#if defined(USE_EXTRA_BLENDING)
	string PhyreRenderPass = "UnderWaterTransparentNoDepthMask";
				#define USE_TRANSPARENT_NODEPTHMASK
			#else // defined(USE_EXTRA_BLENDING)
	string PhyreRenderPass = "UnderWaterTransparent";
			#endif // defined(USE_EXTRA_BLENDING)
		#else // UNDER_WATER_ENABLED
			#if defined(USE_EXTRA_BLENDING)
	string PhyreRenderPass = "TransparentNoDepthMask";
				#define USE_TRANSPARENT_NODEPTHMASK
			#else // defined(USE_EXTRA_BLENDING)

	string PhyreRenderPass = "Transparent";
			#endif // defined(USE_EXTRA_BLENDING)
		#endif // UNDER_WATER_ENABLED

	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
		#if defined(USE_EXTRA_BLENDING)
			#define USE_TRANSPARENT_NODEPTHMASK
		#endif // defined(USE_EXTRA_BLENDING)
	#endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED) && !defined(DCC_TOOL)
{
	pass pass0
	{
	//#if defined(GLARE_EMISSION_ENABLED) || defined(DCC_TOOL)
	//	ColorMask = bool4(true,true,true,true);
	//#else // 
	//	ColorMask = bool4(true,true,true,false);
	//#endif // 

		
		SetVertexShader( CompileShader( ED8_PROFILE_VP, DefaultVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, DefaultFPShader() ) );
		
	#ifdef ADDITIVE_BLENDING_ENABLED
		//BlendFunc = {srcAlpha, one};	// 加算
		SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#elif defined(SUBTRACT_BLENDING_ENABLED)
		//BlendFunc = {zero, invSrcColor};	// 減算
		SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
		//BlendFunc = {zero, invSrcColor};	// 乗算
		SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#else
		//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
		SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#endif
		
	#ifndef USE_TRANSPARENT_NODEPTHMASK
		//DepthMask = true;
		SetDepthStencilState( DepthState, 0);
	#else // USE_TRANSPARENT_NODEPTHMASK
		//DepthMask = false;
		SetDepthStencilState( DepthStateNOMask, 0);
	#endif // USE_TRANSPARENT_NODEPTHMASK
		
	#ifdef DOUBLE_SIDED
		SetRasterizerState( DefaultRasterState );	
	#else // DOUBLE_SIDED
		SetRasterizerState( CullRasterState );	
	#endif 

	}
}
#endif // defined(ALPHA_BLENDING_ENABLED) || defined(TWOPASS_ALPHA_BLENDING_ENABLED)


#ifndef HAS_TRANSPARENT

technique11 ForceTransparent
<
	string PhyreRenderPass = "ForceTransparent";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
	//#if defined(GLARE_EMISSION_ENABLED) || defined(DCC_TOOL)
	//	ColorMask = bool4(true,true,true,true);
	//#else // 
	//	ColorMask = bool4(true,true,true,true);
	//#endif // 

		SetVertexShader( CompileShader( ED8_PROFILE_VP, DefaultVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, ForceTransparentFPShader() ) );
		
	#ifdef ADDITIVE_BLENDING_ENABLED
		//BlendFunc = {srcAlpha, one};	// 加算
		SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#elif defined(SUBTRACT_BLENDING_ENABLED)
		//BlendFunc = {zero, invSrcColor};	// 減算
		SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
		//BlendFunc = {zero, invSrcColor};	// 乗算
		SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#else
		//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
		SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
	#endif

	#ifndef USE_TRANSPARENT_NODEPTHMASK
		//DepthMask = true;
		SetDepthStencilState( DepthState, 0);
	#else // USE_TRANSPARENT_NODEPTHMASK
		//DepthMask = false;
		SetDepthStencilState( DepthStateNOMask, 0);
	#endif // USE_TRANSPARENT_NODEPTHMASK
	
	#ifdef DOUBLE_SIDED
		SetRasterizerState( DefaultRasterState );	
	#else // DOUBLE_SIDED
		SetRasterizerState( CullRasterState );	
	#endif 
	}
}

	//<<-----------------------------------------------------------------------------
	#ifdef FOR_EFFECT
		//エフェクト用(場合によっては汎用にしても可) Z書き込みなし
		//エフェクト汎用(ブレンドなどはプログラム側から制御)
		technique11 ForceTransparent_forEffect
		<
			string PhyreRenderPass = "ForceTransparent_forEffect";
			GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
		>
		{
			pass pass0
			{		
				SetVertexShader( CompileShader( ED8_PROFILE_VP, DefaultVPShader() ) );
				SetPixelShader( CompileShader( ED8_PROFILE_FP, ForceTransparentFPShader() ) );
				
			#ifdef ADDITIVE_BLENDING_ENABLED
				//BlendFunc = {srcAlpha, one};	// 加算
				SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
			#elif defined(SUBTRACT_BLENDING_ENABLED)
				//BlendFunc = {zero, invSrcColor};	// 減算
				SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
			#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
				//BlendFunc = {zero, invSrcColor};	// 乗算
				SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
			#else
				//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
				SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
			#endif
			
				SetDepthStencilState( DepthStateNOMask, 0);
			}
		}
	#endif //FOR_EFFECT
	//>>-----------------------------------------------------------------------------


#endif // HAS_TRANSPARENT

#endif // !defined(DCC_TOOL) && defined(CASTS_SHADOWS_ONLY)

#if !defined(DCC_TOOL) && !defined(NOTHING_ENABLED) && !defined(CASTS_SHADOWS_ONLY)

//-----------------------------------------------------------------------------
// 通常-レンダリングターゲット用
	#if defined(GENERATE_RELFECTION_ENABLED)
		#if !defined(ALPHA_BLENDING_ENABLED)
technique11 DefaultRT
<
			#ifndef ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "OpaqueRT";
			#else // ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "OpaqueAlphaTestRT";
			#endif // ALPHA_TESTING_ENABLED
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,true);
	
		SetVertexShader( CompileShader( ED8_PROFILE_VP, DefaultVPShader() ) );
		#ifdef GLARE_EMISSION_ENABLED
			SetPixelShader( CompileShader( ED8_PROFILE_FP, GlowFPShaderRT() ) );
		#else // GLARE_EMISSION_ENABLED
			SetPixelShader( CompileShader( ED8_PROFILE_FP, DefaultFPShaderRT() ) );
		#endif // GLARE_EMISSION_ENABLED
		
		SetBlendState( NoColourBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}
		#endif // !defined(ALPHA_BLENDING_ENABLED)

		#if defined(ALPHA_BLENDING_ENABLED)
technique11 DefaultRT
<
	string PhyreRenderPass = "TransparentRT";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,false);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, DefaultVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, DefaultFPShaderRT() ) );
		
		#ifdef ADDITIVE_BLENDING_ENABLED
			//BlendFunc = {srcAlpha, one};	// 加算
			SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(SUBTRACT_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 減算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 乗算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#else
			//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
			SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#endif
		
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}
		#endif // defined(ALPHA_BLENDING_ENABLED)
	#endif // defined(GENERATE_RELFECTION_ENABLED)



//-----------------------------------------------------------------------------
// 通常-立ち絵用
	#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
		#if !defined(ALPHA_BLENDING_ENABLED)
technique11 PortraitOpaque
<
			#ifndef ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "PortraitOpaque";
			#else // ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "PortraitOpaqueAlphaTest";
			#endif // ALPHA_TESTING_ENABLED
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,true);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, PortraitVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
		
		SetBlendState( NoColourBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}
		#else // defined(ALPHA_BLENDING_ENABLED)

technique11 PortraitTransparent
<
	string PhyreRenderPass = "PortraitTransparent";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,true);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, PortraitVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
		
		
		#ifdef ADDITIVE_BLENDING_ENABLED
			//BlendFunc = {srcAlpha, one};	// 加算
			SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(SUBTRACT_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 減算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 乗算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#else
			//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
			SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#endif
		
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}
		#endif // defined(ALPHA_BLENDING_ENABLED)

technique11 PortraitForceTransparent
<
	string PhyreRenderPass = "PortraitForceTransparent";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,true);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, PortraitVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
		
		#ifdef ADDITIVE_BLENDING_ENABLED
			//BlendFunc = {srcAlpha, one};	// 加算
			SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(SUBTRACT_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 減算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 乗算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#else
			//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
			SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#endif
		
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}

	#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

//-----------------------------------------------------------------------------
// シャイニングモード
	#if defined(SHINING_MODE_ENABLED)

		#if !defined(ALPHA_BLENDING_ENABLED)
technique11 ShiningOpaque
<
			#ifndef ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "ShiningOpaque";
			#else // ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "ShiningOpaqueAlphaTest";
			#endif // ALPHA_TESTING_ENABLED
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,true);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, PortraitVPShader() ) );
		#ifdef FP_SHINING
			SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
			//SetPixelShader( CompileShader( ED8_PROFILE_FP, ShiningFPShader() ) );
		#else
			SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
		#endif
		
		SetBlendState( NoColourBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}
		#else // defined(ALPHA_BLENDING_ENABLED)

technique11 ShiningTransparent
<
	string PhyreRenderPass = "ShiningTransparent";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,true);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, PortraitVPShader() ) );
		#ifdef FP_SHINING
			SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
			//SetPixelShader( CompileShader( ED8_PROFILE_FP, ShiningFPShader() ) );
		#else
			SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
		#endif
		
		#ifdef ADDITIVE_BLENDING_ENABLED
			//BlendFunc = {srcAlpha, one};	// 加算
			SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(SUBTRACT_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 減算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 乗算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#else
			//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
			SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#endif
		
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}
		#endif // defined(ALPHA_BLENDING_ENABLED)

technique11 ShiningForceTransparent
<
	string PhyreRenderPass = "ShiningForceTransparent";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,true);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, PortraitVPShader() ) );
		#ifdef FP_SHINING
			SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
			//SetPixelShader( CompileShader( ED8_PROFILE_FP, ShiningFPShader() ) );
		#else
			SetPixelShader( CompileShader( ED8_PROFILE_FP, PortraitFPShader() ) );
		#endif
		
		#ifdef ADDITIVE_BLENDING_ENABLED
			//BlendFunc = {srcAlpha, one};	// 加算
			SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(SUBTRACT_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 減算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
			//BlendFunc = {zero, invSrcColor};	// 乗算
			SetBlendState( ZeroInvSrcColorBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#else
			//BlendFunc = {srcAlpha, oneMinusSrcAlpha};	// α合成
			SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#endif
		
		SetDepthStencilState( DepthState, 0);
		
		#ifdef DOUBLE_SIDED
			SetRasterizerState( DefaultRasterState );	
		#else // DOUBLE_SIDED
			SetRasterizerState( CullRasterState );	
		#endif 
	}
}
	#endif // defined(SHINING_MODE_ENABLED)

//-----------------------------------------------------------------------------
// エッジ
	#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)

technique11 EdgeOpaque
<
	string PhyreRenderPass = "EdgeOpaque";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
	#else  // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
technique11 EdgeTransparent
<
	string PhyreRenderPass = "EdgeTransparent";
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
	#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED

{
	pass pass0
	{
		//ColorMask = bool4(true,true,true,false);

		SetVertexShader( CompileShader( ED8_PROFILE_VP, EdgeVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, EdgeFPShader() ) );
		
		#ifdef USE_EDGE_ADDUNSAT
			//BlendFunc = {one, invSrcAlpha};
			SetBlendState( OneInvSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#else // USE_EDGE_ADDUNSAT
			//BlendFunc = {srcAlpha, one};	// 加算
			SetBlendState( SrcAlphaOneBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		#endif // USE_EDGE_ADDUNSAT
		
		SetDepthStencilState( DepthState, 0);
		
		//CullFace = front;
		SetRasterizerState( ReverseCullRasterState );
	}
}

#endif // !defined(DCC_TOOL) && !defined(NOTHING_ENABLED) && !defined(CASTS_SHADOWS_ONLY)

#if !defined(DCC_TOOL) && !defined(NOTHING_ENABLED)

//-----------------------------------------------------------------------------

	
RasterizerState ShadowRenderingRasterState {
	CullMode = None;
	SlopeScaledDepthBias = 0.5f;
};

RasterizerState ShadowRenderingRasterStateCull {
	CullMode = Back;
	SlopeScaledDepthBias = 0.5f;
};


	#ifdef CASTS_SHADOWS
		#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
technique11 ShadowTransparent
		#else // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
technique11 Shadow
		#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
<
		#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
	string PhyreRenderPass = "ShadowTransparent";
		#else // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
	string PhyreRenderPass = "Shadow";
		#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
//	string VpIgnoreContextSwitches[] = {"NUM_LIGHTS"};
//	string FpIgnoreContextSwitches[] = {"NUM_LIGHTS"};
	GENERIC_VPFP_IGNORE_CONTEXT_SWITCHES
>
{
	pass p0
	{		
		#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
			SetVertexShader( CompileShader( ED8_PROFILE_VP, ShadowTexturedVPShader() ) );
			SetPixelShader( CompileShader( ED8_PROFILE_FP, ShadowTexturedFPShader() ) );
		#else  // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
			SetVertexShader( CompileShader( ED8_PROFILE_VP, ShadowVPShader() ) );
			SetPixelShader( CompileShader( ED8_PROFILE_FP, ShadowFPShader() ) );
		#endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
		
			
#if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED) || defined(DOUBLE_SIDED) || defined(SHDOW_DOUBLE_SIDED)
		SetRasterizerState(ShadowRenderingRasterState);
#else // defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED) || defined(DOUBLE_SIDED) || defined(SHDOW_DOUBLE_SIDED)
		SetRasterizerState(ShadowRenderingRasterStateCull);
#endif // defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED) || defined(DOUBLE_SIDED) || defined(SHDOW_DOUBLE_SIDED)
	}
}
	#endif // CASTS_SHADOWS

#endif // !defined(DCC_TOOL) && !defined(NOTHING_ENABLED)