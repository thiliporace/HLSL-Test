Shader "Introduction/FragmentShader 1"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _ColorA ("Color A", color) = (0.7,0.1,0.1,1)
        _ColorB ("Color B", color) = (0.1,0.5,1,1)
        _ColorC ("Color C", color) = (2.0,2.0,0.3,1)
        _ColorD ("Color D", color) = (0.31,0.73,0.666,1)

        _Resolution ("Resolution", Vector) = (1920,1080,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
                float3 color : COLOR0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _ColorA, _ColorB, _ColorC, _ColorD;
            float4 _Resolution;

            float3 palette(float t, float3 a, float3 b, float3 c, float3 d){
                return a + b*cos(6.28318*(c * t + d));
            }

            v2f vert (appdata v) {
            v2f o;
            float2 uv = (v.uv * 2.0 - 1.0); // Normalizar UV para (-1, 1)
            float2 uv0 = uv;
            float3 finalColor = float3(0, 0, 0);
            float displacement = 0.0;

            for (float j = 0; j < 3.0; j++) {
                uv = frac(uv);               // Fractaliza as coordenadas UV
                uv = uv - 0.5;               // Centraliza em (0, 0)
                float decimal = length(uv) * exp(length(uv0));
                decimal = sin(decimal * 8.0 + _Time.y) / 8.0;
                decimal = abs(decimal);      // Somente valores positivos
                decimal = 0.01 / decimal;    // Amplificação

                if (decimal > 0.1) {
                    float3 col = palette(
                        length(uv0) + j * 0.4 + _Time.y * 0.8,
                        _ColorA.xyz, _ColorB.xyz, _ColorC.xyz, _ColorD.xyz
                    );
                    finalColor += col * decimal;
                    displacement += decimal * 10;
                   
                }
            }

           float3 vert = v.vertex;
           vert.y += displacement + sin(o.uv.x * 10.0 + _Time.y) ;

            o.vertex = UnityObjectToClipPos(v.vertex);
            o.color = finalColor; // Passar cor calculada para o fragment shader
            return o;
        }

        fixed4 frag (v2f i) : SV_Target {
            return float4(i.color, 1.0); // Usar a cor calculada no vertex shader
        }
            ENDCG
        }
    }
}
