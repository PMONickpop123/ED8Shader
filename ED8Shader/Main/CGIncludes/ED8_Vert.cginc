//-----------------------------------------------------------------------------
// vertex shader
DefaultVPOutput DefaultVPShader (DefaultVPInput IN) {
    UNITY_SETUP_INSTANCE_ID(IN);
    DefaultVPOutput OUT;
    UNITY_INITIALIZE_OUTPUT(DefaultVPOutput, OUT);
    UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

    float3 normal = IN.Normal;
    float3 position = IN.Position.xyz;
    float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(position.xyz, 1.0f)).xyz; 
    float3 worldSpaceNormal = normalize(mul(unity_ObjectToWorld, float4(normal.xyz, 0.0f)).xyz); 

    #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
        #if defined(USE_TANGENTS)
            float3 tangent = normalize(mul(unity_ObjectToWorld, float4(IN.Tangent.xyz, 0.0f)).xyz);
            OUT.Tangent = (float3)tangent;
        #endif // USE_TANGENTS
    #endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

    #if defined(WINDY_GRASS_ENABLED)
        #if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, IN.TexCoord.y);
        #else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
        #endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
    #endif // WINDY_GRASS_ENABLED

    OUT.pos = UnityWorldToClipPos(worldSpacePosition);
    OUT.WorldPositionDepth = float4(worldSpacePosition.xyz, -mul(float4(worldSpacePosition.xyz, 1.0f), UNITY_MATRIX_V).z);
    OUT.Normal = (float3)worldSpaceNormal;
    float3 viewSpacePosition = mul(float4(UnityWorldSpaceViewDir(worldSpacePosition), 1.0), UNITY_MATRIX_V).xyz;
    
    OUT.TexCoord.xy = (float2)IN.TexCoord.xy * (float2)_GameMaterialTexcoord.zw + (float2)_GameMaterialTexcoord.xy;

    #if !defined(UVA_SCRIPT_ENABLED)
        #if defined(TEXCOORD_OFFSET_ENABLED)
            OUT.TexCoord.xy += (float2)(_TexCoordOffset * getGlobalTextureFactor());
        #endif // TEXCOORD_OFFSET_ENABLED
    #endif // UVA_SCRIPT_ENABLED

    // TexCoord2
    #if defined(DUDV_MAPPING_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            OUT.DuDvTexCoord.xy = (float2)IN.TexCoord.xy;
            OUT.DuDvTexCoord.xy += (float2)(_DuDvScroll * getGlobalTextureFactor());
        #else // UVA_SCRIPT_ENABLED
            OUT.DuDvTexCoord.xy = IN.TexCoord.xy * (float2)_UVaDuDvTexcoord.zw + (float2)_UVaDuDvTexcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #elif defined(MULTI_UV_ENANLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            OUT.TexCoord2.xy = (float2)IN.TexCoord2.xy;

            #if defined(MULTI_UV_TEXCOORD_OFFSET_ENABLED)
                OUT.TexCoord2.xy += (float2)(_TexCoordOffset2 * getGlobalTextureFactor());
            #endif // MULTI_UV_TEXCOORD_OFFSET_ENABLED

            OUT.TexCoord2.xy += (float2)_GameMaterialTexcoord.xy;
        #else // UVA_SCRIPT_ENABLED
            OUT.TexCoord2.xy = IN.TexCoord2.xy * (float2)_UVaMUvTexcoord.zw + (float2)_UVaMUvTexcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #endif // MULTI_UV_ENANLED

    // TexCoord3
    #if defined(MULTI_UV2_ENANLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            OUT.TexCoord3.xy = (float2)IN.TexCoord3.xy;

            #if defined(MULTI_UV2_TEXCOORD_OFFSET_ENABLED)
                OUT.TexCoord3.xy += (float2)(_TexCoordOffset3 * getGlobalTextureFactor());
            #endif // MULTI_UV2_TEXCOORD_OFFSET_ENABLED

            OUT.TexCoord3.xy += (float2)_GameMaterialTexcoord.xy;
        #else // UVA_SCRIPT_ENABLED
            OUT.TexCoord3.xy = IN.TexCoord3.xy * (float2)_UVaMUv2Texcoord.zw + (float2)_UVaMUv2Texcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #endif // defined(MULTI_UV2_ENANLED)

    #if defined(PROJECTION_MAP_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
        #if !defined(UVA_SCRIPT_ENABLED)
            OUT.ProjMap.xy = float2(worldSpacePosition.xz / _ProjectionScale + _ProjectionScroll * getGlobalTextureFactor());
        #else // UVA_SCRIPT_ENABLED
            OUT.ProjMap.xy = float2(worldSpacePosition.xz / _ProjectionScale) + _UVaProjTexcoord.xy;
            //x	OUT.ProjMap.xy = half2(worldSpacePosition.xz / ProjectionScale) + ProjectionScroll * UVaProjTexcoord.xy;
        #endif // UVA_SCRIPT_ENABLED
    #endif // 

    #if defined(VERTEX_COLOR_ENABLED)
        OUT.Color0 = float4(IN.Color.r, IN.Color.g, IN.Color.b, IN.Color.a);
    #else // VERTEX_COLOR_ENABLED
        OUT.Color0 = float4(1.0f, 1.0f, 1.0f, 1.0f);
    #endif // VERTEX_COLOR_ENABLED

    OUT.Color0 = saturate(OUT.Color0);
    OUT.Color1.rgb = float3(1.0f, 1.0f, 1.0f);

    #if defined(FOG_ENABLED)
        OUT.Color1.a = EvaluateFogVP(viewSpacePosition);
    #else // FOG_ENABLED
        OUT.Color1.a = 0.0f;
    #endif // FOG_ENABLED

    float3 worldSpaceEyeDirection = normalize(getEyePosition() - worldSpacePosition);

    #if ((defined(USE_LIGHTING) && !defined(USE_PER_VERTEX_LIGHTING)) || (defined(CARTOON_SHADING_ENABLED) && !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED) ))
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
            OUT.WorldPositionDepth.xyz += light0dir * _ShadowReceiveOffset + worldSpaceNormal * -0.02f;
        #else // defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
            OUT.WorldPositionDepth.xyz += light0dir * 0.02f + worldSpaceNormal * -0.01f;
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
            EvaluateLightingPerVertexVP(OUT.ShadingAmount.rgb, OUT.LightingAmount.rgb, OUT.Color1.rgb, light0dir, worldSpacePosition, worldSpaceNormal, worldSpaceEyeDirection);

            #if defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
                OUT.ShadingAmount.a = EvaluateRimLightValue(ndote);
            #endif // defined(RIM_LIGHTING_ENABLED) && defined(USE_FORCE_VERTEX_RIM_LIGHTING)
        #endif // USE_LIGHTING
    #endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING

    #if defined(USE_SCREEN_UV)
        OUT.ReflectionMap = GenerateScreenProjectedUv(OUT.pos);
    #endif // defined(USE_SCREEN_UV)

    #if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
        #if defined(CUBE_MAPPING_ENABLED)
            OUT.CubeMap = float4(reflect(-worldSpaceEyeDirection, worldSpaceNormal), 1.0f - max(0.0f, ndote) * (float)_CubeFresnelPower);
        #elif defined(SPHERE_MAPPING_ENABLED)
            float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)UNITY_MATRIX_V);
            OUT.SphereMap = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
        #endif // defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
    #endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

    #if defined(CARTOON_SHADING_ENABLED)
        #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
            float ldotn = dot(light0dir, worldSpaceNormal);

            #if defined(CARTOON_HILIGHT_ENABLED)
                float hilit_u = (1.0f - abs(ndote) * 0.667f) * max(ldotn, 0.0f);
                OUT.CartoonMap.xyz = float3(hilit_u, 0.5f, ldotn);
            #else // CARTOON_HILIGHT_ENABLED
                OUT.CartoonMap.xyz = float3(0.0f, 0.0f, ldotn);
            #endif // CARTOON_HILIGHT_ENABLED
        #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
    #endif // defined(CARTOON_SHADING_ENABLED)

    // compute shadows data
    TRANSFER_SHADOW(OUT);
    return OUT;
}

#undef VP_LIGHTPROCESS
#undef VP_NDOTE_1
#undef VP_NDOTE_2
#undef VP_NDOTE_3