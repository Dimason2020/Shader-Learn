Shader "Unlit/USB_specular_reflection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Color", Color) = (1,1,1,1)
        [Space(20)]
        _SpecularTex ("Specular Texture", 2D) = "black" {}
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _SpecularInt ("Specular Intensity", Range(0, 1)) = 1
        _SpecularPow ("Specular Power", Range(1, 128)) = 64
    }
    SubShader
    {
        Tags 
        {
            "RenderType"="Opaque"
            "LightMode"="ForwardBase"
        }

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
                float3 normal_world : TEXCOORD1;
                float3 vertex_world : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SpecularTex;
            float _SpecularInt;
            float _SpecularPow;
            float4 _SpecularColor;
            float4 _MainColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal_world = UnityObjectToWorldNormal(v.normal);
                o.vertex_world = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float3 SpecularShading
            (
                float3 colorRefl, // Sa
                float specularInt, // Sp
                float3 normal, // n
                float3 lightDir, // l
                float3 viewDir, // e
                float specularPow // exponent
            )
            {
                float3 h = normalize(lightDir + viewDir); // halfway
                return colorRefl * specularInt * pow(max(0, dot(normal, h)),
                specularPow);
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.vertex_world);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal = normalize(i.normal_world);
                float3 specCol = tex2D(_SpecularTex, i.uv) * _SpecularColor.rgb;
                float3 specular = SpecularShading(_SpecularColor.rgb, _SpecularInt, normal,
                 lightDir, viewDir, _SpecularPow);
                 col.rgb += specular;
                 return col;
            }
            ENDCG
        }
    }
}
