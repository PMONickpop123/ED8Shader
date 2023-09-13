EdgeVPOutput EdgeVPShader(EdgeVPInput v) {
    EdgeVPOutput o = (EdgeVPOutput)0;
    o.uv.xy = (float2)v.uv.xy * (float2)_GameMaterialTexcoord.zw + (float2)_GameMaterialTexcoord.xy;

    float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0f)).xyz;
    float3 worldSpaceNormal = mul(unity_ObjectToWorld, float4(v.normal.xyz, 0)).xyz;
    float3 clipNormal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
    float2 offset = TransformViewToProjection(clipNormal.xy);
    float distanceOffset = (distance(_WorldSpaceCameraPos, worldSpacePosition) < 4.0f) ? 1.0f : 0.0f;
    float thickness = mul(UNITY_MATRIX_V, float4(worldSpacePosition, 1)).w;
	//thickness = _GameEdgeParameters.w * clamp(thickness, 0.3, 1.0);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.pos.xy += offset * (0.00100000005f + _GameEdgeParameters.w * clamp(thickness, 0.3, 1.0)) * min(1, max(0.300000012f, o.pos.w)) * distanceOffset;
	o.worldPos = float4(worldSpacePosition.xyz, 0);
	o.uv.xy = v.uv.xy;
	
	// 輪郭色
    #if defined(USE_OUTLINE_COLOR)		
        float4 outlineColor = float4(_OutlineColor, 1);				// MAYA指定色
    #else
        float4 outlineColor = float4(_GameEdgeParameters.xyz, 1);	// デフォルト色
    #endif // define(USE_OUTLINE_COLOR)	
	
	// 環境＋平行光の影響
	half3 ambientColor = _OutlineColorFactor.rgb;
	outlineColor.rgb = outlineColor.rgb * ambientColor.rgb;
	o.Color0 = outlineColor;
	
	// フォグ
	o.Color1.rgb = half3(0, 0, 0);
    #if defined(FOG_ENABLED)
        float3 viewSpacePosition = UnityWorldToViewPos(worldSpacePosition);
        o.Color1.a = EvaluateFogValue(-viewSpacePosition.z, worldSpacePosition.y);
    #else
        o.Color1.a = 0;
    #endif

	return o;
}

// 非飽和加算 - [シェーダモデル1.1シングルパスで醜い加算合成の飽和をなんとかする]のやつ
fixed4 EdgeFPShader(EdgeVPOutput v) : SV_TARGET {
    #if defined(NOTHING_ENABLED)
        return float4(0.0, 0.0, 0.0, 1.0);
    #else
        float4 diffuseAmt = tex2D(_MainTex, v.uv.xy);
        diffuseAmt.a *= v.Color0.a;
        diffuseAmt.rgb *= v.Color0.rgb;
        diffuseAmt *= _GameMaterialDiffuse;
        diffuseAmt.rgb += _GameMaterialEmission.rgb;

        #if defined(ALPHA_TESTING_ENABLED)
            diffuseAmt.a *= 1 + max(0, CalcMipLevel(v.uv)) * 0.25;
            diffuseAmt.a = (diffuseAmt.a - _AlphaThreshold) / max(fwidth(diffuseAmt.a), 0.0001) + _AlphaThreshold;
        #endif //ALPHA_TESTING_ENABLED

        // フォグ計算
        #if defined(FOG_ENABLED) && !defined(FP_PORTRAIT)
            EvaluateFogColor(diffuseAmt.rgb, v.Color1.a, v.worldPos.xyz);
        #endif

        // モノクロ変換
        diffuseAmt.rgb = lerp(diffuseAmt.rgb, dot(diffuseAmt.rgb, half3(0.299, 0.587, 0.114)) * _MonotoneMul.xyz + _MonotoneAdd.xyz, _GameMaterialMonotone);
        return diffuseAmt;
    #endif
}