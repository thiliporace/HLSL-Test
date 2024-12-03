Shader "Introduction/Masking"
{
    Properties
    {
        _MainTexture ("MainTexture", 2D) = "white" {}
        _MaskTexture ("MaskTexture", 2D) = "white" {}
        _RevealValue ("Reveal Value", float) = 0
        _Feather ("Feather", float) = 0

        _ErodeColor("Erode Color",color) = (1,1,1,1)

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SourceFactor("Source Factor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DestinationFactor("Destination Factor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _Operation("Operation", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        //1 arg: source, output do shader
        //2 arg: destination, o que esta no background

        //Alpha blend:
        // source * fsource + destination * fdestination
        // alpha = 0.7 -> source * 0.7 + BackgroundColor * 0.3
        // Vemos 70% da imagem e 30% do background

        //Additive blend:
        // source * fsource + destination * fdestination
        // source * 1 + destination * 1
        // source + destination

        Blend [_SourceFactor] [_DestinationFactor]
        BlendOp [_Operation]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                //Mudado de float2 pra float4, xy vai ser a primeira textura e zw a segunda
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {
                //Mudado de float2 pra float4, xy vai ser a primeira textura e zw a segunda
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTexture;
            float4 _MainTexture_ST;

            sampler2D _MaskTexture;
            float4 _MaskTexture_ST;

            float _RevealValue, _Feather;

            float4 _ErodeColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTexture);
                o.uv.zw = TRANSFORM_TEX(v.uv, _MaskTexture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 uvs = i.uv;
                fixed4 col = tex2D(_MainTexture, uvs.xy);
                fixed4 mask = tex2D(_MaskTexture, uvs.zw);

                //Binariza o gradiente, valores do arg 1 menores que arg 2 devolvem 1, se nao devolvem 0
                //float revealAmount = step(mask.r, _RevealValue);

                //Binariza suavemente entre dois inputs
                //float revealAmount = smoothstep(mask.r - _Feather, mask.r + _Feather, _RevealValue);

                //Efeito de erosao
                float revealAmountTop = step(mask.r, _RevealValue + _Feather);
                float revealAmountBottom = step(mask.r, _RevealValue - _Feather);

                //Pega parte do efeito de erosao
                float revealDifference = revealAmountTop - revealAmountBottom;
                float3 finalCol = lerp(col.rgb, mask.rgb, revealDifference);

                return fixed4(finalCol, col.a * revealAmountTop);
            }
            ENDCG
        }
    }
}