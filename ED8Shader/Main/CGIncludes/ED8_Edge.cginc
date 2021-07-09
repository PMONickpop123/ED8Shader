EdgeVPOutput EdgeVPShader(EdgeVPInput v) {
    EdgeVPOutput o = (EdgeVPOutput)0;

    float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0f));
    float4 clipPosition = UnityObjectToClipPos(v.vertex);
    float3 clipNormal = mul((float3x3)UNITY_MATRIX_VP, mul((float3x3)UNITY_MATRIX_M, v.normal));
    float2 offset = normalize(clipNormal.xy) * (0.00100000005f + _GameEdgeParameters.w) * clipPosition.w;
    clipPosition.xy += offset;
    o.pos = clipPosition;

    #if defined(USE_OUTLINE_COLOR)
        o.Color0 = float4(_OutlineColor.rgb * _OutlineColorFactor.rgb + _GameMaterialEmission.rgb, 1.0f);
    #else   
        o.Color0 = float4(_GameEdgeParameters.rgb * _OutlineColorFactor.rgb + _GameMaterialEmission.rgb, 1.0f);
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
        float4 diffuseAmt = tex2D(_MainTex, v.uv.xy);
        float4 resultColor = v.Color0 * diffuseAmt;
        resultColor.a *= diffuseAmt.a;

        #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
            clip(resultColor.a - _AlphaThreshold);
        #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED

        #if defined(FOG_ENABLED)
            EvaluateFogFP(resultColor.rgb, _FogColor.rgb, v.Color1.a);
        #endif // FOG_ENABLED

        return resultColor;
    #endif
}