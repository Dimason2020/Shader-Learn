Shader "Unlit/CurveWorld"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CurveAmountX("Curve Amount X", Range(-0.001, 0.001)) = 0
        _CurveAmountY("Curve Amount Y", Range(-0.001, 0.001)) = 0
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
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CurveAmountX;
            float _CurveAmountY;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 dist = o.worldPos - _WorldSpaceCameraPos.xyz;
                float3 result = float3(_CurveAmountX, _CurveAmountY, 0) * pow(dist.z, 2);
                v.vertex.xyz += result;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
