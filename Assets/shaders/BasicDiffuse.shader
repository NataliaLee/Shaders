Shader "CookBookShaders/BasicDiffuse" {
	 Properties {
            _EmissiveColor("Emissive Color",Color)=(1,1,1,1)
            _AmbientColor("Ambient Color",Color)=(1,1,1,1)
            _MySliderValue("This is a slider",Range(0,10))=2.5
            _RampTex("Gradient",2D)="white"{}
        }
        SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
          #pragma surface surf BasicDiffuse

		  sampler2D _RampTex;
  
       //   inline float4 LightingBasicDiffuse(SurfaceOutput s,fixed3 lightDir,fixed atten){
		//	float difLight = dot(s.Normal,lightDir);
	//		float hLambert=difLight*0.5+0.5;
	//		float2 hl=float2(hLambert,hLambert);
	//		float3 ramp=tex2D(_RampTex,hl).rgb;
	//
	//		float4 col;
	//		col.rgb=s.Albedo * _LightColor0.rgb * (ramp);
	//		col.a = s.Alpha;
	//		return col;
	//	}

	//BRDF
		   inline float4 LightingBasicDiffuse(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			float difLight = dot(s.Normal,lightDir);
			float rimLight = dot(s.Normal,viewDir);
			float hLambert=difLight*0.5+0.5;
			float2 hl=float2(hLambert,rimLight);
			float3 ramp=tex2D(_RampTex,hl).rgb;

			float4 col;
			col.rgb=s.Albedo * _LightColor0.rgb * (ramp);
			col.a = s.Alpha;
			return col;
		}
  
        struct Input {
            float2 uv_MainTex;
        };
        
        //sampler2D _MainTex;
        float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
        
        void surf (Input IN, inout SurfaceOutput o) {
            float4 c;
			c=pow(_EmissiveColor+_AmbientColor,_MySliderValue);
			o.Albedo=c.rgb;
			o.Alpha=c.a;
        }
        ENDCG
        }
        Fallback "Diffuse"
    }
