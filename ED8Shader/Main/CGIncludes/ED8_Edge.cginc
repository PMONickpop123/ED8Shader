EdgeVPOutput EdgeVPShader(EdgeVPInput v) {
    EdgeVPOutput o = (EdgeVPOutput)0;

    float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0f));
    o.pos = mul(UNITY_MATRIX_VP, float4(worldSpacePosition.xyz, 1.0f));	
    float3 worldSpaceNormal = UnityObjectToWorldNormal(v.normal); //normalize(mul(unity_ObjectToWorld, float4(v.Normal.xyz, 0.0f)).xyz);
    float2 projSpaceNormal = mul(UNITY_MATRIX_VP, float4(worldSpaceNormal.xyz, 0.0f)).xy;
    projSpaceNormal = normalize(projSpaceNormal);
    projSpaceNormal *= o.pos.w;
    projSpaceNormal *= (0.00100000005f + _GameEdgeParameters.w);
    o.pos.xy += projSpaceNormal;
    o.uv.xyz = float3(v.TexCoord.xy, 0.0f);

    #if defined(USE_OUTLINE_COLOR)
        o.Color0 = float4(_OutlineColor.rgb, 1.0f);//float4(_OutlineColor.rgb * _OutlineColorFactor.rgb, 1.0f);
    #else   
        o.Color0 = float4((_GameEdgeParameters.rgb + _GameMaterialEmission.rgb) * _OutlineColorFactor.rgb, 1.0f);
    #endif

    o.Color0 = saturate(o.Color0);
    o.Color1.rgb = float3(0.0f, 0.0f, 0.0f);

    #if defined(FOG_ENABLED)
        float3 viewSpacePosition = mul(UNITY_MATRIX_V, float4(UnityWorldSpaceViewDir(worldSpacePosition), 1.0f)).xyz;
        o.Color1.a = EvaluateFogVP(viewSpacePosition);
    #else // FOG_ENABLED
        o.Color1.a = 0.0f;
    #endif // FOG_ENABLED
    return o;
}

fixed4 EdgeFPShader(EdgeVPOutput v, uint facing : SV_IsFrontFace) : SV_TARGET {
    #if defined(NOTHING_ENABLED)
        return float4(0.0, 0.0, 0.0, 1.0);
    #else
        float4 resultColor = v.Color0;
        resultColor.a *= tex2D(_MainTex, v.uv.xy).a;

        #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
            clip(resultColor.a - _AlphaThreshold);
        #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED

        #if defined(FOG_ENABLED)
            EvaluateFogFP(resultColor.rgb, _FogColor.rgb, v.Color1.a);
        #endif // FOG_ENABLED

        #if defined(USE_EDGE_ADDUNSAT) && !defined(USE_OUTLINE_COLOR)
            return EvaluateAddUnsaturation(resultColor);
        #else // USE_EDGE_ADDUNSAT
            return resultColor;
        #endif // USE_EDGE_ADDUNSAT
    #endif
}