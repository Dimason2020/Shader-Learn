// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/LambertLightExample"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MinSelfLighting("MinSelfLighting", Range(0, 0.45)) = 0.25
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            float4 _Color;
            float _MinSelfLighting;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul( v.normal, unity_WorldToObject);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 lightDirection = _WorldSpaceLightPos0.xyz;
                float diffuse = max(_MinSelfLighting, dot(i.normal, lightDirection));
                float4 result =  _Color * diffuse;
                return result;
            }
            ENDCG
        }
    }
}
