float ClampPlusMinusOneToNonNegative(float value) {
	return saturate(value);
}

float4 GenerateScreenProjectedUv(float4 projPosition) {
	float2 clipSpaceDivided = projPosition.xy / float2(projPosition.w, -projPosition.w);
	float2 tc = clipSpaceDivided.xy * 0.5 + 0.5;
	return float4(tc.x * projPosition.w, tc.y * projPosition.w, 0, projPosition.w);
}

float3 GetEyePosition() {
	return _WorldSpaceCameraPos.xyz;
}

float GetGlobalTextureFactor() {
    return _Time.y * 0.30f;
}

//-----------------------------------------------------------------------------
// インスタンシング
//-----------------------------------------------------------------------------
#if defined(INSTANCING_ENABLED)
    float GetDitherThreshold(float2 screenPos) {
        float2 matrixUv = screenPos * (1.0 / 4);
        return tex2Dlod(_UdonDitherNoiseTexture, float4(matrixUv.xy, 0, 0)).x
    }
#endif // defined(INSTANCING_ENABLED)

//-----------------------------------------------------------------------------
// 輝度計算
//-----------------------------------------------------------------------------

// 輝度レンジ。上げ過ぎるとマッハバンド酷くなるので注意！
#if defined(GLARE_ENABLED)
    float CalcGlowValue(float val) {
        float glowIntensity = 2;
        return min(1, val * glowIntensity * 0.5);
    }
#endif // defined(GLARE_ENABLED)

/*
#if defined(BLOOM_ENABLED)
    float CalcBrightness(float3 rgb) {
        float bright = dot(rgb * _BloomIntensity, float3(0.299, 0.587, 0.114));
        float threshold = scene.MiscParameters2.z;
        bright = max(0, bright - threshold);
        return min(1, bright * 0.5);
    }
#endif // defined(BLOOM_ENABLED)
*/

float3 CreateBinormal(float3 normal, float3 tangent, float binormalSign) {
    return cross(normal, tangent) * (binormalSign * unity_WorldTransformParams.w);
}

float3 EvaluateNormalMapNormal(float3 inNormal, float2 inUv, float3 inTangent, float3 inBiTangent, uniform sampler2D normalMap) {
    float4 normalMapData = tex2D(normalMap, inUv).xyzw;

    #if !defined(UNITY_COLORSPACE_GAMMA)
        normalMapData.rgb = LinearToGammaSpace(normalMapData.rgb);
        normalMapData.a = LinearToGammaSpaceExact(normalMapData.a);
    #endif

    normalMapData = normalMapData * 2.0 - 1.0;
    float3 normalMapNormal = float3(0.0f, 0.0f, 0.0f);

    #if defined(NORMAL_MAPP_DXT5_NM_ENABLED)
        normalMapNormal.x = normalMapData.a;
        normalMapNormal.y = normalMapData.r;
        normalMapNormal.z = sqrt(1 - saturate(dot(normalMapNormal.xy, normalMapNormal.xy)));
    #elif defined(NORMAL_MAPP_DXT5_LP_ENABLED)
        normalMapNormal.x = normalMapData.r * normalMapData.a;
        normalMapNormal.y = normalMapData.g;
        normalMapNormal.z = sqrt(1 - saturate(dot(normalMapNormal.xy, normalMapNormal.xy)));
    #else // NORMAL_MAPP_DXT5_NM_ENABLED
        normalMapData.x *= normalMapData.w;
        normalMapNormal.xy = normalMapData.xy;
        normalMapNormal.z = sqrt(1 - saturate(dot(normalMapNormal.xy, normalMapNormal.xy)));
    #endif // NORMAL_MAPP_DXT5_NM_ENABLED

    inNormal = normalize(inNormal);
	inTangent = normalize(inTangent);
	float3 biTangent = cross(inNormal, inTangent);
	normalMapNormal.x *= (inUv.x < 0.0f) ? -1.0f : 1.0f;
	float3 n = normalize((normalMapNormal.x * inTangent) + (normalMapNormal.y * biTangent) + (normalMapNormal.z * inNormal));	
	return n;
}

float3 EvaluateStandardNormal(float3 inNormal) {
	return normalize(inNormal).xyz;
}

#define _EvaluateNormalMapNormal(a,b,c,d,e) EvaluateNormalMapNormal(a, b, c, d, e)

#if defined(NORMAL_MAPPING_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormalFP(In, dudvValue) _EvaluateNormalMapNormal(In.normal.xyz, In.uv.xy + dudvValue, In.tangent, In.binormal, _BumpMap)
	#else
		#define EvaluateNormalFP(In) _EvaluateNormalMapNormal(In.normal.xyz, In.uv.xy, In.tangent, In.binormal, _BumpMap)
	#endif
#else
	#define EvaluateNormalFP(In) EvaluateStandardNormal(In.normal.xyz)
#endif

#if defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormal2FP(In, dudvValue) _EvaluateNormalMapNormal(In.normal.xyz, In.uv2.xy + dudvValue, In.tangent, In.binormal, _NormalMap2Sampler)
	#else
		#define EvaluateNormal2FP(In) _EvaluateNormalMapNormal(In.normal.xyz, In.uv2.xy, In.tangent, In.binormal, _NormalMap2Sampler)
	#endif
#else
	#define EvaluateNormal2FP(In) EvaluateStandardNormal(In.normal.xyz)
#endif

//-----------------------------------------------------------------------------
#if defined(WINDY_GRASS_ENABLED)
	#if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
        float3 calcWindyGrass(float3 position, float weight)
	#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
        float3 calcWindyGrass(float3 position)
	#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
    {
	    float time = GetGlobalTextureFactor();
	    float k = position.x + position.z;
        float a = k * (1.0f / (_WindyGrassHomogenity * _WindyGrassHomogenity));
        float t = a * 0.25f + frac(a) + (time * _WindyGrassSpeed);

        #if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
            float2 dd = _WindyGrassDirection * sin(t) * _WindyGrassScale * weight;
        #else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
            float2 dd = _WindyGrassDirection * sin(t) * _WindyGrassScale;
        #endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	    return position.xyz + float3(dd.x, 0, dd.y);
    }
#endif // WINDY_GRASS_ENABLED

#if defined(FOG_ENABLED)
    float EvaluateFogValue(float z, float worldY) {
        float f = saturate((z - _UdonFogRangeParameters.x) * (1 / (_UdonFogRangeParameters.y - _UdonFogRangeParameters.x)));

        float HeightFogSubtraction = (_UdonHeightFogRangeParameters.y - _UdonHeightFogRangeParameters.x);
        float3 MiscParameters3;
        MiscParameters3.x = (_WorldSpaceCameraPos.y * _UdonHeightCamRate); //- _UdonHeightFogRangeParameters.x;
        MiscParameters3.y = (HeightFogSubtraction == 0.0f) ? 0.0f : (1 / HeightFogSubtraction);
        MiscParameters3.z = _UdonHeightDepthBias;

        float h = saturate((worldY - MiscParameters3.x) * MiscParameters3.y);
        h *= min(1, f + MiscParameters3.z);
        f = min(1, f + h);

        #if defined(FOG_RATIO_ENABLED)
            f *= _FogRatio;
        #endif

        f *= _UdonFogRateClamp;
        return f;
    }

    float EvaluateFogColor(inout float3 resultColor, float fogValue, float3 worldPos) {
        #if defined(USE_EXTRA_BLENDING)
            #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
                float3 fogColor = float3(1, 1, 1);
            #else
                float3 fogColor = float3(0, 0 ,0);
            #endif
        #else
            float3 fogColor = _UdonFogColor.rgb;
        #endif

        float4 MiscParameters6 = float4(_UdonFogImageSpeedX, _UdonFogImageSpeedZ, _UdonFogImageScale, _UdonFogImageRatio);
        
        UNITY_BRANCH
        if (_UdonFogImageRatio > 0) {
            worldPos.xz += MiscParameters6.xy * GetGlobalTextureFactor();
            worldPos *= MiscParameters6.z;

            float3 d = float3(tex2Dlod(_UdonLowResDepthTexture, float4(worldPos.xy, 0, 0)).x, 
            tex2Dlod(_UdonLowResDepthTexture, float4(worldPos.xz, 0, 0)).x, 
            tex2Dlod(_UdonLowResDepthTexture, float4(worldPos.yz, 0, 0)).x);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                d = LinearToGammaSpace(d);
            #endif

            float density = dot(d, float3(0.3333, 0.3333, 0.3333));
            fogValue = max(0.0, fogValue - (density * fogValue * MiscParameters6.w));
        }

        #if !defined(UNITY_COLORSPACE_GAMMA)
            fogColor.rgb = LinearToGammaSpace(fogColor.rgb);
        #endif

        resultColor.rgb = lerp(resultColor.rgb, fogColor.rgb, fogValue);
        return fogValue;
    }
#endif // FOG_ENABLED

//-----------------------------------------------------------------------------
// リムライト
//-----------------------------------------------------------------------------
#if defined(RIM_LIGHTING_ENABLED)
    float EvaluateRimLightValue(float ndote) {
        float rimLightvalue; 

        rimLightvalue = (_Culling < 2) ? pow(max(0, 1.0 - abs(ndote)), _RimLitPower) : pow(1.0 - clamp(ndote, 0.0, 1.0), _RimLitPower);
        return rimLightvalue * _RimLitIntensity;
    }

    float3 ClampRimLighting(float3 ambient) {
        return min(ambient, (float3)_RimLightClampFactor);
    }
#endif // defined(RIM_LIGHTING_ENABLED)

//-----------------------------------------------------------------------------
#if defined(CARTOON_SHADING_ENABLED)
    float calcToonShadingValue(float ldotn, float shadowValue) {
        float u = ldotn * 0.5 + 0.5;

        #if defined(UNITY_PASS_FORWARDBASE)
            #if !defined(FLAT_AMBIENT_ENABLED)
                u *= shadowValue;
            #endif
        #endif

        float r = tex2Dlod(_CartoonMapSampler, float4(u, 0.0, 0, 0)).x;

        #if !defined(UNITY_COLORSPACE_GAMMA)
            r = LinearToGammaSpaceExact(r);
        #endif
        return r;
    }
#endif // CARTOON_SHADING_ENABLED

//-----------------------------------------------------------------------------
float CalcMipLevel(float2 texcoord){
    float2 dx = ddx(texcoord);
    float2 dy = ddy(texcoord);
    float delta_max_sqr = max(dot(dx, dx), dot(dy, dy));
    return 0.5 * log2(delta_max_sqr);
}

float2 SampleSphereMap(float3 viewDirection, float3 normalDirection) {
    float3 worldUp = float3(0, 1, 0);
    float3 worldViewUp = normalize(worldUp - viewDirection * dot(viewDirection, worldUp));
    float3 worldViewRight = normalize(cross(viewDirection, worldViewUp));
    float2 SphereUV = float2(dot(worldViewRight, normalDirection), dot(worldViewUp, normalDirection)) * 0.5 + 0.5;
    return SphereUV;
}

static const float3 lumCoeff = float3(0.2126729, 0.7151522, 0.0721750);
float AvgLuminance(float3 color) {
	return sqrt(
		(color.x * color.x * lumCoeff.x) +
		(color.y * color.y * lumCoeff.y) +
		(color.z * color.z * lumCoeff.z)
	);
}

float3 decodeSRGB(float3 screenRGB) {
    float3 a = screenRGB / 12.92f;
    float3 b = pow((screenRGB + 0.055) / 1.055, (float3)(2.4f));
    float3 c = step((float3)(0.04045f), screenRGB);
    return lerp(a, b, c);
}