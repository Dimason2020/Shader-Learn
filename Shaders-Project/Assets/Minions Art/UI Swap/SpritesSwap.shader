Shader "UI/SpritesSwap"
{
    Properties
    {
        [PerRendererData]_MainTex("Sprite Texture", 2D) = "black" {}
        [PerRendererData]_XOffset("XOffset", Float) = 8
        [PerRendererData]_Offset("Offset", Float) = 8
        _MainTex2("Sprite Texture Swapped", 2D) = "black" {}
        _Color("Tint", Color) = (1,1,1,1)
        [Toggle(DISSOLVE)] _DISSOLVE("Dissolve", Float) = 0
        _Noise("Noise", 2D) = "white" {}
        _NoiseStrength("Noise Strength", Range(0,1)) = 0.3
        [Toggle(FLIPX)] _FLIPX("Flip X", Float) = 0
        [Toggle(FLIPY)] _FLIPY("Flip Y", Float) = 0
        _FlipTransition("Flip Transition", Range(0,1)) = 1
        [Toggle(GRADIENTHOR)] _GRADIENTHOR("Horizontal Gradient", Float) = 1
        [Toggle(GRADIENTVERT)] _GRADIENTVERT("Vertical Gradient", Float) = 0
        _Transition("Transition", Range(0,1.4)) = 1   
        _Edgewidth("Edge Width", Range(0,1)) = 0.1
        _EdgeCol("Edge Color", Color) = (1,1,1,1)
 
        [HideInInspector]_StencilComp("Stencil Comparison", Float) = 8
        [HideInInspector]  _Stencil("Stencil ID", Float) = 0
        [HideInInspector] _StencilOp("Stencil Operation", Float) = 0
        [HideInInspector] _StencilWriteMask("Stencil Write Mask", Float) = 255
        [HideInInspector] _StencilReadMask("Stencil Read Mask", Float) = 255
        [HideInInspector] _ColorMask("Color Mask", Float) = 15

        [PowerSlider(3.0)] 
        _Shininess ("Shininess", Range (0.01, 1)) = 0.08
        [IntRange(3.0)] _Samples("Samples", Range (0, 255)) = 100
    }
 
        SubShader
        {
            Tags
            {
                "Queue" = "Transparent"
                "IgnoreProjector" = "True"
                "RenderType" = "Transparent"
                "PreviewType" = "Plane"
           
              
            }
 
            Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
                ReadMask[_StencilReadMask]
                WriteMask[_StencilWriteMask]
            }
 
            Cull Off
            Lighting Off
            ZWrite Off
            ZTest[unity_GUIZTestMode]
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask[_ColorMask]
 
            Pass
            {
                Name "Default"
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0
                #pragma shader_feature FLIPX
                #pragma shader_feature FLIPY
                #pragma shader_feature GRADIENTHOR
                #pragma shader_feature GRADIENTVERT
                #pragma shader_feature DISSOLVE
                #include "UnityCG.cginc"
                #include "UnityUI.cginc"
 
                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float4 color    : COLOR;
                    float4 texcoord : TEXCOORD0;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };
 
                struct v2f
                {
                    float4 vertex   : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 texcoord  : TEXCOORD0;
                    float4 worldPosition : TEXCOORD1;
                    UNITY_VERTEX_OUTPUT_STEREO
                };
                
                float _Shininess;
                sampler2D _MainTex, _MainTex2, _Noise;
                fixed4 _Color;  
                float4 _MainTex_ST;
 
                float _XOffset, _YOffset;
 
                float _Transition, _Edgewidth, _NoiseStrength, _FlipTransition;
                float4 _EdgeCol;
 
                float3 RotateAroundYInDegrees(float3 vertex, float degrees)
                {
                    float alpha = degrees * UNITY_PI / 180.0;
                    float sina, cosa;
                    sincos(alpha, sina, cosa);
                    float2x2 m = float2x2(cosa, -sina, sina, cosa);
                    return float3(mul(vertex.xz, m), vertex.y).xzy;                   
                }
                float3 RotateAroundXInDegrees(float3 vertex, float degrees)
                {
                    float alpha = degrees * UNITY_PI / 180.0;
                    float sina, cosa;
                    sincos(alpha, sina, cosa);
                    float2x2 m = float2x2(cosa, -sina, sina, cosa);
                    return float3(mul(vertex.yz, m), vertex.x).xzy;
                }
            
                v2f vert(appdata_t v)
                {
                    v2f OUT;
                    UNITY_SETUP_INSTANCE_ID(v);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                              
#if FLIPX
                    // return to 0
                    v.vertex.x -= _XOffset;
                    // rotate
                    v.vertex.x = RotateAroundYInDegrees(v.vertex.xyz, _FlipTransition * 360).x;
                    //set offset back
                    v.vertex.x += _XOffset;
               
#endif
#if FLIPY
                    v.vertex.y -= _YOffset;
                    v.vertex.y = RotateAroundXInDegrees(v.vertex.xyz, _FlipTransition * 360).x;
                    v.vertex.y += _YOffset;
 
#endif
                    OUT.worldPosition = v.vertex;
                    OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);                   
                    OUT.texcoord = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                    OUT.color = v.color * _Color;
                    return OUT;
                }
 
                fixed4 frag(v2f IN,fixed facing : VFACE) : SV_Target
                {
                    // get the textures
                    half4 noise = tex2D(_Noise, IN.texcoord) * IN.color * _NoiseStrength;
                    half4 color = tex2D(_MainTex, IN.texcoord) * IN.color;
                    half4 color2 = tex2D(_MainTex2, IN.texcoord) * IN.color;
 
                    float gradient = 1;
                    float gradientEdge = 0;
 
                    // combine noise with uv
                    float2 noiseGrad = IN.texcoord + noise;
#if GRADIENTHOR
                    // create cutoff
                    gradient = step(_Transition, noiseGrad.x);
                    // create line
                    gradientEdge = step(_Transition - _Edgewidth, noiseGrad.x) - gradient;
                    // only show texture 1
                    color *= (gradient + gradientEdge);
                    // only show texture 2 on inverted
                    color2 *= 1 - (gradient);
#endif
 
#if GRADIENTVERT
                    gradient = step(_Transition, noiseGrad.y);
                    gradientEdge = step(_Transition - _Edgewidth, noiseGrad.y) - gradient;
                    color *= (gradient + gradientEdge);
                    color2 *= 1 - (gradient);
#endif
                 
#if DISSOLVE
                    gradient = step(_Transition, noise.r);
                    gradientEdge = step(_Transition - _Edgewidth, noise.r) - gradient;
                    color *= (gradient + gradientEdge);
                    color2 *= 1 - (gradient);
#endif
                    // add color to the edge, and multiply with alpha for a nicer transition
                    float4 coloredEdge = gradientEdge * _EdgeCol * (color.a + color2.a);
                    // combine everything
                    float4 final = (color + color2 + coloredEdge);
#if FLIPX || FLIPY
                    //VFACE returns positive for front facing, negative for backfacing
                    final =  facing > 0 ? color : color2 ;
#endif
                    return final;                   
                }
            ENDCG
            }
        }
}
