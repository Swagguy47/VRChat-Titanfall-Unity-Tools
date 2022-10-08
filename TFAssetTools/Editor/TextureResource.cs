using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class TextureResource : EditorWindow
{
    public Texture TFLogo;

    [MenuItem("Titanfall Asset Tools/--Resources--/Titanfall Textures")]
    public static void ShowWindow()
    {
        Application.OpenURL("https://mega.nz/folder/so02VKDA#Jxuv8sbpGzZqNjqQfAvqrw");

    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
        Application.OpenURL("https://mega.nz/folder/so02VKDA#Jxuv8sbpGzZqNjqQfAvqrw");

    }

    private void OnGUI()
    {

    }
}
