Shader "Unlit/Toon"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)

        _InMin("InMin", Range(-1,1)) = 1
        _InMax("InMax", Range(-1,1)) = -0.45

        _OutMin("OutMin", Range(-1,1)) = 1
        _OutMax("OutMax", Range(-1,1)) = 0
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            float4 _Color;

            float _InMin;
            float _InMax;
            float _OutMin;
            float _OutMax;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(unity_ObjectToWorld, v.normal);
                return o;
            }

            void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = float4(i.normal, 1);

                float3 lightDirection = _WorldSpaceLightPos0.xyz;
                float dotP = dot(i.normal, lightDirection);
                float4 result;
                Unity_Remap_float4(dotP, float2(_InMin, _InMax), float2(_OutMin,_OutMax), result);
                float4 divide = result / float4(0.49, 0, 0, 0);
                float4 flooring = floor(divide);
                return result;
            }
            ENDCG
        }
    }
}
