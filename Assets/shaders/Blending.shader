Shader "CookBookShaders/Blending" {
	Properties {
		_MainTint("Diffuse Tint",Color)=(1,1,1,1)
		_ColorA("Terrain Color A",Color)=(1,1,1,1)
		_ColorB("Terrain Color B",Color)=(1,1,1,1)
		_RTexture("Red Channel Texture",2D)=""{}
		_GTexture("Green Channel Texture",2D)=""{}
		_BTexture("Blue Channel Texture",2D)=""{}
		_ATexture("Alpha Channel Texture",2D)=""{}
		_BlendTex("Blend Texture",2D)=""{}
	}
	 SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM

        #pragma surface surf Lambert
        #pragma target 3.0

		float4 _MainTint;
		float4 _ColorA;
		float4 _ColorB;
		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
        sampler2D _ATexture;
		sampler2D _BlendTex;

		//это позволит пользоателю менять параметры тайлинга для отдельных текстур
		struct Input {
			float2 uv_RTexture;
			//float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			//Получаем данные из блендинг-текстуры
			//Здесь мы используем float4,потому что данные хранятся в RGBA или XYZW каналах
			float4 blendData = tex2D(_BlendTex,IN.uv_BlendTex);
			//получаем цвета из текстур,которые мы хотим блендить
			float4 rTexData = tex2D(_RTexture,IN.uv_RTexture);
			float4 gTexData = tex2D(_GTexture,IN.uv_RTexture);
			float4 bTexData = tex2D(_BTexture,IN.uv_BTexture);
			float4 aTexData = tex2D(_ATexture,IN.uv_ATexture);

			//Теперь нужно объединить все цвета в один
			//lerp принимает два цвета и производит интерполяцию между ними,используя
			//число в диапазооне от 0 до 1, передаваемое в последнем аргументе
			float4 finalColor;
			finalColor=lerp(rTexData,gTexData,blendData.g);
			finalColor=lerp(finalColor,bTexData,blendData.b);
		    finalColor=lerp(finalColor,aTexData,1-blendData.a);
			finalColor.a=1.0;

			//добавим наши цвета ландшафта
			float4 terrainLayers = lerp(_ColorA,_ColorB,blendData.r);
			finalColor*=terrainLayers;
			finalColor = saturate(finalColor);

			o.Albedo = finalColor.rgb * _MainTint.rgb;
			o.Alpha = finalColor.a;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
