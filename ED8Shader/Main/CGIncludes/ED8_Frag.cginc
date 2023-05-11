#define FP_DEFAULT
#undef FP_DEFAULTRT
#undef FP_FORCETRANSPARENT
#undef FP_PORTRAIT
#undef FP_SHINING

#if defined(GENERATE_RELFECTION_ENABLED) //|| defined(WATER_SURFACE_ENABLED)
	#undef FP_DEFAULT
	#define FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#undef FP_PORTRAIT
	#undef FP_SHINING
#elif defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
	#undef FP_DEFAULT
	#undef FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#define FP_PORTRAIT
	#undef FP_SHINING
//#elif defined(SHINING_MODE_ENABLED)
//	#undef FP_DEFAULT
//	#undef FP_DEFAULTRT
//	#undef FP_FORCETRANSPARENT
//	#undef FP_PORTRAIT
//	#define FP_SHINING
#endif

//-----------------------------------------------------------------------------
// fragment shader
fixed4 DefaultFPShader (DefaultVPOutput i) : SV_TARGET {
    UNITY_SETUP_INSTANCE_ID(i);

    #if defined(NOTHING_ENABLED)
	    float4 resultColor = i.Color0;
        #if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT)
            return resultColor;
        #endif // FP_FORCETRANSPARENT

        #if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
            #if !defined(ALPHA_BLENDING_ENABLED)
                return float4(resultColor.rgb, 0.0f);
            #else // !defined(ALPHA_BLENDING_ENABLED)
                return resultColor;
            #endif // !defined(ALPHA_BLENDING_ENABLED)
        #endif
    #else // NOTHING_ENABLED
        #if defined(FP_DEFAULTRT)
            float3 waterNorm = float3(i.WorldPositionDepth.x, i.WorldPositionDepth.y - _UserClipPlane.w, i.WorldPositionDepth.z);
            clip(dot(normalize(_UserClipPlane.xyz), normalize(waterNorm)));
        #endif // FP_DEFAULTRT

        #if defined(DUDV_MAPPING_ENABLED)
	        float2 dudvValue = tex2D(_DuDvMapSampler, i.DuDvTexCoord.xy).xy;
            #if !defined(UNITY_COLORSPACE_GAMMA)
                dudvValue.x = LinearToGammaSpaceExact(dudvValue.x);
                dudvValue.y = LinearToGammaSpaceExact(dudvValue.y);
            #endif

            dudvValue = (dudvValue * 2.0f - 1.0f) * (_DuDvScale / _DuDvMapImageSize);
            //i.DuDvTexCoord = dudvValue.xy;
        #endif // DUDV_MAPPING_ENABLED

	    float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);
        float3 Monotone;

        diffuseAmt = tex2D(_MainTex, i.uv.xy 
        #if defined(DUDV_MAPPING_ENABLED)
            + dudvValue
        #endif // DUDV_MAPPING_ENABLED
        );

        #if !defined(UNITY_COLORSPACE_GAMMA)
            diffuseAmt.rgb = LinearToGammaSpace(diffuseAmt.rgb);
        #endif

        #if !defined(ALPHA_TESTING_ENABLED)
            diffuseAmt.a *= i.Color0.a;
        #endif

        #if defined(FP_FORCETRANSPARENT)
            #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
                #if defined(ALPHA_TESTING_ENABLED)
                    clip(diffuseAmt.a - _AlphaThreshold * (float)i.Color0.a);
                #else
                    clip(diffuseAmt.a - 0.004f);
                #endif
            #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
        #elif defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
            #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
                #if defined(TWOPASS_ALPHA_BLENDING_ENABLED)
                    float alphaAmt = diffuseAmt.a - _AlphaThreshold * (float)i.Color0.a;
                    clip((alphaAmt > 0.0f) ? (alphaAmt * _AlphaTestDirection) : (-1.0f/255.0f));
                #endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
            #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
        #endif

        #if defined(FP_PORTRAIT)
            float3 lightCoords;
            
            lightCoords = i.WorldPositionDepth.xyz;

            #if defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
                lightCoords += Unity_SafeNormalize(_WorldSpaceLightPos0.xyz) * _ShadowReceiveOffset + i.normal.xyz * -0.02f;
            #else // defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && defined(CARTOON_SHADING_ENABLED)
                lightCoords += Unity_SafeNormalize(_WorldSpaceLightPos0.xyz) * 0.02f + normalize(i.normal.xyz) * -0.01f;
            #endif // !defined(CARTOON_AVOID_SELFSHADOW_OFFSET) && !defined(CARTOON_SHADING_ENABLED)

            UNITY_LIGHT_ATTENUATION(attenuation, i, lightCoords);
        #else
            UNITY_LIGHT_ATTENUATION(attenuation, i, i.WorldPositionDepth.xyz);
        #endif

        #if defined(MULTI_UV_ENANLED)
	        #if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
                float4 diffuse2Amt = tex2D(_DiffuseMap2Sampler, i.uv2.xy
                #if defined(DUDV_MAPPING_ENABLED)
                    + dudvValue
                #endif // DUDV_MAPPING_ENABLED
                );

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    diffuse2Amt.rgb = LinearToGammaSpace(diffuse2Amt.rgb);
                    diffuse2Amt.rgb *= LinearToGammaSpace(_UVaMUvColor.rgb);
                    diffuse2Amt.a *= _UVaMUvColor.a;
                #else
                    diffuse2Amt *= (float4)_UVaMUvColor;
                #endif

                #if defined(MULTI_UV_FACE_ENANLED)
                    float multi_uv_alpha = (float)diffuse2Amt.a;
                #else // defined(MULTI_UV_FACE_ENANLED)
                    float multi_uv_alpha = (float)i.Color0.a * diffuse2Amt.a;
                #endif // defined(MULTI_UV_FACE_ENANLED)

		        #if defined(MULTI_UV_ADDITIVE_BLENDING_ENANLED)
	                // 加算
	                float3 muvtex_add = diffuse2Amt.rgb * multi_uv_alpha;
	                diffuseAmt.rgb += muvtex_add;
		        #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED)
                    float3 muvtex_add = (diffuse2Amt.rgb * diffuseAmt.rgb) * _BlendMulScale2;
                    diffuseAmt.rgb = lerp(diffuseAmt.rgb, muvtex_add, multi_uv_alpha);
                #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    // need to be blank so it doesn't use the bottom branch code.
                #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                    diffuse2Amt.rgb *= _BlendMulScale2;

                    #if !defined(BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED)
                        diffuseAmt.rgb *= diffuse2Amt.rgb;
                    #endif
		        #elif defined(MULTI_UV_SHADOW_ENANLED)
	                // 影領域として扱う
		        #else
	                // アルファ
	                diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
		        #endif //
	        #else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	            float multi_uv_alpha = (float)i.Color0.a;
	        #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

            #if defined(MULTI_UV2_ENANLED)
                #if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
                    float4 diffuse3Amt = tex2D(_DiffuseMap3Sampler, i.uv3.xy
                    #if defined(DUDV_MAPPING_ENABLED)
                        + dudvValue
                    #endif // DUDV_MAPPING_ENABLED
                    );

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        diffuse3Amt.rgb = LinearToGammaSpace(diffuse3Amt.rgb);
                    #endif

                    #if defined(MULTI_UV2_FACE_ENANLED)
                        float multi_uv2_alpha = (float)diffuse3Amt.a;
                    #else // defined(MULTI_UV2_FACE_ENANLED)
                        float multi_uv2_alpha = (float)i.Color0.a * diffuse3Amt.a;
			        #endif // defined(MULTI_UV_FACE_ENANLED)

			        #if defined(MULTI_UV2_ADDITIVE_BLENDING_ENANLED)
                        // 加算
                        float3 muvtex_add2 = diffuse3Amt.rgb * multi_uv2_alpha;

                        diffuseAmt.rgb += muvtex_add2;
			        #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED)
                        float3 muvtex_add2 = (diffuse3Amt.rgb * diffuseAmt.rgb) * _BlendMulScale3;
                        diffuseAmt.rgb = lerp(diffuseAmt.rgb, muvtex_add2, multi_uv2_alpha);
                    #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    // need to be blank so it doesn't use the bottom branch code.
                    #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                        diffuse3Amt.rgb *= _BlendMulScale3;

                        #if !defined(BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED)
                            diffuseAmt.rgb *= diffuse3Amt.rgb;
                        #endif
                    #elif defined(MULTI_UV2_SHADOW_ENANLED)
	                    // 影領域として扱う
			        #else
                        // アルファ
                        diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
                    #endif //
                #endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
            #endif // MULTI_UV2_ENANLED
        #endif // MULTI_UV_ENANLED

        #if !defined(UNITY_COLORSPACE_GAMMA)
            diffuseAmt.rgb *= LinearToGammaSpace(_GameMaterialDiffuse.rgb);
        #else
            diffuseAmt.rgb *= _GameMaterialDiffuse.rgb;
        #endif

        diffuseAmt.a *= _GameMaterialDiffuse.a;

        #if defined(USE_LIGHTING) && (defined(FP_DEFAULT) || defined(FP_PORTRAIT))
            float shadowValue = 1.0f;

            shadowValue = attenuation;

            /*
            #if defined(FP_DUDV_AMT_EXIST)
                shadowValue = (shadowValue + 1.0f) * 0.5f;
            #endif
            */
        #else // defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
            float shadowValue = 1.0f;
        #endif // defined(USE_LIGHTING)

        #if defined(MULTI_UV_ENANLED)
            #if defined(MULTI_UV_SHADOW_ENANLED)
                // 影領域として扱う
                shadowValue = min(shadowValue, 1.0f - (diffuse2Amt.r * multi_uv_alpha));
            #endif //

            #if defined(MULTI_UV2_SHADOW_ENANLED)
                // 影領域として扱う
                shadowValue = min(shadowValue, 1.0f - (diffuse3Amt.r * multi_uv2_alpha));
            #endif //
        #endif // MULTI_UV_ENANLED

        #if defined(PROJECTION_MAP_ENABLED)
            float4 projTex = tex2D(_ProjectionMapSampler, i.ProjMap.xy);
            //projTex *= (float4)_UdonShadowDensity;

            #if !defined(UNITY_COLORSPACE_GAMMA)
                projTex.r = LinearToGammaSpaceExact(projTex.r);
                projTex.a = LinearToGammaSpaceExact(projTex.a);
            #endif

            shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
        #endif // PROJECTION_MAP_ENABLED

        // CS3+ additions.
        #if defined(FLAT_AMBIENT_ENABLED)
            shadowValue += (1.0f - shadowValue) * (1.0f - _UdonShadowDensity);
            //shadowValue = (1.0f - shadowValue) * (1.0f - _GameMaterialEmission.a) + shadowValue;
            shadowValue = min(1, shadowValue);
        #endif

        #if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
	        float glossValue = 1.0f;

	        #if defined(SPECULAR_MAPPING_ENABLED)
	            glossValue = tex2D(_SpecularMapSampler, i.uv.xy).x;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    glossValue = LinearToGammaSpaceExact(glossValue);
                #endif
	        #endif // SPECULAR_MAPPING_ENABLED

            #if defined(MULTI_UV_ENANLED)
                #if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
                    float glossValue2 = tex2D(_SpecularMap2Sampler, i.uv2.xy).x;

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        glossValue2 = LinearToGammaSpaceExact(glossValue2);
                    #endif

                    glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
                #endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)

                #if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
                    float glossValue3 = tex2D(_SpecularMap3Sampler, i.uv3.xy).x;
                    
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        glossValue3 = LinearToGammaSpaceExact(glossValue2);
                    #endif

                    glossValue = lerp(glossValue, glossValue3, multi_uv2_alpha);
                #endif // defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
            #endif // 
        #else // SPECULAR_MAPPING_ENABLED
            float glossValue = 1.0f;
        #endif // SPECULAR_MAPPING_ENABLED

        #if defined(OCCULUSION_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV_OCCULUSION2_MAPPING_ENABLED))
	        float occulusionValue = 1.0f;

	        #if defined(OCCULUSION_MAPPING_ENABLED)
	            occulusionValue = tex2D(_OcculusionMapSampler, i.uv.xy).x;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    occulusionValue = LinearToGammaSpaceExact(occulusionValue);
                #endif
	        #endif // OCCULUSION_MAPPING_ENABLED

	        #if defined(MULTI_UV_ENANLED)
		        #if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue2 = tex2D(_OcculusionMap2Sampler, i.uv2.xy);
                    
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        occulusionValue2.rgb = LinearToGammaSpace(occulusionValue2.rgb);
                    #endif

			        #if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	                    multi_uv_alpha = occulusionValue2.a;
			        #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		        #endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)

		        #if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue3 = tex2D(_OcculusionMap3Sampler, i.uv3.xy);
                    
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        occulusionValue3.rgb = LinearToGammaSpace(occulusionValue3.rgb);
                    #endif

			        #if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	                    float multi_uv2_alpha = occulusionValue3.a;
			        #endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		        #endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	        #endif // defined(MULTI_UV_ENANLED)

            float3 ambientOcclusion = i.Color0.rgb * occulusionValue;
        #else // OCCULUSION_MAPPING_ENABLED
            float3 ambientOcclusion = i.Color0.rgb;
        #endif // OCCULUSION_MAPPING_ENABLED

        #if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        #if defined(USE_LIGHTING)
                float3 subLightColor = float3(0.0f, 0.0f, 0.0f);

                #if defined(USE_DIRECTIONAL_LIGHT_COLOR)
                    subLightColor = _LightColor0.rgb;
                #else
                    subLightColor = _UdonMainLightColor.rgb;
                #endif
	        #else
	            float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	        #endif

            #if !defined(UNITY_COLORSPACE_GAMMA)
                subLightColor = LinearToGammaSpace(subLightColor);
            #endif

	        #if defined(SPECULAR_MAPPING_ENABLED)
	            subLightColor *= (glossValue + shadowValue + 1.0f) * 0.5f;
	        #else
	            subLightColor *= (shadowValue + 1.0f) * 0.5f;
	        #endif
        #else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
        #endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

        float4 resultColor = diffuseAmt;
	    float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);
 	    float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

        #if defined(USE_LIGHTING)
	        // [PerPixel]
            #if defined(DUDV_MAPPING_ENABLED) && defined(NORMAL_MAPPING_ENABLED)
                float3 worldSpaceNormal = EvaluateNormalFP(i, dudvValue);
            #else
                float3 worldSpaceNormal = EvaluateNormalFP(i);
            #endif

            float3 n1 = worldSpaceNormal;

            #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
                #if defined(DUDV_MAPPING_ENABLED)
                    float3 n2 = EvaluateNormal2FP(i, dudvValue);
                #else
                    float3 n2 = EvaluateNormal2FP(i);
                #endif

                worldSpaceNormal = normalize(lerp(n1, n2, multi_uv_alpha));
            #endif

	        float3 ambient = float3(0.0f, 0.0f, 0.0f);

	        #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	            //ambient = float3(0.0f, 0.0f, 0.0f);
	        #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
		        #if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
			        #define FP_NEED_AFTER_MAX_AMBIENT
		        #else // NO_MAIN_LIGHT_SHADING_ENABLED
                    #if defined(FP_PORTRAIT)
                        #if defined(FLAT_AMBIENT_ENABLED)
	                        ambient = PortraitEvaluateAmbient();
                        #else
                            ambient = EvaluateAmbient(worldSpaceNormal);
                        #endif
			        #else // FP_PORTRAIT
	                    ambient = EvaluateAmbient(worldSpaceNormal);
			        #endif // FP_PORTRAIT
		        #endif // NO_MAIN_LIGHT_SHADING_ENABLED
	        #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

            float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
            #define FP_WS_EYEDIR_EXIST

	        // リムライトや環境マップの準備
	        #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    #define FP_NDOTE_1
                #endif // RIM_LIGHTING_ENABLED
	        #endif // defined(USE_LIGHTING)

            #if defined(CUBE_MAPPING_ENABLED)
                #define FP_NDOTE_2
            #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

            #if defined(FP_NDOTE_1) || defined(FP_NDOTE_2)
                float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
                // defined(DOUBLE_SIDED)
                UNITY_BRANCH
                if (_Culling < 2) {
                    if (ndote < 0.0f) {
                        ndote *= -1.0f;
                        worldSpaceNormal *= -1.0f;
                    }
                }
	        #endif  // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

            // リムライト
            #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    float rimLightvalue = EvaluateRimLightValue(ndote);

                    #if defined(RIM_TRANSPARENCY_ENABLED)
                        resultColor.a *= saturate(1.0f - rimLightvalue);
                    #else // RIM_TRANSPARENCY_ENABLED
                        #if !defined(RIM_CLAMP_ENABLED)
                            #if !defined(UNITY_COLORSPACE_GAMMA)
                                ambient += rimLightvalue * LinearToGammaSpace(_RimLitColor) * subLightColor;
                            #else
                                ambient += rimLightvalue * _RimLitColor * subLightColor;
                            #endif
                        #endif
                    #endif // RIM_TRANSPARENCY_ENABLED
                #endif // RIM_LIGHTING_ENABLED
            #endif // defined(USE_LIGHTING)

            // キューブマップ/スフィアマップ-PerPixel
            #if defined(CUBE_MAPPING_ENABLED)
                float3 cubeMapParams = reflect(-float3(worldSpaceEyeDirection.x * -1.0f, worldSpaceEyeDirection.y, worldSpaceEyeDirection.z), worldSpaceNormal);
                float cubeMapIntensity = pow(1.0f - max(0.0f, saturate(ndote)), _CubeMapFresnel) * _CubeMapIntensity;
                float4 cubeMapColor = texCUBE(_CubeMapSampler, cubeMapParams.xyz).rgba;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    cubeMapColor.rgb = LinearToGammaSpace(cubeMapColor.rgb);
                #endif
            #elif defined(SPHERE_MAPPING_ENABLED)
                float3 viewSpaceNormal = mul((float3x3)UNITY_MATRIX_V, worldSpaceNormal);
                float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + 0.5f;
                float4 sphereMapColor = tex2D(_SphereMapSampler, sphereMapParams.xy).rgba;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    sphereMapColor.rgb = LinearToGammaSpace(sphereMapColor.rgb);
                #endif
            #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

            #if !defined(EMVMAP_AS_IBL_ENABLED)
                #if defined(CUBE_MAPPING_ENABLED)
                    //resultColor.rgb = lerp(resultColor.rgb, cubeMapColor.rgb * ambientOcclusion, cubeMapIntensity * glossValue);
                    resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * ambientOcclusion * glossValue;
                #elif defined(SPHERE_MAPPING_ENABLED)
                    resultColor.rgb += sphereMapColor.rgb * _SphereMapIntensity * ambientOcclusion * glossValue;
                #endif 
            #endif

            #if defined(FP_SHINING)
                shadingAmt = (1.0f - float3(ndote, ndote, ndote)) * float3(1.2075f, 3.0625f, 3.5f);
                resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
            #elif defined(FP_PORTRAIT)
                shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection, attenuation);
            #else
                shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection, attenuation);
            #endif

            // リムライト
            #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    #if defined(RIM_CLAMP_ENABLED)
                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            shadingAmt += rimLightvalue * LinearToGammaSpace(_RimLitColor) * subLightColor;
                        #else
                            shadingAmt += rimLightvalue * _RimLitColor * subLightColor;
                        #endif

                        shadingAmt = min(shadingAmt, (float3)_RimLightClampFactor);
                    #endif
                #endif
            #endif
        #else // !defined(USE_LIGHTING)
	        // [PerVertex]
            float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
            #define FP_WS_EYEDIR_EXIST
	        float3 worldSpaceNormal = normalize(i.normal);
            
            float3 subLight = float3(0.0f, 0.0f, 0.0f);
            float3 diffuse = float3(1.0f, 1.0f, 1.0f);
            float3 specular = float3(0.0f, 0.0f, 0.0f);
	        float3 ambient = EvaluateAmbient(worldSpaceNormal);

            #if defined(CUBE_MAPPING_ENABLED)
                #define FP_NDOTE_1
            #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

            #if defined(FP_NDOTE_1)
                float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
                // defined(DOUBLE_SIDED)
                UNITY_BRANCH
                if (_Culling < 2) {
                    if (ndote < 0.0f) {
                        ndote *= -1.0f;
                        worldSpaceNormal *= -1.0f;
                    }
                }
	        #endif  // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

            #if defined(CUBE_MAPPING_ENABLED)
                float3 cubeMapParams = reflect(-float3(worldSpaceEyeDirection.x * -1.0f, worldSpaceEyeDirection.y, worldSpaceEyeDirection.z), worldSpaceNormal);
                float cubeMapIntensity = pow(1.0f - max(0.0f, saturate(ndote)), _CubeMapFresnel) * _CubeMapIntensity;
                float4 cubeMapColor = texCUBE(_CubeMapSampler, cubeMapParams.xyz).rgba;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    cubeMapColor.rgb = LinearToGammaSpace(cubeMapColor.rgb);
                #endif
            #elif defined(SPHERE_MAPPING_ENABLED)
                float3 viewSpaceNormal = mul((float3x3)UNITY_MATRIX_V, worldSpaceNormal);
                float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + 0.5f;
                float4 sphereMapColor = tex2D(_SphereMapSampler, sphereMapParams.xy).rgba;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    sphereMapColor.rgb = LinearToGammaSpace(sphereMapColor.rgb);
                #endif
            #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

            #if !defined(EMVMAP_AS_IBL_ENABLED)
                #if defined(CUBE_MAPPING_ENABLED)
                    //resultColor.rgb = lerp(resultColor.rgb, cubeMapColor.rgb * ambientOcclusion * glossValue, cubeMapIntensity);
                    resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * ambientOcclusion * glossValue;
                #elif defined(SPHERE_MAPPING_ENABLED)
                    resultColor.rgb += sphereMapColor.rgb * _SphereMapIntensity * ambientOcclusion * glossValue;
                #endif 
            #endif

            #if defined(FP_SHINING)
	            float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
	            float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);

	            shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;
	        #else
	            shadingAmt = EvaluateLightingPerVertexFP(i, i.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	        #endif
        #endif

        #if defined(FP_NEED_AFTER_MAX_AMBIENT)
            #if defined(FP_PORTRAIT)
                shadingAmt = max(shadingAmt, PortraitEvaluateAmbient());
            #else // !defined(FP_PORTRAIT)
                shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
            #endif
        #endif

        #if defined(MULTI_UV_ENANLED)
            #if defined(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                resultColor.rgb = resultColor.rgb * diffuse2Amt.rgb * _BlendMulScale2;
            #endif
        #endif

        #if defined(MULTI_UV2_ENANLED)
            #if defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                resultColor.rgb = resultColor.rgb * diffuse3Amt.rgb * _BlendMulScale3;
            #endif
        #endif

        #if defined(USE_SCREEN_UV)
            float4 dudvTex = i.ReflectionMap;

            #if defined(DUDV_MAPPING_ENABLED)
                float2 dudvAmt = dudvValue.xy * float2(_ScreenParams.x / _DuDvMapImageSize.x, _ScreenParams.y / _DuDvMapImageSize.y);
                dudvAmt.y *= _CameraDepthTexture_TexelSize.z * abs(_CameraDepthTexture_TexelSize.y);
                #define FP_DUDV_AMT_EXIST
            #else
                float2 dudvAmt = float2(0.0f, 0.0f);
            #endif // DUDV_MAPPING_ENABLED

            float2 dudvUV = (dudvTex.xy + dudvAmt) / dudvTex.w;
            #if UNITY_UV_STARTS_AT_TOP
                if (_CameraDepthTexture_TexelSize.y < 0) {
                    dudvUV.y = 1 - dudvUV.y;
                }
            #endif

            dudvUV = (floor(dudvUV * _CameraDepthTexture_TexelSize.zw) + 0.5) * abs(_CameraDepthTexture_TexelSize.xy);
            float backgroundDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, dudvUV));
	        float surfaceDepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(dudvTex.z);
	        float depthDifference = backgroundDepth - surfaceDepth;
            dudvAmt *= saturate(depthDifference);
	        dudvUV = (dudvTex.xy + dudvAmt) / dudvTex.w;
            #if UNITY_UV_STARTS_AT_TOP
                if (_CameraDepthTexture_TexelSize.y < 0) {
                    dudvUV.y = 1 - dudvUV.y;
                }
            #endif

            dudvUV = (floor(dudvUV * _CameraDepthTexture_TexelSize.zw) + 0.5) * abs(_CameraDepthTexture_TexelSize.xy);

            float4 refrColor = tex2D(_RefractionTexture, dudvUV).xyzw;

            #if !defined(UNITY_COLORSPACE_GAMMA)
                refrColor.rgb = LinearToGammaSpace(refrColor.rgb);
            #endif

            #if defined(WATER_SURFACE_ENABLED)
                #if defined(FLAT_AMBIENT_ENABLED)
                    float4 reflColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
                #else
                    float4 reflColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
                    //float4 reflColor = tex2D(_ReflectionTex0, dudvUV).xyzw;
                #endif
            #else
                float4 reflColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
            #endif // defined(WATER_SURFACE_ENABLED)
        #else
            #if defined(WATER_SURFACE_ENABLED)
                #if defined(FLAT_AMBIENT_ENABLED)
                    float4 reflColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
                #else
                    float4 reflColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
                    //float4 reflColor = tex2D(_ReflectionTex0, dudvUV).xyzw;
                #endif
            #else
                float4 reflColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
            #endif // defined(WATER_SURFACE_ENABLED)
        #endif // defined(USE_SCREEN_UV)

        #if defined(ED8_GRABPASS)
            #if defined(DUDV_MAPPING_ENABLED)
                resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
            #endif

            #if defined(WATER_SURFACE_ENABLED)
                float waterAlpha;
                #if !defined(FP_WS_EYEDIR_EXIST)
                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
                #endif // FP_WS_EYEDIR_EXIST

                #if defined(FLAT_AMBIENT_ENABLED)
                    #if !defined(FP_NDOTE_1) && !defined(FP_NDOTE_2)
                        float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
                    #endif

                    //waterAlpha = pow(1.0f - (max(0.0f, saturate(ndote)) * _ReflectionFresnel), 4.0f) * _ReflectionIntensity;
                    waterAlpha = pow(1.0f - max(0.0f, saturate(ndote)), _ReflectionFresnel) * _ReflectionIntensity;
                #else
                    float water_ndote = dot(normalize(_UserClipPlane.xyz), worldSpaceEyeDirection);
                    waterAlpha = pow(1.0f - abs(water_ndote), 4.0f) * _ReflectionIntensity;
                #endif

                resultColor.rgb += reflColor.rgb * waterAlpha;

                float waterGlowValue = reflColor.a + refrColor.a;
            #endif // defined(WATER_SURFACE_ENABLED)
        #else
            #if defined(WATER_SURFACE_ENABLED)
                float waterAlpha;

                #if !defined(FP_WS_EYEDIR_EXIST)
                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
                #endif // FP_WS_EYEDIR_EXIST

                #if defined(FLAT_AMBIENT_ENABLED)
                    #if !defined(FP_NDOTE_1) && !defined(FP_NDOTE_2)
                        float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
                    #endif

                    waterAlpha = pow(1.0f - max(0.0f, saturate(ndote)), _ReflectionFresnel) * _ReflectionIntensity;
                #else
                    float water_ndote = dot(normalize(_UserClipPlane.xyz), worldSpaceEyeDirection);
                    waterAlpha = pow(1.0f - abs(water_ndote), 4.0f) * _ReflectionIntensity;
                #endif

                resultColor.rgb += reflColor.rgb * waterAlpha;
                float waterGlowValue = reflColor.a + refrColor.a;
            #endif
        #endif

        #if defined(CARTOON_SHADING_ENABLED)
		    #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			    #if defined(CARTOON_HILIGHT_ENABLED)
	                float hilightValue = tex2D(_HighlightMapSampler, i.CartoonMap.xy).r;

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        hilightValue = LinearToGammaSpaceExact(hilightValue);

                        float3 hilightAmt = hilightValue * _HighlightIntensity * LinearToGammaSpace(_HighlightColor) * subLightColor;
                    #else
                        float3 hilightAmt = hilightValue * _HighlightIntensity * _HighlightColor * subLightColor;
                    #endif
                    #define FP_HAS_HILIGHT
			    #endif // CARTOON_HILIGHT_ENABLED
		    #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	    #endif // CARTOON_SHADING_ENABLED

	    #if defined(FP_HAS_HILIGHT)
	        sublightAmount += hilightAmt;
	    #endif // FP_HAS_HILIGHT

        #if !defined(UNITY_COLORSPACE_GAMMA)
            shadingAmt += LinearToGammaSpace(_GameMaterialEmission.rgb);
        #else
            shadingAmt += _GameMaterialEmission.rgb;
        #endif

        #if defined(SHADOW_COLOR_SHIFT_ENABLED)
	        // [Not Toon] 表面下散乱のような使い方
	        float3 subLightColor2 = max(float3(1.0f, 1.0f, 1.0f), subLightColor * 2.0f);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                shadingAmt.rgb += (float3(1.0f, 1.0f, 1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * LinearToGammaSpace(_ShadowColorShift) * subLightColor2;
            #else
                shadingAmt.rgb += (float3(1.0f, 1.0f, 1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * _ShadowColorShift * subLightColor2;
            #endif
        #endif // SHADOW_COLOR_SHIFT_ENABLED

        #if defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        float3 envMapColor = ambientOcclusion;
	    #else // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	        float3 envMapColor = float3(1.0f, 1.0f, 1.0f);
	    #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

        #if defined(EMVMAP_AS_IBL_ENABLED)
	        // キューブマップ/スフィアマップ-適用 (IBL)
	        #if defined(CUBE_MAPPING_ENABLED)
	            shadingAmt.rgb += cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	        #elif defined(SPHERE_MAPPING_ENABLED)
	            shadingAmt.rgb += sphereMapColor.rgb * _SphereMapIntensity * envMapColor * glossValue;
	        #endif // CUBE_MAPPING_ENABLED
        #endif // EMVMAP_AS_IBL_ENABLED
    
        shadingAmt *= ambientOcclusion;
	    //shadingAmt += sublightAmount;

        #if defined(EMISSION_MAPPING_ENABLED)
	        float4 emiTex = tex2D(_EmissionMapSampler, i.uv.xy);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                emiTex.rgb = LinearToGammaSpace(emiTex.rgb);
            #endif

	        shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r, emiTex.r, emiTex.r));
        #endif // EMISSION_MAPPING_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            resultColor.rgb *= shadingAmt;
        #elif defined(UNITY_PASS_FORWARDADD)
            resultColor.rgb *= sublightAmount;
        #endif

        #if defined(UNITY_PASS_FORWARDBASE)
            #if defined(BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED)
                #if defined(MULTI_UV_ENANLED)
                    #if defined(MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                        resultColor = tex2D(_MainTex, i.uv.xy 
                        #if defined(DUDV_MAPPING_ENABLED)
                            + dudvValue.xy
                        #endif // DUDV_MAPPING_ENABLED
                        );

                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            resultColor.rgb = LinearToGammaSpace(resultColor.rgb);
                        #endif

                        resultColor.a *= (float)i.Color0.a * diffuse2Amt.a;
                        resultColor.rgb = lerp(shadingAmt.rgb, resultColor.rgb * diffuse2Amt.rgb, resultColor.a);
                    #endif
                #endif

                #if defined(MULTI_UV2_ENANLED)
                    #if defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                        resultColor = tex2D(_MainTex, i.uv.xy 
                        #if defined(DUDV_MAPPING_ENABLED)
                            + dudvValue.xy
                        #endif // DUDV_MAPPING_ENABLED
                        );

                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            resultColor.rgb = LinearToGammaSpace(resultColor.rgb);
                        #endif

                        resultColor.a *= (float)i.Color0.a * diffuse3Amt.a;
                        resultColor.rgb = lerp(shadingAmt.rgb, resultColor.rgb * diffuse3Amt.rgb, resultColor.a);
                    #endif
                #endif
            #endif
        #endif

        #if defined(ALPHA_TESTING_ENABLED)
            resultColor.a *= 1 + max(0, CalcMipLevel(i.uv)) * 0.25;
            resultColor.a = (resultColor.a - _AlphaThreshold) / max(fwidth(resultColor.a), 0.0001) + _AlphaThreshold;
        #endif //ALPHA_TESTING_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            // Material diffuse is multiplied to the final color in CS3+ and material emission is added to the final color lighting in CS3+
            #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
                resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
            #endif

            #if defined(FOG_ENABLED)
                /*
                scene.MiscParameters6.x = _UdonFogImageSpeedX
                scene.MiscParameters6.y = _UdonFogImageSpeedZ
                scene.MiscParameters6.z = _UdonFogImageScale
                scene.MiscParameters6.w = _UdonFogImageRatio
                v4.xyz = WorldSpacePosition
                v2.w = i.Color1.a (fog value)

                // ASM:
                r0.w = cmp(0 < scene.MiscParameters6.w);
                if (r0.w != 0) {
                    float3 LowResDepthTexture;
                    LowResDepthTexture = tex2D(_UdonLowResDepthTexture, i.uv.xy).x;

                    r1.xy = GlobalTexcoordFactor * scene.MiscParameters6.xy;
                    r1.xz = r1.xy * float2(30,30) + v4.xz;
                    r1.y = v4.y;
                    r1.xyz = scene.MiscParameters6.zzz * r1.xyz;
                    r3.x = LowResDepthTexture.SampleLevel(LinearWrapSamplerState_s, r1.xy, 0).x;
                    r3.y = LowResDepthTexture.SampleLevel(LinearWrapSamplerState_s, r1.xz, 0).x;
                    r3.z = LowResDepthTexture.SampleLevel(LinearWrapSamplerState_s, r1.yz, 0).x;
                    r0.w = dot(r3.xyz, float3(0.333299994,0.333299994,0.333299994));
                    r0.w = v2.w * r0.w;
                    r0.w = -r0.w * scene.MiscParameters6.w + v2.w;
                    r0.w = max(0, r0.w);
                } else {
                    r0.w = v2.w;
                }
                */

                float fogValue;

                if (_UdonFogImageRatio > 0) {
                    float3 fogTexCoord = 0;
                    fogTexCoord.xz = getGlobalTextureFactor() * float2(_UdonFogImageSpeedX, _UdonFogImageSpeedZ) * float2(30,30);
                    fogTexCoord += i.WorldPositionDepth.xyz;
                    fogTexCoord = _UdonFogImageScale * fogTexCoord;

                    float depthA = tex2Dlod(_UdonLowResDepthTexture, float4(fogTexCoord.xy, 0, 0)).x;
                    float depthB = tex2Dlod(_UdonLowResDepthTexture, float4(fogTexCoord.xz, 0, 0)).x;
                    float depthC = tex2Dlod(_UdonLowResDepthTexture, float4(fogTexCoord.yz, 0, 0)).x;

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        depthA = LinearToGammaSpaceExact(depthA);
                        depthB = LinearToGammaSpaceExact(depthB);
                        depthC = LinearToGammaSpaceExact(depthC);;
                    #endif

                    fogValue = dot(float3(depthA, depthB, depthC), float3(0.333299994,0.333299994,0.333299994));
                    //fogValue = (depthA + depthB + depthC) / 3.0;

                    fogValue = i.Color1.a * fogValue;
                    fogValue = i.Color1.a - (fogValue * _UdonFogImageRatio);
                    fogValue = max(0, fogValue);
                } else {
                    fogValue = i.Color1.a;
                }

                EvaluateFogFP(resultColor.rgb, _UdonFogColor.rgb, fogValue);
            #endif // FOG_ENABLED

            #if defined(SUBTRACT_BLENDING_ENABLED)
                resultColor.rgb = resultColor.rgb * resultColor.a;
            #elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
                resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
            #endif

            // CS3+ function testing.
            //Monotone = (dot(resultColor.rgb, float3(0.298999995f,0.587000012f,0.114f)) * _MonotoneAdd.rgb) + _MonotoneMul.rgb;
            //Monotone -= resultColor.rgb;
            //resultColor.rgb += _GameMaterialMonotone * Monotone;
        #endif

        // Bring back to Linear Space.
        #if !defined(UNITY_COLORSPACE_GAMMA)
            resultColor.rgb = GammaToLinearSpace(resultColor.rgb);
        #endif

        #if defined(FP_FORCETRANSPARENT) || defined(FP_SHINING)
            resultColor.rgb = max(resultColor.rgb, float3(0, 0, 0));
            resultColor.a = min(1.0f, resultColor.a);
            return resultColor;
        #elif defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
            float glowValue = 0.0f;

            #if defined(UNITY_PASS_FORWARDBASE)
                #if defined(GLARE_MAP_ENABLED) || defined(MULTI_UV_GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    #if defined(GLARE_MAP_ENABLED)
                        glowValue = tex2D(_GlareMapSampler, i.uv.xy).x;
                    #endif

                    #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_GLARE_MAP_ENABLED)
                        float glowValue2 = tex2D(_GlareMap2Sampler, i.uv2.xy).x;
                        glowValue = lerp(glowValue, glowValue2, multi_uv_alpha);
                    #endif

                    #if defined(GLARE_HIGHTPASS_ENABLED)
                        float lumi = dot(resultColor.rgb, float3(1.0f, 1.0f, 1.0f));
                        glowValue += max(lumi - 1.0f, 0.0f);
                    #endif

                    #if defined(GLARE_OVERFLOW_ENABLED)
                        float3 glowof = max(float3(0.0f, 0.0f, 0.0f), resultColor.rgb - _GlowThreshold);
                        glowValue += dot(glowof, 1.0f);
                    #endif

                    #if defined(WATER_SURFACE_ENABLED)
                        glowValue += waterGlowValue;
                    #endif

                    glowValue *= _GlareIntensity;

                    #if defined(WATER_SURFACE_ENABLED)
                        glowValue = max(0.0f, glowValue);
                        glowValue = min(1.0f, glowValue);
                        return float4(resultColor.rgb, glowValue);
                    #else
                        resultColor.rgb = max(resultColor.rgb + (resultColor.rgb * glowValue), float3(0, 0, 0));
                        resultColor.a = min(1.0f, resultColor.a);

                        #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                            return float4(resultColor.rgb, 1.0f);
                        #else
                            return float4(resultColor.rgb, resultColor.a);
                        #endif
                    #endif
                #else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    #if defined(WATER_SURFACE_ENABLED)
                        glowValue += waterGlowValue;
                    #endif

                    glowValue *= _GlareIntensity;

                    #if defined(WATER_SURFACE_ENABLED)
                        glowValue = max(0.0f, glowValue);
                        glowValue = min(1.0f, glowValue);
                        return float4(resultColor.rgb, max(0.0f, glowValue));
                    #else
                        resultColor.rgb = max(resultColor.rgb + (resultColor.rgb * _GlareIntensity), float3(0, 0, 0));
                        resultColor.a = min(1.0f, resultColor.a);

                        #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                            return float4(resultColor.rgb, 1.0f);
                        #else
                            return float4(resultColor.rgb, resultColor.a);
                        #endif
                    #endif
                #endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
            #else
                resultColor.rgb = max(resultColor.rgb, float3(0, 0, 0));
                resultColor.a = min(1.0f, resultColor.a);

                #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                    return float4(resultColor.rgb, 1.0f);
                #else
                    return float4(resultColor.rgb, resultColor.a);
                #endif
            #endif
        #endif // FP_DEFAULT || FP_DEFAULTRT
    #endif // NOTHING_ENABLED
}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2