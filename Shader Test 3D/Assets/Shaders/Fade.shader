Shader "Introduction/Fade"
{
    Properties
    {
        _ColorA ("Color A",color) = (0,0,0,0)
        _ColorB ("Color B",color) = (0,0,0,0)
        _ColorC ("Color C",color) = (0,0,0,0)

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

            float4 _AnimateXY, _ColorA, _ColorB, _ColorC;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.uv += sin(_AnimateXY.xy * _Time.yy) + cos(_AnimateXY * _Time.yy);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float blendA = saturate(1.0 - i.uv.x - i.uv.y);
                float blendB = saturate(i.uv.x);
                float blendC = saturate(i.uv.y);

                float total = blendA + blendB + blendC;
                blendA /= total;
                blendB /= total;
                blendC /= total;

                //fixed4 col = fixed4(i.uv.xy,1,1);
                fixed4 col = blendA * _ColorA + blendB * _ColorB + blendC * _ColorC;
                return col;
            }
            ENDCG
        }
    }
}
