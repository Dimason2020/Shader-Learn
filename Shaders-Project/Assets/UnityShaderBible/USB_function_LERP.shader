Shader "Unlit/USB_function_LERP"
{
    Properties
    {
        _Skin01 ("Skin 01", 2D) = "white" {}
        _Skin02 ("Skin 02", 2D) = "white" {}
        _Lerp ("Lerp", Range(0, 1)) = 0.5
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
            sampler2D _Skin01;
            float4 _Skin01_ST;
            sampler2D _Skin02;
            float4 _Skin02_ST;
            float _Lerp;

            struct appdata
            {
                float4 vertex : POSITION;
                // create the UV coordinates for each case 01 and 02
                float2 uv_s01 : TEXCOORD0;
                float2 uv_s02 : TEXCOORD1;
            };
            struct v2f
            {
                float4 vertex : SV_POSITION;
                // we will use the UV coordinates in the fragment shader stage
                float2 uv_s01 : TEXCOORD0;
                float2 uv_s02 : TEXCOORD1;
            };
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // add tiling and offset for each case
                o.uv_s01 = TRANSFORM_TEX(v.uv_s01, _Skin01);
                o.uv_s02 = TRANSFORM_TEX(v.uv_s02, _Skin02);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // create a vector for each skin
                fixed4 skin01 = tex2D(_Skin01, i.uv_s01);
                fixed4 skin02 = tex2D(_Skin02, i.uv_s02);
                // make a linear interpolation between each color
                fixed4 render = lerp(skin01, skin02, _Lerp);
                return render;
            }
            ENDCG
        }
    }
}
