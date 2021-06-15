#define FP_DEFAULT
#undef FP_DEFAULTRT
#undef FP_FORCETRANSPARENT
#undef FP_PORTRAIT
#undef FP_SHINING

#if defined(GENERATE_RELFECTION_ENABLED)
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
#elif defined(SHINING_MODE_ENABLED)
	#undef FP_DEFAULT
	#undef FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#undef FP_PORTRAIT
	#define FP_SHINING
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
	        float2 dudvValue = (tex2D(_DuDvMapSampler, i.DuDvTexCoord.xy).xy * 2.0f - 1.0f) * (_DuDvScale / _DuDvMapImageSize);
        #endif // DUDV_MAPPING_ENABLED

	    float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);

        #if defined(ALPHA_TESTING_ENABLED)
            i.Color0.a *= 1 + max(0, CalcMipLevel(i.uv)) * 0.25;
            i.Color0.a = (i.Color0.a - _AlphaThreshold) / max(fwidth(i.Color0.a), 0.0001) + 0.5;
        #endif //ALPHA_TESTING_ENABLED

        float4 materialDiffuse = (float4)_GameMaterialDiffuse;
        diffuseAmt = tex2D(_MainTex, i.uv.xy 
        #if defined(DUDV_MAPPING_ENABLED)
            + dudvValue
        #endif // DUDV_MAPPING_ENABLED
        );

        //diffuseAmt.rgb = GammaToLinearSpace(diffuseAmt.rgb);
	    diffuseAmt.a *= (float)i.Color0.a;

        #if defined(USE_SCREEN_UV)
            float4 dudvTex = i.ReflectionMap;

            #if defined(DUDV_MAPPING_ENABLED)
                float2 dudvAmt = dudvValue * float2(_ScreenWidth /_DuDvMapImageSize.x, _ScreenHeight / _DuDvMapImageSize.y);
                dudvTex.xy += dudvAmt;
                #define FP_DUDV_AMT_EXIST
            #endif // DUDV_MAPPING_ENABLED

            #if defined(WATER_SURFACE_ENABLED)
                float4 reflColor = tex2D(_ReflectionTexture, dudvTex.xy / dudvTex.w).xyzw;
                //reflColor.rgb = GammaToLinearSpace(reflColor.rgb);
            #endif // defined(WATER_SURFACE_ENABLED)

            float4 refrColor = tex2D(_RefractionTexture, dudvTex.xy / dudvTex.w).xyzw;
            //refrColor.rgb = GammaToLinearSpace(refrColor.rgb);
        #endif // defined(USE_SCREEN_UV)

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
                #else // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
                    #if defined(ALPHA_TESTING_ENABLED)
                        clip(diffuseAmt.a - _AlphaThreshold * (float)i.Color0.a);
                    #else
                        clip(diffuseAmt.a - 0.004f);
                    #endif
                #endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
            #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
        #endif

        #if defined(MULTI_UV_ENANLED)
	        #if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
                float4 diffuse2Amt = tex2D(_DiffuseMap2Sampler, i.uv2.xy);
                //diffuse2Amt.rgb = GammaToLinearSpace(diffuse2Amt.rgb);

		        #if defined(UVA_SCRIPT_ENABLED)
	                diffuse2Amt *= (float4)_UVaMUvColor;
		        #endif // UVA_SCRIPT_ENABLED

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
                    // 乗算
                    // v = lerp(x, x*y, t)
                    // v = x + (x*y - x) * t;
                    // v = x + (y - 1) * x * t;
                    //float3 muvtex_add = ((diffuse2Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb) * multi_uv_alpha;
                    //muvtex_add *= _BlendMulScale2;
                    //diffuseAmt.rgb = diffuseAmt.rgb + muvtex_add;
                    diffuse2Amt.rgb *= (diffuse2Amt.rgb * multi_uv_alpha) * diffuseAmt.rgb;
                    diffuse2Amt.rgb *= (_BlendMulScale2 + -(diffuseAmt.rgb));
                    diffuseAmt.rgb = (diffuseAmt.aaa * diffuse2Amt.rgb) + diffuseAmt.rgb;
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
                    float4 diffuse3Amt = tex2D(_DiffuseMap3Sampler, i.uv3.xy);
                    //diffuse3Amt.rgb = GammaToLinearSpace(diffuse3Amt.rgb);

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
                        // 乗算
                        // v = lerp(x, x*y, t)
                        // v = x + (x*y - x) * t;
                        // v = x + (y - 1) * x * t;
                        float3 muvtex_add2 = ((diffuse3Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb) * multi_uv2_alpha;
                        diffuseAmt.rgb = diffuseAmt.rgb * _BlendMulScale3 + muvtex_add2;
                    #elif defined(MULTI_UV_SHADOW_ENANLED)
	                    // 影領域として扱う
			        #else
                        // アルファ
                        diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
                    #endif //
                #endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
            #endif // MULTI_UV2_ENANLED
        #endif // MULTI_UV_ENANLED

        diffuseAmt *= materialDiffuse;

        #if defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT) //&& defined(RECEIVE_SHADOWS)
            float shadowValue = 1.0f;

            UNITY_LIGHT_ATTENUATION(attenuation, i, i.WorldPositionDepth.xyz);
            shadowValue = attenuation;

            /*
            {
                #ifdef PRECALC_SHADOWMAP_POSITION
                    if (i.shadowPos.w < 1.0f) {
                        float shadowMin = SampleOrthographicShadowMap(i.shadowPos.xyz, LightShadowMap0, DuranteSettings.x, 1.0f);

                        #ifdef SHADOW_ATTENUATION_ENABLED
                            shadowMin = (float)min(shadowMin + i.shadowPos.w, 1.0f);
                        #endif
                        shadowValue = min(shadowValue, shadowMin);
                    }
                #else // PRECALC_SHADOWMAP_POSITION
                    #if defined(DUDV_MAPPING_ENABLED)
                        float3 dudv0 = float3(dudvValue.x, dudvValue.y, 0.0f);
                        float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, i.WorldPositionDepth.xyz + dudv0, i.WorldPositionDepth.w, DuranteSettings.x));
                    #else // DUDV_MAPPING_ENABLED
                        float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, i.WorldPositionDepth.xyz, i.WorldPositionDepth.w, DuranteSettings.x));
                    #endif // DUDV_MAPPING_ENABLED

                    #ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
                        if (scene_MiscParameters2.x > 0.0f) {
                            float shadowMinBias = min(abs(i.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
                            shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
                            shadowMin = min(shadowMin + shadowMinBias, 1.0f);
                        }
                    #endif

                    shadowValue = min(shadowValue, shadowMin);
                #endif // PRECALC_SHADOWMAP_POSITION

                #if defined(FP_DUDV_AMT_EXIST)
                    shadowValue = (shadowValue + 1.0f) * 0.5f;
                #endif
            }
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
            shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
        #endif // PROJECTION_MAP_ENABLED

        #if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
	        float glossValue = 1.0f;

	        #if defined(SPECULAR_MAPPING_ENABLED)
	            glossValue = tex2D(_SpecularMapSampler, i.uv.xy).x;
                //glossValue.x = GammaToLinearSpaceExact(glossValue.x);
	        #endif // SPECULAR_MAPPING_ENABLED

            #if defined(MULTI_UV_ENANLED)
                #if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
                    float glossValue2 = tex2D(_SpecularMap2Sampler, i.uv2.xy).x;
                    //glossValue2.x = GammaToLinearSpaceExact(glossValue2.x);
                    glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
                #endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)

                #if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
                    float glossValue3 = tex2D(_SpecularMap3Sampler, i.uv3.xy).x;
                    //glossValue3.x = GammaToLinearSpaceExact(glossValue3.x);
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
                //occulusionValue.x = GammaToLinearSpaceExact(occulusionValue.x);
	        #endif // OCCULUSION_MAPPING_ENABLED

	        #if defined(MULTI_UV_ENANLED)
		        #if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue2 = tex2D(_OcculusionMap2Sampler, i.uv2.xy).x;
                    //occulusionValue2.x = GammaToLinearSpaceExact(occulusionValue2.x);

			        #if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	                    multi_uv_alpha = occulusionValue2.a;
			        #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		        #endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)

		        #if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue3 = tex2D(_OcculusionMap3Sampler, i.uv3.xy).x;
                    //occulusionValue3.x = GammaToLinearSpaceExact(occulusionValue3.x);

			        #if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	                    float multi_uv2_alpha = occulusionValue3.a;
			        #endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		        #endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	        #endif // defined(MULTI_UV_ENANLED)

	        float3 ambientOcclusion = (float3)i.Color0.rgb * occulusionValue;
        #else // OCCULUSION_MAPPING_ENABLED
	        float3 ambientOcclusion = (float3)i.Color0.rgb;
        #endif // OCCULUSION_MAPPING_ENABLED

        #if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        #if defined(USE_LIGHTING)
                #if defined(FP_PORTRAIT)
                    float3 subLightColor = _PortraitLightColor.rgb;
                #else // FP_PORTRAIT
                    float3 subLightColor = _LightColor0.rgb;
                #endif // FP_PORTRAIT
	        #else
	            float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	        #endif

	        #if defined(SPECULAR_MAPPING_ENABLED)
		        #if defined(RECEIVE_SHADOWS)
	                subLightColor *= (glossValue + shadowValue + 1.0f) * (1.0f / 3.0f);
		        #endif
	        #else
		        #if defined(RECEIVE_SHADOWS)
	                subLightColor *= (shadowValue + 1.0f) * 0.5f;
		        #endif
	        #endif
        #else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
        #endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

        #if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	        #if defined(CUBE_MAPPING_ENABLED)
	            float4 cubeMapColor = texCUBE(_CubeMapSampler, normalize(i.CubeMap.xyz)).rgba; //TODO : check
	            float cubeMapIntensity = i.CubeMap.w;
            #elif defined(SPHERE_MAPPING_ENABLED)
	            float4 sphereMapColor = tex2D(_SphereMapSampler, i.SphereMap.xy).rgba;
	        #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
        #else // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

        #endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

        float4 resultColor = diffuseAmt;
	    float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);
 	    float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

        #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	        // [PerPixel]
            float3 worldSpaceNormal = EvaluateNormalFP(i);

            #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
                worldSpaceNormal = lerp(worldSpaceNormal, EvaluateNormal2FP(i), i.Color0.a);
            #endif

	        float3 ambient = float3(0.0f, 0.0f, 0.0f);

	        #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	            //ambient = float3(0.0f, 0.0f, 0.0f);
	        #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
		        #if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	                //ambient = float3(0.0f, 0.0f, 0.0f);
			        #define FP_NEED_AFTER_MAX_AMBIENT
		        #else // NO_MAIN_LIGHT_SHADING_ENABLED
                    #if defined(FP_PORTRAIT)
	                    ambient = PortraitEvaluateAmbient();
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

            #if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
                #if defined(CUBE_MAPPING_ENABLED)
                    #define FP_NDOTE_2
                #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
            #endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))

            #if defined(FP_NDOTE_1) || defined(FP_NDOTE_2)
                float ndote = saturate(dot(worldSpaceNormal, worldSpaceEyeDirection));

                // defined(DOUBLE_SIDED)
                UNITY_BRANCH
                if (_Culling == 0) {
                    UNITY_BRANCH
                    if (ndote < 0.0f) {
                        ndote *= -1.0f;
                        worldSpaceNormal *= -1.0f;
                    }
                }
	        #endif // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

            // リムライト
            #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    #if defined(RIM_TRANSPARENCY_ENABLED)
                        resultColor.a *= 1.0f - EvaluateRimLightValue(ndote);
                    #else // RIM_TRANSPARENCY_ENABLED
                        half rimLightvalue = EvaluateRimLightValue(ndote);

                        #if defined(RIM_CLAMP_ENABLED)
                            rimLightvalue = min(_RimLightClampFactor, rimLightvalue);
                        #endif

                        ambient += rimLightvalue * (float3)_RimLitColor * subLightColor;
                    #endif // RIM_TRANSPARENCY_ENABLED
                #endif // RIM_LIGHTING_ENABLED
            #endif // defined(USE_LIGHTING)

	        // 環境マップ
	        #if !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))
		        // キューブマップ/スフィアマップ-PerPixel
		        #if defined(CUBE_MAPPING_ENABLED)
	                float3 cubeMapParams = reflect(-worldSpaceEyeDirection, worldSpaceNormal);
	                float cubeMapIntensity = 1.0f - max(0.0f, ndote) * (float)_CubeFresnelPower;
	                float4 cubeMapColor = texCUBE(_CubeMapSampler, normalize(cubeMapParams.xyz)).rgba;
		        #elif defined(SPHERE_MAPPING_ENABLED)
                    float3 viewSpaceNormal = (float3)mul((float3x3)UNITY_MATRIX_V, worldSpaceNormal.xyz);
                    float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + 0.5f; //float2(0.5f, 0.5f);
                    float4 sphereMapColor = tex2D(_SphereMapSampler, sphereMapParams.xy).rgba;
		        #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	        #endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))

            #if defined(FP_SHINING)
                shadingAmt = (1.0f - float3(ndote, ndote, ndote)) * float3(0.345f * 3.5f, 0.875f * 3.5f, 1.0f * 3.5f);
                resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
            #elif defined(FP_PORTRAIT)
                shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
            #else
                shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection, attenuation);
            #endif
        #else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	        // [PerVertex]
            #if defined(USE_LIGHTING)
                #if defined(PRECALC_EVALUATE_AMBIENT)
                    float3 subLight = float3(0.0f, 0.0f, 0.0f);
                #else
                    float3 subLight = i.Color1.rgb;
                #endif

                float3 diffuse = i.ShadingAmount.rgb;
                float3 specular = i.LightingAmount.rgb;
            #else // USE_LIGHTING
                float3 subLight = float3(0.0f, 0.0f, 0.0f);
                float3 diffuse = float3(1.0f, 1.0f, 1.0f);
                float3 specular = float3(0.0f, 0.0f, 0.0f);
            #endif // USE_LIGHTING

	        float3 ambient = float3(0.0f, 0.0f, 0.0f);;

            // リムライト
            #if defined(USE_LIGHTING)
	            float3 worldSpaceNormal = normalize(i.normal);

		        #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	                //ambient = float3(0.0f, 0.0f, 0.0f);
		        #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
			        #if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	                    //ambient = float3(0.0f, 0.0f, 0.0f);
				        #define FP_NEED_AFTER_MAX_AMBIENT
			        #else // NO_MAIN_LIGHT_SHADING_ENABLED
                        #if defined(FP_PORTRAIT)
	                        ambient = PortraitEvaluateAmbient();
				        #else // FP_PORTRAIT
                            #if defined(PRECALC_EVALUATE_AMBIENT)
                                ambient = i.Color1.rgb;
                            #else
                                ambient = EvaluateAmbient(worldSpaceNormal);
                            #endif
                        #endif // FP_PORTRAIT
			        #endif // NO_MAIN_LIGHT_SHADING_ENABLED
		        #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

		        #if defined(RIM_LIGHTING_ENABLED)
			        #if defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	                    half rimLightvalue = i.ShadingAmount.a;
                        //rimLightvalue = min(_RimLightClampFactor, rimLightvalue);

				        #if defined(RIM_TRANSPARENCY_ENABLED)
	                        resultColor.a *= rimLightvalue;
				        #else // RIM_TRANSPARENCY_ENABLED
	                        ambient += rimLightvalue * (float3)_RimLitColor * subLightColor;
				        #endif // RIM_TRANSPARENCY_ENABLED
			        #else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
				        #define FP_WS_EYEDIR_EXIST
	                    float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);

                        // defined(DOUBLE_SIDED)
                        UNITY_BRANCH
                        if (_Culling == 0) {
                            UNITY_BRANCH
                            if (ndote < 0.0f) {
                                ndote *= -1.0f;
                                worldSpaceNormal *= -1.0f;
                            }
                        }

	                    half rimLightvalue = EvaluateRimLightValue(ndote);

                        #if defined(RIM_CLAMP_ENABLED)
                            rimLightvalue = min(rimLightvalue, _RimLightClampFactor);
                        #endif

				        #if defined(RIM_TRANSPARENCY_ENABLED)
	                        resultColor.a *= rimLightvalue;
                        #else // RIM_TRANSPARENCY_ENABLED
	                        ambient += rimLightvalue * (float3)_RimLitColor * subLightColor;
				        #endif // RIM_TRANSPARENCY_ENABLED
			        #endif // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
		        #endif // RIM_LIGHTING_ENABLED
	        #else
	            ambient = float3(0.0f, 0.0f, 0.0f);
	        #endif // defined(USE_LIGHTING)

            #if defined(FP_SHINING)
		        #if !defined(USE_LIGHTING)
	                float3 worldSpaceNormal = normalize(i.normal);
		        #endif

	            float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
	            float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);

		        #if !defined(USE_LIGHTING)
	                shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;
		        #else
	                shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * float3(0.345f * 3.5f, 0.875f * 3.5f, 1.0f * 3.5f);
		        #endif
	        #else
	            shadingAmt = EvaluateLightingPerVertexFP(i, i.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	        #endif
        #endif // !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)

        #if defined(FP_NEED_AFTER_MAX_AMBIENT)
            #if defined(FP_PORTRAIT)
                shadingAmt = max(shadingAmt, PortraitEvaluateAmbient());
            #else // FP_PORTRAIT
                #if defined(USE_PER_VERTEX_LIGHTING) && defined(PRECALC_EVALUATE_AMBIENT)
                    shadingAmt = max(shadingAmt, i.Color1.rgb);
                #else
                    shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
                #endif
            #endif // FP_PORTRAIT
        #endif

        #if defined(USE_LIGHTING)
            #if defined(MULTI_UV_ENANLED)
                #if defined(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    diffuseAmt.rgb *= diffuse2Amt.rgb * multi_uv_alpha;
                    diffuseAmt.rgb = (diffuseAmt.rgb * _BlendMulScale2);
                    diffuse2Amt.rgb = max(float3(1,1,1), EvaluateAmbient(worldSpaceNormal));
                    diffuse2Amt.rgb = min(float3(1.5,1.5,1.5), diffuse2Amt.rgb);
                    diffuse2Amt.rgb = (i.Color0.rgb * diffuse2Amt.rgb);
                    diffuseAmt.rgb = (diffuseAmt.rgb * diffuse2Amt.rgb);
                #else

                #endif
            #elif defined(MULTI_UV2_ENANLED)
                #if defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    diffuseAmt.rgb *= diffuse3Amt.rgb * multi_uv2_alpha;
                    diffuseAmt.rgb = (diffuseAmt.rgb * _BlendMulScale3);
                    diffuse3Amt.rgb = max(float3(1,1,1), EvaluateAmbient(worldSpaceNormal));
                    diffuse3Amt.rgb = min(float3(1.5,1.5,1.5), diffuse3Amt.rgb);
                    diffuse3Amt.rgb = (i.Color0.rgb * diffuse3Amt.rgb);
                    diffuseAmt.rgb = (diffuseAmt.rgb * diffuse3Amt.rgb);
                #else
                
                #endif
            #endif
        #endif

        shadingAmt += (float3)_GameMaterialEmission;

        #if defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
            #if defined(WATER_SURFACE_ENABLED)
                #if !defined(FP_WS_EYEDIR_EXIST)
                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
                #endif // FP_WS_EYEDIR_EXIST

                float water_ndote = dot(normalize(_UserClipPlane.xyz), worldSpaceEyeDirection);
                float waterAlpha = pow(1.0f - abs(water_ndote), 4.0f);
                resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a) + reflColor.rgb * waterAlpha * _ReflectionIntensity;
                float waterGlowValue = reflColor.a + refrColor.a;
            #else // defined(WATER_SURFACE_ENABLED)
                resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
            #endif // defined(WATER_SURFACE_ENABLED)
        #endif // defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)

        #if defined(CARTOON_SHADING_ENABLED)
		    #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			    #if defined(CARTOON_HILIGHT_ENABLED)
	                float hilightValue = tex2D(_HighlightMapSampler, i.CartoonMap.xy).r;
	                float3 hilightAmt = hilightValue * _HighlightIntensity * _HighlightColor * subLightColor;
                    #define FP_HAS_HILIGHT
			    #endif // CARTOON_HILIGHT_ENABLED
		    #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	    #endif // CARTOON_SHADING_ENABLED

	    #if defined(FP_HAS_HILIGHT)
	        sublightAmount += hilightAmt;
	    #endif // FP_HAS_HILIGHT

        #if defined(SHADOW_COLOR_SHIFT_ENABLED)
	        // [Not Toon] 表面下散乱のような使い方
	        float3 subLightColor2 = max(float3(1.0f, 1.0f, 1.0f), subLightColor * 2.0f);
	        shadingAmt.rgb += (float3(1.0f, 1.0f, 1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * _ShadowColorShift * subLightColor2;
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
        #else // EMVMAP_AS_IBL_ENABLED
	        #if defined(CUBE_MAPPING_ENABLED)
	            resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	        #elif defined(SPHERE_MAPPING_ENABLED)
	            resultColor.rgb += sphereMapColor.rgb * _SphereMapIntensity * envMapColor * glossValue;
	        #endif // CUBE_MAPPING_ENABLED
        #endif // EMVMAP_AS_IBL_ENABLED

        shadingAmt *= ambientOcclusion;
	    //shadingAmt += sublightAmount;

        #if defined(EMISSION_MAPPING_ENABLED)
	        float4 emiTex = tex2D(_EmissionMapSampler, i.uv.xy);
            //emiTex.rgb = GammaToLinearSpace(emiTex.rgb);
	        shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r, emiTex.r, emiTex.r));
        #endif // EMISSION_MAPPING_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            resultColor.rgb *= shadingAmt;
        #elif defined(UNITY_PASS_FORWARDADD)
            resultColor.rgb *= sublightAmount;
        #endif

        #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
	        resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
        #endif

        #if defined(FOG_ENABLED) && defined(UNITY_PASS_FORWARDBASE)
            EvaluateFogFP(resultColor.rgb, _FogColor.rgb, i.Color1.a);
        #endif // FOG_ENABLED

        #if defined(SUBTRACT_BLENDING_ENABLED)
	        resultColor.rgb = resultColor.rgb * resultColor.a;
	    #elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
	        resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
	    #endif

        //resultColor = pow(resultColor, 1/2.2);

        #if defined(FP_FORCETRANSPARENT) || defined(FP_SHINING)
            return resultColor;
        #elif defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
            #if !defined(ALPHA_BLENDING_ENABLED)
                #if defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    float glowValue = 0.0f;

                    #if defined(GLARE_MAP_ENABLED)
                        glowValue = tex2D(_GlareMapSampler, i.uv.xy).x;
                        //glowValue.x = GammaToLinearSpaceExact(glowValue.x);
                    #endif

                    #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_GLARE_MAP_ENABLED)
                        float glowValue2 = tex2D(_GlareMap2Sampler, i.uv.xy).x;
                        //glowValue2.x = GammaToLinearSpaceExact(glowValue2.x);
                        glowValue = lerp(glowValue, glowValue2, multi_uv_alpha);
                    #endif

                    #if defined(GLARE_HIGHTPASS_ENABLED)
                        float lumi = dot(resultColor.rgb, float3(1.0f,1.0f,1.0f));
                        glowValue += max(lumi - 1.0f, 0.0f);
                    #endif

                    #if defined(GLARE_OVERFLOW_ENABLED)
                        float3 glowof = max(float3(0.0f, 0.0f, 0.0f), resultColor.rgb - _GlowThreshold);
                        glowValue += dot(glowof, 1.0f);
                    #endif

                    #if defined(WATER_SURFACE_ENABLED)
                        glowValue += waterGlowValue;
                        return float4(resultColor.rgb, glowValue * _GlareIntensity);
                    #else 
                        //return float4(resultColor.rgb * glowValue * _GlareIntensity, resultColor.a);
                        return float4(resultColor.rgb + (resultColor.rgb * glowValue * _GlareIntensity), glowValue * _GlareIntensity * resultColor.a);
                    #endif
                #else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    //return float4(resultColor.rgb, 0.0f);
                    return float4(resultColor.rgb + (resultColor.rgb * _GlareIntensity), 1.0f);
                #endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
            #else // !defined(ALPHA_BLENDING_ENABLED)
                //return resultColor;
                return float4(resultColor.rgb + (resultColor.rgb * _GlareIntensity), resultColor.a);
            #endif // !defined(ALPHA_BLENDING_ENABLED)
        #endif // FP_DEFAULT || FP_DEFAULTRT
    #endif // NOTHING_ENABLED
}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2