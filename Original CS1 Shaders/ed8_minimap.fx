#line 1 "Z:/data/shaders/ed8_minimap.fx"
//------------------------------------------------------------------------------
// ミニマップ用シェーダー
//------------------------------------------------------------------------------


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

#line 6 "Z:/data/shaders/ed8_minimap.fx"

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

#line 8 "Z:/data/shaders/ed8_minimap.fx"

#define UINAME_MinimapTextureSampler		"Texutre"

//#define USE_MINIMAP_EDGE
#define USE_VECTOR_PROCESS

float4x4 WorldViewProjection	: WorldViewProjection;
float4x4 World					: World;

#ifndef DCC_TOOL
	float3	lookPosition = {0,0,0};	//ミニマップの注目点(エリアマップ表示時にユーザーが変更可能)
	float4	inputSpecular= {0,0,0,0};
	float2  inputShift   = {0,0};	//縁取り用スライド幅
	float2  inputHeight  = {3,8};	//半透明化する高さ(3~8)で透明になり0となる
	float	inputColorShiftHeight = 50.f;	//マップの高低差で色を変える
#endif

//------------------------------------------------------------------------------
// ディフューズテクスチャ 
//------------------------------------------------------------------------------
Texture2D<float4> MinimapTextureSampler
<
	string UIName = UINAME_MinimapTextureSampler;
>;


//------------------------------------------------------------------------------
// 入力頂点
//------------------------------------------------------------------------------
struct MinimapVPInput
{
	float4 Position		: POSITION;
	float3  viNormal	: NORMAL;
	float2 viTexCoord	: TEXCOORD0;
	float4  viColor		: COLOR0;
};

//------------------------------------------------------------------------------
// 出力頂点
//------------------------------------------------------------------------------
struct MinimapVPOutput
{
	float4 Position			: SV_Position ;		// xyzw:[Proj]射影座標
	float4 Color0			: COLOR0;		// xyzw:
	float2 TexCoord			: TEXCOORD0;	// xy: テクスチャ座標
};

#ifdef USE_MINIMAP_EDGE
// ä»®Edge
struct MinimapEdgeVPOutput
{
	float4 Position			: SV_Position ;		// xyzw:[Proj]射影座標
};
#endif // USE_MINIMAP_EDGE

//------------------------------------------------------------------------------
// 頂点シェーダー
//------------------------------------------------------------------------------
MinimapVPOutput MinimapVPShader(MinimapVPInput IN)
{
	MinimapVPOutput OUT;

	float4 worldSpacePosition = mul(float4(IN.Position.xyz,1.0f), World);
	float4 pos                = mul(float4(IN.Position.xyz,1.0f), WorldViewProjection);

#ifndef DCC_TOOL
	pos.xy      += inputShift;
#endif

	float4 color = IN.viColor;

#ifndef DCC_TOOL	//高さで透明度を変更

	float dy    = worldSpacePosition.y - lookPosition.y;
	float dh    = clamp(inputHeight.y-inputHeight.x, 0.0001f, 100.f);	//0除算しないように最低値を入れておく

	dy          = abs(dy);	//高さの差

	#ifndef USE_VECTOR_PROCESS

		//高さによって色を変える(立体交差や重なりを分かりやすくする)
		float dyc   = 1.f - (dy / inputColorShiftHeight);
		float dark1  = clamp( dyc, 0.5f, 1.f );
	    color.xyz  *= dark1;
	
		//高さによって透明度を変える
	//	dy          = 1.f - ((dy-3.f) / 7.f);		//消える高さは 3+7
		dy          = 1.f - ((dy-inputHeight.x) / dh);		//消える高さは 3+7
		float  dark  = clamp( dy, 0.0f, 1.f );
		color.w    *= dark;
	//	color.xyz  *= dark;
	

		//坂を分かりやすくする
		float dd    = clamp( IN.viNormal.y, 0.5f, 1.f);	//垂直な坂(ハシゴ)で黒くならないように。
		color.xyz  *= dd;

	#else // USE_VECTOR_PROCESS

		// ↑をベクトル処理
		float2 tmp = clamp(float2(1.0f, 1.0f) - float2(dy, dy-inputHeight.x) / float2(inputColorShiftHeight, dh), float2(0.5f, 0.0f), float2(1.0f, 1.0f));
		color *= (float4)tmp.xxxy;
		color.xyz *= (float3)clamp( IN.viNormal.y, 0.5f, 1.f );//垂直な坂(ハシゴ)で黒くならないように。

	#endif // USE_VECTOR_PROCESS

#endif

	OUT.Position = pos;
	OUT.Color0   = color;
	OUT.TexCoord = IN.viTexCoord;
	return OUT;
};

#ifdef USE_MINIMAP_EDGE
MinimapEdgeVPOutput MinimapEdgeVPShader(MinimapVPInput IN)
{
	MinimapEdgeVPOutput OUT;
	
	float4 localPos = float4(IN.Position.xyz,1.0f);
	localPos.xz *= 1.03f;
	localPos.xyz += normalize(IN.viNormal.xyz) * -0.10f;
	localPos.y -= 0.10f;

	float4 worldSpacePosition = mul(localPos, World);
	float4 pos                = mul(localPos, WorldViewProjection);

	#ifndef DCC_TOOL
	pos.xy      += inputShift;
	#endif
	OUT.Position = pos;
	return OUT;
}
#endif // USE_MINIMAP_EDGE

//------------------------------------------------------------------------------
// 入力ピクセル
//------------------------------------------------------------------------------
#define MinimapFPInput MinimapVPOutput
/*
struct MinimapFPInput
{
	float4 Color0			: COLOR0;
	float2 TexCoord			: TEXCOORD0;	// xy: テクスチャ座標
};
*/
#ifdef USE_MINIMAP_EDGE
// ä»®Edge
struct MinimapEdgeFPInput
{
	float4 Color0			: COLOR0;
};
#endif // USE_MINIMAP_EDGE

//------------------------------------------------------------------------------
// フラグメントシェーダー
//------------------------------------------------------------------------------
float4 MinimapFPShader(MinimapFPInput IN) : FRAG_OUTPUT_COLOR0
{	
	float4 color = MinimapTextureSampler.SampleLevel(MinimapTextureSamplerS, IN.TexCoord.xy, 0);
	color *= IN.Color0;

#ifndef DCC_TOOL	//スペキュラー(なんちゃってエッジ描画用)
	color.xyz += inputSpecular.xyz;
#endif
	return color;
}

#ifdef USE_MINIMAP_EDGE
// ä»®Edge
float4 MinimapEdgeFPShader(MinimapEdgeFPInput IN) : FRAG_OUTPUT_COLOR0
{	
	return (half4)IN.Color0;
}
#endif // USE_MINIMAP_EDGE

//------------------------------------------------------------------------------

BlendState NoBlend 
{
  AlphaToCoverageEnable = FALSE;
  BlendEnable[0] = FALSE;
};
BlendState AdditiveBlend 
{
    AlphaToCoverageEnable = FALSE;
	BlendEnable[0] = TRUE;
	SrcBlend[0] = ONE;
	DestBlend[0] = ONE;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = ADD;
	BlendEnable[1] = FALSE;
	RenderTargetWriteMask[0] = 15;
};
DepthStencilState DepthState {
  DepthEnable = FALSE;
  DepthWriteMask = All;
  DepthFunc = Less;
  StencilEnable = FALSE; 
};

RasterizerState DefaultRasterState 
{
	CullMode = None;
	FillMode = solid;
	DepthBias = 0;
	ScissorEnable = false;
};

//------------------------------------------------------------------------------
// ミニマップ描画用テクニック
//------------------------------------------------------------------------------
technique11 Minimap
<
	string PhyreRenderPass = "Transparent";			//半透明                   PhyreEngine側で用意されたものしか使えない
>
{
	pass pass0
	{		
		SetVertexShader( CompileShader( ED8_PROFILE_VP, MinimapVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, MinimapFPShader() ) );
		
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	
	}
#ifdef USE_MINIMAP_EDGE
	pass pass1
	{
		SetVertexShader( CompileShader( ED8_PROFILE_VP, MinimapEdgeVPShader() ) );
		SetPixelShader( CompileShader( ED8_PROFILE_FP, MinimapEdgeFPShader() ) );
		
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	
	}
#endif // USE_MINIMAP_EDGE
}