//-----------------------------------------------------------------------------
// vertex shader
DefaultVPOutput DefaultVPShader (DefaultVPInput v) {
    UNITY_SETUP_INSTANCE_ID(v);
    DefaultVPOutput o;
    UNITY_INITIALIZE_OUTPUT(DefaultVPOutput, o);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float3 normal = v.normal;
    float3 position = v.vertex.xyz;
    float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(position.xyz, 1.0f)).xyz;
    float3 worldSpaceNormal = UnityObjectToWorldNormal(normal); //normalize(mul(unity_ObjectToWorld, float4(normal.xyz, 0.0f)).xyz);  
    //float3 worldSpaceNormal = normalize(mul(unity_ObjectToWorld, float4(normal.xyz, 0.0f)).xyz); 

    #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
        #if defined(USE_TANGENTS)
            //float3 tangent = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0f)).xyz);
            float3 tangent = UnityObjectToWorldDir(v.tangent.xyz);
            o.tangent = (float3)tangent;
        #endif // USE_TANGENTS
    #endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

    #if defined(WINDY_GRASS_ENABLED)
        #if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, 1.0f - v.uv.y);
        #else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
        #endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
    #endif // WINDY_GRASS_ENABLED

    o.pos = UnityWorldToClipPos(worldSpacePosition);
    o.WorldPositionDepth = float4(worldSpacePosition.xyz, -mul(float4(UnityWorldSpaceViewDir(worldSpacePosition), 1.0f), UNITY_MATRIX_V).z);
    o.normal = (float3)worldSpaceNormal;
    float3 viewSpacePosition = mul(float4(UnityWorldSpaceViewDir(worldSpacePosition), 1.0f), UNITY_MATRIX_V).xyz;
    
    o.uv.xy = (float2)v.uv.xy * (float2)_GameMaterialTexcoord.zw + (float2)_GameMaterialTexcoord.xy;

    #if !defined(UVA_SCRIPT_ENABLED)
        #if defined(TEXCOORD_OFFSET_ENABLED)
            o.uv.xy += (float2)(_TexCoordOffset * getGlobalTextureFactor());
        #endif // TEXCOORD_OFFSET_ENABLED
    #endif // UVA_SCRIPT_ENABLED

    // TexCoord2
    #if defined(DUDV_MAPPING_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            o.DuDvTexCoord.xy = (float2)v.uv.xy;
            o.DuDvTexCoord.xy += (float2)(_DuDvScroll * getGlobalTextureFactor());
        #else // UVA_SCRIPT_ENABLED
            o.DuDvTexCoord.xy = v.uv.xy * (float2)_UVaDuDvTexcoord.zw + (float2)_UVaDuDvTexcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #elif defined(MULTI_UV_ENANLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            o.uv2.xy = (float2)v.uv2.xy;

            #if defined(MULTI_UV_TEXCOORD_OFFSET_ENABLED)
                o.uv2.xy += (float2)(_TexCoordOffset2 * getGlobalTextureFactor());
            #endif // MULTI_UV_TEXCOORD_OFFSET_ENABLED

            o.uv2.xy += (float2)_GameMaterialTexcoord.xy;
        #else // UVA_SCRIPT_ENABLED
            o.uv2.xy = v.uv2.xy * (float2)_UVaMUvTexcoord.zw + (float2)_UVaMUvTexcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #endif // MULTI_UV_ENANLED

    // TexCoord3
    #if defined(MULTI_UV2_ENANLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            o.uv3.xy = (float2)v.uv3.xy;

            #if defined(MULTI_UV2_TEXCOORD_OFFSET_ENABLED)
                o.uv3.xy += (float2)(_TexCoordOffset3 * getGlobalTextureFactor());
            #endif // MULTI_UV2_TEXCOORD_OFFSET_ENABLED

            o.uv3.xy += (float2)_GameMaterialTexcoord.xy;
        #else // UVA_SCRIPT_ENABLED
            o.uv3.xy = v.uv3.xy * (float2)_UVaMUv2Texcoord.zw + (float2)_UVaMUv2Texcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #endif // defined(MULTI_UV2_ENANLED)

    #if defined(PROJECTION_MAP_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            o.ProjMap.xy = float2(worldSpacePosition.xz / _ProjectionScale + _ProjectionScroll * getGlobalTextureFactor());
        #else // UVA_SCRIPT_ENABLED
            o.ProjMap.xy = float2(worldSpacePosition.xz / _ProjectionScale) + _UVaProjTexcoord.xy;
            //x	o.ProjMap.xy = half2(worldSpacePosition.xz / ProjectionScale) + ProjectionScroll * UVaProjTexcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #endif // 

    #if defined(VERTEX_COLOR_ENABLED)
        o.Color0 = float4(v.color.r, v.color.g, v.color.b, v.color.a);
    #else // VERTEX_COLOR_ENABLED
        o.Color0 = float4(1.0f, 1.0f, 1.0f, 1.0f);
    #endif // VERTEX_COLOR_ENABLED

    o.Color0 = saturate(o.Color0);
    o.Color1.rgb = float3(1.0f, 1.0f, 1.0f);

    #if defined(FOG_ENABLED)
        o.Color1.a = EvaluateFogVP(viewSpacePosition);
    #else // FOG_ENABLED
        o.Color1.a = 0.0f;
    #endif // FOG_ENABLED

    float3 worldSpaceEyeDirection = normalize(getEyePosition() - worldSpacePosition);

    #if ((defined(USE_LIGHTING) && !defined(USE_PER_VERTEX_LIGHTING)) || (defined(CARTOON_SHADING_ENABLED) && !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)))
        #define VP_LIGHTPROCESS
    #endif

    float3 light0dir = float3(0.0f, 0.0f, 0.0f);
    #if defined(VP_LIGHTPROCESS)
        #if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
            light0dir = normalize(_LightDirForChar);
        #elif defined(SHINING_MODE_ENABLED)
            light0dir = normalize(float3(0.0f, 1.0f, 0.0f));
        #else
            light0dir = normalize(_WorldSpaceLightPos0.xyz);
        #endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED

        //#if defined(RECEIVE_SHADOWS)
        #if defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
            o.WorldPositionDepth.xyz += light0dir * _ShadowReceiveOffset + worldSpaceNormal * -0.02f;
        #else // defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
            o.WorldPositionDepth.xyz += light0dir * 0.02f + worldSpaceNormal * -0.01f;
        #endif // !defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && !defined(CARTOON_SHADING_ENABLED)
        //#endif // RECEIVE_SHADOWS
    #else
        light0dir = normalize(float3(0.0f, -1.0f, 0.0f));
    #endif

    #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
    #else
        #if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
            #define VP_NDOTE_1
        #endif
    #endif

    #if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
        #if defined(CUBE_MAPPING_ENABLED)
            #define VP_NDOTE_2
        #endif // defined(CUBE_MAPPING_ENABLED) // defined(SPHERE_MAPPING_ENABLED)
    #endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

    #if defined(CARTOON_SHADING_ENABLED)
        #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
            #define VP_NDOTE_3
        #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
    #endif // defined(CARTOON_SHADING_ENABLED)

    #if defined(VP_NDOTE_1) || defined(VP_NDOTE_2) || defined(VP_NDOTE_3)
        float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
    #endif

    #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
        // Per-Pixel
    #else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
        // Per-Vertex
        #if defined(USE_LIGHTING)
            EvaluateLightingPerVertexVP(o.ShadingAmount.rgb, o.LightingAmount.rgb, o.Color1.rgb, light0dir, worldSpacePosition, worldSpaceNormal, worldSpaceEyeDirection);

            #if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
                o.ShadingAmount.a = EvaluateRimLightValue(ndote);
            #endif // defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
        #endif // USE_LIGHTING
    #endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

    #if defined(USE_SCREEN_UV)
        o.ReflectionMap = GenerateScreenProjectedUv(o.pos);
    #endif // defined(USE_SCREEN_UV)

    #if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
        #if defined(CUBE_MAPPING_ENABLED)
            o.CubeMap = float4(reflect(-worldSpaceEyeDirection, worldSpaceNormal), 1.0f - max(0.0f, ndote) * (float)_CubeFresnelPower);
        #elif defined(SPHERE_MAPPING_ENABLED)
            float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)UNITY_MATRIX_V);
            o.SphereMap = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
        #endif // defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
    #endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

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

    // compute shadows data
    TRANSFER_SHADOW(o);
    return o;
}

#undef VP_LIGHTPROCESS
#undef VP_NDOTE_1
#undef VP_NDOTE_2
#undef VP_NDOTE_3