using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class MapLightFix : EditorWindow
{
    public Texture TFLogo;

    public Transform LookUnderRoot;
    public bool LimitSearch = false;

    public Light[] AllLights;

    public Color CurrentColor;

    public bool active;

    public float delay;

    public float constant;

    public bool DisableEnvLights = true;

    public bool PrepForBake = true;

    public bool MultiplyIntensity;

    public float IntensityMultiplier = 1f;

    public int Priority;

    [MenuItem("Titanfall Asset Tools/Map Light Fix")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(MapLightFix));
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
        constant = 27485.077486910999f;
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("If map lights have broken lights,\nthis tool should fix them.");
        GUILayout.Space(5f);
        DisableEnvLights = GUILayout.Toggle(DisableEnvLights, "Disable Environment Lights");
        PrepForBake = GUILayout.Toggle(PrepForBake, "Set Light Mode to 'Baked' for all");
        MultiplyIntensity = GUILayout.Toggle(MultiplyIntensity, "Multiply all light intensities");
        if (MultiplyIntensity)
        {
            IntensityMultiplier = EditorGUILayout.FloatField(IntensityMultiplier);
        }

        LimitSearch = GUILayout.Toggle(LimitSearch, "Limit Search to GameObject Children");
        
        if (LimitSearch)
        {
            LookUnderRoot = EditorGUILayout.ObjectField("Only Look Under:", LookUnderRoot, typeof(Transform), true) as Transform;
        }

        string[] options = new string[]
        {
                "Auto", "Important", "Not Important",
        };
        Priority = EditorGUILayout.Popup("Render Mode: ", Priority, options);

        GUILayout.Space(5f);

        if (GUILayout.Button("Fix Lights"))
        {
            SearchAndFix();
        }
    }

    public void SearchAndFix()
    {
        if(!LimitSearch)
        {
            AllLights = GameObject.FindObjectsOfType<Light>();
        }
        else
        {
            AllLights = LookUnderRoot.GetComponentsInChildren<Light>();
        }

        foreach(Light ThisLight in AllLights)
        {
            //Debug.Log(ThisLight.gameObject.name);
            CurrentColor = ThisLight.color;
            //Debug.Log("Color:\nR: " + CurrentColor.r + "   G: " + CurrentColor.g + "   B: " + CurrentColor.b + "   A: " + CurrentColor.a);
            //27485.077486910999
            if(CurrentColor.r > 1f)
            {
                ThisLight.color = new Color((CurrentColor.r / constant / 255 * 10), (CurrentColor.g / constant / 255 * 10), (CurrentColor.b / constant / 255 * 10), 1); //Pretty Close, not perfect, but around there
            }
            else
            {
                Debug.Log("Light settings seem within acceptable range for: " + ThisLight.gameObject.name + " it will be skipped");
            }
            //Seems inefficient but it complains if I do it better ways
            if (DisableEnvLights)
            {
                if (ThisLight.gameObject.name.Contains("light_environment"))
                {
                    ThisLight.gameObject.SetActive(false);
                    Debug.Log(ThisLight.gameObject.name + " was disabled");
                }
            }

            if (PrepForBake)
            {
                ThisLight.lightmapBakeType = LightmapBakeType.Baked;
            }

            //:P
            if (Priority == 0)
            {
                ThisLight.renderMode = LightRenderMode.Auto;
            }
            else if (Priority == 1)
            {
                ThisLight.renderMode = LightRenderMode.ForcePixel;
            }
            else
            {
                ThisLight.renderMode = LightRenderMode.ForceVertex;
            }

            
        }
    }
}
