Shader "Custom/StencilObject"
{
    Properties
    {
        _MainTex("Main Tex", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)

        _SRef("Stencil Ref", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Comp", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp("Stencil Op", Float) = 2
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        
        Stencil 
        {
            Ref[_SRef]
            Comp[_SComp]
            Pass [_SOp]
        }


        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _Color;
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = color * _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
