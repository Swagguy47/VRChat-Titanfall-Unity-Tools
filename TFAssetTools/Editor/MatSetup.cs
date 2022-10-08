using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

//This is a modified version of my simplified Halo 2 Anniversary Material Converter tool for Titanfall usage
public class MatSetup : EditorWindow
{
    public Texture TFLogo;
    public Vector2 scrollPos;

    public Material[] InputMaterials;

    private string TextureDirectory;

    private string FileType = ".png";

    //Methods
    private int Shader;

    //Overrides
    private bool ChangeTex = true;
    private bool ChangeProperties = true;

    private bool skipAlbedo;
    private bool skipNormal;
    private bool skipSpecular;
    private bool skipEmission;

    private float OverrideNormal = 1;
    [Range(0,1)] private float OverrideSpecular = 0.6f;
    private float OverrideEmission = 1, Progress;

    [MenuItem("Titanfall Asset Tools/Auto Texture Materials")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(MatSetup));
    }

    private void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("--EXPERIMENTAL, YOU MAY ENCOUNTER BUGS--\n");

        GUILayout.Label("Applies textures to materials assuming folders & textures are named accordingly.");
        GUILayout.Space(5f);
        GUILayout.Label("(Tip: Select all the material files and drag them over the dropdown)");
        GUILayout.Space(5f);

        //Shader Method
        string[] options = new string[]
           {
                "Standard", "Standard (Specular Setup)",
           };

        //BATCH SETTING
        Shader = EditorGUILayout.Popup("Expected Shader:", Shader, options);

        //Array field
        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialJson = serialObj.FindProperty("InputMaterials");

        EditorGUILayout.PropertyField(serialJson, true);
        serialObj.ApplyModifiedProperties();
        //-----

        GUILayout.Label("Textures folder:");
        TextureDirectory = EditorGUILayout.TextField(TextureDirectory);
        if (GUILayout.Button("Use Selected Folder"))
        {
            SelectedFolder();
        }
        GUILayout.Space(5f);

        GUILayout.Label("Texture File Type:");
        FileType = EditorGUILayout.TextField(FileType);
        GUILayout.Space(15f);

        //Placeholders
        GUILayout.Label("Overrides:");
        ChangeTex = GUILayout.Toggle(ChangeTex, "Change textures");
        ChangeProperties = GUILayout.Toggle(ChangeProperties, "Change material properties");
        skipAlbedo = GUILayout.Toggle(skipAlbedo, "Skip Albedo maps");
        skipNormal = GUILayout.Toggle(skipNormal, "Skip Normal maps");
        skipSpecular = GUILayout.Toggle(skipSpecular, "Skip Specular maps");
        skipEmission = GUILayout.Toggle(skipEmission, "Skip Emission maps");

        GUILayout.Label("Normal Intensity:");
        OverrideNormal = EditorGUILayout.FloatField(OverrideNormal);

        GUILayout.Label("Emission Intensity:");
        OverrideEmission = EditorGUILayout.FloatField(OverrideEmission);

        GUILayout.Label("Smoothness:");
        OverrideSpecular = EditorGUILayout.Slider(OverrideSpecular, 0, 1);


        if (GUILayout.Button("Convert"))
        {
            ConvertMaterials();
        }

        EditorGUILayout.EndScrollView();
    }

    private void SelectedFolder()
    {
        var Getpath = "";
        var obj = Selection.activeObject;
        if (obj == null) Getpath = "Assets";
        else Getpath = AssetDatabase.GetAssetPath(obj.GetInstanceID());
        if (Getpath.Length > 0)
        {
            if (Directory.Exists(Getpath))
            {
                TextureDirectory = Getpath + "/";
                Debug.Log("Path Set! (" + TextureDirectory + ")");
            }
        }
    }

    public void ConvertMaterials()
    {
        Debug.Log("Setting up materials...");
        Progress = 0;
        foreach (Material CurrentMat in InputMaterials)
        {
            if (ChangeTex)
            {
                //Albedo
                if (!skipAlbedo && (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_col" + FileType, typeof(Texture)) != null)
                {
                    CurrentMat.mainTexture = (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_col" + FileType, typeof(Texture));
                }
                //Normal
                if (!skipNormal && (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_nml" + FileType, typeof(Texture)) != null)
                {
                    CurrentMat.SetTexture("_BumpMap", (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_nml" + FileType, typeof(Texture)));
                }
                //Specular
                if (!skipSpecular && (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_spc" + FileType, typeof(Texture)) != null)
                {
                    if (Shader == 1)
                    {
                        CurrentMat.SetTexture("_SpecGlossMap", (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_spc" + FileType, typeof(Texture)));
                    }
                    else
                    {
                        CurrentMat.SetTexture("_MetallicGlossMap", (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_spc" + FileType, typeof(Texture)));
                    }
                }

                //Emission
                if (!skipEmission && (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_ilm" + FileType, typeof(Texture)) != null)
                {
                    CurrentMat.EnableKeyword("_EMISSION");
                    CurrentMat.SetTexture("_EmissionMap", (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_ilm" + FileType, typeof(Texture)));
                }
            }

            if (ChangeProperties) //Copypaste because yes
            {
                //Normal
                if (!skipNormal && (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_nml" + FileType, typeof(Texture)) != null)
                {
                    CurrentMat.SetFloat("_BumpScale", OverrideNormal);
                }

                //Specular
                if (!skipSpecular && (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_spc" + FileType, typeof(Texture)) != null)
                {
                    CurrentMat.SetFloat("_GlossMapScale", OverrideSpecular);
                }

                //Emission
                if (!skipEmission && (Texture)AssetDatabase.LoadAssetAtPath(TextureDirectory + CurrentMat.name + "/" + CurrentMat.name + "_ilm" + FileType, typeof(Texture)) != null)
                {
                    CurrentMat.EnableKeyword("_EMISSION");
                    CurrentMat.SetColor("_EmissionColor", Color.white);
                    CurrentMat.SetFloat("_EmissionIntensity", OverrideEmission);
                    //CurrentMat.SetColor("_EmissionColor", CurrentMat.GetColor("_EmissionColor") * OverrideEmission);
                }
            }

            //Editor progressbar popup
            Progress++;
            EditorUtility.DisplayProgressBar("Texturing your materials for you... Sit tight.", "Progress: ( " + Progress + " / " + InputMaterials.Length + " )", Progress / InputMaterials.Length);
        }
        Debug.Log("DONE!");
        EditorUtility.ClearProgressBar();
    }
}
