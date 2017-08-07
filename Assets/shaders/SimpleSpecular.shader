Shader "CookBookShaders/SimpleSpecular" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf BlinnPhong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _SpecPower;
		float4 _MainTint;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Specular=_SpecPower;
			o.Gloss=1.0;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
