Shader "Introduction/Blend"
{
    Properties
    {
        _MainTexture ("MainTexture", 2D) = "white" {}
        _Color("Color",color) = (1,1,1,1)

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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTexture;
            float4 _MainTexture_ST;

            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTexture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uvs = i.uv;
                fixed4 col = tex2D(_MainTexture, uvs);
                return col;
            }
            ENDCG
        }
    }
}
