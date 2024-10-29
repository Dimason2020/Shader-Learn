Shader "Unlit/UnlitReflectionShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Cube ("Reflection Cubemap", Cube) = "" { }
        _ReflectionStrength ("Reflection Strength", Range (0.0, 1.0)) = 1.0
        _Smoothness ("Smoothness", Range (1.0, 64.0)) = 0.0
        _MinSelfLight ("MinSelfLight", Range (0.0, 5.0)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            samplerCUBE _Cube;
            float _ReflectionStrength;
            float _MinSelfLight;
            float _Smoothness;

            v2f vert (appdata v)
            {
                v2f o;
                o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float3 frag (v2f i) : SV_Target
            {
                float3 N = normalize(i.normal);
                float3 L = _WorldSpaceLightPos0.xyz;
                float3 V = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 R = reflect(-L, N);
                
                float3 specularLight = saturate(dot(V, R));
                specularLight = pow(specularLight, _Smoothness);

                fixed3 mainTex = tex2D(_MainTex, i.uv).rgb;

                fixed3 reflectionColor = texCUBElod(_Cube, float4(reflect(-V, N), 0)).rgb;

                float3 color = lerp(mainTex, reflectionColor, _ReflectionStrength);
                float3 result = (color * _MinSelfLight) + (specularLight);
                return (result);
            }
            ENDCG
        }
    }
}
