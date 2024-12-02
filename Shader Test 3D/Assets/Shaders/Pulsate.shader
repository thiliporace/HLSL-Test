Shader "Introduction/Pulsate"
{
    Properties
    {
        _MainTexture ("Main Texture", 2D) = "white" {}
        _AnimateXY("Animate X Y", Vector) = (0,0,0,0)
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

            //Pra poder usar a textura
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _AnimateXY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //Faz a mesma coisa que as contas embaixo mas pelo inspetor
                o.uv = TRANSFORM_TEX(v.uv,_MainTexture);
                //Multiplica o offset por Time, usa o frac pra o numero do Time nao ficar enorme e pixelizar a imagem, ela faz com que volte pra 0 se passar de 1
                //Multiplicamos o MainTextureST pra ele ter a velocidade relacionada a quantidade do tiling
                o.uv += frac(_AnimateXY.xy * _MainTexture_ST.xy * float2(_Time.y,_Time.y));
                //Coloca o (1,0) no meio, e cria um (2,0) no fim, como passou da coordeanda UV ele duplica (porque a imagem ta em repeat)
                //o.uv *= 2.0;
                //Offset da textura
                //o.uv.x += 0.5;

                //o.uv *= log2(_CosTime.z);
                //o.uv *= _Time.y;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uvs = i.uv;

                //Pegar a cor da textura, i.uv e a coordenada
                fixed4 textureColor = tex2D(_MainTexture, uvs);
                return textureColor;
            }
            ENDCG
        }
    }
}
