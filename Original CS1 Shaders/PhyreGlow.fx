#line 1 "Z:/data/shaders/PhyreGlow.fx"
/* SCE CONFIDENTIAL
PhyreEngine(TM) Package 3.4.0.0
* Copyright (C) 2012 Sony Computer Entertainment Inc.
* All Rights Reserved.
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

#line 8 "Z:/data/shaders/PhyreGlow.fx"

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

#line 10 "Z:/data/shaders/PhyreGlow.fx"

#define FLIBMOD_NO_GAUSSIAN_BLUR_Y_COMPOSITE	// Èƒƒ'ƒŠ'Ì'½'ß

float4 GaussianBlurBufferSize;
float4 GaussianOutputScale;
float4 UvScaleBias;
Texture2D <float4> GlowBuffer;

///////////////////////////////////////////////////////////////
// structures /////////////////////
///////////////////////////////////////////////////////////////

struct FullscreenVertexIn
{
	float3 vertex		: POSITION;
	float2 uv			: TEXCOORD0;
};

struct FullscreenVertexOut
{
	float4 position		: SV_Position;
	float2 uv			: TEXCOORD0;
};

struct FullscreenFragIn
{
	float4 position		: POSITION;
	float2	uv			: TEXCOORD0;
};

struct GaussianVertexOut
{
	float4 position			: SV_Position;
	float2 uv				: TEXCOORD0;
	float4 uvs0				: TEXCOORD1;
	float4 uvs1				: TEXCOORD2;
};

struct GaussianFragIn
{
	float4 position			: POSITION;
	float2 uv				: TEXCOORD0;
	float4 uvs0				: TEXCOORD1;
	float4 uvs1				: TEXCOORD2;
};

SamplerState LinearClampSampler
{
	Filter = Min_Mag_Linear_Mip_Point;
    AddressU = Clamp;
    AddressV = Clamp;
};


///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

FullscreenVertexOut FullscreenVP(FullscreenVertexIn input)
{
	FullscreenVertexOut output;

	output.position = float4(input.vertex.xy, 1, 1);
	float2 uv = input.uv * UvScaleBias.xy + UvScaleBias.zw * 0.99999;
	output.uv = uv;

	return output;
}


// Output fullscreen vertex.
GaussianVertexOut GaussianUpscaleXVP(FullscreenVertexIn input)
{
	GaussianVertexOut output;
	output.position = float4(input.vertex.xyz,1.0f);

	float2 uv = input.uv;
	output.uv = uv;

	float2 off1 = float2(1.0f/GaussianBlurBufferSize.x,0);
	float2 off2 = float2(2.0f/GaussianBlurBufferSize.x,0);

	// pack the texcoord attributes
	output.uvs0 = float4( uv - off2, uv - off1 );
	output.uvs1 = float4( uv + off1, uv + off2 );
		
	return output;
}
// Output fullscreen vertex.
GaussianVertexOut GaussianUpscaleYVP(FullscreenVertexIn input)
{
	GaussianVertexOut output;
	output.position = float4(input.vertex.xyz,1.0f);

	float2 uv = input.uv;
	output.uv = uv;
	

	float2 off1 = float2(0,1.0f/GaussianBlurBufferSize.y);
	float2 off2 = float2(0,2.0f/GaussianBlurBufferSize.y);

	// pack the texcoord attributes
	output.uvs0 = float4( uv - off2, uv - off1 );
	output.uvs1 = float4( uv + off1, uv + off2 );

	return output;
}



#define kWeight0 4.0
#define kWeight1 2.0
#define kWeight2 1.0
#define kWeightSum (half)(1.0/(kWeight0+kWeight1+kWeight1+kWeight2+kWeight2))


float4 GaussianBlurUpscaleFP(GaussianVertexOut input) : FRAG_OUTPUT_COLOR
{
	float4 sampleCentre = GlowBuffer.Sample(LinearClampSampler,input.uv);
		
	float4 sample0 = GlowBuffer.Sample(LinearClampSampler,input.uvs0.xy);
	float4 sample1 = GlowBuffer.Sample(LinearClampSampler,input.uvs0.zw);
	float4 sample2 = GlowBuffer.Sample(LinearClampSampler,input.uvs1.xy);
	float4 sample3 = GlowBuffer.Sample(LinearClampSampler,input.uvs1.zw);

	float4 rslt = sampleCentre * (kWeight0 * kWeightSum);
	rslt += sample0 * (kWeight2 * kWeightSum);
	rslt += sample1 * (kWeight1 * kWeightSum);
	rslt += sample2 * (kWeight1 * kWeightSum);
	rslt += sample3 * (kWeight2 * kWeightSum);
	return rslt * GaussianOutputScale;
}


float4 CopyToScreenFP(FullscreenVertexOut input) : FRAG_OUTPUT_COLOR0
{
	float4 sampleCentre = GlowBuffer.Sample(LinearClampSampler,input.uv);
	return sampleCentre;
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

RasterizerState CullRasterState 
{
	CullMode = Front;
	FillMode = solid;
	DepthBias = 0;
	ScissorEnable = false;
};

RasterizerState ReverseCullRasterState 
{
	CullMode = Back;
	FillMode = solid;
	DepthBias = 0;
	ScissorEnable = false;
};



technique11 RenderGaussianBlurX
{
	pass mainRender
	{
		SetVertexShader( CompileShader( vs_4_0, GaussianUpscaleXVP() ) );
		SetPixelShader( CompileShader( ps_4_0, GaussianBlurUpscaleFP() ) );
		
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );

	}		
}
technique11 RenderGaussianBlurY
{
	pass mainRender
	{
		SetVertexShader( CompileShader( vs_4_0, GaussianUpscaleYVP() ) );
		SetPixelShader( CompileShader( ps_4_0, GaussianBlurUpscaleFP() ) );
		
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );
				
	}		
}
#ifndef FLIBMOD_NO_GAUSSIAN_BLUR_Y_COMPOSITE
technique11 RenderGaussianBlurYComposite
{
	pass mainRender
	{
		SetVertexShader( CompileShader( vs_4_0, GaussianUpscaleYVP() ) );
		SetPixelShader( CompileShader( ps_4_0, GaussianBlurUpscaleFP() ) );
		
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	

	}		
}
#endif // FLIBMOD_NO_GAUSSIAN_BLUR_Y_COMPOSITE
technique11 CopyGaussianBlurToScreen
{
	pass mainRender
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyToScreenFP() ) );
		
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );

	}		
}
// FLIBMOD_RND_ENABLE_GLOW_ED8_SPECIAL
float4 CopyToScreenFP2(FullscreenVertexOut input) : FRAG_OUTPUT_COLOR0
{
	float4 sampleCentre = GlowBuffer.Sample(LinearClampSampler, input.uv);
	return float4(sampleCentre.rgb * 1.5f, sampleCentre.a);
}

technique11 CopyGaussianBlurToScreen2
{
	pass mainRender
	{
		SetVertexShader( CompileShader( vs_4_0, FullscreenVP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyToScreenFP2() ) );
		
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );	

	}		
}
// FLIBMOD_RND_ENABLE_GLOW_ED8_SPECIAL