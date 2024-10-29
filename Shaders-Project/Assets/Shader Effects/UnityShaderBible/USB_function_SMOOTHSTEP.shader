Shader "Unlit/USB_function_SMOOTHSTEP"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Interpolation("Interpolation", Range(0,1)) = 0.1
        _Edge("Edge", Range(0,1)) = 0.5
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Edge;
            float _Interpolation;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float a = i.uv.y - _Interpolation;
                float b = i.uv.y + _Interpolation;
                float ssmoothstep = smoothstep(a, b, _Edge);
                return float4(ssmoothstep.xxx, 1);
            }
            ENDCG
        }
    }
}
