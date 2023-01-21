using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class TFTutorials : EditorWindow
{
    public Texture TFLogo;

    [MenuItem("Titanfall Asset Tools/--Resources--/Guides and Tutorials")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(TFTutorials));
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));

    }

    private void OnGUI()
    {
        //GUILayout.Label(TFLogo);
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Potentially useful tutorials for the toolset, the asset resource,\nor just making Titanfall VRChat content in general.");
        GUILayout.Space(15f);
        if (GUILayout.Button("(Video): 'Titanfall Asset Tools Walkthrough'"))
        {
            Application.OpenURL("https://youtu.be/XUO1OT2Eres");
        }
        GUILayout.Space(15f);
        if (GUILayout.Button("(Video): 'Making Your Own Titanfall Avatar'"))
        {
            Application.OpenURL("https://youtu.be/jOdDULz0UCw");
        }
        GUILayout.Space(15f);
        if (GUILayout.Button("(Video): 'Fixing Hands/Fingertips'"))
        {
            Application.OpenURL("https://youtu.be/TVxSyMi-TfM");
        }
        GUILayout.Space(15f);
        //if (GUILayout.Button("(Video): Walkthrough of the Toolset"))
        //{
        //    Application.OpenURL("");
        //}
        if (GUILayout.Button("(Video): 'How to make Swagguy47's Titanfall avatars'"))
        {
            Application.OpenURL("https://youtu.be/0KbFwiIOSbE");
        }
        GUILayout.Space(15f);
        if (GUILayout.Button("(Video): 'Properly Setting up a Material'"))
        {
            Application.OpenURL("https://drive.google.com/file/d/1CcZSq1bIqY3QOV56MhV6zZSstHr6bIbs/view?usp=sharing");
        }
        GUILayout.Space(15f);
        if (GUILayout.Button("(Guide): 'Editing Textures to Apply Camos'"))
        {
            Application.OpenURL("https://drive.google.com/file/d/1fY30UQ-HPlfoamuFzgO0VpOfBaHpkwcU/view?usp=sharing");
        }
        GUILayout.Space(15f);
        if (GUILayout.Button("(Guide): 'Setting up a Titanfall Model in Unity'"))
        {
            Application.OpenURL("https://drive.google.com/file/d/1HxMuWrmq3h2G1_33E2QCWN-Dgl2mVoIE/view?usp=sharing");
        }
    }
}