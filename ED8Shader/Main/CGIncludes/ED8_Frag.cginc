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
fixed4 DefaultFPShader (DefaultVPOutput IN) : SV_TARGET {
    UNITY_SETUP_INSTANCE_ID(IN);

    #if defined(NOTHING_ENABLED)
	    float4 resultColor = IN.Color0;
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
            float3 waterNorm = float3(IN.WorldPositionDepth.x, IN.WorldPositionDepth.y - _UserClipPlane.w, IN.WorldPositionDepth.z);
            clip(dot(normalize(_UserClipPlane.xyz), normalize(waterNorm)));
        #endif // FP_DEFAULTRT

        #if defined(DUDV_MAPPING_ENABLED)
	        float2 dudvValue = (tex2D(_DuDvMapSampler, IN.DuDvTexCoord.xy).xy * 2.0f - 1.0f) * (_DuDvScale / _DuDvMapImageSize);
        #endif // DUDV_MAPPING_ENABLED

	    float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 1.0f);

        #if defined(ALPHA_TESTING_ENABLED)
            IN.Color0.a *= 1 + max(0, CalcMipLevel(IN.TexCoord)) * 0.25;
            IN.Color0.a = (IN.Color0.a - _AlphaThreshold) / max(fwidth(IN.Color0.a), 0.0001) + 0.5;
        #endif //ALPHA_TESTING_ENABLED

        float4 materialDiffuse = (float4)_GameMaterialDiffuse;

        #if !defined(DIFFUSEMAP_CHANGING_ENABLED)
	        diffuseAmt = tex2D(_DiffuseMapSampler, IN.TexCoord.xy 
	        #if defined(DUDV_MAPPING_ENABLED)
		        + dudvValue
	        #endif // DUDV_MAPPING_ENABLED
		    );
        #else // DIFFUSEMAP_CHANGING_ENABLED
	        float diffuseTxRatio = (float)materialDiffuse.a - 1.0f;
	        materialDiffuse.a = min(1.0f, materialDiffuse.a);

            UNITY_BRANCH
            if (diffuseTxRatio < 1.0f) {
                float t = max(0.0f, diffuseTxRatio);

                float4 diffuseTx0 = tex2D(_DiffuseMapSampler, IN.TexCoord.xy 
                #if defined(DUDV_MAPPING_ENABLED)
                    + dudvValue
                #endif // DUDV_MAPPING_ENABLED
                );

                float4 diffuseTx1 = tex2D(_DiffuseMapTrans1Sampler, IN.TexCoord.xy
                #if defined(DUDV_MAPPING_ENABLED)
                    + dudvValue
                #endif // DUDV_MAPPING_ENABLED
                );

                diffuseAmt = lerp(diffuseTx0, diffuseTx1, t);
            }
            else if (diffuseTxRatio < 2.0f) {
                float t = diffuseTxRatio - 1.0f;

                float4 diffuseTx1 = tex2D(_DiffuseMapTrans1Sampler, IN.TexCoord.xy
                #if defined(DUDV_MAPPING_ENABLED)
                    + dudvValue
                #endif // DUDV_MAPPING_ENABLED
                );

                float4 diffuseTx2 = tex2D(_DiffuseMapTrans2Sampler IN.TexCoord.xy
                #if defined(DUDV_MAPPING_ENABLED)
                    + dudvValue
                #endif // DUDV_MAPPING_ENABLED
                );

                diffuseAmt = lerp(diffuseTx1, diffuseTx2, t);
            }
            else {
                float t = (min(3.0f, diffuseTxRatio) - 2.0f);

                float4 diffuseTx2 = tex2D(_DiffuseMapTrans2Sampler, IN.TexCoord.xy
                #if defined(DUDV_MAPPING_ENABLED)
                    + dudvValue
                #endif // DUDV_MAPPING_ENABLED
                );

                float4 diffuseTx0 = tex2D(_DiffuseMapSampler, IN.TexCoord.xy
                #if defined(DUDV_MAPPING_ENABLED)
                    + dudvValue
                #endif // DUDV_MAPPING_ENABLED
                );

                diffuseAmt = lerp(diffuseTx2, diffuseTx0, t);
            }
        #endif // DIFFUSEMAP_CHANGING_ENABLED
        
	    diffuseAmt.a *= (float)IN.Color0.a;

        #if defined(USE_SCREEN_UV)
            float4 dudvTex = IN.ReflectionMap;

            #if defined(DUDV_MAPPING_ENABLED)
                float2 dudvAmt = dudvValue * float2(_ScreenWidth /_DuDvMapImageSize.x, _ScreenHeight / _DuDvMapImageSize.y);
                dudvTex.xy += dudvAmt;
                #define FP_DUDV_AMT_EXIST
            #endif // DUDV_MAPPING_ENABLED

            #if defined(WATER_SURFACE_ENABLED)
                float4 reflColor = tex2D(_ReflectionTexture, dudvTex.xy / dudvTex.w).xyzw;
            #endif // defined(WATER_SURFACE_ENABLED)

            float4 refrColor = tex2D(_RefractionTexture, dudvTex.xy / dudvTex.w).xyzw;
        #endif // defined(USE_SCREEN_UV)

        #if defined(FP_FORCETRANSPARENT)
            #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
                #if defined(ALPHA_TESTING_ENABLED)
                    clip(diffuseAmt.a - _AlphaThreshold * (float)IN.Color0.a);
                #else
                    clip(diffuseAmt.a - 0.004f);
                #endif
            #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
        #elif defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
            #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
                #if defined(TWOPASS_ALPHA_BLENDING_ENABLED)
                    float alphaAmt = diffuseAmt.a - _AlphaThreshold * (float)IN.Color0.a;
                    clip((alphaAmt > 0.0f) ? (alphaAmt * _AlphaTestDirection) : (-1.0f/255.0f));
                #else // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
                    #if defined(ALPHA_TESTING_ENABLED)
                        clip(diffuseAmt.a - _AlphaThreshold * (float)IN.Color0.a);
                    #else
                        clip(diffuseAmt.a - 0.004f);
                    #endif
                #endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
            #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
        #endif

        #if defined(MULTI_UV_ENANLED)
	        #if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	            float4 diffuse2Amt = tex2D(_DiffuseMap2Sampler, IN.TexCoord2.xy);

		        #if defined(UVA_SCRIPT_ENABLED)
	                diffuse2Amt *= (float4)_UVaMUvColor;
		        #endif // UVA_SCRIPT_ENABLED

                #if defined(MULTI_UV_FACE_ENANLED)
                    float multi_uv_alpha = (float)diffuse2Amt.a;
                #else // defined(MULTI_UV_FACE_ENANLED)
                    float multi_uv_alpha = (float)IN.Color0.a * diffuse2Amt.a;
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
                    //	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv_alpha);
                    float3 muvtex_add = (diffuse2Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv_alpha;
                    diffuseAmt.rgb += muvtex_add;
		        #elif defined(MULTI_UV_SHADOW_ENANLED)
	                // 影領域として扱う
		        #else
	                // アルファ
	                diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
		        #endif //
	        #else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	            float multi_uv_alpha = (float)IN.Color0.a;
	        #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

            #if defined(MULTI_UV2_ENANLED)
                #if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
                    float4 diffuse3Amt = tex2D(_DiffuseMap3Sampler, IN.TexCoord3.xy);

                    #if defined(MULTI_UV2_FACE_ENANLED)
                        float multi_uv2_alpha = (float)diffuse3Amt.a;
                    #else // defined(MULTI_UV2_FACE_ENANLED)
                        float multi_uv2_alpha = (float)IN.Color0.a * diffuse3Amt.a;
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
                        //	diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb, multi_uv2_alpha);
                        float3 muvtex_add2 = (diffuse3Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb * multi_uv2_alpha;
                        diffuseAmt.rgb += muvtex_add2;
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

        #if defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
            float shadowValue = 1.0f;

            UNITY_BRANCH
            if (_WorldSpaceLightPos0.w >= 0) {
                shadowValue = SHADOW_ATTENUATION(IN);
            }

            #if defined(FP_DUDV_AMT_EXIST)
                shadowValue = (shadowValue + 1.0f) * 0.5f;
            #endif
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
            float4 projTex = tex2D(_ProjectionMapSampler, IN.ProjMap.xy);
            shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
        #endif // PROJECTION_MAP_ENABLED

        #if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
	        float glossValue = 1.0f;

	        #if defined(SPECULAR_MAPPING_ENABLED)
	            glossValue = tex2D(_SpecularMapSampler, IN.TexCoord.xy).x;
	        #endif // SPECULAR_MAPPING_ENABLED

            #if defined(MULTI_UV_ENANLED)
                #if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
                    float glossValue2 = tex2D(_SpecularMap2Sampler, IN.TexCoord2.xy).x;
                    glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
                #endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)

                #if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
                    float glossValue3 = tex2D(_SpecularMap3Sampler, IN.TexCoord3.xy).x;
                    glossValue = lerp(glossValue, glossValue3, multi_uv2_alpha);
                #endif // defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
            #endif // 
        #else // SPECULAR_MAPPING_ENABLED
            float glossValue = 1.0f;
        #endif // SPECULAR_MAPPING_ENABLED

        #if defined(OCCULUSION_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV_OCCULUSION2_MAPPING_ENABLED))
	        float occulusionValue = 1.0f;

	        #if defined(OCCULUSION_MAPPING_ENABLED)
	            occulusionValue = tex2D(_OcculusionMapSampler, IN.TexCoord.xy).x;
	        #endif // OCCULUSION_MAPPING_ENABLED

	        #if defined(MULTI_UV_ENANLED)
		        #if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue2 = tex2D(_OcculusionMap2Sampler, IN.TexCoord2.xy);

			        #if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	                    multi_uv_alpha = occulusionValue2.a;
			        #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		        #endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)

		        #if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue3 = tex2D(_OcculusionMap3Sampler, IN.TexCoord3.xy);

			        #if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	                    float multi_uv2_alpha = occulusionValue3.a;
			        #endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		        #endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	        #endif // defined(MULTI_UV_ENANLED)

	        float3 ambientOcclusion = (float3)IN.Color0.rgb * occulusionValue;
        #else // OCCULUSION_MAPPING_ENABLED
	        float3 ambientOcclusion = (float3)IN.Color0.rgb;
        #endif // OCCULUSION_MAPPING_ENABLED

        #if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        #if defined(USE_LIGHTING)
                #if defined(FP_PORTRAIT)
                    float3 subLightColor = _PortraitLightColor;
                #else // FP_PORTRAIT
                    float3 subLightColor = _LightColor0.rgb;
                #endif // FP_PORTRAIT
	        #else
	            float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	        #endif

	        #if defined(SPECULAR_MAPPING_ENABLED)
		        //#if defined(RECEIVE_SHADOWS)
	            subLightColor *= (glossValue + shadowValue + 1.0f) * (1.0f / 3.0f);
		        //#endif
	        #else
		        //#if defined(RECEIVE_SHADOWS)
	            subLightColor *= (shadowValue + 1.0f) * 0.5f;
		        //#endif
	        #endif
        #else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
        #endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

        #if defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)
	        #if defined(CUBE_MAPPING_ENABLED)
	            float4 cubeMapColor = texCUBE(_CubeMapSampler, normalize(IN.CubeMap.xyz)).rgba; //TODO : check
	            float cubeMapIntensity = IN.CubeMap.w;
            #elif defined(SPHERE_MAPPING_ENABLED)
	            float4 sphereMapColor = tex2D(_SphereMapSampler, IN.SphereMap.xy).rgba;
	        #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
        #else // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

        #endif // defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS) || !defined(USE_LIGHTING)

        float4 resultColor = diffuseAmt;
	    float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);
 	    float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

        #if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
	        // [PerPixel]
	        float3 worldSpaceNormal = EvaluateNormalFP(IN);

	        #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
	            worldSpaceNormal = normalize(lerp(worldSpaceNormal, EvaluateNormal2FP(IN), multi_uv_alpha));
	        #endif //

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

            float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
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
	        #endif // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

            // リムライト
            #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    #if defined(RIM_TRANSPARENCY_ENABLED)
                        resultColor.a *= 1.0f - EvaluateRimLightValue(ndote);
                    #else // RIM_TRANSPARENCY_ENABLED
                        float rimLightvalue = EvaluateRimLightValue(ndote);
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
	                float4 cubeMapColor = tex2D(_CubeMapSampler, normalize(cubeMapParams.xyz)).rgba;
		        #elif defined(SPHERE_MAPPING_ENABLED)
                    float3 viewSpaceNormal = (float3)mul(worldSpaceNormal.xyz, (float3x3)UNITY_MATRIX_V);
                    float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + float2(0.5f, 0.5f);
                    float4 sphereMapColor = tex2D(_SphereMapSampler, sphereMapParams.xy).rgba;
		        #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	        #endif // !(defined(FORCE_PER_VERTEX_ENVIRON_MAP) || !defined(USE_TANGENTS))

            #if defined(FP_SHINING)
                shadingAmt = (1.0f - float3(ndote, ndote, ndote)) * float3(0.345f * 3.5f, 0.875f * 3.5f, 1.0f * 3.5f);
                resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
            #elif defined(FP_PORTRAIT)
                shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
            #else
                shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, IN.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection);
            #endif
        #else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
	        // [PerVertex]
            #if defined(USE_LIGHTING)
                #if defined(PRECALC_EVALUATE_AMBIENT)
                    float3 subLight = float3(0.0f, 0.0f, 0.0f);
                #else
                    float3 subLight = IN.Color1.rgb;
                #endif

                float3 diffuse = IN.ShadingAmount.rgb;
                float3 specular = IN.LightingAmount.rgb;
            #else // USE_LIGHTING
                float3 subLight = float3(0.0f, 0.0f, 0.0f);
                float3 diffuse = float3(1.0f, 1.0f, 1.0f);
                float3 specular = float3(0.0f, 0.0f, 0.0f);
            #endif // USE_LIGHTING

	        float3 ambient = float3(0.0f, 0.0f, 0.0f);;

            // リムライト
            #if defined(USE_LIGHTING)
	            float3 worldSpaceNormal = normalize(IN.Normal);

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
                                ambient = IN.Color1.rgb;
                            #else
                                ambient = EvaluateAmbient(worldSpaceNormal);
                            #endif
                        #endif // FP_PORTRAIT
			        #endif // NO_MAIN_LIGHT_SHADING_ENABLED
		        #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

		        #if defined(RIM_LIGHTING_ENABLED)
			        #if defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	                    float rimLightvalue = IN.ShadingAmount.a;

				        #if defined(RIM_TRANSPARENCY_ENABLED)
	                        resultColor.a *= rimLightvalue;
				        #else // RIM_TRANSPARENCY_ENABLED
	                        ambient += rimLightvalue * (float3)_RimLitColor * subLightColor;
				        #endif // RIM_TRANSPARENCY_ENABLED
			        #else // defined(USE_FORCE_VERTEX_RIM_LIGHTING)
	                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
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

	                    float rimLightvalue = EvaluateRimLightValue(ndote);

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
	                float3 worldSpaceNormal = normalize(IN.Normal);
		        #endif

	            float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
	            float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);

		        #if !defined(USE_LIGHTING)
	                shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;
		        #else
	                shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * float3(0.345f * 3.5f, 0.875f * 3.5f, 1.0f * 3.5f);
		        #endif
	        #else
	            shadingAmt = EvaluateLightingPerVertexFP(IN, IN.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	        #endif
        #endif // !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)

        #if defined(CUSTOM_DIFFUSE_ENABLED)
            float grayscale = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));

            UNITY_BRANCH
            if (_WorldSpaceLightPos0.w == 0.0) {
                #if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
                    float ldotn = (float)dot(normalize(_LightDirForChar), worldSpaceNormal);
                    resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
                #else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
                    float ldotn = (float)dot(_WorldSpaceLightPos0.xyz, worldSpaceNormal);
                    resultColor.rgb = calcCustomDiffuse(grayscale * (ldotn * 0.5f + 0.5f) * shadowValue);
                #endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
            }
            else {
                resultColor.rgb = float3(grayscale, grayscale, grayscale);
            }
        #endif // CUSTOM_DIFFUSE_ENABLED

        #if defined(FP_NEED_AFTER_MAX_AMBIENT)
            #if defined(FP_PORTRAIT)
                shadingAmt = max(shadingAmt, PortraitEvaluateAmbient());
            #else // FP_PORTRAIT
                #if defined(USE_PER_VERTEX_LIGHTING) && defined(PRECALC_EVALUATE_AMBIENT)
                    shadingAmt = max(shadingAmt, IN.Color1.rgb);
                #else
                    shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
                #endif
            #endif // FP_PORTRAIT
        #endif

        shadingAmt += (float3)_GameMaterialEmission;

        #if defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
            #if defined(WATER_SURFACE_ENABLED)
                #if !defined(FP_WS_EYEDIR_EXIST)
                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - IN.WorldPositionDepth.xyz);
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
	                float hilightValue = tex2D(_HighlightMapSampler, IN.CartoonMap.xy).r;
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
	    shadingAmt += sublightAmount;

        #if defined(EMISSION_MAPPING_ENABLED)
	        float4 emiTex = tex2D(_EmissionMapSampler, IN.TexCoord.xy);
	        shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r, emiTex.r, emiTex.r));
        #endif // EMISSION_MAPPING_ENABLED

        resultColor.rgb *= shadingAmt;

        #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
	        resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
        #endif

        #if defined(FOG_ENABLED)
            EvaluateFogFP(resultColor.rgb, _FogColor.rgb, IN.Color1.a);
        #endif // FOG_ENABLED

        #if defined(SUBTRACT_BLENDING_ENABLED)
	        resultColor.rgb = resultColor.rgb * resultColor.a;
	    #elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
	        resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
	    #endif

        #if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT) || defined(FP_SHINING)
            return resultColor;
        #elif defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
            #if !defined(ALPHA_BLENDING_ENABLED)
                #if defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    float glowValue = 0.0f;

                    #if defined(GLARE_MAP_ENABLED)
                        glowValue += tex2D(_GlareMapSampler, IN.TexCoord.xy).x;
                    #endif

                    #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_GLARE_MAP_ENABLED)
                        float glowValue2 = tex2D(_GlareMap2Sampler, IN.TexCoord.xy).x;
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
                        return float4(resultColor.rgb, glowValue * _GlareIntensity * resultColor.a);
                    #endif
                #else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    return float4(resultColor.rgb, 0.0f);
                #endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
            #else // !defined(ALPHA_BLENDING_ENABLED)
                return resultColor;
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