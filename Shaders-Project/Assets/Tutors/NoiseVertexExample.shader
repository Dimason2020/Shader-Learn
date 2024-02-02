Shader "Unlit/NoiseVertexExample"
{
    Properties
    {
        _ColorMap ("ColorMap", 2D) = "white" {}
        _HeightMap ("HeightMap", 2D) = "white" {}

        _Color1 ("Color1", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (1,1,1,1)
        _Color3 ("Color3", Color) = (1,1,1,1)
        _Color4 ("Color4", Color) = (1,1,1,1)
        _Color5 ("Color5", Color) = (1,1,1,1)

        _Height1("Height1", Range(0,1)) = 0
        _Height2("Height2", Range(0,1)) = 0
        _Height3("Height3", Range(0,1)) = 0
        _Height4("Height4", Range(0,1)) = 0
        _Height5("Height5", Range(0,1)) = 0
        _MountainAmplitude("Amplitude", Range(0, 5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

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

            sampler2D _HeightMap;
            float4 _HeightMap_ST;
            sampler2D _ColorMap;

            float _Max;

            float4 _Color1;
            float4 _Color2;
            float4 _Color3;
            float4 _Color4;
            float4 _Color5;

            float _Height1;
            float _Height2;
            float _Height3;
            float _Height4;
            float _Height5;


            float _MountainAmplitude;

            v2f vert (appdata v)
            {
                v2f o;
                o.normal = v.normal;
                o.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex));

                o.uv = TRANSFORM_TEX(v.uv, _HeightMap);
                o.vertex = UnityObjectToClipPos(v.vertex);

                float heightMap = tex2Dlod(_HeightMap, float4(o.uv, 0, 0));
                o.vertex.y -= (heightMap.x * _MountainAmplitude);
                return o;
            }

            float4 GetHeightColor(float4 color)
            {
                if(color.g <= _Height1)
                {
                    color = _Color1;
                }
                else if(color.g > _Height1 && color.g <= _Height2)
                {
                    color = _Color2;
                }
                else if(color.g > _Height2 && color.g <= _Height3)
                {
                    color = _Color3;
                }
                else if(color.g > _Height3 && color.g <= _Height4)
                {
                    color = _Color4;
                }
                else if(color.g > _Height4 && color.g <= _Height5)
                {
                    color = _Color5;
                }

                return color;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 color = tex2D(_HeightMap, i.uv);

                float clampedValue = clamp(0.01, 0.95, color.g);
                float4 mapColor = tex2D(_ColorMap, clampedValue);
                return saturate(mapColor);
            }
            ENDCG
        }
    }
}
