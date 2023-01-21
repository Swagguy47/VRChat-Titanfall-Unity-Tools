using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using static PlasticPipe.Server.MonitorStats;

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
    private bool skipAO;
    private bool skipGloss;
    private bool skipCavity;

    private float OverrideNormal = 1;
    [Range(0,1)] private float OverrideSpecular = 0.6f;
    private float OverrideEmission = 1, Progress;
    private bool NarrowSearch;
    private Texture[] AllTex;

    [MenuItem("Titanfall Asset Tools/Materials/Auto Texture Materials")]
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

        GUILayout.Label("Applies textures to materials assuming folders & textures are named accordingly.");
        GUILayout.Space(5f);
        GUILayout.Label("(Tip: Select all the material files and drag them over the dropdown)");
        GUILayout.Space(5f);

        //Shader Method
        string[] options = new string[]
           {
                "Standard", "Standard (Specular Setup)", "Titanfall 2 Standard"
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
        if (ChangeTex)
        {
            skipAlbedo = GUILayout.Toggle(skipAlbedo, "Skip Albedo maps");
            skipNormal = GUILayout.Toggle(skipNormal, "Skip Normal maps");
            skipSpecular = GUILayout.Toggle(skipSpecular, "Skip Specular maps");
            if (Shader == 2) //Titanfall shader
            {
                skipGloss = GUILayout.Toggle(skipGloss, "Skip Gloss maps");
                skipCavity = GUILayout.Toggle(skipCavity, "Skip Cavity maps");
            }
            skipEmission = GUILayout.Toggle(skipEmission, "Skip Emission maps");
            skipAO = GUILayout.Toggle(skipAO, "Skip Occlusion maps");
        }

        if (ChangeProperties)
        {
            GUILayout.Label("Normal Intensity:");
            OverrideNormal = EditorGUILayout.FloatField(OverrideNormal);

            GUILayout.Label("Emission Intensity:");
            OverrideEmission = EditorGUILayout.FloatField(OverrideEmission);

            GUILayout.Label("Smoothness:");
            OverrideSpecular = EditorGUILayout.Slider(OverrideSpecular, 0, 1);
        }
        else
        {
            GUILayout.Space(30f);
        }

        NarrowSearch = GUILayout.Toggle(NarrowSearch, "Specific Texture Search (Not Recommended)");
        GUILayout.Space(5f);

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

        foreach (Material Mat in InputMaterials)
        {
            if (ChangeTex) //Texture Changing
            {
                //Universal Textures
                SetTexture(Mat, "_col", "_MainTex", skipAlbedo); //Albedo
                SetTexture(Mat, "_nml", "_BumpMap", skipNormal); //Normal
                SetTexture(Mat, "_ao", "_OcclusionMap", skipAO); //AO
                SetTexture(Mat, "_ilm", "_EmissionMap", skipEmission); //EmisisonTex
                Mat.EnableKeyword("_EMISSION"); //Enables Emission

                if (Shader == 0) //Standard
                {
                    SetTexture(Mat, "_spc", "_MetallicGlossMap", skipSpecular);
                }
                else //Specular & TF|2
                {
                    SetTexture(Mat, "_spc", "_SpecGlossMap", skipSpecular);
                }

                if (Shader == 2) //TF|2
                {
                    SetTexture(Mat, "_cav", "_Cav", skipCavity);
                    SetTexture(Mat, "_gls", "_GlossMap", skipCavity);
                }
            }

            if (ChangeProperties) //Parameter changing
            {
                if (!skipNormal) //Normal
                {
                    Mat.SetFloat("_BumpScale", OverrideNormal);
                }
                if (!skipSpecular) //Specular
                {
                    Mat.SetFloat("_GlossMapScale", OverrideSpecular);
                }
                if (!skipEmission && CheckTexture(Mat, "_ilm"))
                {
                    Mat.EnableKeyword("_EMISSION");
                    Mat.SetColor("_EmissionColor", Color.white);
                    Mat.SetFloat("_EmissionIntensity", OverrideEmission);
                }
            }
            //Editor progressbar popup
            Progress++;
            EditorUtility.DisplayProgressBar("Texturing your materials for you... Sit tight.", "Progress: ( " + Progress + " / " + InputMaterials.Length + " )", Progress / InputMaterials.Length);
        }
        Debug.Log("DONE!");
        EditorUtility.ClearProgressBar();
    }

    private void SetTexture(Material CurrentMat, string Identifier, string ShaderName, bool Toggler)
    {
        if (!Toggler)
        {
            if (Directory.Exists(TextureDirectory + CurrentMat.name))
            {
                FindTextures(CurrentMat, Identifier, ShaderName, Toggler, "");
                //Debug.Log(TextureDirectory + CurrentMat.name + " EXISTS! Grabbing:" + Identifier);
            }
            else if (Directory.Exists(TextureDirectory + CurrentMat.name + "_colpass"))
            {
                FindTextures(CurrentMat, Identifier, ShaderName, Toggler, "_colpass");
                //Debug.Log(TextureDirectory + CurrentMat.name + "_colpass EXISTS! Grabbing: " + Identifier);
            }
        }
    }

    private void FindTextures(Material CurrentMat, string Identifier, string ShaderName, bool Toggler, string PathAppend)
    {
        foreach (var file in Directory.GetFiles(TextureDirectory + CurrentMat.name + PathAppend, "*" + FileType, SearchOption.TopDirectoryOnly))
        {
            Texture ThisTex = (Texture)AssetDatabase.LoadAssetAtPath(file, typeof(Texture));

            if (ThisTex.name.Contains(Identifier))
            {
                CurrentMat.SetTexture(ShaderName, ThisTex);
            }
        }
    }

    //Just checks if a texture exists
    private bool CheckTexture(Material CurrentMat, string Identifier)
    {
        bool returnVal = false;
        if (Directory.Exists(TextureDirectory + CurrentMat.name))
        {
            foreach(var file in Directory.GetFiles(TextureDirectory + CurrentMat.name, "*" + FileType, SearchOption.TopDirectoryOnly))
            {
                Texture ThisTex = (Texture)AssetDatabase.LoadAssetAtPath(file, typeof(Texture));

                if (ThisTex.name.Contains(Identifier))
                {
                    returnVal = true;
                }
                else
                {
                    returnVal = false;
                }
            }
            //Debug.Log(returnVal);
        }
        return returnVal;
    }
}