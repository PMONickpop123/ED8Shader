float calcDiffuseLightAmtLdotN(float ldotn) {
	float diffuseValue;

	#if defined(HALF_LAMBERT_LIGHTING_ENABLED)
	    diffuseValue = pow(ldotn * 0.5f + 0.5f, 2.4);
	    //diffuseValue *= diffuseValue;
	#else // !HALF_LAMBERT_LIGHTING_ENABLED
	    diffuseValue = saturate(ldotn);
	#endif // HALF_LAMBERT_LIGHTING_ENABLED
	return diffuseValue;
}

float calcSpecularLightAmt(float3 normal, float3 lightDir, float3 eyeDirection, float shininess, float specularPower) {
	// Specular calcs
	float3 halfVec = normalize(eyeDirection + lightDir);
	float nDotH = saturate(dot(halfVec, normal));
    float specularLightAmount = pow(nDotH, specularPower);
    specularLightAmount = min(1, specularLightAmount);
    specularLightAmount = specularLightAmount * shininess;
	return specularLightAmount;
}

#if defined(FAKE_CONSTANT_SPECULAR_ENABLED) && defined(SPECULAR_ENABLED)
    float3 getFakeSpecularLightDir(float3 trueLightDir) {
        float3 v0 = mul(unity_CameraToWorld, float4(0, 0, 0, 1)).xyz;
        float3 v1 = mul(unity_CameraToWorld, float4(0, 0, 1, 1)).xyz;
	    float3 cameraEyeDir = normalize(v1 - v0);
        float3 lightDir = normalize(trueLightDir);
	    return normalize(lightDir + 2 * (cameraEyeDir * 1.5f + float3(0, 1, 0)));
    }   
#endif // FAKE_CONSTANT_SPECULAR_ENABLED

float3 EvaluateAmbient(float3 normal) {
	#if defined(HEMISPHERE_AMBIENT_ENABLED) && !defined(FLAT_AMBIENT_ENABLED)
        float3 upDirection = normalize(_UdonHemiSphereAmbientAxis);
        float amt = (dot(normal, upDirection) + 1.0f) * 0.5f;

		#if defined(MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED)
            float3 L = _UdonHemiSphereAmbientGndColor.rgb;
            float3 U = _UdonHemiSphereAmbientSkyColor.rgb;
            float3 M = _UdonGlobalAmbientColor.rgb;
	        return L + (2 * M - 2 * L) * amt + (U - 2 * M + L) * amt * amt;
		#else // MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	        return lerp(_UdonHemiSphereAmbientGndColor.rgb, _UdonHemiSphereAmbientSkyColor.rgb, amt);
		#endif // MULTIPLEX_HEMISPHERE_AMBIENT_ENABLED
	#else // HEMISPHERE_AMBIENT_ENABLED
        float3 ambientColor = _UdonGlobalAmbientColor.rgb;

	    return ambientColor;
	#endif // HEMISPHERE_AMBIENT_ENABLED
}

float calculateAttenuationQuadratic(float distanceToLightSqr, float4 attenuationProperties) {
	// attenuationProperties contains:
	// innerRange, outerRange, 1.0f/(outerRange/innerRange), (-innerRange / (outerRange/innerRange)
	float rd = (attenuationProperties.y * attenuationProperties.y) - (attenuationProperties.x * attenuationProperties.x);
	float b = 1.0f / rd;
	float a = attenuationProperties.x * attenuationProperties.x;
	float c = a * b + 1.0f;

	float coeff0 = (float)(-b);
	float coeff1 = (float)(c);
	float attenValuef = saturate(distanceToLightSqr * coeff0 + coeff1);
	float attenValue = (float)attenValuef;
	return attenValue;
}

//-----------------------------------------------------------------------------
#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
    float3 PortraitEvaluateAmbient() {
        float3 ambientColor = _UdonGlobalAmbientColor.rgb;
        return ambientColor;
    }
#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)

#if defined(USE_LIGHTING)
    float3 EvaluateLightingPerPixelFP(inout float3 sublightAmount, float3 worldSpacePosition, float3 normal, float glossValue, float shadowValue, float3 ambientAmount, float3 eyeDirection, float atten) {
        #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	        float3 lightingResult = float3(0.0f, 0.0f, 0.0f);
	    #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
            float3 lightingResult = ambientAmount;
	    #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

        float3 shadingAmount = float3(0.0f, 0.0f, 0.0f);
        float3 lightingAmount = float3(0.0f, 0.0f, 0.0f);
        float3 lightDir = float3(0.0f, 0.0f, 0.0f);
        float3 diffuseValue = float3(0.0f, 0.0f, 0.0f);
        float3 lightColor = float3(0.0f, 0.0f, 0.0f);
        float ldotn = 0;

        #if defined(UNITY_PASS_FORWARDBASE)
            #if defined(USE_DIRECTIONAL_LIGHT_COLOR)
                lightColor = _LightColor0.rgb;
            #else
                #if !defined(UNITY_COLORSPACE_GAMMA)
                    #if !defined(FLAT_AMBIENT_ENABLED)
                        lightColor = GammaToLinearSpace(_UdonMainLightColor.rgb + (_UdonMainLightColor.rgb * 0.5f));
                    #else
                        lightColor = GammaToLinearSpace(_UdonMainLightColor.rgb);
                    #endif
                #else
                    lightColor = _UdonMainLightColor.rgb;
                #endif
            #endif
        #else
            lightColor = _LightColor0.rgb;
        #endif

        #if !defined(UNITY_COLORSPACE_GAMMA)
            lightColor = LinearToGammaSpace(lightColor.rgb);
        #endif

        #if defined(SPECULAR_ENABLED)
            float3 specularValue = float3(0.0f, 0.0f, 0.0f);
            float3 specularLightDir = float3(0.0f, 0.0f, 0.0f);
            float shininess = _Shininess * glossValue;
        #endif // SPECULAR_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            UNITY_BRANCH
            if (_WorldSpaceLightPos0.w == 0) {
                lightDir = Unity_SafeNormalize(_WorldSpaceLightPos0.xyz);
                //lightDir = _WorldSpaceLightPos0.xyz;
                ldotn = (dot(normal, lightDir));
                //ldotn = max(0.0, dot(normal, lightDir));

                #if defined(CARTOON_SHADING_ENABLED)
                    diffuseValue = lightColor;
                #elif defined(NO_MAIN_LIGHT_SHADING_ENABLED)
                    diffuseValue = lightColor.rgb / max(max(lightColor.r, lightColor.g), max(lightColor.b, 0.001f));
                #else
                    diffuseValue = lightColor.rgb * calcDiffuseLightAmtLdotN(ldotn);
                #endif

                #if defined(SPECULAR_ENABLED)
                    #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                        specularLightDir = (_UdonAllowFakeSpecularDir == 1) ? getFakeSpecularLightDir(lightDir) : lightDir;
                    #else // FAKE_CONSTANT_SPECULAR_ENABLED
                        specularLightDir = lightDir;
                    #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                    specularValue = GammaToLinearSpace(lightColor.rgb) * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);

                    #if defined(SPECULAR_COLOR_ENABLED)
                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            specularValue *= LinearToGammaSpace(_SpecularColor.rgb);
                            //specularValue *= _SpecularColor.rgb;
                        #else
                            specularValue *= _SpecularColor.rgb;
                        #endif
                    #endif
                #endif // SPECULAR_ENABLED

                #if defined(CARTOON_SHADING_ENABLED)
                    diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                #else // CARTOON_SHADING_ENABLED
                    #if !defined(FLAT_AMBIENT_ENABLED)
                        diffuseValue *= shadowValue;
                    #endif
                #endif // CARTOON_SHADING_ENABLED

                #if defined(SPECULAR_ENABLED)
                    //#if !defined(UNITY_COLORSPACE_GAMMA)
                    //    specularValue = GammaToLinearSpace(specularValue);
                    //#endif

                    lightingAmount += specularValue;
                    
                    #if !defined(FLAT_AMBIENT_ENABLED)
                        lightingAmount *= shadowValue;
                    #endif
                #endif // SPECULAR_ENABLED

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    diffuseValue = GammaToLinearSpace(diffuseValue);
                #endif

                shadingAmount += diffuseValue;
                lightingResult += shadingAmount;

                #if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
                    lightingResult = min(lightingResult, (float3)_GlobalMainLightClampFactor);
                #endif // MAINLIGHT_CLAMP_FACTOR_ENABLED
            }
        #elif defined(UNITY_PASS_FORWARDADD)
            UNITY_BRANCH
            if (_WorldSpaceLightPos0.w > 0.0) {
                lightDir = normalize(_WorldSpaceLightPos0.xyz - worldSpacePosition);
                ldotn = max(0.0, dot(normal, lightDir));
                diffuseValue = lightColor.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                #if defined(SPECULAR_ENABLED)
                    #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                        specularLightDir = (_UdonAllowFakeSpecularDir == 1) ? getFakeSpecularLightDir(lightDir) : lightDir;
                    #else // FAKE_CONSTANT_SPECULAR_ENABLED
                        specularLightDir = lightDir;
                    #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                    specularValue = lightingAmount * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                #endif // SPECULAR_ENABLED

                #if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
                    diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                #endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    diffuseValue = GammaToLinearSpace(diffuseValue);
                #endif

                sublightAmount += diffuseValue;

                #if defined(SPECULAR_ENABLED)
                    sublightAmount += specularValue;
                #endif // SPECULAR_ENABLED

                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w > 1.0) {
                    diffuseValue = lightColor.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                    #if defined(SPECULAR_ENABLED)
                        #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                            specularLightDir = (_UdonAllowFakeSpecularDir == 1) ? getFakeSpecularLightDir(lightDir) : lightDir;
                        #else // FAKE_CONSTANT_SPECULAR_ENABLED
                            specularLightDir = lightDir;
                        #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                        specularValue = lightingAmount * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                    #endif // SPECULAR_ENABLED

                    #if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
                        diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                    #endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        diffuseValue = GammaToLinearSpace(diffuseValue);
                    #endif

                    sublightAmount += diffuseValue;

                    #if defined(SPECULAR_ENABLED)
                        sublightAmount += specularValue;
                    #endif // SPECULAR_ENABLED
                }
            }
        #endif

		#if defined(SPECULAR_ENABLED)
		    lightingResult += lightingAmount;
		#endif // SPECULAR_ENABLED

        #if defined(FLAT_AMBIENT_ENABLED)
            lightingResult = lerp(lightingResult, lightingResult * _UdonGlobalAmbientColor.rgb, 1 - shadowValue);
        #endif

	    return lightingResult;
    }

	#if defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
        float3 PortraitEvaluateLightingPerPixelFP(inout float3 sublightAmount, float3 worldSpacePosition, float3 normal, float glossValue, float shadowValue, float3 ambientAmount, float3 eyeDirection, float atten) {
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
            float3 lightColor = float3(0.0f, 0.0f, 0.0f);
            float ldotn = 0;

            #if defined(UNITY_PASS_FORWARDBASE)
                #if defined(USE_DIRECTIONAL_LIGHT_COLOR)
                    lightColor = _LightColor0.rgb;
                #else
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        #if !defined(FLAT_AMBIENT_ENABLED)
                            lightColor = GammaToLinearSpace(_UdonMainLightColor.rgb + (_UdonMainLightColor.rgb * 0.5f));
                        #else
                            lightColor = GammaToLinearSpace(_UdonMainLightColor.rgb);
                        #endif
                    #else
                        lightColor = _UdonMainLightColor.rgb;
                    #endif
                #endif
            #else
                lightColor = _LightColor0.rgb;
            #endif

            #if !defined(UNITY_COLORSPACE_GAMMA)
                lightColor = LinearToGammaSpace(lightColor.rgb);
            #endif

            #if defined(SPECULAR_ENABLED)
                float3 specularValue = float3(0.0f, 0.0f, 0.0f);
                float shininess = _Shininess * glossValue;
            #endif // SPECULAR_ENABLED

            #if defined(UNITY_PASS_FORWARDBASE)
                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w == 0.0) {
                    lightDir = normalize(_WorldSpaceLightPos0.xyz);
                    ldotn = max(0.0, dot(normal, lightDir));

                    #if defined(CARTOON_SHADING_ENABLED)
                        diffuseValue = lightColor.rgb;
                    #elif defined(NO_MAIN_LIGHT_SHADING_ENABLED)
                        diffuseValue = lightColor.rgb / max(max(lightColor.r, lightColor.g), max(lightColor.b, 0.001f));
                    #else
                        diffuseValue = lightColor.rgb * calcDiffuseLightAmtLdotN(ldotn);
                    #endif

                    #if defined(SPECULAR_ENABLED)
                        #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                            specularLightDir = (_UdonAllowFakeSpecularDir == 1) ? getFakeSpecularLightDir(lightDir) : lightDir;
                        #else // FAKE_CONSTANT_SPECULAR_ENABLED
                            specularLightDir = lightDir;
                        #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                        specularValue = GammaToLinearSpace(lightColor.rgb) * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);

                        #if defined(SPECULAR_COLOR_ENABLED)
                            #if !defined(UNITY_COLORSPACE_GAMMA)
                                specularValue *= LinearToGammaSpace(_SpecularColor.rgb);
                                //specularValue *= _SpecularColor.rgb;
                            #else
                                specularValue *= _SpecularColor.rgb;
                            #endif
                        #endif
                    #endif // SPECULAR_ENABLED

                    #if defined(CARTOON_SHADING_ENABLED)
                        diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                    #else // CARTOON_SHADING_ENABLED
                        #if !defined(FLAT_AMBIENT_ENABLED)
                            diffuseValue *= shadowValue;
                        #endif
                    #endif // CARTOON_SHADING_ENABLED

                    #if defined(SPECULAR_ENABLED)
                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            specularValue = GammaToLinearSpace(specularValue);
                        #endif

                        lightingAmount += specularValue;
                        
                        #if !defined(FLAT_AMBIENT_ENABLED)
                            lightingAmount *= shadowValue;
                        #endif
                    #endif // SPECULAR_ENABLED

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        diffuseValue = GammaToLinearSpace(diffuseValue);
                    #endif

                    shadingAmount += diffuseValue;
                    lightingResult += shadingAmount;

                    #if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
                        lightingResult = min(lightingResult, (float3)_GlobalMainLightClampFactor);
                    #endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

                    #if defined(SPECULAR_ENABLED)
                        lightingResult += lightingAmount;
                    #endif // SPECULAR_ENABLED
                }
            #elif defined(UNITY_PASS_FORWARDADD)
                UNITY_BRANCH
                if (_WorldSpaceLightPos0.w > 0.0) {
                    lightDir = normalize(_WorldSpaceLightPos0.xyz - worldSpacePosition);
                    ldotn = max(0.0, dot(normal, lightDir));
                    diffuseValue = lightColor.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                    #if defined(SPECULAR_ENABLED)
                        #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                            specularLightDir = (_UdonAllowFakeSpecularDir == 1) ? getFakeSpecularLightDir(lightDir) : lightDir;
                        #else // FAKE_CONSTANT_SPECULAR_ENABLED
                            specularLightDir = lightDir;
                        #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                        specularValue = GammaToLinearSpace(lightColor.rgb) * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                    #endif // SPECULAR_ENABLED

                    #if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
                        diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                    #endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        diffuseValue = GammaToLinearSpace(diffuseValue);
                    #endif

                    sublightAmount += diffuseValue;

                    #if defined(SPECULAR_ENABLED)
                        lightingAmount += specularValue;
                        sublightAmount += specularValue;
                    #endif // SPECULAR_ENABLED

                    UNITY_BRANCH
                    if (_WorldSpaceLightPos0.w > 1.0) {
                        diffuseValue = lightColor.rgb * atten * calcDiffuseLightAmtLdotN(ldotn);

                        #if defined(SPECULAR_ENABLED)
                            #if defined(FAKE_CONSTANT_SPECULAR_ENABLED)
                                specularLightDir = (_UdonAllowFakeSpecularDir == 1) ? getFakeSpecularLightDir(lightDir) : lightDir;
                            #else // FAKE_CONSTANT_SPECULAR_ENABLED
                                specularLightDir = lightDir;
                            #endif // FAKE_CONSTANT_SPECULAR_ENABLED

                            specularValue = lightingAmount * calcSpecularLightAmt(normal, specularLightDir, eyeDirection, shininess, _SpecularPower);
                        #endif // SPECULAR_ENABLED

                        #if defined(CARTOON_SHADING_ENABLED) && !defined(TOON_FIRST_LIGHT_ONLY_ENABLED)
                            diffuseValue *= calcToonShadingValueFP(ldotn, shadowValue);
                        #endif // CARTOON_SHADING_ENABLED && !TOON_FIRST_LIGHT_ONLY_ENABLED

                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            diffuseValue = GammaToLinearSpace(diffuseValue);
                        #endif

                        sublightAmount += diffuseValue;

                        #if defined(SPECULAR_ENABLED)
                            sublightAmount += specularValue;
                        #endif // SPECULAR_ENABLED
                    }
                }
            #endif

            #if defined(FLAT_AMBIENT_ENABLED)
                lightingResult = lerp(lightingResult, lightingResult * _UdonGlobalAmbientColor.rgb, 1 - shadowValue);
            #endif

	        return lightingResult;
        }
	#endif // defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
#else // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING
    float3 EvaluateLightingPerVertexFP(DefaultVPOutput In, float3 worldSpacePosition, float glossValue, float shadowValue, float3 ambientAmount, float3 shadingAmount, float3 lightingAmount, float3 subLight) {
	    float3 lightingResult = float3(0.0f, 0.0f, 0.0f);

        #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
            shadowValue = 1.0f;
        #endif

        lightingResult = max(_UdonGlobalAmbientColor.rgb, (float3)shadowValue);

        #if defined(MAINLIGHT_CLAMP_FACTOR_ENABLED)
            lightingResult = min(lightingResult, (float3)_GlobalMainLightClampFactor);
        #endif // MAINLIGHT_CLAMP_FACTOR_ENABLED

        return lightingResult;
    }
#endif // !USE_PER_VERTEX_LIGHTING && USE_LIGHTING