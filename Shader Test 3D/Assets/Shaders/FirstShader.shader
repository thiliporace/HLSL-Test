Shader "Introduction/NewUnlitShader"
{
    //Pode ser cor, imagem, sao variaveis que afetam o shader
    Properties
    {
        _Color("Test Color", color) = (1,1,1,1)
    }
    SubShader
    {
        //Tipos diferentes de renderizacao
        Tags { "RenderType"="Opaque" }
        //Nivel de detalhe do shader
        LOD 100

        Pass
        {
            CGPROGRAM
            //Roda em cada vertice
            #pragma vertex vert
            //Roda em cada pixel
            #pragma fragment frag 

            #include "UnityCG.cginc"

            //Declarando a propriedade _Color
            fixed4 _Color;

            //Object Data
            struct appdata
            {
                float4 vertex : POSITION;
            };

            //Passa dados do vertex shader pro fragment shader
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            //Vertex shader
            v2f vert (appdata v)
            {
                //Output pro frag
                v2f o;
                //Multiplica o vertice da funcao pela matriz MVP da unity
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            //Fragment shader
            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 geralmente e usado pra cor, tem pouca precisao, half4 tem mais precisao, float4 ainda mais
                fixed4 col = _Color;
                return col;
            }
            ENDCG
        }
    }
}
