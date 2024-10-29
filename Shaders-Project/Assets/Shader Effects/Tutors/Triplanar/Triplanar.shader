Shader "Unlit/Triplanar"
{
   Properties
    {
        _MainTexY ("Texture", 2D) = "white" {}
        _MainTexX ("Texture", 2D) = "white" {}
        _MainTexZ ("Texture", 2D) = "white" {}
        _Tiling("Tiling", Float) = 1
        _Pow("Pow", Range(1, 8)) = 1
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
                float3 wNormal : TEXCOORD1;
                float4 wVertex : TEXCOORD2;
            };

            sampler2D _MainTexY;
            sampler2D _MainTexX;
            sampler2D _MainTexZ;
            float4 _MainTexY_ST;
            float _Tiling;
            int _Pow;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTexY);
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wVertex = normalize(mul(unity_ObjectToWorld, v.vertex));
                return o;
            }

            float4 BlendOverwrite(float4 Blending, float Opasity)
            {
                return lerp(float4(0,0,0,1), Blending, Opasity);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 value = pow(abs(i.wNormal), _Pow);
                float2 uvX = (i.wVertex.gb / 2) * _Tiling;
                fixed4 texX = tex2D(_MainTexX, uvX);
                float4 colX = BlendOverwrite(texX, value.x);
                float2 uvY = (i.wVertex.rb / 2) * _Tiling;
                fixed4 texY = tex2D(_MainTexY, uvY);
                float4 colY = BlendOverwrite(texY, value.y);
                float2 uvZ = (i.wVertex.rg / 2) * _Tiling;
                fixed4 texZ = tex2D(_MainTexZ, uvZ);
                float4 colZ = BlendOverwrite(texZ, value.z);
                return colX + colY + colZ;
            }
            ENDCG
        }
    }
}
