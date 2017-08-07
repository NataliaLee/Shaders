Shader "CookBookShaders/Phong" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0,30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Phong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _SpecularColor;
		sampler2D _MainTex;
		float4 _MainTint;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
		};

		inline fixed4 LightingPhong(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			//вычислим диффузный и отраженный вектор
			float diff=dot(s.Normal,lightDir);
			float3 reflectionVector=normalize(2.0*s.Normal*diff-lightDir);
			float spec = pow (max(0,dot(reflectionVector,viewDir)),_SpecPower);
			float3 finalSpec=_SpecularColor.rgb*spec;
			fixed4 c;
			c.rgb=(s.Albedo*_LightColor0.rgb*diff)+(_LightColor0.rgb*finalSpec);
			c.a=1.0;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
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
