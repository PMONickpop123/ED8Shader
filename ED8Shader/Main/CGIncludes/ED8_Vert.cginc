#define VP_DEFAULT
#undef VP_PORTRAIT

#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED) || defined(SHINING_MODE_ENABLED)
	#undef VP_DEFAULT
	#define VP_PORTRAIT
#endif

//-----------------------------------------------------------------------------
// vertex shader
DefaultVPOutput DefaultVPShader (DefaultVPInput v) {
    DefaultVPOutput o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(DefaultVPOutput, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float3 position = v.vertex.xyz;
    float3 normal = v.normal;

    #if defined(USE_LIGHTING)
        #if defined(USE_TANGENTS)
            float3 tangent = UnityObjectToWorldDir(v.tangent.xyz);
            float3 binormal = CreateBinormal(normal, v.tangent.xyz, v.tangent.w);
            
            o.tangent = tangent;
            o.binormal = binormal;
        #endif // USE_TANGENTS
    #endif // USE_LIGHTING

    /*
    #if defined(INSTANCING_ENABLED) && defined(FAR_CLIP_BY_DITHER_ENABLED)
        // 距離クリップされることが分かっているインスタンスには０スケールを掛けてピクセル負荷を抑える
        float3 instancePos = float3(v.instancingInput.InstanceTransform0.w, v.instancingInput.InstanceTransform1.w, v.instancingInput.InstanceTransform2.w);
        float3 instancePosInView = _mul(scene.View, float4(instancePos, 1)).xyz;
        position *= (-instancePosInView.z) > _GameDitherParams.z ? 0.0 : 1.0;
    #endif // defined(INSTANCING_ENABLED) && defined(FAR_CLIP_BY_DITHER_ENABLED)

    #if defined(INSTANCING_ENABLED)
        ApplyInstanceTransformVertex(v.instancingInput, position);
        ApplyInstanceTransformNormal(v.instancingInput, normal);

        #if defined(USE_TANGENTS)
            ApplyInstanceTransformNormal(v.instancingInput, tangent);
        #endif
    #endif // defined(INSTANCING_ENABLED)
    */

	float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(position, 1)).xyz;
	float3 worldSpaceNormal = normalize(UnityObjectToWorldNormal(normal));

    #if defined(WINDY_GRASS_ENABLED)
        #if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, 1.0f - v.uv.y);
        #else
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
        #endif
    #endif

    float3 viewSpacePosition = UnityWorldToViewPos(worldSpacePosition);
    o.pos = UnityWorldToClipPos(worldSpacePosition);
    o.WorldPositionDepth = float4(worldSpacePosition.xyz, -viewSpacePosition.z);
    o.normal = worldSpaceNormal;
    o.uv.xy = float2(v.uv.xy) * float2(_GameMaterialTexcoord.zw) + float2(_GameMaterialTexcoord.xy);

    #if defined(TEXCOORD_OFFSET_ENABLED)
        o.uv.xy += _TexCoordOffset.xy * GetGlobalTextureFactor();
    #endif // TEXCOORD_OFFSET_ENABLED

    // TexCoord2 / マルチUV
    #if defined(MULTI_UV_ENANLED)
        o.uv2.xy = v.uv2.xy;

        #if defined(MULTI_UV_TEXCOORD_OFFSET_ENABLED)
            o.uv2.xy += _TexCoordOffset2.xy * GetGlobalTextureFactor();
        #else
            o.uv2.xy = v.uv2.xy * float2(_UVaMUvTexcoord.zw) + float2(_UVaMUvTexcoord.xy);
        #endif // MULTI_UV_TEXCOORD_OFFSET_ENABLED

        o.uv2.xy += _GameMaterialTexcoord.xy;
    #endif // MULTI_UV_ENANLED

    // TexCoord3 / マルチUV2
    #if defined(MULTI_UV2_ENANLED)
        o.uv3.xy = v.uv3.xy;

        #if defined(MULTI_UV2_TEXCOORD_OFFSET_ENABLED)
            o.uv3.xy += _TexCoordOffset3.xy * GetGlobalTextureFactor();
        #else
            o.uv3.xy = v.uv3.xy * float2(_UVaMUv2Texcoord.zw) + float2(_UVaMUv2Texcoord.xy);
        #endif // MULTI_UV2_TEXCOORD_OFFSET_ENABLED

        o.uv3.xy += _GameMaterialTexcoord.xy;
    #endif // defined(MULTI_UV2_ENANLED)

	// DUDV
    #if defined(DUDV_MAPPING_ENABLED)
        //o.DuDvTexCoord.xy = v.uv.xy * half2(_UVaDuDvTexcoord.zw) + half2(_UVaDuDvTexcoord.xy);
        o.DuDvTexCoord.xy = float2(v.uv.xy * _UVaDuDvTexcoord.zw + (_DuDvScroll.xy * GetGlobalTextureFactor()));
    #endif // defined(DUDV_MAPPING_ENABLED)

    // 射影マップ
    #if defined(PROJECTION_MAP_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
        //o.ProjMap.xy = half2(worldSpacePosition.xz / _ProjectionScale) + _UVaProjTexcoord.xy;
        o.ProjMap.xy = float2(worldSpacePosition.xz / _ProjectionScale + (_ProjectionScroll * GetGlobalTextureFactor()));
    #endif // defined(PROJECTION_MAP_ENABLED)

    // 頂点カラー
    #if defined(VERTEX_COLOR_ENABLED)
        o.Color0 = min(float4(1, 1, 1, 1), float4(v.color.r, v.color.g, v.color.b, v.color.a));
    #else
        o.Color0 = float4(1, 1, 1, 1);
    #endif

    // フォグ
    o.Color1.rgb = float3(0, 0, 0);
    #if defined(FOG_ENABLED)
        o.Color1.a = EvaluateFogValue(-viewSpacePosition.z, worldSpacePosition.y);
    #else
        o.Color1.a = 0;
    #endif

    /*
	// インスタンス描画
    #if defined(INSTANCING_ENABLED)
        o.instanceParam = float4(0, 0, 0, 0);

        #if defined(FAR_CLIP_BY_DITHER_ENABLED)
            // ディザリングによる距離クリップ
            float ditherValue = EvaluateDitherValue(instancePosInView, _GameDitherParams.x, _GameDitherParams.y);
            o.instanceParam.x = ditherValue;
        #endif
        // ディザリングによるモデル切替
        o.instanceParam.y = v.instancingInput.InstanceColor.x;
        o.instanceParam.z = v.instancingInput.InstanceColor.y;
    #endif // defined(INSTANCING_ENABLED)
    */

    float3 worldSpaceEyeDirection = normalize(GetEyePosition() - worldSpacePosition);

    #if (defined(USE_LIGHTING) || (defined(CARTOON_SHADING_ENABLED) && !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)))
        #define VP_LIGHTPROCESS
    #endif

    float3 light0dir = float3(0.0f, 0.0f, 0.0f);
    #if defined(VP_LIGHTPROCESS)
        #if defined(VP_PORTRAIT)
            #if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
                light0dir = normalize(_WorldSpaceLightPos0.xyz);
            #else
                light0dir = normalize(float3(0.0f, 1.0f, 0.0f));
            #endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
        #else
            light0dir = normalize(_WorldSpaceLightPos0.xyz);
        #endif // VP_PORTRAIT
    #else
        light0dir = normalize(float3(0.0f, -1.0f, 0.0f));
    #endif

    #if defined(CARTOON_SHADING_ENABLED)
        #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
            #define VP_NDOTE
        #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
    #endif // defined(CARTOON_SHADING_ENABLED)

    #if defined(VP_NDOTE)
        float ndote = saturate(dot(worldSpaceNormal, worldSpaceEyeDirection));
    #endif

    #if defined(USE_SCREEN_UV)
        o.screenPos = ComputeGrabScreenPos(o.pos);
    #endif // defined(USE_SCREEN_UV)

    #if defined(CARTOON_SHADING_ENABLED)
        #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
            float ldotn = dot(light0dir, worldSpaceNormal);

            #if defined(CARTOON_HILIGHT_ENABLED)
                float hilit_u = (1.0f - abs(ndote) * 0.667f) * max(ldotn, 0.0f);
                o.CartoonMap.xyz = float3(hilit_u, 0.5f, ldotn);
            #else // CARTOON_HILIGHT_ENABLED
                o.CartoonMap.xyz = float3(0.0f, 0.0f, ldotn);
            #endif // CARTOON_HILIGHT_ENABLED
        #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
    #endif // defined(CARTOON_SHADING_ENABLED)

    // compute shadows data.
    UNITY_TRANSFER_SHADOW(o, o.uv);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    return o;
}

#undef VP_LIGHTPROCESS
#undef VP_NDOTE