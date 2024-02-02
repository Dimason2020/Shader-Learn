Shader "Custom/ReflectionShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _Cube ("Reflection Cubemap", Cube) = "" { }
        _ReflectionStrength ("Reflection Strength", Range (0.0, 1.0)) = 1.0
        _MinSelfLight ("MinSelfLight", Range (0.0, 5.0)) = 1.0
        _Smoothness ("Smoothness", Range (0.0, 1.0)) = 1.0
        _SmoothnessExponent ("Smoothness Exponent", Range (0.0, 10.0)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        samplerCUBE _Cube;
        float _ReflectionStrength;
        float _Smoothness;
        float _SmoothnessExponent;
        float _MinSelfLight;

        struct Input
        {
            float2 uv_MainTex;
            INTERNAL_DATA
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {

            // Sample the main texture
            fixed3 mainTex = tex2D(_MainTex, IN.uv_MainTex).rgb;

            // Sample the cubemap for reflection with explicit LOD
            fixed3 reflectionColor = texCUBElod(_Cube, float4(reflect(-IN.viewDir, o.Normal), 0)).rgb;

            float3 color = lerp(mainTex, reflectionColor, _ReflectionStrength);
            // Combine the main texture and reflection with a strength factor

            float3 viewDirection = normalize(IN.viewDir);

            //float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDirection);
            //float specular = saturate(dot(o.Normal, halfVector));
            //float shininess = exp2(10 * _Roughness + 1);
            //specular = pow(specular, shininess);

            float3 reflectDir = reflect(viewDirection, o.Normal);
            float3 viewReflectDir = normalize(viewDirection + reflectDir);
            float smoothnessValue = pow(saturate(1 - dot(viewDirection, viewReflectDir)), _SmoothnessExponent);

            o.Albedo = color * _MinSelfLight;
            o.Smoothness = _Smoothness;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
