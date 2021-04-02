float calcDiffuseLightAmtLdotN(float ldotn) {
	float diffuseValue;

	#if defined(HALF_LAMBERT_LIGHTING_ENABLED)
	    diffuseValue = ldotn * 0.5f + 0.5f;
	    diffuseValue *= diffuseValue;
	#else // !HALF_LAMBERT_LIGHTING_ENABLED
	    diffuseValue = saturate(ldotn);
	#endif // HALF_LAMBERT_LIGHTING_ENABLED
	return diffuseValue;
}

float calcSpecularLightAmt(float3 normal, float3 lightDir, float3 eyeDirection, float shininess, float specularPower) {
	// Specular calcs
	float3 halfVec = normalize(eyeDirection + lightDir);
	float nDotH = saturate(dot(halfVec, normal));
	float specularLightAmount = saturate(pow(nDotH, specularPower)) * shininess;
	return specularLightAmount;
}

#if defined(FAKE_CONSTANT_SPECULAR_ENABLED) && defined(SPECULAR_ENABLED)
    float3 getFakeSpecularLightDir(float3 trueLightDir) {
        float3 v0 = mul(float4(0, 0, 0, 1), unity_CameraToWorld).xyz;
	    float3 v1 = mul(float4(0, 0, -1, 1), unity_CameraToWorld).xyz;
	    float3 cameraEyeDir = normalize(v1 - v0);
        float3 lightDir = normalize(trueLightDir);
	    return normalize(lightDir + 2 * (cameraEyeDir * 1.5f + normalize(_FakeSpecularDir)));
    }   
#endif // FAKE_CONSTANT_SPECULAR_ENABLED

float3 EvaluateAmbient(float3 normal) {
	#if defined(HEMISPHERE_AMBIENT_ENABLED)
        float3 upDirection = normalize(_HemiSphereAmbientAxis);
        float amt = 0.5f * (1.0f + dot(upDirection, normal));

		#if defined(MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED)
            float3 L = _HemiSphereAmbientGndColor.rgb;
            float3 U = _HemiSphereAmbientSkyColor.rgb;
            float3 M = _GlobalAmbientColor.rgb;
	        return L + (2 * M - 2 * L) * amt + (U - 2 * M + L) * amt * amt;
		#else // MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	        return lerp(_HemiSphereAmbientGndColor.rgb, _HemiSphereAmbientSkyColor.rgb, amt);
		#endif // MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	#else // HEMISPHERE_AMBIENT_ENABLED
	    return _GlobalAmbientColor.rgb;
	#endif // HEMISPHERE_AMBIENT_ENABLED
}

//-----------------------------------------------------------------------------
#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
    float3 PortraitEvaluateAmbient() {
        return _PortraitAmbientColor;
    }
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#if !defined(USE_PER_VERTEX_LIGHTING) && defined(USE_LIGHTING)
    float3 EvaluateLightingPerPixelFP(inout float3 sublightAmount, float3 worldSpacePosition, float3 normal, float glossValue, float shadowValue, float3 ambientAmount, float3 eyeDirection) {
        #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	        float3 lightingResult = float3(0.0f, 0.0f, 0.0f);
	    #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	        float3 lightingResult = ambientAmount;
	    #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

        float3 shadingAmount = float3(0.0f, 0.0f, 0.0f);
        float3 lightingAmount = float3(0.0f, 0.0f, 0.0f);
        float3 lightDir = float3(0.0f, 0.0f, 0.0f);
        float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
        float ldotn = 0;

        #if defined(SPECULAR_ENABLED)
            float3 specularValue = float3(0.0f, 0.0f, 0.0f);
            float3 specularLightDir = float3(0.0f, 0.0f, 0.0f);
            float shininess = _Shininess * glossValue;
        #endif // SPECULAR_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            UNITY_BRANCH
            if (_WorldSpaceLightPos0.w == 0) {
                #if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
                    lightDir = normalize(_LightDirForChar);
                #else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
                    lightDir = normalize(_WorldSpaceLightPos0.xyz);
                #endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED

                ldotn = dot(normal, lightDir);

                #if defined(CARTOON_SHADING_ENABLED)
                    diffuseValue = _LightColor0.rgb;
                #elif defined(NO_MAIN_LIGHT_SHADING_ENABLED)
                    diffuseValue = _LightColor0.rgb / max(max(_LightColor0.r, _LightColor0.g), max(_LightColor0.b, 0.001f));
                #else
                    diffuseValue = _LightColor0.rgb * calcDiffuseLightAmtLdotN(ldotn);
                #endif

                #if defined(SPECULAR_ENABLED)
                    #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                        specularLightDir = getFakeSpecularLightDir(lightDir);
                    #else // FAKE_CONSTANT_SPECULAR_ENABLED
                        specularLightDir = lightDir;
                    #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                    specularValue = _LightColor0.rgb * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);

                    #if defined(SPECULAR_COLOR_ENABLED)
                        specularValue *= _SpecularColor.rgb;
                    #endif
                #endif // SPECULAR_ENABLED

                #if defined(CARTOON_SHADING_ENABLED)
                    diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                #else // CARTOON_SHADING_ENABLED
                    diffuseValue *= shadowValue;
                #endif // CARTOON_SHADING_ENABLED

                #if defined(SPECULAR_ENABLED)
                    lightingAmount += specularValue;
                    lightingAmount *= shadowValue;
                #endif // SPECULAR_ENABLED

                shadingAmount += diffuseValue;
                lightingResult += shadingAmount;

                #if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
                    lightingResult = min(lightingResult, (float3)_GlobalMainLightClampFactor);
                #endif // MAINLIGHT_CLAMP_FACTOR_ENABLED
            }
        #elif defined(UNITY_PASS_FORWARDADD)
            lightDir = normalize(_WorldSpaceLightPos0.xyz - worldSpacePosition);
            ldotn = dot(lightDir, normal);
            float distance = length(lightDir);
            float atten = 1 / distance;

            UNITY_BRANCH
            if (_WorldSpaceLightPos0.w > 0.0) {
                diffuseValue = _LightColor0.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                #if defined(SPECULAR_ENABLED)
                    #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                        specularLightDir = getFakeSpecularLightDir(lightDir);
                    #else // FAKE_CONSTANT_SPECULAR_ENABLED
                        specularLightDir = lightDir;
                    #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                    specularValue = lightingAmount * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                #endif // SPECULAR_ENABLED

                #if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
				    diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
				#endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

				sublightAmount += diffuseValue;

				#if defined(SPECULAR_ENABLED)
				    sublightAmount += specularValue;
				#endif // SPECULAR_ENABLED
            }

            UNITY_BRANCH
            if (_WorldSpaceLightPos0.w > 1.0) {
                diffuseValue = _LightColor0.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                #if defined(SPECULAR_ENABLED)
                    #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                        specularLightDir = getFakeSpecularLightDir(lightDir);
                    #else // FAKE_CONSTANT_SPECULAR_ENABLED
                        specularLightDir = lightDir;
                    #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                    specularValue = lightingAmount * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                #endif // SPECULAR_ENABLED

                #if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
				    diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
				#endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

				sublightAmount += diffuseValue;

				#if defined(SPECULAR_ENABLED)
				    sublightAmount += specularValue;
				#endif // SPECULAR_ENABLED
            }
        #endif

		#if defined(SPECULAR_ENABLED)
		    lightingResult += lightingAmount;
		#endif // SPECULAR_ENABLED

	    return lightingResult;
    }

	#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
        float3 PortraitEvaluateLightingPerPixelFP(inout float3 sublightAmount, float3 worldSpacePosition, float3 normal, float glossValue, float shadowValue, float3 ambientAmount, float3 eyeDirection) {
	        #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	            float3 lightingResult = float3(0.0f, 0.0f, 0.0f);
	        #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	            float3 lightingResult = ambientAmount;
	        #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

            float3 shadingAmount = float3(0.0f, 0.0f, 0.0f);
            float3 lightingAmount = float3(0.0f, 0.0f, 0.0f);
            float3 lightDir = float3(0.0f, 0.0f, 0.0f);
            float3 specularLightDir = float3(0.0f, 0.0f, 0.0f);
            float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
            float ldotn = 0;

            #if defined(SPECULAR_ENABLED)
                float3 specularValue = float3(0.0f, 0.0f, 0.0f);
                float shininess = _Shininess * glossValue;
            #endif // SPECULAR_ENABLED

            #if defined(UNITY_PASS_FORWARDBASE)
                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w == 0.0) {
                    lightDir = normalize(_LightDirForChar);
                    ldotn = dot(lightDir, normal);

                    #if defined(CARTOON_SHADING_ENABLED)
                        diffuseValue = _LightColor0.rgb;
                    #elif defined(NO_MAIN_LIGHT_SHADING_ENABLED)
                        diffuseValue = _LightColor0.rgb / max(max(_LightColor0.r, _LightColor0.g), max(_LightColor0.b, 0.001f));
                    #else
                        diffuseValue = _LightColor0.rgb * calcDiffuseLightAmtLdotN(ldotn);
                    #endif

                    #if defined(SPECULAR_ENABLED)
                        #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                            specularLightDir = getFakeSpecularLightDir(lightDir);
                        #else // FAKE_CONSTANT_SPECULAR_ENABLED
                            specularLightDir = lightDir;
                        #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                        specularValue = _LightColor0.rgb * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);

                        #if defined(SPECULAR_COLOR_ENABLED)
                            specularValue *= _SpecularColor.rgb;
                        #endif
                    #endif // SPECULAR_ENABLED

                    #if defined(CARTOON_SHADING_ENABLED)
                        diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                    #else // CARTOON_SHADING_ENABLED
                        diffuseValue *= shadowValue;
                    #endif // CARTOON_SHADING_ENABLED

                    #if defined(SPECULAR_ENABLED)
                        lightingAmount += specularValue;
                        lightingAmount *= shadowValue;
                    #endif // SPECULAR_ENABLED

                    shadingAmount += diffuseValue;
                    lightingResult += shadingAmount;

                    #if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
                        lightingResult = min(lightingResult, (float3)_GlobalMainLightClampFactor);
                    #endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

                    #if defined(SPECULAR_ENABLED)
                        lightingResult += lightingAmount;
                    #endif // SPECULAR_ENABLED
                }
            #endif

	        return lightingResult;
        }
	#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
    #if defined(USE_LIGHTING)
        void EvaluateLightingPerVertexVP(out float3 shadingAmount, out float3 lightingAmount, out float3 subLightingAmount, out float3 light0dir, float3 worldSpacePosition, float3 normal
            #if defined(SPECULAR_ENABLED)
                , float3 eyeDirection
            #endif // SPECULAR_ENABLED
            )
        {
            shadingAmount = float3(0.0f, 0.0f, 0.0f);
            lightingAmount = float3(0.0f, 0.0f, 0.0f);
            subLightingAmount = float3(0.0f, 0.0f, 0.0f);
            float3 lightDir = float3(0.0f, 0.0f, 0.0f);
            float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
            float ldotn = 0.0f;

            #if defined(SPECULAR_ENABLED)
                float3 specularValue = float3(0.0f, 0.0f, 0.0f);
                float3 specularLightDir = float3(0.0f, 0.0f, 0.0f);
                float shininess = _Shininess;
            #endif // SPECULAR_ENABLED

            #if defined(UNITY_PASS_FORWARDBASE)
                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w == 0.0) {
                    #if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
                        lightDir = normalize(_LightDirForChar);
                    #else // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED
                        lightDir = normalize(_WorldSpaceLightPos0.xyz);
                    #endif // LIGHT_DIRECTION_FOR_CHARACTER_ENABLED

                    ldotn = dot(lightDir, normal);

                    #if defined(CARTOON_SHADING_ENABLED)
                        diffuseValue = _LightColor0.rgb;
                    #elif defined(NO_MAIN_LIGHT_SHADING_ENABLED)
                        diffuseValue = _LightColor0.rgb / max(max(_LightColor0.r, _LightColor0.g), max(_LightColor0.b, 0.001f));
                    #else
                        diffuseValue = _LightColor0.rgb * calcDiffuseLightAmtLdotN(ldotn);
                    #endif

                    #if defined(SPECULAR_ENABLED)
                        #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                            specularLightDir = getFakeSpecularLightDir(lightDir);
                        #else // FAKE_CONSTANT_SPECULAR_ENABLED
                            specularLightDir = lightDir;
                        #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                        specularValue = _LightColor0.rgb * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);

                        #if defined(SPECULAR_COLOR_ENABLED)
                            specularValue *= _SpecularColor.rgb;
                        #endif
                    #endif // SPECULAR_ENABLED

                    shadingAmount += diffuseValue;

                    #if defined(SPECULAR_ENABLED)
                        lightingAmount += specularValue;
                    #endif // SPECULAR_ENABLED

                    light0dir = lightDir;
                }

                #if defined(PRECALC_EVALUATE_AMBIENT)
                    subLightingAmount = EvaluateAmbient(normal);
                #endif
            #elif defined(UNITY_PASS_FORWARDADD)
                lightDir = normalize(_WorldSpaceLightPos0.xyz - worldSpacePosition);
                ldotn = dot(lightDir, normal);
                float distance = length(lightDir);
                float atten = 1 / distance;

                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w > 0.0) {
                    diffuseValue = _LightColor0.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                    #if defined(SPECULAR_ENABLED)
                        #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                            specularLightDir = getFakeSpecularLightDir(lightDir);
                        #else // FAKE_CONSTANT_SPECULAR_ENABLED
                            specularLightDir = lightDir;
                        #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                        specularValue = lightingAmount * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                    #endif // SPECULAR_ENABLED

                    subLightingAmount += diffuseValue;

                    #if defined(SPECULAR_ENABLED)
                        subLightingAmount += specularValue;
                    #endif // SPECULAR_ENABLED
                }

                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w > 1.0) {
                    diffuseValue = _LightColor0.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                    #if defined(SPECULAR_ENABLED)
                        #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                            specularLightDir = getFakeSpecularLightDir(lightDir);
                        #else // FAKE_CONSTANT_SPECULAR_ENABLED
                            specularLightDir = lightDir;
                        #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                        specularValue = lightingAmount * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                    #endif // SPECULAR_ENABLED

                    subLightingAmount += diffuseValue;

                    #if defined(SPECULAR_ENABLED)
                        subLightingAmount += specularValue;
                    #endif // SPECULAR_ENABLED
                }
            #endif
        }
    #endif // USE_LIGHTING

    float3 EvaluateLightingPerVertexFP(DefaultVPOutput In, float3 worldSpacePosition, float glossValue, float shadowValue, float3 ambientAmount, float3 shadingAmount, float3 lightingAmount, float3 subLight) {
	    float3 lightingResult = float3(0.0f, 0.0f, 0.0f);

        #if defined(USE_LIGHTING)
            lightingResult = ambientAmount;

            #if defined(UNITY_PASS_FORWARDBASE)
                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w == 0.0) {
                    #if defined(SPECULAR_ENABLED)
                        lightingAmount *= shadowValue * glossValue;
                    #endif // SPECULAR_ENABLED

                    // トゥーン
                    #if defined(CARTOON_SHADING_ENABLED)
                        shadingAmount *= calcToonShadingValueFP(In.CartoonMap.z, shadowValue);
                    #else // CARTOON_SHADING_ENABLED
                        shadingAmount *= shadowValue;
                    #endif // CARTOON_SHADING_ENABLED

                    lightingResult += shadingAmount;

                    #if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
                        lightingResult = min(lightingResult, (float3)_GlobalMainLightClampFactor);
                    #endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

                    #if defined(SPECULAR_ENABLED)
                        lightingResult += lightingAmount;
                    #endif // SPECULAR_ENABLED

                    lightingResult += subLight;
                }
            #endif
        #else // USE_LIGHTING
            #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
                shadowValue = 1.0f;
            #endif

            lightingResult = max(_GlobalAmbientColor.rgb, (float3)shadowValue);

            #if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
                lightingResult = min(lightingResult, (float3)_GlobalMainLightClampFactor);
            #endif // MAINLIGHT_CLAMP_FACTOR_ENABLED
        #endif // USE_LIGHTING

        return lightingResult;
    }
#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING