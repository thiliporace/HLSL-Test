Shader "Introduction/FragmentShader"
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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _ColorA, _ColorB, _ColorC, _ColorD;
            float4 _Resolution;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float3 palette(float t, float3 a, float3 b, float3 c, float3 d){
                return a + b*cos(6.28318*(c * t + d));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Multiplicar pelo aspect ratio da tela pra nao distorcer o efeito dependendo do tamanho da tela
                float2 fragCoord = i.uv * _Resolution.xy;
                //Troca o range de (-0.5,0.5) pra (-1,1)
                float2 uv = (fragCoord * 2.0 - _Resolution.xy) / _Resolution.y;

                //Salva localmente pra usar depois
                float2 uv0 = uv;
                float3 finalColor = float3(0,0,0);

                //Itera varias vezes o calculo
                for (float j = 0; j < 3.0; j++){

                    //Fractaliza as coordenadas uv
                    uv = frac(uv);

                    //Coloca o centro da tela no (0,0)
                    uv = uv - 0.5;

                    //Muda o ratio
                    //Graphtoy para ver as funcoes
                    float decimal = length(uv) * exp(length(uv0));

                    //Repete o padrão várias vezes, precisa dividir depois pra manter a forma original
                    decimal = sin(decimal * 8.0 +_Time.y) / 8.0;

                    //Valores positivos saem pra fora e negativos entram pra dentro, ao fazer o abs você so pega os positivos
                    decimal = abs(decimal);

                    //Binariza o gradiente, valores menores ou maiores que 0.1 vão automaticamente pra 0
                    //decimal = step(0.1,decimal);
    
                    //Também binariza valores menores e maiores, mas agora cria um gradiente nos valores intermediários
                    //decimal = smoothstep(0.0,0.1,decimal);

                    //Como nossa range é de -1,1 , colocar 0.1 na binarização coloca mais valores no gradiente
                    //Valores maiores aumentam o brilho
                    decimal = 0.01/decimal;

                    //Colocando cor
                    //vec3 col = vec3(uv,0.8);
                    //Colocar o i aqui aumenta a variação de cores com as iteracoes
                    if (decimal > 0.1){
                        float3 col = palette(length(uv0) + j*0.4 + _Time.y * 0.8,_ColorA.xyz,_ColorB.xyz,_ColorC.xyz,_ColorD.xyz);
                        finalColor += col * decimal;
                    }
                }
                //Output pra tela
                return float4(finalColor, 1.0);

            }
            ENDCG
        }
    }
}
