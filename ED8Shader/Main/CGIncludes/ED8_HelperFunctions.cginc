float3 EvaluateNormalMapNormal(float3 inNormal, float2 inUv, float3 inTangent, uniform sampler2D normalMap) {
    float4 normalMapData = tex2D(normalMap, inUv).xyzw;
    float3 normalMapNormal = float3(0.0f, 0.0f, 0.0f);

    #if defined(NORMAL_MAPP_DXT5_NM_ENABLED)
        normalMapNormal.x = normalMapData.a * 2.0 - 1.0;
        normalMapNormal.y = normalMapData.r * 2.0 - 1.0;
        normalMapNormal.z = sqrt(1 - saturate(normalMapNormal.x * normalMapNormal.x - normalMapNormal.y * normalMapNormal.y));
    #elif defined(NORMAL_MAPP_DXT5_LP_ENABLED)
        normalMapData = normalMapData * 2.0 - 1.0;
        normalMapNormal.x = normalMapData.r * normalMapData.a;
        normalMapNormal.y = normalMapData.g;
        normalMapNormal.z = sqrt(1 - saturate(normalMapNormal.x * normalMapNormal.x - normalMapNormal.y * normalMapNormal.y));
    #else // NORMAL_MAPP_DXT5_NM_ENABLED
        normalMapNormal = normalMapData.xyz * 2.0 - 1.0;
        //normalMapNormal.xy = normalMapData.xy * 2.0 - 1.0;
        //normalMapNormal.z = sqrt(1 - saturate(normalMapNormal.x * normalMapNormal.x - normalMapNormal.y * normalMapNormal.y));
        //normalMapNormal.z = sqrt(1 - saturate(dot(normalMapData.xy, normalMapData.xy)));
    #endif // NORMAL_MAPP_DXT5_NM_ENABLED

	inTangent = normalize(inTangent);
	inNormal = normalize(inNormal);
	float3 biTangent = cross(inNormal, inTangent);
	normalMapNormal.x *= (inUv.x < 0.0f) ? -1.0f : 1.0f;
	float3 n = normalize((normalMapNormal.x * inTangent) + (normalMapNormal.y * biTangent) + (normalMapNormal.z * inNormal));	
	return n;
}

float3 EvaluateStandardNormal(float3 inNormal) {
	return normalize(inNormal).xyz;
}

float3 getEyePosition() {
	return _WorldSpaceCameraPos.xyz;
}

//-----------------------------------------------------------------------------
float2 getGlobalTextureFactor() {
	//return (_GlobalTexcoordFactor + 0.001) * (float2)_Time * 0.25f;
    return (float2)_Time.y * 0.60f;
}

float CalcMipLevel(float2 texcoord){
    float2 dx = ddx(texcoord);
    float2 dy = ddy(texcoord);
    float delta_max_sqr = max(dot(dx, dx), dot(dy, dy));
    return 0.5 * log2(delta_max_sqr);
}

//-----------------------------------------------------------------------------
#if defined(USE_SCREEN_UV)
    float4 GenerateScreenProjectedUv(float4 projPosition) {
        float2 clipSpaceDivided = projPosition.xy / float2(projPosition.w, -projPosition.w);
        float2 tc = clipSpaceDivided.xy * 0.5f + 0.5f;
        return float4(tc * projPosition.w, 0, projPosition.w);	
    }
#endif // defined(USE_SCREEN_UV)

//-----------------------------------------------------------------------------
#if defined(WINDY_GRASS_ENABLED)
	#if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
        float3 calcWindyGrass(float3 position, float weight)
	#else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
        float3 calcWindyGrass(float3 position)
	#endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
    {
	    float2 time = getGlobalTextureFactor();
	    float k = position.x + position.z;
        float a = k * (1.0f / (_WindyGrassHomogenity * _WindyGrassHomogenity));
        float t = a * 0.25f + frac(a) + time.x * _WindyGrassSpeed;

        #if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
            float2 dd = _WindyGrassDirection * sin(t) * _WindyGrassScale * weight;
        #else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
            float2 dd = _WindyGrassDirection * sin(t) * _WindyGrassScale;
        #endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
	    return position.xyz + float3(dd.x, 0, dd.y);
    }
#endif // WINDY_GRASS_ENABLED

#if defined(FOG_ENABLED)
    float EvaluateFogVP(float3 viewPosition) {
        float f = (-viewPosition.z - _FogRangeParameters.x) * (-1 / (_FogRangeParameters.y - _FogRangeParameters.x)); 

        #ifdef FOG_RATIO_ENABLED
            f *= _FogRatio;
        #endif // FOG_RATIO_ENABLED

        return saturate(f);
    }

    void EvaluateFogFP(inout float3 resultColor, float3 fogColor, float fogValue) {
        #if defined(USE_EXTRA_BLENDING)
            fogColor = float3(0.0f, 0.0f, 0.0f);
        #endif // defined(USE_EXTRA_BLENDING)
        
        resultColor.rgb = lerp(resultColor.rgb, fogColor.rgb, fogValue);
    }
#endif // FOG_ENABLED

#if defined(NORMAL_MAPPING_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormalFP(In) EvaluateNormalMapNormal(In.normal.xyz, In.DuDvTexCoord.xy, In.tangent, _BumpMap)
	#else // defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormalFP(In) EvaluateNormalMapNormal(In.normal.xyz, In.uv.xy, In.tangent, _BumpMap)
	#endif // defined(DUDV_MAPPING_ENABLED)
#else
	#define EvaluateNormalFP(In) EvaluateStandardNormal(In.normal.xyz)
#endif

#if defined(NORMAL_MAPPING2_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormal2FP(In) EvaluateNormalMapNormal(In.normal.xyz, In.DuDvTexCoord.xy, In.tangent, _NormalMap2Sampler)
	#else // defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormal2FP(In) EvaluateNormalMapNormal(In.normal.xyz, In.uv.xy, In.tangent, _NormalMap2Sampler)
	#endif // defined(DUDV_MAPPING_ENABLED)
#else
	#define EvaluateNormal2FP(In) EvaluateStandardNormal(In.normal.xyz)
#endif

//-----------------------------------------------------------------------------
#if defined(RIM_LIGHTING_ENABLED)
    float EvaluateRimLightValue(float ndote) {
        float rimLightvalue = pow(1.0f - abs(ndote), _RimLitPower);
        rimLightvalue *= _RimLitIntensity;
        return rimLightvalue;
    }
#endif // RIM_LIGHTING_ENABLED

//-----------------------------------------------------------------------------
#if defined(CARTOON_SHADING_ENABLED)
    float calcToonShadingValueFP(float ldotn, float shadowValue) {
        float u = (ldotn * 0.5f + 0.5f);

        #if defined(UNITY_PASS_FORWARDBASE)
            u *= shadowValue;
        #endif

        float r = tex2D(_CartoonMapSampler, float2(u, 0.0f)).r;
        return r;
    }
#endif // CARTOON_SHADING_ENABLED

float4 EvaluateAddUnsaturation(float4 color) {
	float4 t0 = color;
	t0.rgb *= t0.a;
	float4 r0 = t0 * t0;
	r0 = r0 * r0 + float4(-0.11f, -0.11f, -0.11f, 1.0f);
	r0 = lerp(t0, r0, float4(1.0f, 0.6f, 0.0f, 1.0f));
	float r1a = min(t0.b + 0.75f, 1.0f);
	r0.a = r1a + 1.0f * -0.75f;
	return r0;
}