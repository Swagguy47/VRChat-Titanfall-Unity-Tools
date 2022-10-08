using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class MaterialSetup : EditorWindow
{
    public Texture TFLogo;

    public Material[] InputMaterials;

    public string TexturesFolder = "Assets/";

    public Vector2 scrollPos;


    //[MenuItem("Titanfall Asset Tools/Auto Texture Materials")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(MaterialSetup));
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Automatically sets up all textures in materials\nassuming textures & folders are named accordingly");

        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        //Materials:

        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialTex = serialObj.FindProperty("InputMaterials");

        EditorGUILayout.PropertyField(serialTex, true);
        serialObj.ApplyModifiedProperties();

        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        GUILayout.Space(5f);

        //Folder Path
        GUILayout.Label("Root Textures Folder: \n'" + TexturesFolder + "'");
        if (GUILayout.Button("Set Texture Folder Path"))
        {

        }
        GUILayout.Label("(Highlight the folder in the project browser, then click button)");

        GUILayout.Space(15f);

        if (GUILayout.Button("Texture all inputted materials"))
        {

        }
        GUILayout.Label("Warning:\nThis will override any settings of the materials");

        EditorGUILayout.EndScrollView();

        //I realize I've actually already coded thise before but for H2A, This script will remain in case I 
        //return to it, but its currently abandonded.
    }
}
