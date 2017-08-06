Shader "CookBookShaders/Normals" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_NormalTex("Normal Map",2D)="bump"{}
		_NormalIntensity("Normal Map Intensity",Range(0,2))=1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		struct Input {
			float2 uv_NormalTex;
		};

		float4 _MainTint;
		sampler2D _NormalTex;
		float _NormalIntensity;

		void surf (Input IN, inout SurfaceOutput o) {
			//Получаем направление нормалей из текстуры карты нормалей
			float3 normalMap = UnpackNormal(tex2D(_NormalTex,IN.uv_NormalTex));
			normalMap = float3(normalMap.x*_NormalIntensity,normalMap.y*_NormalIntensity,
			normalMap.z);
			//применяем новые нормали к модели освещения
			o.Normal = normalMap.rgb;
			o.Albedo = _MainTint;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
