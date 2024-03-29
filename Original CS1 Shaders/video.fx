#line 1 "Z:/data/shaders/video.fx"
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

#line 8 "Z:/data/shaders/video.fx"

Texture2D <float4> AlphaTexture;
Texture2D <float4> VideoScreen3DTexture : MovieTexture;
Texture2D <float4> VideoScreenTexture;
float4x4 WorldViewProjection	: WorldViewProjection;

///////////////////////////////////////////////////////////////
// structures /////////////////////
///////////////////////////////////////////////////////////////

struct MeshVertexIn
{
	float4 position		: POSITION;
	float2 uv			: TEXCOORD0;
};

struct Video3DVertexOut
{
	float4 position		: SV_Position;
	float2 uv0			: TEXCOORD0;
	float2 uv1			: TEXCOORD1;
};

#define Video3DFragIn Video3DVertexOut
/*
struct Video3DFragIn
{
	float4 position		: POSITION;
	float2	uv0			: TEXCOORD0;
	float2	uv1			: TEXCOORD1;
};
*/


struct VideoScreenVertexIn
{
	float2 vertex		: POSITION;
	float2 uv			: TEXCOORD0;
};

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

#define FullscreenFragIn FullscreenVertexOut
/*
struct FullscreenFragIn
{
	float4 position		: POSITION;
	float2	uv			: TEXCOORD0;
};
*/

SamplerState LinearClampSampler
{
	Filter = Min_Mag_Linear_Mip_Point;
	AddressU = Clamp;
	AddressV = Clamp;
};

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

FullscreenVertexOut VideoScreenVP(VideoScreenVertexIn IN)
{
	FullscreenVertexOut OUT;
	
	OUT.position =  float4(IN.vertex.xy, 1.0f, 1.0f);
	OUT.uv = float2(IN.uv.x, 1.0f - IN.uv.y); // y coord is flipped
	
	return OUT;
}

float4 VideoScreenFP(FullscreenFragIn IN) : FRAG_OUTPUT_COLOR0
{
	return VideoScreenTexture.Sample(LinearClampSampler, IN.uv);
}

BlendState LinearBlend 
{
	AlphaToCoverageEnable = FALSE;
	BlendEnable[0] = TRUE;
	SrcBlend[0] = Src_Alpha;
	DestBlend[0] = Inv_Src_Alpha;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = ADD;
	BlendEnable[1] = FALSE;
	RenderTargetWriteMask[0] = 15;
};

DepthStencilState DepthState 
{
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

technique11 VideoScreen
{
	pass p1
	{
		SetVertexShader( CompileShader( vs_4_0, VideoScreenVP() ) );
		SetPixelShader( CompileShader( ps_4_0, VideoScreenFP() ) );
		
		//ColorMask = bool4(true,true,true,false);
		//CullFaceEnable = false;
		//DepthTestEnable = false;
		//DepthMask = false;
		//BlendEnable = true;
		//BlendFunc = {srcAlpha, oneMinusSrcAlpha};
		//StencilTestEnable = false;
		//CullFaceEnable = false;
		SetBlendState( LinearBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );
	}
}

Video3DVertexOut VideoScreen3DVP(MeshVertexIn IN)
{
	Video3DVertexOut OUT;
	
	OUT.position = mul(transpose(WorldViewProjection), IN.position);
	OUT.uv0 = float2(IN.uv.x, 1.0-IN.uv.y);
	OUT.uv1 = float2(IN.uv.x, IN.uv.y);
	
	return OUT;
}

float4 VideoScreen3DFP(Video3DFragIn IN) : FRAG_OUTPUT_COLOR0
{
	float a = AlphaTexture.Sample(LinearClampSampler, IN.uv0).x;
	float4 tex = VideoScreen3DTexture.Sample(LinearClampSampler, IN.uv1);
	return float4(tex.x, tex.y, tex.z, a);
}

BlendState SrcAlphaOneMinusSrcAlphaBlend 
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = SRC_ALPHA;
	DestBlend[0] = INV_SRC_ALPHA;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = ADD;
};

BlendState NoBlend 
{
  AlphaToCoverageEnable = FALSE;
  BlendEnable[0] = FALSE;
};

technique11 VideoScreen3D
<
	string PhyreRenderPass = "Transparent";
>
{
	pass pass0
	{
		SetVertexShader( CompileShader( vs_4_0, VideoScreen3DVP() ) );
		SetPixelShader( CompileShader( ps_4_0, VideoScreen3DFP() ) );
		
		//ColorMask = bool4(true,true,true,false);
		//CullFaceEnable = false;
		//DepthFunc = LEqual;
		//DepthTestEnable = true;
		//DepthMask = true;
		//BlendEnable = true;
		//BlendFunc = {srcAlpha, oneMinusSrcAlpha};
		//StencilTestEnable = false;
		//CullFaceEnable = false;
		//SetBlendState( SrcAlphaOneMinusSrcAlphaBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetBlendState( NoBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetDepthStencilState( DepthState, 0);
		SetRasterizerState( DefaultRasterState );
	}
}