Shader "Unlit/UnlitToonShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DarkColor("Dark Color", Color) = (0,0,0,0)
        _LitColor("Lit Color", Color) = (1,1,1,1)
        _FresnelPower ("Fresnel Power", Range(0.1, 5.0)) = 2.0
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
                float3 normal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _DarkColor;
            float4 _LitColor;
            float _FresnelPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = mul(unity_ObjectToWorld, v.normal).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float dotProduct = dot(_WorldSpaceLightPos0.xyz, i.normal);
                dotProduct = (dotProduct + 1) * 0.5;
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 finalColor = lerp(_DarkColor, _LitColor, col.r);
                return finalColor;
            }
            ENDCG
        }
    }
}
