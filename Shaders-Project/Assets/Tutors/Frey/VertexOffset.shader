Shader "Unlit/VertexOffset"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("ColorA", Color) = (1,1,1,1)
        _ColorB("ColorB", Color) = (1,1,1,1)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End", Range(0,1)) = 1
        _WaveAmplitude("Wave Amplitude", Range(0, 0.45)) = 0.2
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }

        Pass
        {
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
            float _WaveAmplitude;

            float GetWave(float2 uv)
            {
                float2 uvsCentered = uv * 2 - 1;
                float radialDistance = length(uvsCentered);
                float waves = cos((radialDistance - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                waves *= 1-radialDistance;
                return waves;
            }

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.y = GetWave(v.uv) * _WaveAmplitude;
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
                float4 color = lerp(_ColorB, _ColorA, GetWave(i.uv));
                return color;
            }
            ENDCG
        }
    }
}
