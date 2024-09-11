Shader "Flexus/Tutor/CRT Draw"
{
    Properties
    {
        _BrushSize ("Brush Size", Range(0, 1)) = 0.1
        _BrushSoftness ("Brush Softness", Range(0, 1)) = 1
        _Height ("Height", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Lighting Off
        Blend One Zero

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            float2 _BrushPosition;
            float _BrushSoftness;
            float _Height;

            float4 frag(v2f_customrendertexture IN) : COLOR
            {
                float brushRadius = 0.1;
                half4 prevCol = tex2D(_SelfTexture2D, IN.localTexcoord.xy);
                half4 col = smoothstep(1, 1 - _BrushSoftness, distance(_BrushPosition, IN.localTexcoord.xy) / brushRadius);
                col = max(prevCol, col * _Height);
                
                col.a = 1;
                return col;
            }
            ENDCG
        }
    }
}