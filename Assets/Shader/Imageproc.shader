﻿Shader "Custom/Imageproc"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Mix("Effect", Float) = 0
		_mX("Mouse X", Float) = 0
		_mY("Mouse Y", Float) = 0

	}
		SubShader
		{

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				uniform float _Mix;
				uniform float _LookUpDistance;
				uniform float4 _MainTex_TexelSize; //special value
				uniform float _mX;
				uniform float _mY;
				struct VertexShaderInput
				{
					float4 vertex: POSITION;
				};
            
				struct VertexShaderOutput
				{
					float4 pos: SV_POSITION;
				};
			
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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex;
				
				fixed4 frag(v2f i) : SV_Target
				{


					float2 texel = float2(
						_MainTex_TexelSize.x * _LookUpDistance,
						_MainTex_TexelSize.y * _LookUpDistance
					   );


					float3x3 Gx = float3x3(0, -1, 0, -1, 5, -1, 0, -1, 0); // x direction kernel
					float3x3 Gy = float3x3(0, -1, 0, -1, 5, -1, 0, -1, 0); // y direction kernel


					// fetch the 3x3 neighborhood of a fragment
					float tx0y0 = tex2D(_MainTex, i.uv + texel * float2(-1, -1)).r;
					float tx0y1 = tex2D(_MainTex, i.uv + texel * float2(-1,  0)).r;
					float tx0y2 = tex2D(_MainTex, i.uv + texel * float2(-1,  1)).r;

					float tx1y0 = tex2D(_MainTex, i.uv + texel * float2(0, -1)).r;
					float tx1y1 = tex2D(_MainTex, i.uv + texel * float2(0,  0)).r;
					float tx1y2 = tex2D(_MainTex, i.uv + texel * float2(0,  1)).r;

					float tx2y0 = tex2D(_MainTex, i.uv + texel * float2(1, -1)).r;
					float tx2y1 = tex2D(_MainTex, i.uv + texel * float2(1,  0)).r;
					float tx2y2 = tex2D(_MainTex, i.uv + texel * float2(1,  1)).r;

					float valueGx = Gx[0][0] * tx0y0 + Gx[1][0] * tx1y0 + Gx[2][0] * tx2y0 +
							Gx[0][1] * tx0y1 + Gx[1][1] * tx1y1 + Gx[2][1] * tx2y1 +
							Gx[0][2] * tx0y2 + Gx[1][2] * tx1y2 + Gx[2][2] * tx2y2;

					float valueGy = Gy[0][0] * tx0y0 + Gy[1][0] * tx1y0 + Gy[2][0] * tx2y0 +
							Gy[0][1] * tx0y1 + Gy[1][1] * tx1y1 + Gy[2][1] * tx2y1 +
							Gy[0][2] * tx0y2 + Gy[1][2] * tx1y2 + Gy[2][2] * tx2y2;

					float G = sqrt((valueGx * valueGx) + (valueGy * valueGy));

					float4 edgePix = float4(float3(1.0,1.0,1.0) - float3(G,G,G), 1.0);
					//float4 edgePix = float4( float3( G,G,G ), 1.0);
					float4 texPix = tex2D(_MainTex, i.uv);


					 float4 edgeCol = lerp(texPix, edgePix, _Mix);
					 return edgeCol;





			   }
			   ENDCG
		   }
		}
}
