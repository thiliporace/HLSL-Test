Shader "Introduction/Vert"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Scale ("Scale",Float) = 1.0
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

            float _Scale;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                float xMod = tex2Dlod(_MainTex,float4(o.uv.xy,0,1));

                //Muda o centro
                xMod = xMod * 2 - 1;
                
                //Cria efeito de onda e anima
                o.uv.x = sin(xMod * 10 - _Time.y);
                float3 vert = v.vertex;
                //vert.y = o.uv.x;
                vert.z = o.uv.x * 10;
                o.uv.x = o.uv.x * 0.5 + 0.5;
                o.vertex = UnityObjectToClipPos(vert);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(i.uv.x,0,0,1);
                return col;
            }
            ENDCG
        }
    }
}
