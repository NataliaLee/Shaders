Shader "CookBookShaders/AnimationShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CellAmount("Cell Amount",float)=0.0
		_Speed("Speed",Range(0.01,32))=12
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		fixed _CellAmount;
		fixed _Speed;


		struct Input {
			float2 uv_MainTex;
		};



		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed2 spriteUV = IN.uv_MainTex;
			float cellUVPercentage=1/_CellAmount;
			float frame=fmod(_Time.y*_Speed,_CellAmount);
			frame=floor(frame);
			float xValue=(spriteUV.x+frame)*cellUVPercentage;
			spriteUV=float2(xValue,spriteUV.y);
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
