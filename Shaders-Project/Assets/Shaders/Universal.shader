// UNIVERSAL SHADER by Semyonchik27cm
Shader "Flexus/Universal v6.0.2"
{
    Properties
    {
        [Space(10)][KeywordEnum(Lambert, Unlit, Soft Lambert, Baked Only)] LIGHT_MODE ("Модель освітлення", Int) = 0
        //[Space(10)][Toggle(POINT_LIGHTS_ON)] _PointLightsOn("4 точкові джерела світла", Int) = 0
        [Space(10)][HDR][MainColor] _Color ("Колір", Color) = (0,0,0,1)
        [Space(10)][KeywordEnum(Disabled, Fresnel, World X, World Y, World Z, Object X, Object Y, Object Z)] USE_GRADIENT ("Градієнт кольору", Int) = 0
        [Space(10)][HDR][MainColor] _Color2 ("Другий колір градієнту", Color) = (1,1,1,1)
        [Space(10)] _GradientSettings ("Налаштування градієнту [X] Старт [Y] Кінець", Vector) = (1,0,0,0)
        [Space(10)][Toggle(USE_TEXTURE)] _UseTexture("Використовувати текстуру", Int) = 0
        [Space(10)][KeywordEnum(Model UV, Object space, Wall, Floor)] UV_MODE ("Розгортка текстури", Int) = 0
        [MainTexture] _MainTex ("Альбедо", 2D) = "white" {}
        [Toggle(ALBEDO_ALPHA_IS_AO)] _AlbedoAlphaIsOcclusion("Альфа це AO", Int) = 0
        [Space(10)][Toggle(USE_NORMAL_MAP)] _UseNormalMap("Використовувати нормалмапу", Int) = 0
        [NoScaleOffset] _NormalMap ("Нормалмапа", 2D) = "bump" {}
        [Toggle(NORMAL_FLIP_Y)] _NormalFlipY("Зелений знизу на випуклості", Int) = 0
		[Toggle(NOR_BLUE_IS_NONMETALLIC)] _NorBlueIsNonmetallic("Синій це неметалевість", Int) = 0
        [Toggle(NOR_ALPHA_IS_ROUGHNESS)] _NorAlphaIsRoughness("Альфа це шорсткість", Int) = 0
        [Space(10)][Toggle(USE_GLOW)] _UseGlow("Підсвічування", Int) = 1
        [HDR] _GlowColor ("Колір підсвічування", Color) = (.4,.4,.4)
        [PowerSlider(2.0)] _GlowPower ("Тонкість підсвічування", Range(0, 5)) = 2
		[Space(10)][Toggle(USE_SPECULAR)] _UseSpecular("Відблиск", Int) = 1
		_SpecularMultiplier ("Яскравість відблиску", Range(0, 3)) = 1
		_Roughness ("Шорсткість", Range(0.001, 1)) = 0.1
        [Space(10)][KeywordEnum(Disabled, Global, Local)] USE_CUBEMAP ("Використовувати кубмап", Int) = 0
		[NoScaleOffset] _Cubemap ("Кубмап", CUBE) = "black" {}
		[HDR] _CubemapColor ("Колір відбиття", Color) = (1,1,1)
		[PowerSlider(2.0)] _CubemapPower ("Неметалевість", Range(0, 5)) = 1
        [Space(10)][Toggle(USE_EMISSION_TEX)] _UseEmissionTex("Використовувати текстуру емісії", Int) = 0
        [NoScaleOffset] _EmissionTex ("Текстура емісії", 2D) = "black" {}
        _EmissionMultiplier ("Яскравість емісії на лайтмапі", Range(0, 10)) = 1
		[Space(10)][Toggle(USE_CC)] _UseCC("Корекція кольору", Int) = 0
		_Saturation ("Насиченість", Range(0, 1)) = 0.5
		_Brightness ("Яскравість", Range(0, 3)) = 0.375
        [Space(10)][Toggle(UNIVERSAL_HD)] _UniversalHD("HD відблиск та відбиття", Int) = 0
        [Space(10)]_OutlineScale ("Обведення", Float) = 1
        _OutlineColor ("Колір обведення", Color) = (0,0,0)
		[Header(OOO   OOO      OOOO               OOO   OOO      OO      OO         OO      OOO         OO   OO         )]
		[Header(.  OO      OO         OO                     OO      OO      OOO   OO         OO         OO      OO         OO      )]
		[Header(.  OO                     OO                     OO                     OOO               OO         OO      OOOO               )]
		[Header(.  OO   OO            OO                     OO   OO               OOO            OO         OO         OOOOO         )]
		[Header(.  OO                     OO                     OO                           OOO         OO         OO                  OOO      )]
		[Header(.  OO                     OO      OO         OO      OO      OO      OOO      OO         OO      OO         OO      )]
		[Header(OOOO               OOO   OOO      OOO   OOO      OO         OO         OO   OO            OO   OO         )]
		[Space(20)]_DickSize ("Тортури члена та яєчок", Range(0, 27)) = 27
        [Space(10)][Toggle(TEST_TEXTURES)] _TestTextures("Тестові текстури", Int) = 0
        [NoScaleOffset] _RoughnessTex ("[Для тесту] Шорсткість", 2D) = "white" {}
        [NoScaleOffset] _MetallicTex ("[Для тесту] Металевість", 2D) = "black" {}
        [NoScaleOffset] _OcclusionTex ("[Для тесту] AO", 2D) = "white" {}
        [Space(10)][KeywordEnum(Final Render, Normal, Vertex normals, Normal map, UV, NdotV, NdotL, NdotH, View vector, Reflection vector, Half vector, Fresnel, Specular, Cubemap, Lambert, Shadow, Light, Lightmap, Diffuse, Albedo, Roughness, Metallic, Occlusion, Curvature, Depth, World Position, Model Position)] DEBUG_MODE ("Оверлеі для дебагу", Int) = 0
        //[Header(For Opaque. Off One Zero Queue.Geometry)]
        //[Header(For Transparent. On SrcAlpha OneMinusSrcAlpha Queue.Transparent)]
        [Space(10)][Toggle(USE_ALPHA)] _UseAlpha("Прозорість", Int) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Int) = 1 //"One”
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DestBlend", Int) = 0 //"Zero"

    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" }
		Blend [_SrcBlend] [_DstBlend]

        CGINCLUDE
        #include "UniversalSupport/FlexusCore.hlsl"
        //#include "UniversalSupport/UniversalModExample.hlsl" // UNCOMMENT
        ENDCG

        Pass
        {
			Name "Universal ForwardBase"
            Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            //#pragma shader_feature SHADOWS_SCREEN DIRECTIONAL
            //#pragma multi_compile VERTEXLIGHT_ON
            #pragma multi_compile __ LIGHTMAP_ON
            #pragma multi_compile_instancing
            #pragma shader_feature UNIVERSAL_HD
            #pragma shader_feature USE_GRADIENT_DISABLED USE_GRADIENT_FRESNEL USE_GRADIENT_WORLD_X USE_GRADIENT_WORLD_Y USE_GRADIENT_WORLD_Z USE_GRADIENT_OBJECT_X USE_GRADIENT_OBJECT_Y USE_GRADIENT_OBJECT_Z
            #pragma shader_feature LIGHT_MODE_LAMBERT LIGHT_MODE_UNLIT LIGHT_MODE_SOFT_LAMBERT LIGHT_MODE_BAKED_ONLY
            #pragma shader_feature UV_MODE_MODEL_UV UV_MODE_OBJECT_SPACE UV_MODE_WALL UV_MODE_FLOOR
            #pragma shader_feature USE_TEXTURE
            #pragma shader_feature ALBEDO_ALPHA_IS_AO
            #pragma shader_feature USE_NORMAL_MAP
            #pragma shader_feature NOR_BLUE_IS_NONMETALLIC
            #pragma shader_feature NOR_ALPHA_IS_ROUGHNESS
            #pragma shader_feature NORMAL_FLIP_Y
            #pragma shader_feature USE_GLOW
            #pragma shader_feature USE_EMISSION_TEX
			#pragma shader_feature USE_SPECULAR
			#pragma shader_feature USE_CUBEMAP_DISABLED USE_CUBEMAP_GLOBAL USE_CUBEMAP_LOCAL
            #pragma shader_feature USE_CC
            #pragma shader_feature USE_ALPHA
            //#pragma shader_feature POINT_LIGHTS_ON
			#pragma shader_feature __ FOG_LINEAR FOG_EXP FOG_EXP2
            #pragma shader_feature DEBUG_MODE_FINAL_RENDER DEBUG_MODE_NORMAL DEBUG_MODE_VERTEX_NORMALS DEBUG_MODE_NORMAL_MAP DEBUG_MODE_UV DEBUG_MODE_NDOTV DEBUG_MODE_NDOTL DEBUG_MODE_NDOTH DEBUG_MODE_VIEW_VECTOR DEBUG_MODE_REFLECTION_VECTOR DEBUG_MODE_HALF_VECTOR DEBUG_MODE_FRESNEL DEBUG_MODE_SPECULAR DEBUG_MODE_CUBEMAP DEBUG_MODE_LAMBERT DEBUG_MODE_SHADOW DEBUG_MODE_LIGHT DEBUG_MODE_POINT_LIGHTS DEBUG_MODE_LIGHTMAP DEBUG_MODE_DIFFUSE DEBUG_MODE_ALBEDO DEBUG_MODE_ROUGHNESS DEBUG_MODE_METALLIC DEBUG_MODE_OCCLUSION DEBUG_MODE_CURVATURE DEBUG_MODE_DEPTH DEBUG_MODE_WORLD_POSITION DEBUG_MODE_MODEL_POSITION
            #pragma shader_feature TEST_TEXTURES

            #include "UniversalSupport/Universal.hlsl"

            UNIVERSAL_DEFINE_INSTANCING_BUFFER
            float4 _MainTex_ST;
            half4 _Color;

			universal_v2f vert (universal_vertex_input v)
            {
				universal_v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNIVERSAL_MOD_OS_POS_INJECTION
				CALCULATE_WORLD_POSITION(ws_pos)
                UNIVERSAL_MOD_WS_POS_INJECTION
                //o.depth = distance(CAMERA_POS, ws_pos);
                UNIVERSAL_MOD_VERTEX_OS_NORMAL_INJECTION
				TRANSFER_WORLD_NORMAL(o.N)
                UNIVERSAL_TRANSFER_TANGENT(o)
                UNIVERSAL_MOD_VERTEX_WS_NORMAL_INJECTION
                TRANSFER_CLIP_POS

                #if defined(UNIVERSAL_HD) || defined(WS_POS_NEEDED)
                o.ws_pos = ws_pos;
                #else
                TRANSFER_VIEW_VECTOR(ws_pos)
                #endif

                TRANSFER_SHADOW(o)

				#ifdef UV_NEEDED
                    float2 uv;
                    APPLY_UV_MODE(o.N)
				    o.uv = TRANSFORM_TEX(uv, GET(_MainTex));
				#endif

                #if LIGHTMAP_ON
                o.uv_gi = v.uv_gi * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif

				UNITY_TRANSFER_FOG(o, o.pos);

                UNITY_TRANSFER_INSTANCE_ID(v, o);

				return o;
            }

			half4 frag (universal_v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);

                universal_data data = (universal_data)0;

                data.tint = GET(_Color);
                data.occlusion = 1;

                #ifdef UNIVERSAL_HD
                i.N = normalize(i.N);
                #endif

                #if defined(UNIVERSAL_HD) || defined(WS_POS_NEEDED)
                data.V = normalize(UnityWorldSpaceViewDir(i.ws_pos));
                #else
                data.V = i.V;
                #endif

                data.N = i.N;
                // #ifdef UNIVERSAL_HD
                // data.N = normalize(i.N);
                // #else
                // data.N = i.N;
                // #endif
                // Optimize this: calculate ws_pos and depth from matrix, remove i.depth
                //data.V = GetFragmentV(i.pos);


                //float3 ws_pos = RestoreWorldPosition(data.V, i.depth);

                data.L = DIR_LIGHT;
                #if defined(USE_NORMAL_MAP) || defined(NOR_BLUE_IS_NONMETALLIC) || defined(NOR_ALPHA_IS_ROUGHNESS)
                    data.normal_texture = tex2D(_NormalMap, i.uv);
                #endif
                #ifdef NOR_BLUE_IS_NONMETALLIC
                    data.normal_map.xy = data.normal_texture.xy * 2 - 1;
                    data.normal_map.z = sqrt(1 - dot(data.normal_map.xy, data.normal_map.xy));
                    data.nonmetallic = data.normal_texture.b * 2;
                #else
                    data.normal_map = data.normal_texture.xyz * 2 - 1;
                    #if USE_CUBEMAP_LOCAL || USE_CUBEMAP_GLOBAL
                        data.nonmetallic = GET(_CubemapPower);
                    #else
                        data.nonmetallic = 1;
                    #endif
                #endif
                #ifdef NORMAL_FLIP_Y
                    data.normal_map.y = -data.normal_map.y;
                #endif
                #ifdef NOR_ALPHA_IS_ROUGHNESS
                    data.roughness = data.normal_texture.a;
                #else
                    data.roughness = GET(_Roughness);
                #endif

                //data.normal_map = normalize(data.normal_map);
                #if USE_NORMAL_MAP
                    #if UV_MODE_MODEL_UV
                        data.N = UniversalApplyNormalMap(i, data.normal_map);
                    #endif
                    #if UV_MODE_OBJECT_SPACE || UV_MODE_WALL || UV_MODE_FLOOR
                        data.N = ApplyWorldSpaceNormalMap(i.N, data.normal_map);
                    #endif
                #endif

                UNIVERSAL_CALCULATE_NORMAL_DATA(data) // NdotV NdotL NdotH fresnel R H

                UNIVERSAL_APPLY_GRADIENT_TINT

                half4 color;
                UNIVERSAL_SET_ALBEDO
                UNIVERSAL_MOD_ALBEDO_INJECTION
                #if ALBEDO_ALPHA_IS_AO
                data.occlusion = data.normal_texture.b;
                #endif

                #ifdef TEST_TEXTURES
                data.roughness *= tex2D(_RoughnessTex, i.uv).x;
                data.nonmetallic *= (1 - tex2D(_MetallicTex, i.uv).x) * 2;
                data.occlusion *= tex2D(_OcclusionTex, i.uv).x;
                #endif

                // Light
                #if LIGHTMAP_ON
                    data.lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv_gi));
                #endif
                #ifdef LIGHT_MODE_UNLIT
                    data.shadow = 1;
                    data.lambert = 1;
                    data.lambert_raw = 1;
                    data.light = 1;
                #endif
                #ifdef LIGHT_MODE_LAMBERT
                    UNIVERSAL_CALCULATE_SHADOW
                    UNIVERSAL_CALCULATE_LAMBERT
                    UNIVERSAL_CALCULATE_LIGHT
                    #if LIGHTMAP_ON
                        data.light += data.lightmap;
                    #endif
                #endif
                #ifdef LIGHT_MODE_SOFT_LAMBERT
                    UNIVERSAL_CALCULATE_SHADOW
                    UNIVERSAL_CALCULATE_LAMBERT
                    UNIVERSAL_CALCULATE_LIGHT
                    #if LIGHTMAP_ON
                        data.light += data.lightmap;
                    #endif
                #endif
                #if LIGHT_MODE_BAKED_ONLY
                    data.shadow = 1;
                    #if LIGHTMAP_ON
                        data.lambert_raw = data.occlusion;
                        data.lambert = data.lambert_raw;
                        data.light = data.lightmap;
                    #else
                        data.lambert_raw = data.occlusion;
                        data.lambert = data.lambert_raw;
                        data.light = data.lambert;
                    #endif
                #endif

                //UNIVERSAL_ADD_POINT_LIGHTS
                UNIVERSAL_MOD_LIGHT_INJECTION

				color.rgb = data.albedo * data.light;
				UNIVERSAL_ADD_CUBEMAP
                UNIVERSAL_ADD_GLOW // Підсвічування
                #if USE_EMISSION_TEX
                    data.emission = tex2D(_EmissionTex, i.uv).rgb;
                    color.rgb += data.emission;
                #endif
                UNIVERSAL_ADD_SPECULAR
				UNIVERSAL_APPLY_CC
				UNITY_APPLY_FOG(i.fogCoord, color);
                UNIVERSAL_MOD_FINAL_INJECTION
				OLD_DEVICES_FIX
                UNIVERSAL_DEBUG_OVERLAY
                REQUIRED_UNIVERSAL_HLSL_VERSION_602

                #ifdef TEST_TEXTURES
                if (TIME.y / 4 % 1 > 0.98) color = half4(1, 1, 0, 1);
                #endif
                #if defined(UNITY_NO_SCREENSPACE_SHADOWS)
                //color.rgb = 1;
                #endif
                //color.rgb = mul(unity_CameraToWorld, float4(i.pos.xy/_ScreenParams.xy*2-1, i.pos.z, 0));
                //color.rgb = -normalize(color.rgb) * 0.5+0.5;

				return UNIVERSAL_RETURN;
            }
            ENDCG
        }
        //UsePass "VertexLit/SHADOWCASTER" // Default Shadowcaster
        Pass
		{
			Name "Universal ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            #ifndef UNIVERSAL_MOD_OS_POS_INJECTION
            #define UNIVERSAL_MOD_OS_POS_INJECTION
            #endif
            #ifndef UNIVERSAL_MOD_WS_POS_SHADOWCASTER_INJECTION
            #define UNIVERSAL_MOD_WS_POS_SHADOWCASTER_INJECTION
            #endif
            #ifndef MOD_INSTANCED_PROPS
            #define MOD_INSTANCED_PROPS
            #endif

            UNITY_INSTANCING_BUFFER_START(PROPS)
            MOD_INSTANCED_PROPS
            UNITY_INSTANCING_BUFFER_END(PROPS)

			struct v2f {
				V2F_SHADOW_CASTER;
			};

			v2f vert( appdata_base v ) {
                UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
                UNIVERSAL_MOD_OS_POS_INJECTION
                UNIVERSAL_MOD_WS_POS_SHADOWCASTER_INJECTION

				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag( v2f i ) : SV_Target {
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
        Pass
        {
            Name "Universal Meta"
            Tags {"LightMode"="Meta"}
            Cull Off
            CGPROGRAM

            #include "UniversalSupport/UniversalMeta.hlsl"

            ENDCG
        }
        // Uncomment if you need outline
        /*Pass
        {
			Name "Universal Outline"
            Cull Front
			ZWrite Off
			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature __ FOG_LINEAR FOG_EXP FOG_EXP2
			#include "UnityCG.cginc"

			struct appdata
            {
                float4 vertex : POSITION;
				half3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
				UNITY_FOG_COORDS(0)
            };

			half _OutlineScale;

			v2f vert (appdata v)
            {
                v2f o;
				v.vertex.xyz += v.normal * _OutlineScale;
				v.normal = -v.normal;
				o.pos = UnityObjectToClipPos(v.vertex);
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
            }

			half3 _OutlineColor;

            half4 frag (v2f i) : SV_Target
            {
				UNITY_APPLY_FOG(i.fogCoord, _OutlineColor);
				return half4(_OutlineColor,1);
            }
            ENDCG
        }*/
    }
    CustomEditor "UniversalEditor"
}
