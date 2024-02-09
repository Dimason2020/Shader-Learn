Shader "Custom/StencilWindow"
{
   Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "black" {}

        _SRef("Stencil Ref", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Comp", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp("Stencil Op", Float) = 2
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" }

        ColorMask 0
        ZWrite Off

        Stencil 
        {
            Ref[_SRef]
            Comp[_SComp]
            Pass [_SOp]
        }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
}
