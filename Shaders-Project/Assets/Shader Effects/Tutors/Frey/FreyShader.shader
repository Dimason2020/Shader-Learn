Shader "Unlit/FreyShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("ColorA", Color) = (1,1,1,1)
        _ColorB("ColorB", Color) = (1,1,1,1)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End", Range(0,1)) = 1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent" 
            "Queue"="Transparent"
        }

        Pass
        {
            Blend One One
            ZWrite Off
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define TAU 6.28318

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _ColorA;
            float4 _ColorB;

            float _ColorStart;
            float _ColorEnd;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                return o;
            }
            
            float InverseLerp(float a, float b, float t)
            {
                return (t-a)/(b-a);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float xOffset = cos(i.uv.x * TAU * 8) * 0.01;
                float a = cos((i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                a *= 1-i.uv.y;

                float topBottomRemover = (abs(i.normal.y) < 0.999);
                float waves = a * topBottomRemover;
                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);

                return gradient * waves;
            }
            ENDCG
        }
    }
}
