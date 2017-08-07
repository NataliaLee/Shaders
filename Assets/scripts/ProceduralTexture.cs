using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProceduralTexture : MonoBehaviour {
	public int widthHeight = 512;
	public Texture2D generatedTexture;
	private Material currentMaterial;
	private Vector2 centerPosition;

	// Use this for initialization
	void Start () {
		if (!currentMaterial) {
			Renderer r = GetComponent<Renderer> ();
			currentMaterial = r.sharedMaterial;
			if (!currentMaterial) {
				Debug.LogWarning ("Cannot find a material on:"+transform.name);
			}
		}
		//генерируем процедурную текстуру
		if(currentMaterial){
			//генерируем текстуру градиента
			centerPosition = new Vector2(0.5f,0.5f);
			//generatedTexture = GenerateGradient ();
			generatedTexture = GenerateRings ();
			//присваеваем её матуриалу текущего объекта
			currentMaterial.SetTexture("_MainTex",generatedTexture);
		}
		
	}

	private Texture2D GenerateGradient(){
		Texture2D proceduralTexture = new Texture2D (widthHeight,widthHeight);
		//узнаем центр текстуры
		Vector2 centerPixelPosition = centerPosition * widthHeight;

		//пройдемся по всем пикселям,определим их расстояние от центра
		//и на основе этого присвоим им значения
		for(int x=0;x<widthHeight;x++){
			for(int y=0;y<widthHeight;y++){
				//вычисляем расстояние от центра текстуры до выбранного пикселя
				Vector2 currentPosition = new Vector2(x,y);
				float pixelDistance = Vector2.Distance (currentPosition,centerPixelPosition)/
					(widthHeight*0.5f);
				//инвертируем значения и ограничиваем их диапазоном [0,1]
				pixelDistance = Mathf.Abs(1- Mathf.Clamp(pixelDistance,0f,1f));

				//создаем новый цвет пикселя
				Color pixelColor=new Color(pixelDistance,pixelDistance,pixelDistance,1f);
				proceduralTexture.SetPixel (x,y,pixelColor);
			}
		}
		proceduralTexture.Apply ();
		return proceduralTexture;
	}

	private Texture2D GenerateRings(){
		Texture2D proceduralTexture = new Texture2D (widthHeight,widthHeight);
		//узнаем центр текстуры
		Vector2 centerPixelPosition = centerPosition * widthHeight;
		for (int x = 0; x < widthHeight; x++) {
			for (int y = 0; y < widthHeight; y++) {
				Vector2 currentPosition = new Vector2 (x, y);
				float pixelDistance = Vector2.Distance (currentPosition,centerPixelPosition)/
					(widthHeight*0.5f);
				pixelDistance = Mathf.Abs(1- Mathf.Clamp(pixelDistance,0f,1f));
				pixelDistance = Mathf.Sin (pixelDistance * 30f) * pixelDistance;
				//создаем новый цвет пикселя
				Color pixelColor=new Color(pixelDistance,pixelDistance,pixelDistance,1f);
				proceduralTexture.SetPixel (x,y,pixelColor);
			}
		}
		proceduralTexture.Apply ();
		return proceduralTexture;
	}
}
