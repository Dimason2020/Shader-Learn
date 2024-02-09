Shader "Custom/BlendTest"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            SetTexture[_MainTex] {combine texture}
        }
    }
}
