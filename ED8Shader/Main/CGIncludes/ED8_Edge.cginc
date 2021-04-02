#if !defined(NOTHING_ENABLED)
    EdgeVPOutput EdgeVPShader(EdgeVPInput IN) {
        EdgeVPOutput OUT;
        float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(IN.Position.xyz, 1.0f));
        OUT.Position = mul(float4(worldSpacePosition.xyz, 1.0f), UNITY_MATRIX_VP);	
        float3 worldSpaceNormal = normalize(mul(unity_ObjectToWorld, float4(IN.Normal.xyz, 0.0f)).xyz);
        float2 projSpaceNormal = mul(float4(worldSpaceNormal.xyz, 0.0), UNITY_MATRIX_VP).xy;
        projSpaceNormal = normalize(projSpaceNormal);
        projSpaceNormal *= OUT.Position.w;
        OUT.Position.xy += (float2)(projSpaceNormal * _GameEdgeParameters.w);
        OUT.TexCoord.xyz = float3(IN.TexCoord.xy, 0.0f);
        OUT.Color0 = float4(_GameEdgeParameters.xyz + (float3)_GameMaterialEmission, 1.0f);
        OUT.Color0 = saturate(OUT.Color0);
        return OUT;
    }

    float4 EdgeFPShader(EdgeFPInput IN) : COLOR0 {
        float4 resultColor = (float4)IN.Color0;
        resultColor.a *= tex2D(_MainTex, IN.TexCoord.xy).a;

        #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
            clip(resultColor.a - _AlphaThreshold);
        #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED

        #if defined(USE_EDGE_ADDUNSAT)
            return EvaluateAddUnsaturation(resultColor);
        #else // USE_EDGE_ADDUNSAT
            return resultColor;
        #endif // USE_EDGE_ADDUNSAT
    }
#endif // !defined(NOTHING_ENABLED)
