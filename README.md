# ED8Shader
This is the "The Legend of Heroes: Trails of Cold Steel / Sen no Kiseki" shader used in the actual game, but compatible with Unity/VRChat. However, currently it needs to be heavily fixed up and optimized for public use.

Some notes:
Cold Steel 2:
added shader property: "SpecularColor"
added shader keyword: "SPECULAR_COLOR_ENABLED".

Cold Steel 3: 
added shader properties: "BlendMulScale2", "BloomIntensity", "GlareMap2Sampler", "OutlineColor", "OutlineColorFactor", and "RimLightClampFactor". 
added shader keywords: "BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED", "FAR_CLIP_BY_DITHER_ENABLED", "FOR_SHADOW", "GLARE_ENABLED", "MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED", "MULTI_UV_GLARE_MAP_ENABLED", "MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED", "SPHERE_MAPPING_HAIRCUTICLE_ENABLED", "TRANSPARENT_DELAY_ENABLED", "USE_OUTLINE", and "USE_OUTLINE_COLOR" were added. 
BloomIntensity is somehow used by post processing, don't know if its possible to replicate.
added map properties: DOF[enabled, range, ratio] Wind[dir, power], Bloom[threshold, gamma], Godray[position, color, intensity, skyboxFactor], Shadow[density]
Godray is used in the games post processing (postfx.fx), however, no idea if its possible to pull off.
changed map properties: DefaultLight and ChrLight now have rotation and does not define the lights direction via the float3 position anymore. Fog is now [near, far, color, rate, heightNear, heightFar, heightDepthBias, heightCamRate, imageSpeedX, imageSpeedZ, imageScale, imageRatio]

Cold Steel 4:
added map properties: SSAO[intensity, radius, dist], PlayerOwnLight[radius, color]

General:
The map setting files are located in the games "/data/ops/" folder. These files include information of the maps lighting, effects, loading zones and map objects.
The table files are located in the games "/data/text/dat_us/" folder. "t_name.tbl" has information on the character names which go to what model, as well as their animation file, and facial expressions. "t_place.tbl" has information on map names and what map model it belongs to.
The animation data files are located in the games "/data/scripts/ani/dat_us/". These dat files hold what animations belong to them, as well as have info on the equipment files (EQU) and what bone they get rooted to.

From Cold Steel 2+, the developers decided to actually remove the actual code when compiling the shaders, so we have to guess with the new implementations they added to the shader.
