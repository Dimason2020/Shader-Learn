Shader "Custom/Rim"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0)

        _Color1 ("Color1", Color) = (0,0.5,0.5,0)
        _Color2 ("Color2", Color) = (0,0.5,0.5,0)

        _RimPower("Rim Power", Range(1, 10)) = 1
        _SliceThickness("Slice Thickness", Range(0, 1)) = 1
        _SliceAmount("Slice Amount", Range(0.25, 1)) = 1
        [Toggle] _Select("Select", Float) = 0
    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Lambert

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        fixed4 _RimColor;
        fixed4 _Color1;
        fixed4 _Color2;
        float _RimPower;
        float _Select;
        float _SliceAmount;
        float _SliceThickness;

        float3 colorizing(float worldPosY)
        {
            return frac(worldPosY * 10 * _SliceAmount) > _SliceThickness ? _Color1 : _Color2;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal)); 
            float3 tex = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Emission = _Select == 0 ? _RimColor.rgb * pow(rim,_RimPower) : colorizing(IN.worldPos.y);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
