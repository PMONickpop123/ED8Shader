#define VP_DEFAULT
#undef VP_PORTRAIT

#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED) || defined(SHINING_MODE_ENABLED)
	#undef VP_DEFAULT
	#define VP_PORTRAIT
#endif

float3 CreateBinormal(float3 normal, float3 tangent, float binormalSign) {
    return cross(normal, tangent); //* (binormalSign * unity_WorldTransformParams.w);
}

//-----------------------------------------------------------------------------
// vertex shader
DefaultVPOutput DefaultVPShader (DefaultVPInput v) {
    DefaultVPOutput o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(DefaultVPOutput, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    UNITY_TRANSFER_INSTANCE_ID(v, o);

    float3 normal = v.normal;
    float3 position = v.vertex.xyz;
    float3 worldSpacePosition = mul(unity_ObjectToWorld, float4(position.xyz, 1.0f)).xyz;
    float3 worldSpaceNormal = normalize(UnityObjectToWorldNormal(normal));

    #if defined(USE_LIGHTING)
        #if defined(USE_TANGENTS)
            float3 tangent = UnityObjectToWorldDir(v.tangent.xyz);
            float3 binormal = CreateBinormal(normal, v.tangent.xyz, v.tangent.w);
            
            o.tangent = tangent;
            o.binormal = binormal;
        #endif // USE_TANGENTS
    #endif // USE_LIGHTING

    #if defined(WINDY_GRASS_ENABLED)
        #if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, 1.0f - v.uv.y);
        #else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
        #endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED
    #endif // WINDY_GRASS_ENABLED

    float3 viewSpacePosition = UnityWorldToViewPos(worldSpacePosition);
    o.pos = UnityWorldToClipPos(worldSpacePosition);
    o.WorldPositionDepth = float4(worldSpacePosition.xyz, -viewSpacePosition.z);
    o.normal = worldSpaceNormal;
    o.uv.xy = v.uv.xy * _GameMaterialTexcoord.zw + _GameMaterialTexcoord.xy;

    #if defined(TEXCOORD_OFFSET_ENABLED)
        o.uv.xy += _TexCoordOffset.xy * getGlobalTextureFactor();
    #endif // TEXCOORD_OFFSET_ENABLED

    // TexCoord2
    #if defined(MULTI_UV_ENANLED)
        o.uv2.xy = v.uv2.xy;

        #if defined(MULTI_UV_TEXCOORD_OFFSET_ENABLED)
            o.uv2.xy += _TexCoordOffset2.xy * getGlobalTextureFactor();
        #endif // MULTI_UV_TEXCOORD_OFFSET_ENABLED

        o.uv2.xy += _GameMaterialTexcoord.xy;
    #endif // MULTI_UV_ENANLED

    // TexCoord3
    #if defined(MULTI_UV2_ENANLED)
        o.uv3.xy = v.uv3.xy;

        #if defined(MULTI_UV2_TEXCOORD_OFFSET_ENABLED)
            o.uv3.xy += _TexCoordOffset3.xy * getGlobalTextureFactor();
        #endif // MULTI_UV2_TEXCOORD_OFFSET_ENABLED

        o.uv3.xy += _GameMaterialTexcoord.xy;
    #endif // defined(MULTI_UV2_ENANLED)

    #if defined(PROJECTION_MAP_ENABLED) && !defined(CARTOON_SHADING_ENABLED)
        o.ProjMap.xy = float2(worldSpacePosition.xz / _ProjectionScale + (_ProjectionScroll * getGlobalTextureFactor()));
    #endif // 

    #if defined(DUDV_MAPPING_ENABLED)
        o.DuDvTexCoord.xy = v.uv.xy * _UVaDuDvTexcoord.zw;
        o.DuDvTexCoord.xy += _DuDvScroll.xy * getGlobalTextureFactor();
    #endif

    #if defined(VERTEX_COLOR_ENABLED)
        o.Color0 = float4(v.color.r, v.color.g, v.color.b, v.color.a);
    #else // VERTEX_COLOR_ENABLED
        o.Color0 = float4(1.0f, 1.0f, 1.0f, 1.0f);
    #endif // VERTEX_COLOR_ENABLED

    o.Color0 = saturate(o.Color0);
    o.Color1.rgb = float3(1.0f, 1.0f, 1.0f);

    #if defined(FOG_ENABLED)
        o.Color1.a = EvaluateFogVP(-viewSpacePosition.z, worldSpacePosition.y);
    #else // FOG_ENABLED
        o.Color1.a = 0.0f;
    #endif // FOG_ENABLED

    float3 worldSpaceEyeDirection = normalize(getEyePosition() - worldSpacePosition);

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
        o.ReflectionMap = ComputeGrabScreenPos(o.pos);
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

    // compute shadows data
    UNITY_TRANSFER_SHADOW(o, o.uv);
    return o;
}

#undef VP_LIGHTPROCESS
#undef VP_NDOTE