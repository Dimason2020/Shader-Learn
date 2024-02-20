Shader "Custom/Water" {
    Properties {
      _MainTex("Diffuse", 2D) = "white" {}
      _Alpha("Colour Alpha", Range(0, 1)) = 0.5
      _Freq("Frequency", Range(0,5)) = 3
      _Speed("Speed",Range(0,100)) = 10
      _Amp("Amplitude",Range(0,1)) = 0.5
      _Add("Color Add",Range(0,1)) = 1
    }
    SubShader 
    {
          Blend SrcAlpha OneMinusSrcAlpha

          CGPROGRAM
          #pragma surface surf Lambert vertex:vert alpha:fade
      
          struct Input {
              float2 uv_MainTex;
              float3 vertColor;
          };
      
          float _Alpha;
          float _Freq;
          float _Speed;
          float _Amp;
          float _Add;

          struct appdata {
              float4 vertex: POSITION;
              float3 normal: NORMAL;
              float4 texcoord: TEXCOORD0;
              float4 texcoord1: TEXCOORD1;
              float4 texcoord2: TEXCOORD2;
          };
      
          void vert (inout appdata v, out Input o) {
              UNITY_INITIALIZE_OUTPUT(Input,o);
              float t = _Time * _Speed;
              float waveHeight = sin(t + v.vertex.x * v.vertex.z * _Freq) * _Amp;
              v.vertex.y = v.vertex.y + waveHeight;
              v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
              o.vertColor = waveHeight + _Add;

          }

          sampler2D _MainTex;
          void surf (Input IN, inout SurfaceOutput o) {
              float2 timeUV = float2(IN.uv_MainTex.x + _Time.x, IN.uv_MainTex.y + _Time.x);
              float4 c = tex2D(_MainTex, timeUV);
              o.Albedo = c * IN.vertColor.rgb;
              o.Alpha = _Alpha;
          }
          ENDCG

    } 
    Fallback "Diffuse"
  }