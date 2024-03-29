#line 1 "Z:/data/shaders/postfx.fx"
// このファイルはUTF-8コードで保存してください。


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

#line 4 "Z:/data/shaders/postfx.fx"

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

#line 6 "Z:/data/shaders/postfx.fx"

#define INVSCREENUV float2(IN.ScreenUv.x, 1.f-IN.ScreenUv.y)

// Fullscreen
Texture2D <float4> ColorBuffer;
Texture2D <float4> DepthBuffer;

// Final
Texture2D <float4> GlareBuffer;
Texture2D <float4> FocusBuffer;
Texture2D <float4> FilterTexture;
Texture2D <float4> FadingTexture;

SamplerState LinearClampSampler
{
	Filter = Min_Mag_Linear_Mip_Point;
    AddressU = Clamp;
    AddressV = Clamp;
};

float4 FilterColor = { 1.0, 1.0, 1.0, 1.0 };	// 加算フィルタ RGB:色 A:強さ
float4 FadingColor = { 1.0, 1.0, 1.0, 1.0 };	// フェードフィルタ RGB:色 A:補間
float4 MonotoneMul = { 1.0, 1.0, 1.0, 1.0 };	// モノトーンフィルタ RGB:色 A:補間
float4 MonotoneAdd   = { 0.0, 0.0, 0.0, 0.0 };	// モノトーンフィルタ RGB:色 A:-
float4 GlowIntensity = { 1.0, 1.0, 1.0, 1.0 };
float4 ToneFactor = { 1.0, 1.0, 1.0, 1.0 };
float4 UvScaleBias = { 1.0, 1.0, 0.0, 0.0 };	// XY:uvのスケール値、ZW:uvのバイアス値
float4 GaussianBlurParams = { 0.0, 0.0, 0.0, 0.0 };		// XY:ソース画像のサイズ ZW:未使用
float4 DofParams = { 0.0, 0.0, 0.0, 0.0 };		// X:cameraFar/(cameraFar-cameraNear) Y:1/cameraFar Z:合焦距離 W:1/(被写界深度の最奥距離 - 合焦距離)
float4 GammaParameters = { 2.20f/2.20f, 1.0, 1.0, 0 };	// DeGamma/Gamma, 画面のスケール(X), 画面のスケール(Y), -
float4 WhirlPinchParams = { 0.0, 0.0, 0.0, 0.0 };

struct FullscreenVPInput
{
	float3 ScreenVertex		: POSITION;
	float2 ScreenUv			: TEXCOORD0;
};

struct FullscreenVPOutput
{
	float4 ScreenPosition	: SV_Position;
	float2 ScreenUv			: TEXCOORD0;
};

#define FullscreenFPInput FullscreenVPOutput
/*
struct FullscreenFPInput
{
	float4 ScreenPosition	: SV_Position;
	float2 ScreenUv			: TEXCOORD0;
};
*/


struct FullscreenGaussianBlurVPOutput
{
	float4 ScreenPosition	: SV_Position;
	float2 ScreenUv			: TEXCOORD0;
	float2 BlurUv0			: TEXCOORD1;
	float2 BlurUv1			: TEXCOORD2;
	float2 BlurUv2			: TEXCOORD3;
	float2 BlurUv3			: TEXCOORD4;
};
#define FullscreenGaussianBlurFPInput FullscreenGaussianBlurVPOutput
/*
struct FullscreenGaussianBlurFPInput
{
	float4 ScreenPosition	: SV_Position;
	float2 ScreenUv			: TEXCOORD0;
	float2 BlurUv0			: TEXCOORD1;
	float2 BlurUv1			: TEXCOORD2;
	float2 BlurUv2			: TEXCOORD3;
	float2 BlurUv3			: TEXCOORD4;
};
*/
struct FullscreenCompositVPOutput
{
	float4 ScreenPosition	: SV_Position;
	float2 ScreenUv			: TEXCOORD0;
};

#define FullscreenCompositFPInput FullscreenCompositVPOutput
/*
struct FullscreenCompositFPInput
{
	float4 ScreenPosition	: SV_Position;
	float2 ScreenUv			: TEXCOORD0;
};
*/
//
// RGB->YCbCr
//
float3 RGBtoYCbCr(float3 c)
{
	float3 v = float3(0.0f, 0.0f, 0.0f);
	v.x = dot(c, float3( 0.299f, 0.587f, 0.114f));
	v.y = dot(c, float3(-0.169f,-0.331f, 0.500f));
	v.z = dot(c, float3( 0.500f,-0.419f,-0.081f));
	return v * float3(219.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f) + float3( 16.0f/255.0f, 126.0f/255.0f, 126.0f/255.0f);
}

// YCbCr->RGB
float3 YCbCrtoRGB(float3 v)
{
	float y_  = (v.x -  16.0f/255.0f) * 255.0f/219.0f;
	float cb_ = (v.y - 128.0f/255.0f) * 255.0f/224.0f;
	float cr_ = (v.z - 128.0f/255.0f) * 255.0f/224.0f;

	float3 c;
	c.x = y_ + 1.402f*cr_;
	c.y = y_ - 0.344f*cb_ - 0.714f*cr_;
	c.z = y_ + 1.772f*cb_;
	return c;
}

FullscreenVPOutput FullscreenVP(FullscreenVPInput IN)
{
	FullscreenVPOutput OUT;
	OUT.ScreenPosition = float4(IN.ScreenVertex.xy, 1.0f, 1.0f);
	OUT.ScreenUv.xy = IN.ScreenUv.xy;
	return OUT;
}

FullscreenVPOutput GammaCorrectionVP(FullscreenVPInput IN)
{
	FullscreenVPOutput OUT;
	OUT.ScreenPosition = float4(IN.ScreenVertex.xy * GammaParameters.yz, 1.0f, 1.0f);
	OUT.ScreenUv.xy = IN.ScreenUv.xy;
	return OUT;
}

FullscreenGaussianBlurVPOutput FullscreenGaussianBlurXVP(FullscreenVPInput IN)
{
	FullscreenGaussianBlurVPOutput OUT;
	OUT.ScreenPosition = float4(IN.ScreenVertex.xy, 1.0f, 1.0f);
	OUT.ScreenUv.xy = IN.ScreenUv.xy * UvScaleBias.xy + UvScaleBias.zw;

	float2 off1 = float2(1.0f/GaussianBlurParams.x, 0.0f);
	float2 off2 = float2(2.0f/GaussianBlurParams.x, 0.0f);

	OUT.BlurUv0 = OUT.ScreenUv.xy - off2;
	OUT.BlurUv1 = OUT.ScreenUv.xy - off1;
	OUT.BlurUv2 = OUT.ScreenUv.xy + off1;
	OUT.BlurUv3 = OUT.ScreenUv.xy + off2;

	return OUT;
}

FullscreenGaussianBlurVPOutput FullscreenGaussianBlurYVP(FullscreenVPInput IN)
{
	FullscreenGaussianBlurVPOutput OUT;
	OUT.ScreenPosition = float4(IN.ScreenVertex.xy, 1.0f, 1.0f);
	OUT.ScreenUv.xy = IN.ScreenUv.xy * UvScaleBias.xy + UvScaleBias.zw;

	float2 off1 = float2(0.0f, 1.0f/GaussianBlurParams.y);
	float2 off2 = float2(0.0f, 2.0f/GaussianBlurParams.y);

	OUT.BlurUv0 = OUT.ScreenUv.xy - off2;
	OUT.BlurUv1 = OUT.ScreenUv.xy - off1;
	OUT.BlurUv2 = OUT.ScreenUv.xy + off1;
	OUT.BlurUv3 = OUT.ScreenUv.xy + off2;

	return OUT;
}

// レンダーターゲットのコピー
float4 CopyBufferFP(FullscreenFPInput IN) : FRAG_OUTPUT_COLOR0
{
	return ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0);
}

// レンダーターゲットのコピー(Aを1.0にする)
float4 CopyBufferFP_FillAlpha1(FullscreenFPInput IN) : FRAG_OUTPUT_COLOR0
{
	return float4(ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb, 1.0f);
}

// レンダーターゲットのコピー(RGBをAにする)
float4 CopyBufferFP_ShowAlpha(FullscreenFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float4 col = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0);
	return float4(float3(col.a, col.a, col.a), 1.0f);
}

// レンダーターゲットのコピー(高輝度成分だけ抽出)
float4 CopyBufferFP_ExtractHightPass(FullscreenFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float4 col = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0);
	return float4(col.rgb * col.a, col.a);
}

#define BLUR_WEIGHT0		4.0
#define BLUR_WEIGHT1		2.0
#define BLUR_WEIGHT2		1.0
#define BLUR_WEIGHT_SUM		(float)(1.0 / (BLUR_WEIGHT0 + BLUR_WEIGHT1 + BLUR_WEIGHT1 + BLUR_WEIGHT2 + BLUR_WEIGHT2))

// レンダーターゲットのコピー(ガウスぼかし付き)
float4 CopyBufferFP_GaussianBlur(FullscreenGaussianBlurFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float4 sampleCentre = ColorBuffer.Sample(LinearClampSampler, IN.ScreenUv.xy);

	float4 sample0 = ColorBuffer.Sample(LinearClampSampler, IN.BlurUv0);
	float4 sample1 = ColorBuffer.Sample(LinearClampSampler, IN.BlurUv1);
	float4 sample2 = ColorBuffer.Sample(LinearClampSampler, IN.BlurUv2);
	float4 sample3 = ColorBuffer.Sample(LinearClampSampler, IN.BlurUv3);

	float4 result = sampleCentre * (BLUR_WEIGHT0 * BLUR_WEIGHT_SUM);
	result += sample0 * (BLUR_WEIGHT2 * BLUR_WEIGHT_SUM);
	result += sample1 * (BLUR_WEIGHT1 * BLUR_WEIGHT_SUM);
	result += sample2 * (BLUR_WEIGHT1 * BLUR_WEIGHT_SUM);
	result += sample3 * (BLUR_WEIGHT2 * BLUR_WEIGHT_SUM);

	return result;
}

FullscreenCompositVPOutput FullscreenCompositVP(FullscreenVPInput IN)
{
	FullscreenCompositVPOutput OUT;
	OUT.ScreenPosition = float4(IN.ScreenVertex.xy, 1.0f, 1.0f);
	OUT.ScreenUv.xy = IN.ScreenUv.xy;
	return OUT;
	
}

float4 loadGlowTex(FullscreenCompositFPInput IN)
{
	float4 glow = GlareBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0);
	return glow;
}

float getDepth(FullscreenCompositFPInput IN)
{
	float depthSample = DepthBuffer.Sample(LinearClampSampler, IN.ScreenUv.xy).x;

	// 深度を線形深度へ変換
	float linearDepth = DofParams.y / (DofParams.x - depthSample);
	return saturate(linearDepth);
}

float getDofValue(float depth)
{
	// 合焦距離から一定距離までの間でぼかす
	depth = saturate(abs(depth - DofParams.z) * DofParams.w);
	depth *= depth;		// 遠景、近景にメリハリを付けるため
	return depth;
}

float3 getDofTexel(FullscreenCompositFPInput IN, float depth)
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb;
	float3 focus = FocusBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb;
	return lerp(color, focus, (float)getDofValue(depth));
}

float getCoverFilterDof(float depth)
{
	return min(1.0f, 0.15f + (float)depth * ToneFactor.y);
}

// S_____
float4 ComposeSceneFP_S_____(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	//
	return float4(resultColor, 1.0f);
}
	// S__z__
	float4 ComposeSceneFP_S__z__(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		//
		return float4(resultColor, 1.0f);
	}

// SG____
float4 ComposeSceneFP_SG____(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;
	//
	return float4(resultColor, 1.0f);
}
	// SG_z__
	float4 ComposeSceneFP_SG_z__(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;
		//
		return float4(resultColor, 1.0f);
	}
	
// S_C___
float4 ComposeSceneFP_S_C___(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;
	//
	return float4(resultColor, 1.0f);
}
	// S_Cz__
	float4 ComposeSceneFP_S_Cz__(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;
		//
		return float4(resultColor, 1.0f);
	}

// SGC___
float4 ComposeSceneFP_SGC___(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;
	//
	return float4(resultColor, 1.0f);
}
	// SGCz__
	float4 ComposeSceneFP_SGCz__(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;
		//
		return float4(resultColor, 1);
	}

		// S_d___
		float4 ComposeSceneFP_S_d___(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);
			//
			return float4(resultColor, 1.0f);
		}
			// S_dz__
			float4 ComposeSceneFP_S_dz__(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);
				//
				return float4(resultColor, 1);
			}

		// SGd___
		float4 ComposeSceneFP_SGd___(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 glare = loadGlowTex(IN);
			resultColor += glare.rgb * (float)GlowIntensity.a;

			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);
			//
			return float4(resultColor, 1.0f);
		}
			// SGdz__
			float4 ComposeSceneFP_SGdz__(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 glare = loadGlowTex(IN);
				resultColor += glare.rgb * (float)GlowIntensity.a;

				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);
				//
				return float4(resultColor, 1);
			}

// S___M_
float4 ComposeSceneFP_S___M_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
	//
	return float4(resultColor, 1);
}
	// S__zM_
	float4 ComposeSceneFP_S__zM_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
		//
		return float4(resultColor, 1);
	}

// SG__M_
float4 ComposeSceneFP_SG__M_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
	//
	return float4(resultColor, 1);
}
	// SG_zM_
	float4 ComposeSceneFP_SG_zM_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
		//
		return float4(resultColor, 1);
	}

// S_C_M_
float4 ComposeSceneFP_S_C_M_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
	//
	return float4(resultColor, 1);
}
	// S_CzM_
	float4 ComposeSceneFP_S_CzM_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
		//
		return float4(resultColor, 1);
	}

// SGC_M_
float4 ComposeSceneFP_SGC_M_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
	//
	return float4(resultColor, 1);
}
	// SGCzM_
	float4 ComposeSceneFP_SGCzM_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
		//
		return float4(resultColor, 1);
	}

		// S_d_M_
		float4 ComposeSceneFP_S_d_M_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
			resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
			//
			return float4(resultColor, 1);
		}
			// S_dzM_
			float4 ComposeSceneFP_S_dzM_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float3 mono = dot(resultColor, float3(0.299f, 0.587f, 0.114f)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
				resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
				//
				return float4(resultColor, 1);
			}

		// SGd_M_
		float4 ComposeSceneFP_SGd_M_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 glare = loadGlowTex(IN);
			resultColor += glare.rgb * (float)GlowIntensity.a;

			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
			resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
			//
			return float4(resultColor, 1);
		}
			// SGdzM_
			float4 ComposeSceneFP_SGdzM_(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 glare = loadGlowTex(IN);
				resultColor += glare.rgb * (float)GlowIntensity.a;

				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
				resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);
				//
				return float4(resultColor, 1);
			}

// S_____
float4 ComposeSceneFP_S____i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// S__z__
	float4 ComposeSceneFP_S__z_i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SG___i
float4 ComposeSceneFP_SG___i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SG_z_i
	float4 ComposeSceneFP_SG_z_i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// S_C__i
float4 ComposeSceneFP_S_C__i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// S_Cz_i
	float4 ComposeSceneFP_S_Cz_i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SGC__i
float4 ComposeSceneFP_SGC__i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SGCz_i
	float4 ComposeSceneFP_SGCz_i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

		// S_d__i
		float4 ComposeSceneFP_S_d__i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// S_dz_i
			float4 ComposeSceneFP_S_dz_i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}

		// SGd__i
		float4 ComposeSceneFP_SGd__i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 glare = loadGlowTex(IN);
			resultColor += glare.rgb * (float)GlowIntensity.a;

			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// SGdz_i
			float4 ComposeSceneFP_SGdz_i(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 glare = loadGlowTex(IN);
				resultColor += glare.rgb * (float)GlowIntensity.a;

				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}

// S___Mi
float4 ComposeSceneFP_S___Mi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// S__zMi
	float4 ComposeSceneFP_S__zMi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SG__Mi
float4 ComposeSceneFP_SG__Mi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SG_zMi
	float4 ComposeSceneFP_SG_zMi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// S_C_Mi
float4 ComposeSceneFP_S_C_Mi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// S_CzMi
	float4 ComposeSceneFP_S_CzMi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SGC_Mi
float4 ComposeSceneFP_SGC_Mi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SGCzMi
	float4 ComposeSceneFP_SGCzMi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

		// S_d_Mi
		float4 ComposeSceneFP_S_d_Mi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
			resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

			float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// S_dzMi
			float4 ComposeSceneFP_S_dzMi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
				resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

				float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}

		// SGd_Mi
		float4 ComposeSceneFP_SGd_Mi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 glare = loadGlowTex(IN);
			resultColor += glare.rgb * (float)GlowIntensity.a;

			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
			resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

			float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// SGdzMi
			float4 ComposeSceneFP_SGdzMi(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 glare = loadGlowTex(IN);
				resultColor += glare.rgb * (float)GlowIntensity.a;

				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
				resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

				float4 fading = FadingTexture.Sample(LinearClampSampler, IN.ScreenUv.xy) * (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}

// S____c
float4 ComposeSceneFP_S____c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// S__z_c
	float4 ComposeSceneFP_S__z_c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SG___c
float4 ComposeSceneFP_SG___c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SG_z_c
	float4 ComposeSceneFP_SG_z_c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// S_C__c
float4 ComposeSceneFP_S_C__c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// S_Cz_c
	float4 ComposeSceneFP_S_Cz_c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SGC__c
float4 ComposeSceneFP_SGC__c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SGCz_c
	float4 ComposeSceneFP_SGCz_c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

		// S_d__c
		float4 ComposeSceneFP_S_d__c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float4 fading = (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// S_dz_c
			float4 ComposeSceneFP_S_dz_c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float4 fading = (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}

		// SGd__c
		float4 ComposeSceneFP_SGd__c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 glare = loadGlowTex(IN);
			resultColor += glare.rgb * (float)GlowIntensity.a;

			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float4 fading = (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// SGdz_c
			float4 ComposeSceneFP_SGdz_c(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 glare = loadGlowTex(IN);
				resultColor += glare.rgb * (float)GlowIntensity.a;

				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float4 fading = (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}

// S___Mc
float4 ComposeSceneFP_S___Mc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}

	// S__zMc
	float4 ComposeSceneFP_S__zMc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SG__Mc
float4 ComposeSceneFP_SG__Mc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SG_zMc
	float4 ComposeSceneFP_SG_zMc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// S_C_Mc
float4 ComposeSceneFP_S_C_Mc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// S_CzMc
	float4 ComposeSceneFP_S_CzMc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

// SGC_Mc
float4 ComposeSceneFP_SGC_Mc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 glare = loadGlowTex(IN);
	resultColor += glare.rgb * (float)GlowIntensity.a;

	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;

	float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
	resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

	float4 fading = (float4)FadingColor;
	resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
	//
	return float4(resultColor, 1);
}
	// SGCzMc
	float4 ComposeSceneFP_SGCzMc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
	{
		float depth = getDepth(IN);
		float3 color = getDofTexel(IN, depth) * ToneFactor.x;
		float3 resultColor = color.rgb;
		//
		float4 glare = loadGlowTex(IN);
		resultColor += glare.rgb * (float)GlowIntensity.a;

		float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
		resultColor += cover.rgb * cover.a;

		float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
		resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

		float4 fading = (float4)FadingColor;
		resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
		//
		return float4(resultColor, 1);
	}

		// S_d_Mc
		float4 ComposeSceneFP_S_d_Mc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
			resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

			float4 fading = (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// S_dzMc
			float4 ComposeSceneFP_S_dzMc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
				resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

				float4 fading = (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}

		// SGd_Mc
		float4 ComposeSceneFP_SGd_Mc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
		{
			float depth = getDepth(IN);
			float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb * ToneFactor.x;
			float3 resultColor = color.rgb;
			//
			float4 glare = loadGlowTex(IN);
			resultColor += glare.rgb * (float)GlowIntensity.a;

			float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
			resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

			float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
			resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

			float4 fading = (float4)FadingColor;
			resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
			//
			return float4(resultColor, 1);
		}
			// SGdzMc
			float4 ComposeSceneFP_SGdzMc(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
			{
				float depth = getDepth(IN);
				float3 color = getDofTexel(IN, depth) * ToneFactor.x;
				float3 resultColor = color.rgb;
				//
				float4 glare = loadGlowTex(IN);
				resultColor += glare.rgb * (float)GlowIntensity.a;

				float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
				resultColor += cover.rgb * cover.a * getCoverFilterDof(depth);

				float3 mono = dot(resultColor, float3(0.299, 0.587, 0.114)) * (float3)MonotoneMul.rgb + (float3)MonotoneAdd.rgb;
				resultColor = lerp(resultColor, mono, (float)MonotoneMul.a);

				float4 fading = (float4)FadingColor;
				resultColor = lerp(resultColor.rgb, fading.rgb, fading.a);
				//
				return float4(resultColor, 1);
			}


// WhirlPinch
// ラスボス部屋用。ソースにクロスフェード画面を用いる。
// モノトーンなし
float4 ComposeSceneFP_WhirlPinch(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
//	float whirl = WhirlPinchParams.x;
//	float pinch = WhirlPinchParams.y;
//	float wpradius = WhirlPinchParams.z;

	float scale_x = 1280/720.0f;
	float scale_y = 1.25f;

	float cen_x = 0.5f;
	float cen_y = 0.5f;
//	float radius = 1.0f;

	float2 tx;
	float2 dd = (IN.ScreenUv.xy - float2(cen_x, cen_y)) * float2(scale_x, scale_y);

//	float rad2 = radius * radius * wpradius;
	float d = dd.x * dd.x + dd.y * dd.y;

//	if ((d < rad2) && (d > 0))
	if ((d < WhirlPinchParams.z) && (d > 0))
	{
		float dist = sqrt(d / WhirlPinchParams.z);
//		float dist = sqrt(d / wpradius) / radius;
		float factor = pow(sin(1.57079632679489661923 * dist), -WhirlPinchParams.y);
		dd.xy *= factor;
		
		factor = 1.0f - dist;
		float ang = WhirlPinchParams.x * factor * factor;

		float sina, cosa;
		sina = sin(ang);
		cosa = cos(ang);

		tx.xy = float2(cosa * dd.x - sina * dd.y, sina * dd.x + cosa * dd.y) / float2(scale_x, scale_y) + float2(cen_x, cen_y);
	}
	else
	{
		tx = IN.ScreenUv.xy;
	}
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, tx, 0).rgb * ToneFactor.x;
	float3 resultColor = color.rgb;
	//
	float4 cover = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	resultColor += cover.rgb * cover.a;
	//
	return float4(resultColor, 1);

}


/*

// テスト
// 天候 - 雨


// 輝度強調
float4 ComposeSceneFP_Brightness(FullscreenCompositFPInput IN) : FRAG_OUTPUT_COLOR0
{
	float3 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0).rgb;
	float4 filter = FilterTexture.Sample(LinearClampSampler, INVSCREENUV) * (float4)FilterColor;
	float4 glare = loadGlowTex(IN);

	float3 resultColor;
	resultColor = color.rgb + glare.rgb + filter.rgb * filter.a;

	float3 tmp = RGBtoYCbCr(min(float3(1.0), max(float3(0.0), resultColor)));
//	float3 tmp = RGBtoYCbCr(resultColor);
	tmp.x *= 1.5;
	resultColor = YCbCrtoRGB(tmp);

	return float4(resultColor, 1);
}
*/

// pow^(DeGamma/Gamma)
float3 degamma_gamma(float3 v)
{
	return pow(saturate(v), GammaParameters.x*1.1f);
}

static const float3 lumCoeff = float3(0.2126729, 0.7151522, 0.0721750);
float AvgLuminance(float3 color) {
	return sqrt(
		(color.x * color.x * lumCoeff.x) +
		(color.y * color.y * lumCoeff.y) +
		(color.z * color.z * lumCoeff.z)
	);
}
 
float3 curves(float3 v)
{
	float luma = AvgLuminance(v);
	float3 chroma = v - luma;

	// LumaLerp Cubic Bezier spline
	float3 a = float3(0.00, 0.00, 0.00);
	float3 b = float3(0.25, 0.25, 0.25);
	float3 c = float3(0.90, 0.90, 0.90);
	float3 d = float3(1.00, 1.00, 1.00);

	float3 ab = lerp(a, b, luma);
	float3 bc = lerp(b, c, luma);
	float3 cd = lerp(c, d, luma);

	float3 abbc = lerp(ab, bc, luma);
	float3 bccd = lerp(bc, cd, luma);
	float3 dest = lerp(abbc, bccd, luma);

	float3 contrast = chroma + dest;

	return saturate(lerp(v, contrast, float(0.50)));
}

float4 GammaCorrectionFP(FullscreenFPInput IN) : FRAG_OUTPUT_COLOR0
{
// これつかいものになるのか?
	float4 color = ColorBuffer.SampleLevel(LinearClampSampler, IN.ScreenUv.xy, 0);
	float3 v = degamma_gamma(color.rgb);
	//v = curves(v);
	return float4((float)v.r, (float)v.g, (float)v.b, color.a);
}


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

// ガンマ補正
technique11 GammaCorrection
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, GammaCorrectionVP() ) );
		SetPixelShader( CompileShader( ps_4_0, GammaCorrectionFP() ) );
		
		//colorMask = bool4(true,true,true,true);
		//cullFaceEnable = false;
		//depthTestEnable = false;
		//depthMask = false;
		//blendEnable = false;
		//StencilTestEnable = false;
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	
	}
}



// レンダーターゲットのコピー
technique11 CopyBuffer
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyBufferFP() ) );
		
		//colorMask = bool4(true,true,true,true);
		//cullFaceEnable = false;
		//depthTestEnable = false;
		//depthMask = false;
		//blendEnable = false;
		//StencilTestEnable = false;
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );		
	}
}

// レンダーターゲットのコピー(Aを1.0にする)
technique11 CopyBufferFillAlpha1
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyBufferFP_FillAlpha1() ) );
		
		//colorMask = bool4(true,true,true,true);
		//cullFaceEnable = false;
		//depthTestEnable = false;
		//depthMask = false;
		//blendEnable = false;
		//StencilTestEnable = false;
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	
	}
}

// レンダーターゲットのコピー(RGBをAにする)
technique11 CopyBufferShowAlpha
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyBufferFP_ShowAlpha() ) );
		
		//colorMask = bool4(true,true,true,true);
		//cullFaceEnable = false;
		//depthTestEnable = false;
		//depthMask = false;
		//blendEnable = false;
		//StencilTestEnable = false;
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	
	}
}

// レンダーターゲットのコピー(高輝度成分だけ抽出)
technique11 CopyBufferExtractHightPass
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyBufferFP_ExtractHightPass() ) );
		
		//colorMask = bool4(true,true,true,true);
		//cullFaceEnable = false;
		//depthTestEnable = false;
		//depthMask = false;
		//blendEnable = false;
		//StencilTestEnable = false;
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	
	}
}

// レンダーターゲットのコピー(横方向ガウスぼかし付き)
technique11 CopyBufferGaussianBlurX
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenGaussianBlurXVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyBufferFP_GaussianBlur() ) );
		
		//colorMask = bool4(true,true,true,true);
		//cullFaceEnable = false;
		//depthTestEnable = false;
		//depthMask = false;
		//blendEnable = false;
		//StencilTestEnable = false;
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );
	}
}

// レンダーターゲットのコピー(縦方向ガウスぼかし付き)
technique11 CopyBufferGaussianBlurY
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenGaussianBlurYVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyBufferFP_GaussianBlur() ) );
		
		//colorMask = bool4(true,true,true,true);
		//cullFaceEnable = false;
		//depthTestEnable = false;
		//depthMask = false;
		//blendEnable = false;
		//StencilTestEnable = false;
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );
	}
}


// S_____
// SG____
// S_C___
// SGC___

// S___M_
// SG__M_
// S_C_M_
// SGC_M_

// S____i
// SG___i
// S_C__i
// SGC__i

// S___Mi
// SG__Mi
// S_C_Mi
// SGC_Mi

// S____c
// SG___c
// S_C__c
// SGC__c

// S___Mc
// SG__Mc
// S_C_Mc
// SGC_Mc

#define TECHNIQUE_COMPOSIT(tecn_name, fp_name)	\
technique11 tecn_name\
{\
	pass p0\
	{\
		SetVertexShader( CompileShader( vs_4_0, FullscreenCompositVP() ) );\
		SetPixelShader( CompileShader( ps_4_0, fp_name() ) );\
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );\
		SetDepthStencilState( DepthState, 0);\
		SetRasterizerState( DefaultRasterState );\
	}\
}

TECHNIQUE_COMPOSIT(ComposeScene_S_____, ComposeSceneFP_S_____)
TECHNIQUE_COMPOSIT(ComposeScene_S__z__, ComposeSceneFP_S__z__)
TECHNIQUE_COMPOSIT(ComposeScene_SG____, ComposeSceneFP_SG____)
TECHNIQUE_COMPOSIT(ComposeScene_SG_z__, ComposeSceneFP_SG_z__)
TECHNIQUE_COMPOSIT(ComposeScene_S_C___, ComposeSceneFP_S_C___)
TECHNIQUE_COMPOSIT(ComposeScene_S_Cz__, ComposeSceneFP_S_Cz__)
TECHNIQUE_COMPOSIT(ComposeScene_SGC___, ComposeSceneFP_SGC___)
TECHNIQUE_COMPOSIT(ComposeScene_SGCz__, ComposeSceneFP_SGCz__)
TECHNIQUE_COMPOSIT(ComposeScene_S_d___, ComposeSceneFP_S_d___)
TECHNIQUE_COMPOSIT(ComposeScene_S_dz__, ComposeSceneFP_S_dz__)
TECHNIQUE_COMPOSIT(ComposeScene_SGd___, ComposeSceneFP_SGd___)
TECHNIQUE_COMPOSIT(ComposeScene_SGdz__, ComposeSceneFP_SGdz__)

TECHNIQUE_COMPOSIT(ComposeScene_S___M_, ComposeSceneFP_S___M_)
TECHNIQUE_COMPOSIT(ComposeScene_S__zM_, ComposeSceneFP_S__zM_)
TECHNIQUE_COMPOSIT(ComposeScene_SG__M_, ComposeSceneFP_SG__M_)
TECHNIQUE_COMPOSIT(ComposeScene_SG_zM_, ComposeSceneFP_SG_zM_)
TECHNIQUE_COMPOSIT(ComposeScene_S_C_M_, ComposeSceneFP_S_C_M_)
TECHNIQUE_COMPOSIT(ComposeScene_S_CzM_, ComposeSceneFP_S_CzM_)
TECHNIQUE_COMPOSIT(ComposeScene_SGC_M_, ComposeSceneFP_SGC_M_)
TECHNIQUE_COMPOSIT(ComposeScene_SGCzM_, ComposeSceneFP_SGCzM_)
TECHNIQUE_COMPOSIT(ComposeScene_S_d_M_, ComposeSceneFP_S_d_M_)
TECHNIQUE_COMPOSIT(ComposeScene_S_dzM_, ComposeSceneFP_S_dzM_)
TECHNIQUE_COMPOSIT(ComposeScene_SGd_M_, ComposeSceneFP_SGd_M_)
TECHNIQUE_COMPOSIT(ComposeScene_SGdzM_, ComposeSceneFP_SGdzM_)

TECHNIQUE_COMPOSIT(ComposeScene_S____i, ComposeSceneFP_S____i)
TECHNIQUE_COMPOSIT(ComposeScene_S__z_i, ComposeSceneFP_S__z_i)
TECHNIQUE_COMPOSIT(ComposeScene_SG___i, ComposeSceneFP_SG___i)
TECHNIQUE_COMPOSIT(ComposeScene_SG_z_i, ComposeSceneFP_SG_z_i)
TECHNIQUE_COMPOSIT(ComposeScene_S_C__i, ComposeSceneFP_S_C__i)
TECHNIQUE_COMPOSIT(ComposeScene_S_Cz_i, ComposeSceneFP_S_Cz_i)
TECHNIQUE_COMPOSIT(ComposeScene_SGC__i, ComposeSceneFP_SGC__i)
TECHNIQUE_COMPOSIT(ComposeScene_SGCz_i, ComposeSceneFP_SGCz_i)
TECHNIQUE_COMPOSIT(ComposeScene_S_d__i, ComposeSceneFP_S_d__i)
TECHNIQUE_COMPOSIT(ComposeScene_S_dz_i, ComposeSceneFP_S_dz_i)
TECHNIQUE_COMPOSIT(ComposeScene_SGd__i, ComposeSceneFP_SGd__i)
TECHNIQUE_COMPOSIT(ComposeScene_SGdz_i, ComposeSceneFP_SGdz_i)

TECHNIQUE_COMPOSIT(ComposeScene_S___Mi, ComposeSceneFP_S___Mi)
TECHNIQUE_COMPOSIT(ComposeScene_S__zMi, ComposeSceneFP_S__zMi)
TECHNIQUE_COMPOSIT(ComposeScene_SG__Mi, ComposeSceneFP_SG__Mi)
TECHNIQUE_COMPOSIT(ComposeScene_SG_zMi, ComposeSceneFP_SG_zMi)
TECHNIQUE_COMPOSIT(ComposeScene_S_C_Mi, ComposeSceneFP_S_C_Mi)
TECHNIQUE_COMPOSIT(ComposeScene_S_CzMi, ComposeSceneFP_S_CzMi)
TECHNIQUE_COMPOSIT(ComposeScene_SGC_Mi, ComposeSceneFP_SGC_Mi)
TECHNIQUE_COMPOSIT(ComposeScene_SGCzMi, ComposeSceneFP_SGCzMi)
TECHNIQUE_COMPOSIT(ComposeScene_S_d_Mi, ComposeSceneFP_S_d_Mi)
TECHNIQUE_COMPOSIT(ComposeScene_S_dzMi, ComposeSceneFP_S_dzMi)
TECHNIQUE_COMPOSIT(ComposeScene_SGd_Mi, ComposeSceneFP_SGd_Mi)
TECHNIQUE_COMPOSIT(ComposeScene_SGdzMi, ComposeSceneFP_SGdzMi)

TECHNIQUE_COMPOSIT(ComposeScene_S____c, ComposeSceneFP_S____c)
TECHNIQUE_COMPOSIT(ComposeScene_S__z_c, ComposeSceneFP_S__z_c)
TECHNIQUE_COMPOSIT(ComposeScene_SG___c, ComposeSceneFP_SG___c)
TECHNIQUE_COMPOSIT(ComposeScene_SG_z_c, ComposeSceneFP_SG_z_c)
TECHNIQUE_COMPOSIT(ComposeScene_S_C__c, ComposeSceneFP_S_C__c)
TECHNIQUE_COMPOSIT(ComposeScene_S_Cz_c, ComposeSceneFP_S_Cz_c)
TECHNIQUE_COMPOSIT(ComposeScene_SGC__c, ComposeSceneFP_SGC__c)
TECHNIQUE_COMPOSIT(ComposeScene_SGCz_c, ComposeSceneFP_SGCz_c)
TECHNIQUE_COMPOSIT(ComposeScene_S_d__c, ComposeSceneFP_S_d__c)
TECHNIQUE_COMPOSIT(ComposeScene_S_dz_c, ComposeSceneFP_S_dz_c)
TECHNIQUE_COMPOSIT(ComposeScene_SGd__c, ComposeSceneFP_SGd__c)
TECHNIQUE_COMPOSIT(ComposeScene_SGdz_c, ComposeSceneFP_SGdz_c)

TECHNIQUE_COMPOSIT(ComposeScene_S___Mc, ComposeSceneFP_S___Mc)
TECHNIQUE_COMPOSIT(ComposeScene_S__zMc, ComposeSceneFP_S__zMc)
TECHNIQUE_COMPOSIT(ComposeScene_SG__Mc, ComposeSceneFP_SG__Mc)
TECHNIQUE_COMPOSIT(ComposeScene_SG_zMc, ComposeSceneFP_SG_zMc)
TECHNIQUE_COMPOSIT(ComposeScene_S_C_Mc, ComposeSceneFP_S_C_Mc)
TECHNIQUE_COMPOSIT(ComposeScene_S_CzMc, ComposeSceneFP_S_CzMc)
TECHNIQUE_COMPOSIT(ComposeScene_SGC_Mc, ComposeSceneFP_SGC_Mc)
TECHNIQUE_COMPOSIT(ComposeScene_SGCzMc, ComposeSceneFP_SGCzMc)
TECHNIQUE_COMPOSIT(ComposeScene_S_d_Mc, ComposeSceneFP_S_d_Mc)
TECHNIQUE_COMPOSIT(ComposeScene_S_dzMc, ComposeSceneFP_S_dzMc)
TECHNIQUE_COMPOSIT(ComposeScene_SGd_Mc, ComposeSceneFP_SGd_Mc)
TECHNIQUE_COMPOSIT(ComposeScene_SGdzMc, ComposeSceneFP_SGdzMc)

TECHNIQUE_COMPOSIT(ComposeScene_WhirlPinch, ComposeSceneFP_WhirlPinch)
//TECHNIQUE_COMPOSIT(ComposeScene_WhirlPinch, ComposeSceneFP_WhirlPinch)