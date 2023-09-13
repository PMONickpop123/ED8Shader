#line 1 "Z:/data/shaders/generic.fx"

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

#line 2 "Z:/data/shaders/generic.fx"

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

#line 4 "Z:/data/shaders/generic.fx"

//------------------------------------------------------------------------------
// PhyreEnging共通
//------------------------------------------------------------------------------
float4x4 World					: World;
float4x4 View					: View;
//float4x4 Projection				: Projection;
//float4x4 ViewProjection			: ViewProjection;
//float4x4 WorldView				: WorldView;
float4x4 WorldViewProjection	: WorldViewProjection;
float4x4 WorldViewInverse		: WorldViewInverse;	

//------------------------------------------------------------------------------
//プログラム入力変数
//------------------------------------------------------------------------------
Texture2D<float4>	DepthBuffer;
Texture2D<float4>	TextureSampler;
Texture2D<float4>	Texture2Sampler;

SamplerState PointClampSampler
{
	Filter = Min_Mag_Mip_Point;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState LinearClampSampler
{
	Filter = Min_Mag_Linear_Mip_Point;
    AddressU = Clamp;
    AddressV = Clamp;
};

SamplerState Texture2SamplerS
{
	Filter = Min_Mag_Linear_Mip_Point;
    AddressU = Clamp;
    AddressV = Clamp;
};

float 		CameraAspectRatio;
float4 		inputColor = { 1.0f, 1.0f, 1.0f, 1.f };					//色
float4 		inputSpecular = { 0.0f, 0.0f, 0.0f, 0.f };				//スペキュラ
float4		inputUVShift = {1,1,0,0};								//UVずらし値
float		inputAlphaThreshold = 0.0;								//αテストのしきい値(Vitaではαテストをシェーダーでやる必要ある)
float4		inputCenter  = {0.0f, 0.0f, 0.0f, 0.f};
//float3	inputCameraVector = {0.0f, 0.0f, -1.0f};				//カメラベクトル eye-lookat
float2		inputUVtraspose = {1.0f, 0.0f};							//UV転置用
//float3	inputLightVector = {0.0f, 0.0f, 0.0f};
float4		inputShaderParam = {0.0f,0.0f,0.0f,0.0f};
float2		inputScreenOffset= {0.0f,0.0f};							//3D描画でのスクリーン座標オフセット
float		inputDepth = 0.f;
float4		inputUVShiftMT = {1,1,0,0};								//UVずらし値MT

// fxファイルとの互換性を高めるため構造体型の入出力にしました
struct SpriteC_VPInput
{
	float4 position		: POSITION;
	float4 color		: COLOR0;
};
struct SpriteC_VPOutput
{
	float4 position		: SV_Position;
	float4 color		: COLOR0;
};
#define SpriteC_FPInput SpriteC_VPOutput
//SpriteC_VPOutputを使う
//struct SpriteC_FPInput
//{
//	float4 color		: COLOR0;
//};


struct SpriteCT_VPInput
{
	float4 position		: POSITION;
	float4 color		: COLOR0;
	float2 texCoord		: TEXCOORD0;
};

struct SpriteCT_VPOutput
{
	float4 position		: SV_Position;
	float4 color		: COLOR0;
	float2 texCoord		: TEXCOORD0;
};
#define SpriteCT_FPInput SpriteCT_VPOutput
//SpriteCT_VPOutputを使う
//struct SpriteCT_FPInput
//{
//	float4 color		: COLOR0;
//	float2 texCoord		: TEXCOORD0;
//};

struct SpriteCTMT_VPOutput
{
	float4 position		: SV_Position;
	float4 color		: COLOR0;
	float2 texCoord		: TEXCOORD0;
	float2 texCoord2	: TEXCOORD1;
};
#define SpriteCTMT_FPInput SpriteCTMT_VPOutput
//SpriteCTMT_VPOutputを使う
//struct SpriteCTMT_FPInput
//{
//	float4 color		: COLOR0;
//	float2 texCoord		: TEXCOORD0;
//	float2 texCoord2	: TEXCOORD1;
//};

struct SpriteCT3D_VPOutput
{
	float4 position		: SV_Position;
	float4 color		: COLOR0;
	float2 texCoord		: TEXCOORD0;
	float4 texCoord1	: TEXCOORD1;
};
#define SpriteCT3D_FPInput SpriteCT3D_VPOutput
//SpriteCT3D_VPOutputを使う
//struct SpriteCT3D_FPInput
//{
//	float4 color		: COLOR0;
//	float2 texCoord		: TEXCOORD0;
//	float4 texCoord1	: TEXCOORD1;
//};

//-----------------------------------------------------------------------------
// 視点の位置
//-----------------------------------------------------------------------------
float3 getEyePosition()
{
	return scene_EyePosition;
}

//------------------------------------------------------------------------------
// 仮想陰影値を計算
// pos:頂点ワールド座標
//------------------------------------------------------------------------------
float getShadeFactor(float3 worldPos )
{
	float dh		= worldPos.y - inputCenter.y;
	
	dh += inputCenter.w;			//w==0で初期値が動くように

	dh = clamp(dh, 0.f, 1.f);
	return dh;
}


//-----------------------------------------------------------------------------
// DepthバッファからDepth値を
//-----------------------------------------------------------------------------
float ReadDepth( Texture2D <float4> depthMap, float2 uv )
{
	float3 zBuffer_fragment = saturate( depthMap.SampleLevel(PointClampSampler, uv.xy, 0).xyz );	
	float currentDepth = dot(zBuffer_fragment, ((float3(65536, 256, 1)*255.0f) / 16777215.0f));

	return currentDepth;
}

float ReadDepth2( Texture2D <float4> depthMap, float2 uv )
{
	float currentDepth = saturate( depthMap.SampleLevel(PointClampSampler, uv.xy, 0).x);
	return currentDepth;
}

//------------------------------------------------------------------------------
// Mimic the functionality of texDepth2D.
//------------------------------------------------------------------------------
float GetDepth(float4 depthSample)
{
	return dot(depthSample.xyz, ((float3(65536, 256, 1)*255.0f) / 16777215.0f));	
}

//------------------------------------------------------------------------------
// Convert a depth value from post projection space to view space. 
//------------------------------------------------------------------------------
float ConvertDepth(float depth)
{				
	float viewSpaceZ = -(scene_cameraNearFarParameters.z / (depth * scene_cameraNearFarParameters.w - scene_cameraNearFarParameters.y));	// near*far / (depth * (far-near) - far)
	return saturate(viewSpaceZ);
}


//------------------------------------------------------------------------------
// 転置UVを返す
// inputUVtraspose = {1,0} で通常UV {0,1}で転置
//------------------------------------------------------------------------------
float2 getUV( float2 IN )
{
	// UV転置
	float2 OUT = float2(0.0f, 0.0f);
	float2 uv1 = IN * inputUVShift.xy + inputUVShift.zw;

	OUT.x = uv1.x * inputUVtraspose.x + uv1.y *-inputUVtraspose.y + 1.0f * inputUVtraspose.y;
	OUT.y = uv1.y * inputUVtraspose.x + uv1.x * inputUVtraspose.y;

	return OUT;
}

///////////////////////////////////////////////////////////////////////////////
// スプライト

SpriteC_VPOutput PositionColor2D_VP(SpriteC_VPInput IN)
{
	SpriteC_VPOutput OUT;
	//OUT.position = mul(IN.position, transpose(World));// TODO : Check
	OUT.position = mul( transpose(World), IN.position);
	OUT.position.x *= CameraAspectRatio;
	OUT.color = IN.color;
	return OUT;
}

float4 PositionColor2D_FP(SpriteC_VPOutput IN) : FRAG_OUTPUT_COLOR0
{
	return IN.color;
}

technique11 PositionColor2D	
{
	pass p0
	{	
		SetVertexShader( CompileShader( vs_4_0, PositionColor2D_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionColor2D_FP() ) );
	}
}

//-----------------------------------------------------------------------------
// 頂点シェーダー:2D, 標準、マルチテクスチャ
//-----------------------------------------------------------------------------
SpriteCTMT_VPOutput PositionTextureColor2DMT_VP(SpriteCT_VPInput IN)
{
	SpriteCTMT_VPOutput OUT;
	//OUT.position = mul(IN.position, transpose(World)); // TODO : Check
	OUT.position = mul(transpose(World), IN.position);
	OUT.position.x *= CameraAspectRatio;
	OUT.texCoord = IN.texCoord * inputUVShift.xy + inputUVShift.zw;
	OUT.color    = IN.color    * inputColor;
	OUT.texCoord2 = OUT.texCoord.xy * inputUVShiftMT.xy + inputUVShiftMT.zw;
	return OUT;
}

//-----------------------------------------------------------------------------
// フラグメントシェーダー:2D, 標準、マルチテクスチャ
//-----------------------------------------------------------------------------
float4 PositionTextureColor2DMT_FP(SpriteCTMT_VPOutput IN) : FRAG_OUTPUT_COLOR0
{
	float4 _color = TextureSampler.Sample(LinearClampSampler, IN.texCoord);
	float4 _color2 = Texture2Sampler.Sample(Texture2SamplerS, IN.texCoord2);
	_color *= IN.color;
	_color.r += inputSpecular.r * inputSpecular.a;
	_color.g += inputSpecular.g * inputSpecular.a;
	_color.b += inputSpecular.b * inputSpecular.a;
	_color.a = min(1.0f, IN.color.a * _color2.r * 2);
	return _color;
}
//-----------------------------------------------------------------------------
// テクニック:2D, 標準、マルチテクスチャ
//-----------------------------------------------------------------------------
technique11 PositionTextureColor2DMT
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, PositionTextureColor2DMT_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor2DMT_FP() ) );
	}
}

//-----------------------------------------------------------------------------
// 頂点シェーダー:2D, 標準
//-----------------------------------------------------------------------------
SpriteCT_VPOutput PositionTextureColor2D_VP(SpriteCT_VPInput IN)
{
	SpriteCT_VPOutput OUT;
	//OUT.position = mul(IN.position, transpose(World)); // TODO : Check
	OUT.position = mul(transpose(World), IN.position);
	OUT.position.x *= CameraAspectRatio;
	OUT.position.z = inputDepth;	//Z値書き込みたい場合に使う
	OUT.texCoord = IN.texCoord * inputUVShift.xy + inputUVShift.zw;
	OUT.color    = IN.color    * inputColor;
	return OUT;
}
//-----------------------------------------------------------------------------
// フラグメントシェーダー:2D, 標準
//-----------------------------------------------------------------------------
float4 PositionTextureColor2D_FP(SpriteCT_VPOutput IN) : FRAG_OUTPUT_COLOR0
{
	float4 _color = TextureSampler.Sample(LinearClampSampler, IN.texCoord);
	_color *= IN.color;
	_color.r += inputSpecular.r * inputSpecular.a;
	_color.g += inputSpecular.g * inputSpecular.a;
	_color.b += inputSpecular.b * inputSpecular.a;
	return _color;
}

BlendState LinearBlend 
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = SRC_ALPHA;
	DestBlend[0] = INV_SRC_ALPHA;
	BlendOp[0] = ADD;
	SrcBlendAlpha[0] = ONE;
	DestBlendAlpha[0] = ONE;
	BlendOpAlpha[0] = ADD;
};

DepthStencilState NoDepth
{
	DepthEnable = FALSE;
	StencilEnable = FALSE;
};

//-----------------------------------------------------------------------------
// テクニック:2D, 標準
// FTECH_POSITIONTEXTURECOLOR2D
//-----------------------------------------------------------------------------
technique11 PositionTextureColor2D
{
	pass p0
	{
		//SetBlendState( LinearBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );

		SetVertexShader( CompileShader( vs_4_0, PositionTextureColor2D_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor2D_FP() ) );
	}
}





//-----------------------------------------------------------------------------
// 頂点シェーダー:Depth -> Color
//-----------------------------------------------------------------------------
SpriteCT_VPOutput CopyPositionTextureColor2D_VP(SpriteCT_VPInput IN)
{
	SpriteCT_VPOutput OUT;
	OUT.position = IN.position;
	OUT.texCoord = IN.texCoord;
	OUT.color    = IN.color;
	return OUT;
}

//-----------------------------------------------------------------------------
// フラグメントシェーダー:Depth -> Color
//-----------------------------------------------------------------------------
float4 CopyPositionTextureColor2D_FP(SpriteCT_VPOutput IN) : FRAG_OUTPUT_COLOR0
{
	float currentDepth = 0;
	float4 _color = float4(0.0f, 0.0f, 0.0f, 0.0f);

	float3 zBuffer_fragment = saturate( TextureSampler.Sample(LinearClampSampler, IN.texCoord.xy ).xyz );
	float3 depth_factor_precise = float3(65536.0f/16777215.0f, 256.0f/16777215.0f, 1.0f/16777215.0f);
	zBuffer_fragment = round(zBuffer_fragment * 255.0f);
	currentDepth = dot( zBuffer_fragment, depth_factor_precise);

	_color.r = currentDepth;
	_color.g = currentDepth;
	_color.b = currentDepth;
	_color.a = 1.f;
	return _color;
}

//-----------------------------------------------------------------------------
// テクニック:2D, 標準
// FTECH_POSITIONTEXTURECOLOR2D
//-----------------------------------------------------------------------------
technique11 CopyPositionTextureColor2D
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, CopyPositionTextureColor2D_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, CopyPositionTextureColor2D_FP() ) );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ポリゴン

// 位置、色
SpriteC_VPOutput PositionColor3D_VP(SpriteC_VPInput IN)
{
	SpriteC_VPOutput OUT;
	//OUT.position = mul(IN.position, transpose(WorldViewProjection)); // TODO : Check
	OUT.position = mul(transpose(WorldViewProjection), IN.position);
	OUT.color    = IN.color    * inputColor;
	return OUT;
}

float4 PositionColor3D_FP(SpriteC_VPOutput IN) : FRAG_OUTPUT_COLOR0
{
	return IN.color;
}

technique11 PositionColor3D
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, PositionColor3D_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionColor3D_FP() ) );
	}
}

//-----------------------------------------------------------------------------
// 頂点シェーダー:3D, 標準
//-----------------------------------------------------------------------------
// 位置、テクスチャ、色		(FVF_POSITION|FVF_TEXCOORD0|FVF_COLOR0)
SpriteCT_VPOutput PositionTextureColor3D_VP(SpriteCT_VPInput IN)
{
	SpriteCT_VPOutput OUT;
	//OUT.position = mul(IN.position, transpose(WorldViewProjection)); // TODO : Check
	OUT.position = mul( transpose(WorldViewProjection), IN.position);
	OUT.texCoord = getUV( IN.texCoord );
	OUT.color    = IN.color    * inputColor;
	
	//陰影
	//float4	worldPos	= mul(IN.position, transpose(World)); // TODO : Check
	float4	worldPos	= mul(transpose(World), IN.position);
	float	_dot		= getShadeFactor( worldPos.xyz );
	OUT.color.a *= _dot;

	return OUT;
}

//-----------------------------------------------------------------------------
// フラグメントシェーダー:3D, 標準
//-----------------------------------------------------------------------------
float4 PositionTextureColor3D_FP(SpriteCT_VPOutput IN) : FRAG_OUTPUT_COLOR0
{
	float4 _color = TextureSampler.Sample(LinearClampSampler, IN.texCoord);
	_color *= IN.color;
	_color.r += inputSpecular.r * inputSpecular.a;
	_color.g += inputSpecular.g * inputSpecular.a;
	_color.b += inputSpecular.b * inputSpecular.a;

	clip(_color.a - inputAlphaThreshold);	//αテスト(Vitaで必要)
	return _color;
}





//-----------------------------------------------------------------------------
// テクニック:3D, 標準
//-----------------------------------------------------------------------------
technique11 PositionTextureColor3D
{
	pass p0
	{
		SetVertexShader( CompileShader( vs_4_0, PositionTextureColor3D_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor3D_FP() ) );
	}
}

technique11 PositionTextureColor3D_NoDepth
{
	pass p0
	{
		SetDepthStencilState(NoDepth, 0xFFFFFFFF);
		SetVertexShader( CompileShader( vs_4_0, PositionTextureColor3D_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor3D_FP() ) );
	}
}


//------------------------------------------------------------------------------
// 入力頂点 FVF_3D3   FVF_POSITION|FVF_NORMAL|FVF_TEXCOORD0|FVF_COLOR0
//------------------------------------------------------------------------------
struct DefualtVPInput
{
	float4 position		: POSITION;
	float4 normal		: NORMAL;
	float2 texCoord		: TEXCOORD0;
	float4 color		: COLOR0;
};
struct DefaultVPOutput
{
	float4 position		: SV_Position;
	float4 color		: COLOR0;	
	float2 texCoord		: TEXCOORD0;
};



//------------------------------------------------------------------------------
// 頂点シェーダー:3D,通常,法線あり
//------------------------------------------------------------------------------
DefaultVPOutput PositionNormalTextureColor3D_VP( DefualtVPInput IN )
{
	DefaultVPOutput OUT;
	
	// UV転置
	OUT.texCoord = getUV( IN.texCoord );	
	//OUT.position = mul(IN.position, transpose(WorldViewProjection)); // TODO : Check
	OUT.position = mul(transpose(WorldViewProjection), IN.position);
	OUT.color    = IN.color    * inputColor;

	//スクリーン座標系でのオフセット(-1~1)
	OUT.position.x += inputScreenOffset.x * OUT.position.w;
	OUT.position.y += inputScreenOffset.y * OUT.position.w;	

	return OUT;
};



//------------------------------------------------------------------------------
// 頂点シェーダー:3D,カメラに対して頂点単位で淵を消すシェーダー
//------------------------------------------------------------------------------
DefaultVPOutput PositionNormalTextureColor3D_rimTransparency_VP( DefualtVPInput IN )
{
	DefaultVPOutput OUT;
	//OUT.position = mul(IN.position, transpose(WorldViewProjection)); // TODO : Check
	OUT.position = mul(transpose(WorldViewProjection), IN.position);

	float3 worldNormal   = normalize( mul( float4(IN.normal.xyz,0.0f), World).xyz);
	float3 worldPosition = mul(float4(IN.position.xyz,1.f), World).xyz;
		
	//視線、法線で計算
	float3 cameraVec = normalize( getEyePosition() - worldPosition );
	float3 normalVec = worldNormal;	

	float alpha = abs( dot(cameraVec, normalVec) );

	alpha = pow(1.0f - alpha, (float)inputShaderParam[0] );
	alpha *= (float)inputShaderParam[1];	
	alpha = 1.0f - alpha;
		
	OUT.texCoord = getUV( IN.texCoord );	
	OUT.color    = IN.color    * inputColor;
	OUT.color.a *= alpha;

	return OUT;
};


//------------------------------------------------------------------------------
// テクニック:3D,法線あり
//------------------------------------------------------------------------------
// Used for map, leaves
technique11 PositionNormalTextureColor3D
{
	pass main
	{
		//SetBlendState( LinearBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetVertexShader( CompileShader( vs_4_0, PositionNormalTextureColor3D_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor3D_FP() ) );
	}
};

//------------------------------------------------------------------------------
// テクニック:3D,法線あり 淵消し
//------------------------------------------------------------------------------
technique11 PositionNormalTextureColor3D_rimTrans
{
	pass main
	{
		SetVertexShader( CompileShader( vs_4_0, PositionNormalTextureColor3D_rimTransparency_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor3D_FP() ) );
	}
};




//-----------------------------------------------------------------------------
// 頂点シェーダー:3D, 仮ステルスシェーダー
//-----------------------------------------------------------------------------
// 位置、テクスチャ、色		(FVF_POSITION|FVF_NORMAL|FVF_TEXCOORD0|FVF_COLOR0)
DefaultVPOutput PositionNormalTextureColor3D_Stealth_VP( DefualtVPInput IN)
{
	//法線が無いころに使ったので、頂点でずらしている。
	DefaultVPOutput OUT;
	//OUT.position = mul(IN.position, transpose(WorldViewProjection)); //TODO : Check
	OUT.position = mul(transpose(WorldViewProjection), IN.position);
	OUT.color    = IN.color    * inputColor;

	// スクリーン座標を計算
	float2 tmp;
    tmp.x = ((OUT.position.x / OUT.position.w)*0.5f+0.5f);
    tmp.y = ((OUT.position.y / OUT.position.w)*0.5f+0.5f);
	tmp.x += IN.texCoord.x;	//頂点埋め込みuvでずらす
	tmp.y += IN.texCoord.y;
	OUT.texCoord = tmp;
	return OUT;
}


technique11 PositionNormalTextureColor3D_Stealth
{
	pass main
	{
		//SetBlendState( LinearBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetVertexShader( CompileShader( vs_4_0, PositionNormalTextureColor3D_Stealth_VP() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor3D_FP() ) );
	}
}


//深度比較で薄くするやつ用
// 位置、テクスチャ、色		(FVF_POSITION|FVF_NORMAL|FVF_TEXCOORD0|FVF_COLOR0)
SpriteCT3D_VPOutput PositionNormalTextureColor3D_VP2(DefualtVPInput IN)
{
	SpriteCT3D_VPOutput OUT;
	//OUT.position = mul(IN.position, transpose(WorldViewProjection)); // TODO : Check
	OUT.position = mul(transpose(WorldViewProjection), IN.position);
	OUT.texCoord = getUV( IN.texCoord );
	OUT.color    = IN.color    * inputColor;
	
	
	//陰影
	//float4	worldPos	= mul(IN.position, transpose(World)); // TODO : Check
	float4	worldPos	= mul(transpose(World), IN.position);
	float	_dot		= getShadeFactor( worldPos.xyz );
	OUT.color.a *= _dot;

	OUT.texCoord1 = mul(float4(IN.position.xyz,1.0f), WorldViewProjection);	
	return OUT;
}

//深度比較で薄くするやつ
float4 PositionTextureColor3D_FP2(SpriteCT3D_VPOutput IN) : FRAG_OUTPUT_COLOR0
{
	float4 _color = TextureSampler.Sample(LinearClampSampler, IN.texCoord);
	_color *= IN.color;
	_color.r += inputSpecular.r * inputSpecular.a;
	_color.g += inputSpecular.g * inputSpecular.a;
	_color.b += inputSpecular.b * inputSpecular.a;

	//clip(_color.a - inputAlphaThreshold);	//αテスト(Vitaで必要)


	//深度バッファの深度(何か1が強い
	float2 screenPos = (IN.texCoord1.xy/IN.texCoord1.w);
	screenPos.xy = screenPos.xy * 0.5f + float2(0.5f, 0.5f);
	
	float depthMapValue = ReadDepth(DepthBuffer, screenPos );
	depthMapValue = ConvertDepth( depthMapValue );
	depthMapValue = saturate(depthMapValue);

//やるとは、CDraw.cpp で DepthBufferをl。
	//ピクセルの深度計算
	float myDepthValue = (IN.texCoord1.z / IN.texCoord1.w);
	float myDepth = saturate(myDepthValue);
	
	float delta = depthMapValue-myDepth;
	delta = delta / 0.0001f;
		
	delta = saturate(delta);
	
	_color.a *= delta;
	
	return _color;
}

technique11 PositionNormalTextureColor3D_Test
{
	pass p0
	{
		//SetBlendState( LinearBlend, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF );
		SetVertexShader( CompileShader( vs_4_0, PositionNormalTextureColor3D_VP2() ) );
		SetPixelShader( CompileShader( ps_4_0, PositionTextureColor3D_FP2() ) );
	}
}