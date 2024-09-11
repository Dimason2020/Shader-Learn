Shader "Custom/DepthShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = o.pos.xy * 0.5 + 0.5;
                return o;
            }

            sampler2D _CameraDepthTexture;  // Текстура глубины
            float4 _CameraParams; // Параметры камеры: x = near, y = far, z = 1/(far-near), w = -near/(far-near)

            float LD(float depth)
            {
                return 1.0 / (_CameraParams.y - depth * (_CameraParams.y - _CameraParams.x));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Выборка глубины
                float depth = tex2D(_CameraDepthTexture, i.uv).r;

                // Преобразование глубины в линейное пространство
                float linearDepth = LD(depth);

                return fixed4(linearDepth, linearDepth, linearDepth, 1.0);
            }
            ENDCG
        }
    }
}
