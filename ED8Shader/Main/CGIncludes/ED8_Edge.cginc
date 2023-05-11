EdgeVPOutput EdgeVPShader(EdgeVPInput v) {
    EdgeVPOutput o = (EdgeVPOutput)0;
    o.uv.xy = (float2)v.uv.xy * (float2)_GameMaterialTexcoord.zw + (float2)_GameMaterialTexcoord.xy;

    float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0f));
    float3 clipNormal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
    float2 offset = TransformViewToProjection(clipNormal.xy);
    float distanceOffset = (distance(_WorldSpaceCameraPos, worldSpacePosition) < 4.0f) ? 1.0f : 0.0f;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.pos.xy += offset * (0.00100000005f + _GameEdgeParameters.w) * min(1, max(0.300000012f, o.pos.w)) * distanceOffset;

    #if defined(USE_OUTLINE_COLOR)
        //#if !defined(UNITY_COLORSPACE_GAMMA)
        //    o.Color0 = float4(LinearToGammaSpace(_OutlineColor.rgb * _OutlineColorFactor.rgb + _GameMaterialEmission.rgb), 1.0f);
        //#else
            o.Color0 = float4(_OutlineColor.rgb * _OutlineColorFactor.rgb + _GameMaterialEmission.rgb, 1.0f);
        //#endif
    #else  
        //#if !defined(UNITY_COLORSPACE_GAMMA)
        //    o.Color0 = float4(LinearToGammaSpace(_GameEdgeParameters.rgb * _OutlineColorFactor.rgb + _GameMaterialEmission.rgb), 1.0f);
        //#else 
            o.Color0 = float4(_GameEdgeParameters.rgb * _OutlineColorFactor.rgb + _GameMaterialEmission.rgb, 1.0f);
        //#endif
    #endif

    o.Color0 = saturate(o.Color0);
    o.Color1.rgb = float3(0.0f, 0.0f, 0.0f);

    #if defined(FOG_ENABLED)
        float3 viewSpacePosition = UnityWorldToViewPos(worldSpacePosition);
        o.Color1.a = EvaluateFogVP(-viewSpacePosition.z, worldSpacePosition.y);
    #else // FOG_ENABLED
        o.Color1.a = 0.0f;
    #endif // FOG_ENABLED
    return o;
}

// 非飽和加算 - [シェーダモデル1.1シングルパスで醜い加算合成の飽和をなんとかする]のやつ
fixed4 EdgeFPShader(EdgeVPOutput v) : SV_TARGET {
    #if defined(NOTHING_ENABLED)
        return float4(0.0, 0.0, 0.0, 1.0);
    #else
        float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);
        diffuseAmt = tex2D(_MainTex, v.uv.xy);

        //#if !defined(UNITY_COLORSPACE_GAMMA)
        //    diffuseAmt.rgb = LinearToGammaSpace(diffuseAmt.rgb);
        //#endif

        diffuseAmt = v.Color0 * diffuseAmt;

        float4 resultColor = diffuseAmt;

        #if defined(ALPHA_TESTING_ENABLED)
            resultColor.a *= 1 + max(0, CalcMipLevel(v.uv)) * 0.25;
            resultColor.a = (resultColor.a - _AlphaThreshold) / max(fwidth(resultColor.a), 0.0001) + _AlphaThreshold;
        #endif //ALPHA_TESTING_ENABLED

        //#if !defined(UNITY_COLORSPACE_GAMMA)
        //    resultColor.rgb = GammaToLinearSpace(resultColor.rgb);
        //#endif

        #if defined(FOG_ENABLED)
            EvaluateFogFP(resultColor.rgb, _UdonFogColor.rgb, v.Color1.a);
        #endif // FOG_ENABLED

        return resultColor;
    #endif
}