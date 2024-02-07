Shader "Custom/DotProduct"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        #pragma target 3.0

        struct Input
        {
            float2 viewDir;
        };

        float4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half dotp = dot(IN.viewDir, o.Normal);
            o.Albedo = float3(dotp, 1, 1-dotp);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
