using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class AssetResource : EditorWindow
{
    public Texture TFLogo;
    
    [MenuItem("Titanfall Asset Tools/Titanfall Asset Resource")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(AssetResource));
        
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
        Application.OpenURL("https://drive.google.com/drive/u/7/folders/1_T8UpjXId-mQMHozFZb7g4kk3mV-L15S");
    }

    private void OnGUI()
    {
        //GUILayout.Label(TFLogo);
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Asset Resource Opened in Browser\n\n\nREMINDER:\nAssets are to be used soley for\nVRChat and Non-Commercial purposes.\n\nDid it not open automatically? Try:");
        if(GUILayout.Button("Open Resource Manually"))
        {
            Application.OpenURL("https://drive.google.com/drive/u/7/folders/1_T8UpjXId-mQMHozFZb7g4kk3mV-L15S");
        }
    }
}
