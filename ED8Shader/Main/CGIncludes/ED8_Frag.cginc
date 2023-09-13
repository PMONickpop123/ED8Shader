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
        half4 resultColor = i.Color0;
	
        // シェーダ外部からのカラー操作
        resultColor *= _GameMaterialDiffuse;
        resultColor.rgb += _GameMaterialEmission.rgb;

        #if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
            float4 resultColor2 = float4(0,0,0,0);

            #if !defined(ALPHA_BLENDING_ENABLED)
                resultColor2 = float4(resultColor.rgb, 0);
            #else
                resultColor2 = resultColor;
            #endif

            return resultColor2;
        #elif defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT)
            return resultColor;
        #endif
    #else // NOTHING_ENABLED
        #if defined(INSTANCING_ENABLED)
            float ditherThreshold = GetDitherThreshold(ScreenPosition.xy);
            #if defined(FAR_CLIP_BY_DITHER_ENABLED)
                // ディザリングによる距離クリップ
                clip(i.instanceParam.x - ditherThreshold);
            #else
                // ディザリングによるモデル切替
                float ditherResult = i.instanceParam.y - ditherThreshold;
                ditherResult = (sign(i.instanceParam.z) < 0) ? -ditherResult : ditherResult;
                clip(ditherResult);
            #endif
        #endif

        #if defined(USER_CLIP_PLANE)
            // 任意平面でクリップ
            float3 waterNorm = float3(i.WorldPositionDepth.x, i.WorldPositionDepth.y, i.WorldPositionDepth.z) - _UserClipPlane2.xyz;
            clip(dot(_UserClipPlane.xyz, normalize(waterNorm)));
        #endif

        #if defined(DUDV_MAPPING_ENABLED)
            float2 dudvValue = tex2D(_DuDvMapSampler, i.DuDvTexCoord.xy).xy;
            #if !defined(UNITY_COLORSPACE_GAMMA)
                dudvValue.x = LinearToGammaSpaceExact(dudvValue.x);
                dudvValue.y = LinearToGammaSpaceExact(dudvValue.y);
            #endif

            dudvValue = (dudvValue * 2.0f - 1.0f) * (_DuDvScale / _DuDvMapImageSize);
            float4 diffuseAmt = tex2D(_MainTex, i.uv.xy + dudvValue);
        #else
            float4 diffuseAmt = tex2D(_MainTex, i.uv.xy);
        #endif // DUDV_MAPPING_ENABLED

        #if !defined(UNITY_COLORSPACE_GAMMA)
            diffuseAmt.rgb = LinearToGammaSpace(diffuseAmt.rgb);
        #endif

        #if !defined(ALPHA_TESTING_ENABLED)
            diffuseAmt.a *= i.Color0.a;
        #endif

        // アルファテスト
        #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
            #if defined(ALPHA_TESTING_ENABLED)
                clip(diffuseAmt.a - _AlphaThreshold * i.Color0.a);
            #else
                clip(diffuseAmt.a - 0.004);
            #endif
        #endif // defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)

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

        // DUDV
        #if defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED) || defined(FP_FORCETRANSPARENT)
            float4 screenUv = float4(i.screenPos.x / _ScreenParams.x, i.screenPos.y / _ScreenParams.y, 0, 1);
            float2 screenUvBase = screenUv.xy;

            /*
            #if defined(DUDV_MAPPING_ENABLED)
                float2 dudvAmt = dudvValue * half2(_DuDvMapImageSize.x / _ScreenParams.x, _DuDvMapImageSize.y / _ScreenParams.y);
                screenUv.xy += dudvAmt;

                #define FP_DUDV_AMT_EXIST
            #endif
            */

            #if defined(DUDV_MAPPING_ENABLED)
                float2 dudvAmt = dudvValue.xy * float2(_ScreenParams.x / _DuDvMapImageSize.x, _ScreenParams.y / _DuDvMapImageSize.y);
                dudvAmt.y *= _CameraDepthTexture_TexelSize.z * abs(_CameraDepthTexture_TexelSize.y);
                #define FP_DUDV_AMT_EXIST
            #else
                float2 dudvAmt = float2(0.0f, 0.0f);
            #endif // DUDV_MAPPING_ENABLED
        #endif // defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED) || defined(FP_FORCETRANSPARENT)

        // マルチUV
        #if defined(MULTI_UV_ENANLED)
            #if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
                #if defined(DUDV_MAPPING_ENABLED)
                    float4 diffuse2Amt = tex2D(_DiffuseMap2Sampler, i.uv2.xy + dudvValue);
                #else
                    float4 diffuse2Amt = tex2D(_DiffuseMap2Sampler, i.uv2.xy);
                #endif

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    diffuse2Amt.rgb = LinearToGammaSpace(diffuse2Amt.rgb);
                    diffuse2Amt.rgb *= LinearToGammaSpace(_UVaMUvColor.rgb);
                    diffuse2Amt.a *= _UVaMUvColor.a;
                #else
                    diffuse2Amt *= _UVaMUvColor;
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
                    // 乗算
                    diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse2Amt.rgb * _BlendMulScale2, multi_uv_alpha);
                #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    // 乗算（ライトマップとして扱う）
                    //x	diffuseAmt.rgb = diffuseAmt.rgb * diffuse2Amt.rgb * _BlendMulScale2;	// キューブマップ後まで遅らせる
                #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                    // 乗算（純粋な掛け算。海や雲の揺らぎ表現に使う）
                    diffuseAmt *= diffuse2Amt * _BlendMulScale2;
                #elif defined(MULTI_UV_SHADOW_ENANLED)
                    // 影領域として扱う
                #else
                    // アルファ
                    diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
                #endif
            #else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
                float multi_uv_alpha = (float)i.Color0.a;
            #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

            // マルチUV2
            #if defined(MULTI_UV2_ENANLED)
                #if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
                    #if defined(DUDV_MAPPING_ENABLED)
                        float4 diffuse3Amt = tex2D(_DiffuseMap3Sampler, i.uv3.xy + dudvValue);
                    #else
                        float4 diffuse3Amt = tex2D(_DiffuseMap3Sampler, i.uv3.xy);
                    #endif

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
                        // 乗算
                        diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuseAmt.rgb * diffuse3Amt.rgb * _BlendMulScale3, multi_uv2_alpha);
                    #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                        // 乗算（ライトマップとして扱う）
                        //x	diffuseAmt.rgb = diffuseAmt.rgb * diffuse3Amt.rgb * _BlendMulScale3;	// キューブマップ後まで遅らせる
                    #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                        // 乗算（純粋な掛け算。海や雲の揺らぎ表現に使う）
                        diffuseAmt *= diffuse3Amt * _BlendMulScale3;
                    #elif defined(MULTI_UV2_SHADOW_ENANLED)
                        // 影領域として扱う
                    #else
                        // アルファ
                        diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
                    #endif
                #endif
            #endif // defined(MULTI_UV2_ENANLED)
        #endif // defined(MULTI_UV_ENANLED)

        // CS2- function
        #if !defined(FLAT_AMBIENT_ENABLED)
            #if !defined(UNITY_COLORSPACE_GAMMA)
                diffuseAmt.rgb *= LinearToGammaSpace(_GameMaterialDiffuse.rgb);
            #else
                diffuseAmt.rgb *= _GameMaterialDiffuse.rgb;
            #endif

            diffuseAmt.a *= _GameMaterialDiffuse.a;
        #endif

        #if defined(USE_LIGHTING) && (defined(FP_DEFAULT) || defined(FP_PORTRAIT))
            float shadowValue = 1;

            shadowValue = attenuation;

            #if defined(FP_DUDV_AMT_EXIST)
                shadowValue = (shadowValue + 1.0) * 0.5;
            #endif
        #else // defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
            float shadowValue = 1;
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

        // "雲の影"の濃度を加味
        #if defined(PROJECTION_MAP_ENABLED)
            float4 projTex = tex2D(_ProjectionMapSampler, i.ProjMap.xy);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                projTex.r = LinearToGammaSpaceExact(projTex.r);
                projTex.a = LinearToGammaSpaceExact(projTex.a);
            #endif

            shadowValue = min(shadowValue, 1.0f - (projTex.r * projTex.a));
        #endif // PROJECTION_MAP_ENABLED

        // CS3+ additions.
        #if defined(FLAT_AMBIENT_ENABLED)
            // シーン単位の影濃度を加味
            #if !defined(FP_PORTRAIT)
                shadowValue += (1 - shadowValue) * (1 - _UdonShadowDensity);
            #else
                shadowValue += (1 - shadowValue) * (1 - (_UdonShadowDensity * 0.3));
            #endif    
            
            // モデル単位の影濃度を加味
            //shadowValue += (1 - shadowValue) * (1 - _GameMaterialEmission.a);
            shadowValue = min(1, shadowValue);
        #endif

        // スペキュラマップ
        #if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
            float glossValue = 1;

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
            float glossValue = 1;
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

        // リムライト用のライト色を計算
        #if defined(USE_LIGHTING) && (defined(RIM_LIGHTING_ENABLED) || defined(SHADOW_COLOR_SHIFT_ENABLED) || defined(CARTOON_SHADING_ENABLED))
            float3 subLightColor = float3(0.0f, 0.0f, 0.0f);

            #if defined(USE_DIRECTIONAL_LIGHT_COLOR)
                subLightColor = _LightColor0.rgb;
            #else
                subLightColor = _UdonMainLightColor.rgb;
            #endif

            #if !defined(UNITY_COLORSPACE_GAMMA)
                subLightColor = LinearToGammaSpace(subLightColor);
            #endif

            #if defined(SPECULAR_MAPPING_ENABLED)
                subLightColor *= (glossValue + 1.0) * 0.5;
            #endif

            //#if !defined(UNITY_COLORSPACE_GAMMA)
            //    subLightColor *= LinearToGammaSpaceExact(pow(shadowValue, 2));
            //#else
            subLightColor *= (shadowValue + 1.0f) * 0.5f;
            //#endif
        #else // defined(USE_LIGHTING) && (defined(RIM_LIGHTING_ENABLED) || defined(SHADOW_COLOR_SHIFT_ENABLED) || defined(CARTOON_SHADING_ENABLED))
            float3 subLightColor = float3(0, 0, 0);
        #endif // defined(USE_LIGHTING) && (defined(RIM_LIGHTING_ENABLED) || defined(SHADOW_COLOR_SHIFT_ENABLED) || defined(CARTOON_SHADING_ENABLED))

        float4 resultColor = diffuseAmt;
        float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);
        float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

        // 法線の算出
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

        // 視線ベクトルの計算
        float3 worldSpaceEyeDirection = normalize(GetEyePosition() - i.WorldPositionDepth.xyz);

        // 視線ベクトルとの内積（リムライト、スフィア／キューブマップで使用）
        float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
        #if defined(RIM_LIGHTING_ENABLED)
            ndote *= (_Culling < 2 && ndote < 0) ? -1 : 1;
            worldSpaceNormal *= (_Culling < 2 && ndote < 0) ? -1 : 1;

            /*
            if (_Culling < 2) {
                if (ndote < 0) {
                    ndote *= -1;
                    worldSpaceNormal *= -1;
                }
            }
            */
        #endif // defined(DOUBLE_SIDED) && defined(RIM_LIGHTING_ENABLED)

        // スフィア／キューブマップ
        #if defined(SPHERE_MAPPING_ENABLED)
            float3 viewSpaceNormal = mul((float3x3)UNITY_MATRIX_V, worldSpaceNormal);
            float4 sphereMapColor = tex2D(_SphereMapSampler, viewSpaceNormal.xy * 0.5 + float2(0.5, 0.5)).rgba;

            #if !defined(UNITY_COLORSPACE_GAMMA)
                sphereMapColor.rgb = LinearToGammaSpace(sphereMapColor.rgb);
            #endif
        #elif defined(SPHERE_MAPPING_HAIRCUTICLE_ENABLED)
            // カメラ角度によって映りこみ角度が変わる
            float2 sphereMapTexcoord = reflect(-worldSpaceEyeDirection, worldSpaceNormal).xy * 0.5 + float2(0.5, 0.5);
            float sphereMapIntensity = float(pow(1.0 - abs(worldSpaceEyeDirection.y), 2));
            sphereMapIntensity *= float(pow(dot(-worldSpaceEyeDirection, worldSpaceNormal.xyz), 2));
            float4 sphereMapColor = tex2D(_SphereMapSampler, sphereMapTexcoord.xy).rgba;

            #if !defined(UNITY_COLORSPACE_GAMMA)
                sphereMapColor.rgb = LinearToGammaSpace(sphereMapColor.rgb);
            #endif
        #elif defined(CUBE_MAPPING_ENABLED)
            #if defined(WATER_SURFACE_ENABLED)
                // 「水面」時は上方向に補正を掛ける。映り込みをより綺麗に見せるため
                float3 cubeMapNormal = normalize(lerp(worldSpaceNormal, float3(0,1,0), 0.9));
                float3 cubeMapParams = reflect(-float3(worldSpaceEyeDirection.x * -1.0f, worldSpaceEyeDirection.y, worldSpaceEyeDirection.z), cubeMapNormal);
                float4 cubeMapColor = texCUBE(_CubeMapSampler, cubeMapParams.xyz).rgba;
                float cubeMapFresnel = pow(1.0 - max(0, dot(cubeMapNormal, worldSpaceEyeDirection)) * _CubeMapFresnel, 3);
            #else
                float3 cubeMapParams = reflect(-float3(worldSpaceEyeDirection.x * -1.0f, worldSpaceEyeDirection.y, worldSpaceEyeDirection.z), worldSpaceNormal);
                float4 cubeMapColor = texCUBE(_CubeMapSampler, cubeMapParams.xyz).rgba;
                float cubeMapFresnel = 1.0 - max(0, ndote) * _CubeMapFresnel;
            #endif

            #if !defined(UNITY_COLORSPACE_GAMMA)
                cubeMapColor.rgb = LinearToGammaSpace(cubeMapColor.rgb);
            #endif

            resultColor.rgb = lerp(resultColor.rgb, cubeMapColor.rgb, _CubeMapIntensity * cubeMapFresnel * ambientOcclusion * glossValue);
        #endif // defined(SPHERE_MAPPING_ENABLED)

        // ライティング計算
        #if defined(USE_LIGHTING)

            // 環境光の算出
            float3 ambientAmount;

            #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
                ambientAmount = float3(0, 0, 0);
            #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
                #if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
                    ambientAmount = float3(0, 0, 0);
                    #define FP_NEED_AFTER_MAX_AMBIENT
                #else
                    ambientAmount = GetGlobalAmbientColor(worldSpaceNormal);
                #endif
            #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

            // CS2- リムライト
            #if !defined(FLAT_AMBIENT_ENABLED)
                #if defined(USE_LIGHTING) && defined(RIM_LIGHTING_ENABLED)
                    float rimLightvalue = EvaluateRimLightValue(ndote);

                    #if defined(RIM_TRANSPARENCY_ENABLED)
                        resultColor.a *= saturate(1 - rimLightvalue);
                    #else
                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            ambientAmount += rimLightvalue * LinearToGammaSpace(_RimLitColor) * subLightColor;
                        #else
                            ambientAmount += rimLightvalue * _RimLitColor * subLightColor;
                        #endif
                    #endif
                #endif // defined(USE_LIGHTING) && defined(RIM_LIGHTING_ENABLED)
            #endif

            #if defined(FP_PORTRAIT)
                shadingAmt = PortraitEvaluateLightingPerPixel(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambientAmount, worldSpaceEyeDirection, attenuation);
            #else
                shadingAmt = EvaluateLightingPerPixel(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambientAmount, worldSpaceEyeDirection, attenuation);
            #endif

            #if defined(FLAT_AMBIENT_ENABLED)
                shadingAmt = lerp(shadingAmt, shadingAmt * GetGlobalAmbientColor(worldSpaceNormal), 1 - shadowValue);

                // CS3+ リムライト
                #if defined(USE_LIGHTING) && defined(RIM_LIGHTING_ENABLED)
                    float rimLightvalue = EvaluateRimLightValue(ndote);

                    #if defined(RIM_TRANSPARENCY_ENABLED)
                        resultColor.a *= saturate(1 - rimLightvalue);
                    #else
                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            shadingAmt += rimLightvalue * LinearToGammaSpace(_RimLitColor) * subLightColor;
                        #else
                            shadingAmt += rimLightvalue * _RimLitColor * subLightColor;
                        #endif

                        #if defined(RIM_CLAMP_ENABLED)
                            shadingAmt = ClampRimLighting(shadingAmt);
                        #endif
                    #endif
                #endif // defined(USE_LIGHTING) && defined(RIM_LIGHTING_ENABLED)
            #endif
        #else // defined(USE_LIGHTING)
            shadingAmt = EvaluateLightingPerVertexFP(shadowValue, worldSpaceNormal);

            #if defined(FLAT_AMBIENT_ENABLED)
                shadingAmt = lerp(shadingAmt, shadingAmt * GetGlobalAmbientColor(worldSpaceNormal), 1 - shadowValue);
            #endif

        #endif // defined(USE_LIGHTING)

        #if defined(FP_NEED_AFTER_MAX_AMBIENT)
            shadingAmt = max(shadingAmt, GetGlobalAmbientColor(worldSpaceNormal));
        #endif

            // ライトマップの反映
        #if defined(MULTI_UV_ENANLED)
            #if defined(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                resultColor.rgb = resultColor.rgb * diffuse2Amt.rgb * _BlendMulScale2;
            #endif

            #if defined(MULTI_UV2_ENANLED)
                #if defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    resultColor.rgb = resultColor.rgb * diffuse3Amt.rgb * _BlendMulScale3;
                #endif
            #endif
        #endif

        // 反射・屈折画像との合成
        #if defined(USE_SCREEN_UV) && (defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED) || defined(FP_FORCETRANSPARENT))
            //#if defined(FP_FORCETRANSPARENT)
            //    float3 _viewSpaceNormal = mul((float3x3)UNITY_MATRIX_V, reflect(-float3(worldSpaceEyeDirection.x * -1.0f, worldSpaceEyeDirection.y, worldSpaceEyeDirection.z), worldSpaceNormal););
            //  
            //    screenUv.xy += (_viewSpaceNormal * _AlphaTestDirection).xy;
            //#endif

            //float2 refrUv = lerp(screenUv.xy, screenUvBase, _AdditionalShadowOffset) / screenUv.w;
            //refrUv.y = 1 - refrUv.y;

            //float4 refrColor = tex2D(_RefractionTexture, refrUv);

            //#if defined(FP_FORCETRANSPARENT)
            //    resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a * _PointLightParams.w);
            //#else
                //resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
            //#endif

            //#if defined(WATER_SURFACE_ENABLED)
            //    float2 reflUv = screenUv.xy / screenUv.w;
            //    reflUv.y = 1 - reflUv.y;
                //float4 reflColor = tex2D(_ReflectionTex0, reflUv);
                //float4 reflColor = tex2D(_ReflectionTex0, dudvUV);
            //#endif

            float4 dudvTex = i.screenPos;

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
                    //float4 reflColor = tex2D(_ReflectionTex0, dudvUV).xyzw;
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
        #endif // defined(WATER_SURFACE_ENABLED) || defined(DUDV_MAPPING_ENABLED) || defined(FP_FORCETRANSPARENT)

        #if defined(ED8_GRABPASS)
            #if defined(DUDV_MAPPING_ENABLED)
                resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
            #endif

            #if defined(WATER_SURFACE_ENABLED)
                float waterFresnel;

                #if defined(FLAT_AMBIENT_ENABLED)
                    waterFresnel = pow(1.0 - max(0, dot(float3(0,1,0), worldSpaceEyeDirection)) * _ReflectionFresnel, 3);
                    //resultColor.rgb = lerp(resultColor.rgb, reflColor.rgb, _ReflectionIntensity * waterFresnel);
                    resultColor.rgb += reflColor.rgb * waterFresnel;
                #else
                    waterFresnel = pow(1.0 - max(0, dot(float3(0,1,0), worldSpaceEyeDirection)), 3) * _ReflectionIntensity;;
                    resultColor.rgb += reflColor.rgb * waterFresnel;
                #endif

                float waterGlowValue = reflColor.a + refrColor.a;
            #endif // defined(WATER_SURFACE_ENABLED)
        #else
            #if defined(WATER_SURFACE_ENABLED)
                float waterFresnel;

                #if defined(FLAT_AMBIENT_ENABLED)
                    waterFresnel = pow(1.0 - max(0, dot(float3(0,1,0), worldSpaceEyeDirection)) * _ReflectionFresnel, 3);
                    resultColor.rgb = lerp(resultColor.rgb, reflColor.rgb, _ReflectionIntensity * waterFresnel);
                #else
                    waterFresnel = pow(1.0 - max(0, dot(float3(0,1,0), worldSpaceEyeDirection)), 3) * _ReflectionIntensity;;
                    resultColor.rgb += reflColor.rgb * waterFresnel;
                #endif

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

        #if !defined(FLAT_AMBIENT_ENABLED)
            #if !defined(UNITY_COLORSPACE_GAMMA)
                shadingAmt += LinearToGammaSpace(_GameMaterialEmission.rgb);
            #else
                shadingAmt += _GameMaterialEmission.rgb;
            #endif
        #endif

        // 陰影カラーシフト
        #if defined(SHADOW_COLOR_SHIFT_ENABLED)
            // [Not Toon] 表面下散乱のような使い方
            float3 subLightColor2 = max(float3(1, 1, 1), subLightColor * 2.0f);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                shadingAmt.rgb += (float3(1, 1, 1) - min(float3(1, 1, 1), shadingAmt.rgb)) * LinearToGammaSpace(_ShadowColorShift) * subLightColor2;
            #else
                shadingAmt.rgb += (float3(1, 1, 1) - min(float3(1, 1, 1), shadingAmt.rgb)) * _ShadowColorShift * subLightColor2;
            #endif
        #endif // SHADOW_COLOR_SHIFT_ENABLED

        #if defined(EMVMAP_AS_IBL_ENABLED)
            // キューブマップ/スフィアマップ-適用 (IBL)
            #if defined(CUBE_MAPPING_ENABLED)
                shadingAmt.rgb += cubeMapColor.rgb * _CubeMapIntensity * cubeMapFresnel * ambientOcclusion * glossValue;
            #elif defined(SPHERE_MAPPING_ENABLED)
                shadingAmt.rgb += sphereMapColor.rgb * _SphereMapIntensity * ambientOcclusion * glossValue;
            #endif // CUBE_MAPPING_ENABLED
        #else
            // スフィアマップ（加算合成）
            #if defined(SPHERE_MAPPING_ENABLED)
                resultColor.rgb += sphereMapColor.rgb * _SphereMapIntensity * ambientOcclusion * glossValue;
            #elif defined(SPHERE_MAPPING_HAIRCUTICLE_ENABLED)
	            resultColor.rgb += sphereMapColor.rgb * _SphereMapIntensity * ambientOcclusion * glossValue * sphereMapIntensity;
            #endif
        #endif // EMVMAP_AS_IBL_ENABLED

        shadingAmt *= ambientOcclusion;

        // 自己発光度マップ（ライトやシャドウを打ち消す値という解釈）
        #if defined(EMISSION_MAPPING_ENABLED)
            float4 emiTex = tex2D(_EmissionMapSampler, i.uv.xy);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                emiTex.rgb = LinearToGammaSpace(emiTex.rgb);
            #endif

            shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1, 1, 1), float3(emiTex.r, emiTex.r, emiTex.r));
        #endif // EMISSION_MAPPING_ENABLED

        // ライティング結果を反映
        #if defined(BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED)
            resultColor.rgb = lerp(shadingAmt, resultColor.rgb, resultColor.a);
        #else
            //#if defined(FP_FORCETRANSPARENT)
            //    resultColor.rgb = lerp(resultColor.rgb * shadingAmt, resultColor.rgb, (1 - PointLightParams.w) * scene.MiscParameters5.z);
            //#else
            #if defined(UNITY_PASS_FORWARDBASE)
                resultColor.rgb *= shadingAmt;
            #elif defined(UNITY_PASS_FORWARDADD)
                resultColor.rgb *= sublightAmount;
            #endif
            //#endif
        #endif

        // シェーダ外部からのカラー操作
        #if defined(FLAT_AMBIENT_ENABLED)
            #if !defined(UNITY_COLORSPACE_GAMMA)
                resultColor.rgb *= LinearToGammaSpace(_GameMaterialDiffuse.rgb);
                resultColor.rgb += LinearToGammaSpace(_GameMaterialEmission.rgb);
            #else
                resultColor.rgb *= _GameMaterialDiffuse.rgb;
                resultColor.rgb += _GameMaterialEmission.rgb;
            #endif

            //resultColor.a *= _GameMaterialDiffuse.a;
        #endif

        #if defined(ALPHA_TESTING_ENABLED)
            resultColor.a *= 1 + max(0, CalcMipLevel(i.uv)) * 0.25;
            resultColor.a = (resultColor.a - _AlphaThreshold) / max(fwidth(resultColor.a), 0.0001) + _AlphaThreshold;
        #endif //ALPHA_TESTING_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
                resultColor.rgb += max((1 - resultColor.rgb), 0) * (1.0 - shadowValue);
            #endif

            // フォグ計算
            #if defined(FOG_ENABLED)
                float fogValue = EvaluateFogColor(resultColor.rgb, i.Color1.a, i.WorldPositionDepth.xyz);
            #endif

            // フォグ濃度とブルーム強度は反比例
            #if defined(BLOOM_ENABLED)
                #if defined(FOG_ENABLED)
                    float brightRatio = 1 - fogValue * 0.5;
                    brightRatio *= brightRatio;
                #else
                    float brightRatio = 1;
                #endif

                brightRatio *= _PointLightParams.z;
            #endif

            #if defined(SUBTRACT_BLENDING_ENABLED)
                resultColor.rgb = resultColor.rgb * resultColor.a;
            #elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
                resultColor.rgb = (1 - resultColor.rgb) * resultColor.a;
            #endif

            // モノクロ変換
            resultColor.rgb = lerp(resultColor.rgb, dot(resultColor.rgb, float3(0.299, 0.587, 0.114)) * _MonotoneMul.xyz + _MonotoneAdd.xyz, _GameMaterialMonotone);
        #endif

        // Bring back to Linear Space.
        #if !defined(UNITY_COLORSPACE_GAMMA)
            resultColor.rgb = GammaToLinearSpace(resultColor.rgb);
        #endif

        // 出力
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
                        glowValue *= glowValue2;
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
                        glowValue = max(0, glowValue);
                        glowValue = min(1, glowValue);
                        return float4(resultColor.rgb, glowValue);
                    #else
                        resultColor.rgb = max(resultColor.rgb + (resultColor.rgb * glowValue), float3(0, 0, 0));
                        resultColor.a = min(1, resultColor.a);

                        #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                            return float4(resultColor.rgb, 1);
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
                        glowValue = max(0, glowValue);
                        glowValue = min(1, glowValue);
                        return float4(resultColor.rgb, max(0, glowValue));
                    #else
                        resultColor.rgb = max(resultColor.rgb + (resultColor.rgb * _GlareIntensity), float3(0, 0, 0));
                        resultColor.a = min(1, resultColor.a);

                        #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                            return float4(resultColor.rgb, 1);
                        #else
                            return float4(resultColor.rgb, resultColor.a);
                        #endif
                    #endif
                #endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
            #else
                resultColor.rgb = max(resultColor.rgb, float3(0, 0, 0));
                resultColor.a = min(1, resultColor.a);

                #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                    return float4(resultColor.rgb, 1);
                #else
                    return float4(resultColor.rgb, resultColor.a);
                #endif
            #endif
        #endif // FP_DEFAULT || FP_DEFAULTRT
    #endif// NOTHING_ENABLED
}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2