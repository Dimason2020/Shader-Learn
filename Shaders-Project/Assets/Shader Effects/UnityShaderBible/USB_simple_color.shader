Shader "USB/USB_simple_color"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _VPos ("Vertex Position", Vector) = (0, 0, 0, 1)

        [Header(Textures)]
        _FrontTex("Front Texture", 2D) = "white" {}
        _BackTex("Back Texture", 2D) = "white" {}

        [Header(Category name)]
        [Space(10)]
        [PowerSlider(3.0)] _Brightness ("Brightness", Range (0.01, 1)) = 0.08
        [IntRange] _Samples ("Samples", Range (0, 255)) = 100

        [Space(10)]
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend ("SrcFactor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend ("DstFactor", Float) = 1
    }
    SubShader 
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend [_SrcBlend] [_DstBlend]
        //AlphaToMask On
        //ColorMask RB
        //ZWrite Off
        ZTest Always
        //Cull Off
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

            sampler2D _FrontTex;
            sampler2D _BackTex;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Brightness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }


            fixed4 frag (v2f i, bool face : SV_ISFRONTFACE) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * _Color;

                //fixed4 colFront = tex2D(_FrontTex, i.uv);
                //fixed4 colBack = tex2D(_BackTex, i.uv);
                //return face ? colFront : colBack;
            }
            ENDCG
        }
    }
}
