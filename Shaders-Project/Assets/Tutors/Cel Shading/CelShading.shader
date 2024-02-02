Shader "Unlit/CelShading"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FrontColor("Front Color", Color) = (1, 1, 1, 1)
        _BackColor("Back Color", Color) = (1, 1, 1, 1)
        _Range("Range", Range(0, 10)) = 3
        _Multiplier("Multiplier", Range(0, 10)) = 0.5

        _SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
        _Glossiness("Glossiness", Range(0, 32)) = 10
        _Smoothness("Smoothness", Range(0, 32)) = 10
        _RimThreshold("Rim Threshold", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : NORMAL;
                float3 viewDirection : TEXCOORD1;
                SHADOW_COORDS(2)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _FrontColor;
            fixed4 _BackColor;
            float _Range;
            float _Multiplier;

            float4 _SpecularColor;
            float _Glossiness;
            float _Smoothness;
            float _RimThreshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.viewDirection = WorldSpaceViewDir(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float shadow = SHADOW_ATTENUATION(i);

                float3 normal = normalize(i.worldNormal);

                float NdotL = dot(_WorldSpaceLightPos0, normal);
                float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
                float diffuse = saturate(NdotL);

                float3 viewDirection = normalize(i.viewDirection);
                float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDirection);
                float specular = saturate(dot(normal, halfVector));
                specular = pow(specular, _Glossiness);
                specular *= diffuse * _Smoothness;

                float rim = 1 - dot(viewDirection, normal);
                rim *= pow(diffuse, _RimThreshold);

                //eturn _FrontColor * (unity_AmbientSky + lightIntensity);
                return _FrontColor * (diffuse + max(specular, rim)); 
            }
            ENDCG
        }
    }
}
