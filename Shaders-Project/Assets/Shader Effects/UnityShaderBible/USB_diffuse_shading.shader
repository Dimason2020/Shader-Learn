Shader "Unlit/USB_diffuse_shading"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _LightIntensity ("Light Intensity", Range(0, 1)) = 1
        _AmbientIntensity ("Ambient Intensity", Range (0,1)) = 0.2
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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LightIntensity;
            float4 _LightColor0;
            float _AmbientIntensity;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal_world = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0))).xyz;
                return o;
            }

            float3 LambertShading(float3 colorReflection, float lightIntensity, float3 normal, float3 lightDir)
            {
                return colorReflection * lightIntensity * max(0, dot(normal, lightDir));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 colorRefl = _LightColor0.rgb;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 diffuse = LambertShading(colorRefl, _LightIntensity, i.normal_world, lightDir);
                diffuse = (diffuse + 1) * 0.5;

                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = (_Color.rgb * diffuse) + (UNITY_LIGHTMODEL_AMBIENT.rgb * _AmbientIntensity);
                return col;
            }
            ENDCG
        }
    }
}
