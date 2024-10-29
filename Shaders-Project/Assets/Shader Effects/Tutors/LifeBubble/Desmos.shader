Shader "Learn/Desmos"
{
    Properties
    {
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU = 6.28

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _ColorA;
            float4 _ColorB;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sinus
                //float sinus;
                //sinus = sin(i.uv.x * 3.14 + _Time.y) * 0.5 + 0.5;
                //float4 color = lerp(_ColorA, _ColorB, sinus);

                float xOffset = cos(i.uv.y * 6.28 * 8) * 0.01;
                float time = _Time.y * 0.1;
                float t = cos((i.uv.x + xOffset + time) * 6.28 * 5) * 0.5 + 0.5;

                return t; 
            }
            ENDCG
        }
    }
}
