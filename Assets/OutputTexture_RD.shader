﻿Shader "Custom/OutputTexture_RD"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};

			sampler2D_float _MainTex;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{

				float4 c = tex2D(_MainTex, i.uv);
                
                float val = 1.0 - (c.r - c.b);
                val = clamp(val, 0.0, 1.0);

                
                //return c;                 
                return float4(val, val, val, 1.0);
			    //return float4(0.0, 0.0, 1.0, 1.0);
            
            }
			
			ENDCG
		}
      
    }
    FallBack "Diffuse"
}
