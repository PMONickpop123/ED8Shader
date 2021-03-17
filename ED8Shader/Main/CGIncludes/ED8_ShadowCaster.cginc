#include "UnityCG.cginc"
#include "UnityShaderVariables.cginc"

#if defined(ALPHA_BLENDING_ENABLED) && defined(UNITY_USE_DITHER_MASK_FOR_ALPHABLENDED_SHADOWS)
    #if !((SHADER_TARGET < 30) || defined (SHADER_API_MOBILE) || defined(SHADER_API_D3D11_9X) || defined (SHADER_API_PSP2) || defined (SHADER_API_PSM))
        #define UNITY_STANDARD_USE_DITHER_MASK 1
    #endif
#endif

// Need to output UVs in shadow caster, since we need to sample texture and do clip/dithering based on it
#if defined(ALPHA_TESTING_ENABLED) || defined(ALPHA_BLENDING_ENABLED)
    #define UNITY_STANDARD_USE_SHADOW_UVS 1
#endif

// Has a non-empty shadow caster output struct (it's an error to have empty structs on some platforms...)
#if !defined(V2F_SHADOW_CASTER_NOPOS_IS_EMPTY) || defined(UNITY_STANDARD_USE_SHADOW_UVS)
    #define UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT 1
#endif

#if defined(UNITY_STEREO_INSTANCING_ENABLED)
    #define UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT 1
#endif

half4 _Color = half4(1, 1, 1, 1);
half _Cutoff = 0.5;

#if defined(UNITY_STANDARD_USE_DITHER_MASK)
    sampler3D   _DitherMaskLOD;
#endif

struct ShadowVPInput {
    float4 vertex   : POSITION;
    float3 normal   : NORMAL;
    float2 texcoord      : TEXCOORD0;

    UNITY_VERTEX_INPUT_INSTANCE_ID
};

#if defined(UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT)
    struct ShadowVPOutput {
        V2F_SHADOW_CASTER_NOPOS

        #if defined(UNITY_STANDARD_USE_SHADOW_UVS)
            float2 texcoord : TEXCOORD1;
        #endif
    };
#endif

#if defined(UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT)
    struct ShadowVPOutputStereo {
        UNITY_VERTEX_OUTPUT_STEREO
    };
#endif

// We have to do these dances of outputting SV_POSITION separately from the vertex shader,
// and inputting VPOS in the pixel shader, since they both map to "POSITION" semantic on
// some platforms, and then things don't go well.
void ShadowVPShader (ShadowVPInput v, out float4 opos : SV_POSITION
    #ifdef UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT
    , out ShadowVPOutput o
    #endif

    #ifdef UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT
    , out ShadowVPOutputStereo os
    #endif
)
{
    UNITY_SETUP_INSTANCE_ID(v);

    #ifdef UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(os);
    #endif

    TRANSFER_SHADOW_CASTER_NOPOS(o, opos)

    #if !defined(UVA_SCRIPT_ENABLED)
        #if defined(TEXCOORD_OFFSET_ENABLED)
            v.texcoord.xy += (float2)(_TexCoordOffset * getGlobalTextureFactor());
        #endif // TEXCOORD_OFFSET_ENABLED

        v.texcoord.xy += (float2)_GameMaterialTexcoord.xy;
    #else // UVA_SCRIPT_ENABLED
        v.texcoord.xy = v.texcoord.xy * (float2)_GameMaterialTexcoord.zw + (float2)_GameMaterialTexcoord.xy;
    #endif // UVA_SCRIPT_ENABLED

    #if defined(UNITY_STANDARD_USE_SHADOW_UVS)
        o.texcoord = TRANSFORM_TEX(v.texcoord, _DiffuseMapSampler);
    #endif

    float3 position = v.vertex.xyz;

    #if defined(WINDY_GRASS_ENABLED)
        float3 worldSpacePosition = mul(unity_ObjectToWorld, position);

        #if !defined(WINDY_GRASS_TEXV_WEIGHT_ENABLED)
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz, v.texcoord.y);
        #else // WINDY_GRASS_TEXV_WEIGHT_ENABLED
            worldSpacePosition = calcWindyGrass(worldSpacePosition.xyz);
        #endif // WINDY_GRASS_TEXV_WEIGHT_ENABLED

        opos = UnityWorldToClipPos(worldSpacePosition);
    #else // WINDY_GRASS_ENABLED
        opos = UnityObjectToClipPos(position);
    #endif // WINDY_GRASS_ENABLED
}

half4 ShadowFPShader (UNITY_POSITION(vpos)
#ifdef UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT
    , ShadowVPOutput i
#endif
) : SV_Target
{
    #if defined(UNITY_STANDARD_USE_SHADOW_UVS)
        _Color = _GameMaterialDiffuse;

        #if defined(_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A)
            half alpha = _Color.a;
        #else
            half alpha = tex2D(_DiffuseMapSampler, i.texcoord.xy).a * _Color.a;
        #endif

        _Cutoff = half(_AlphaThreshold);

        #if defined(ALPHA_TESTING_ENABLED)
            clip (alpha - _Cutoff);
        #endif

        #if defined(ALPHA_BLENDING_ENABLED)
            #if defined(UNITY_STANDARD_USE_DITHER_MASK)
                // Use dither mask for alpha blended shadows, based on pixel position xy
                // and alpha level. Our dither texture is 4x4x16.
                #if defined(LOD_FADE_CROSSFADE)
                    #define _LOD_FADE_ON_ALPHA

                    alpha *= unity_LODFade.y;
                #endif

                half alphaRef = tex3D(_DitherMaskLOD, float3(vpos.xy * 0.25, alpha * 0.9375)).a;

                clip (alphaRef - 0.01);
            #else
                clip (alpha - _Cutoff);
            #endif
        #endif
    #endif // #if defined(UNITY_STANDARD_USE_SHADOW_UVS)

    #if defined(LOD_FADE_CROSSFADE)
        #if defined(_LOD_FADE_ON_ALPHA)
            #undef _LOD_FADE_ON_ALPHA
        #else
            UnityApplyDitherCrossFade(vpos.xy);
        #endif
    #endif

    SHADOW_CASTER_FRAGMENT(i)
}