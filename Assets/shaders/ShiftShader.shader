Shader "CookBookShaders/ShiftShader" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ScrollXSpeed("Scroll Speed X",Range(0,10))=2
		_ScrollYSpeed("Scroll Speed Y",Range(0,10))=2
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

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _MainTint;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed2 scrolledUV = IN.uv_MainTex;
			fixed xScrollValue = _ScrollXSpeed*_Time.x;
			fixed yScrollValue = _ScrollYSpeed*_Time.y;

			scrolledUV+=fixed2(xScrollValue,yScrollValue);
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, scrolledUV);
			o.Albedo = c.rgb*_MainTint;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
