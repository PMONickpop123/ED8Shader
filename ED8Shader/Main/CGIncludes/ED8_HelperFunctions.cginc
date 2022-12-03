float3 EvaluateNormalMapNormal(float3 inNormal, float2 inUv, float3 inTangent, float3 inBiTangent, uniform sampler2D normalMap) {
    float4 normalMapData = tex2D(normalMap, inUv).xyzw;

    #if !defined(UNITY_COLORSPACE_GAMMA)
        normalMapData.rgb = LinearToGammaSpace(normalMapData.rgb);
        normalMapData.a = LinearToGammaSpaceExact(normalMapData.a);
    #endif

    normalMapData = normalMapData * float4(2.0f, 2.0f, 2.0f, 2.0f) - float4(1.0f, 1.0f, 1.0f, 1.0f);
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
        normalMapData *= 2.0f;
        normalMapNormal.xyz = normalMapData.xyz;
        //normalMapNormal.xy = normalMapData.xy;
        //normalMapNormal.z = sqrt(1 - saturate(dot(normalMapNormal.xy, normalMapNormal.xy)));
        //normalMapNormal.z = sqrt(1 - saturate(normalMapNormal.x * normalMapNormal.x - normalMapNormal.y * normalMapNormal.y));
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

float3 getEyePosition() {
	return _WorldSpaceCameraPos.xyz;
}

//-----------------------------------------------------------------------------
float getGlobalTextureFactor() {
	//return (_GlobalTexcoordFactor + 0.001) * (float2)_Time * 0.25f;
    return _Time.y * 0.30f;
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
	    float time = getGlobalTextureFactor();
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
    float EvaluateFogVP(float z, float worldY) {
        float f = saturate((z - _FogRangeParameters.x) * (1 / (_FogRangeParameters.y - _FogRangeParameters.x)));

        /*
        scene.MiscParameters3.x = (CameraYPosition * _HeightCamRate) + _HeightFogNear
        scene.FogRangeParameters.x = FogNear
        scene.FogRangeParameters.z  = 1 / (FogFar - FogNear)
        scene.FogRangeParameters.w = _FogRateClamp
        r0.y = worldYPosition
        r0.w = dot(worldPosition, scene.View._m02_m12_m22_m32) aka clipPosition.z
        r1.x = -scene.MiscParameters3.x + r0.y;
        r0.x = saturate(scene.MiscParameters3.y * r1.x);
        r0.y = -scene.FogRangeParameters.x + -r0.w;
        r0.y = saturate(scene.FogRangeParameters.z * r0.y);
        r0.z = scene.MiscParameters3.z + r0.y;
        r0.z = min(1, r0.z);
        r0.x = r0.x * r0.z + r0.y;
        r0.x = min(1, r0.x);
        o2.w = scene.FogRangeParameters.w * r0.x;
        */
        float HeightFogSubtraction = (_HeightFogRangeParameters.y - _HeightFogRangeParameters.x);
        float3 MiscParameters3;
        
        MiscParameters3.x = (_WorldSpaceCameraPos.y * _HeightCamRate); //- _HeightFogRangeParameters.x;
        MiscParameters3.y = (HeightFogSubtraction == 0.0f) ? 0.0f : (1 / HeightFogSubtraction);
        MiscParameters3.z = _HeightDepthBias;

        float hf = saturate((worldY - MiscParameters3.x) * MiscParameters3.y);
        float f2 = min(1.0f, MiscParameters3.z + f);

        f = min(1.0f, (hf * f2) + f);

        #if defined(FOG_RATIO_ENABLED)
            #if !defined(UNITY_COLORSPACE_GAMMA)
                f *= LinearToGammaSpaceExact(_FogRatio);
            #else
                f *= _FogRatio;
            #endif
        #endif // FOG_RATIO_ENABLED

        f *= _FogRateClamp;

        #if !defined(UNITY_COLORSPACE_GAMMA)
            f = GammaToLinearSpaceExact(f);
        #endif
        return f;
    }

    void EvaluateFogFP(inout float3 resultColor, float3 fogColor, float fogValue) {
        #if defined(USE_EXTRA_BLENDING)
            fogColor = float3(0.0f, 0.0f, 0.0f);
        #endif // defined(USE_EXTRA_BLENDING)

        #if !defined(UNITY_COLORSPACE_GAMMA)
            resultColor.rgb = lerp(resultColor.rgb, fogColor.rgb, fogValue);
        #else
            resultColor.rgb = lerp(resultColor.rgb, fogColor.rgb, fogValue);
        #endif
    }
#endif // FOG_ENABLED

#if defined(NORMAL_MAPPING_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		//#define EvaluateNormalFP(In) EvaluateNormalMapNormal(In.normal.xyz, In.DuDvTexCoord.xy, In.tangent, In.binormal, _BumpMap)
        #define EvaluateNormalFP(In, dudvValue) EvaluateNormalMapNormal(In.normal.xyz, In.uv.xy + dudvValue, In.tangent, In.binormal, _BumpMap)
	#else // defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormalFP(In) EvaluateNormalMapNormal(In.normal.xyz, In.uv.xy, In.tangent, In.binormal, _BumpMap)
	#endif // defined(DUDV_MAPPING_ENABLED)
#else
	#define EvaluateNormalFP(In) EvaluateStandardNormal(In.normal.xyz)
#endif

#if defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	#if defined(DUDV_MAPPING_ENABLED)
		//#define EvaluateNormal2FP(In) EvaluateNormalMapNormal(In.normal.xyz, In.DuDvTexCoord.xy, In.tangent, In.binormal, _NormalMap2Sampler)
        #define EvaluateNormal2FP(In, dudvValue) EvaluateNormalMapNormal(In.normal.xyz, In.uv.xy + dudvValue, In.tangent, In.binormal, _NormalMap2Sampler)
	#else // defined(DUDV_MAPPING_ENABLED)
		#define EvaluateNormal2FP(In) EvaluateNormalMapNormal(In.normal.xyz, In.uv2.xy, In.tangent, In.binormal, _NormalMap2Sampler)
	#endif // defined(DUDV_MAPPING_ENABLED)
#else
	#define EvaluateNormal2FP(In) EvaluateStandardNormal(In.normal.xyz)
#endif

//-----------------------------------------------------------------------------
#if defined(RIM_LIGHTING_ENABLED)
    float EvaluateRimLightValue(float ndote) {
        #if !defined(UNITY_COLORSPACE_GAMMA)
            float rimLightvalue = pow(saturate(1.0f - ndote), _RimLitPower);
            rimLightvalue *= _RimLitIntensity;
        #else
            float rimLightvalue = pow(saturate(1.0f - ndote), _RimLitPower);
            rimLightvalue *= _RimLitIntensity;
        #endif
        return rimLightvalue;
    }
#endif // RIM_LIGHTING_ENABLED

//-----------------------------------------------------------------------------
#if defined(CARTOON_SHADING_ENABLED)
    float calcToonShadingValueFP(float ldotn, float shadowValue) {
        float u = pow((ldotn * 0.5f + 0.5f), 2.4);

        #if defined(UNITY_PASS_FORWARDBASE)
            #if !defined(FLAT_AMBIENT_ENABLED)
                u *= shadowValue;
            #endif
        #endif

        float r = tex2D(_CartoonMapSampler, float2(u, 0.0f)).x;

        #if !defined(UNITY_COLORSPACE_GAMMA)
            r = LinearToGammaSpaceExact(r);
        #endif
        return r;
    }
#endif // CARTOON_SHADING_ENABLED

// Returns pixel sharpened to nearest pixel boundary. 
// texelSize is Unity _Texture_TexelSize; zw is w/h, xy is 1/wh
float2 sharpSample(float4 texelSize, float2 p) {
	p = p * texelSize.zw;

    float2 c = max(0.0f, fwidth(p));

    p = floor(p) + saturate(frac(p) / c);
	p = (p - 0.5f) * texelSize.xy;
	return p;
}

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

half2 SampleSphereMap(half3 viewDirection, half3 normalDirection) {
    half3 worldUp = half3(0, 1, 0);
    half3 worldViewUp = normalize(worldUp - viewDirection * dot(viewDirection, worldUp));
    half3 worldViewRight = normalize(cross(viewDirection, worldViewUp));
    half2 SphereUV = half2(dot(worldViewRight, normalDirection), dot(worldViewUp, normalDirection)) * 0.5 + 0.5;
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