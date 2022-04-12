using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class NormalConverter : EditorWindow
{

    public Texture TFLogo;

    public Texture2D InputNormal, maskMap;
    public string textureName = "Untitled";
    public int width, height;
    public bool inverseSmoothness;
    private string path
    {
        get
        {
            string a = "";
            if(InputNormal != null)
            {
                a = AssetDatabase.GetAssetPath((Object)InputNormal);
                a = a.Substring(0, a.IndexOf(((Object)InputNormal).name));
                return a;

            }
            return a;
        }
    }
    
    [MenuItem("Titanfall Asset Tools/Normal Map Converter")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(NormalConverter));

    }

    private void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    public void OnGUI()
    {
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Converts yellow normal maps to standard\npurple ones, especially useful for Quest");
        GUILayout.Space(10f);
        GUILayout.Label("Please ensure your normal map texture has \n'Read/Write Enabled' set to true in its import settings");
        GUILayout.Space(10f);
        InputNormal = ShowTexGUI("Input (Yellow) Normal Map:", InputNormal);
        textureName = InputNormal.name + "_Converted";
        width = InputNormal.width;
        height = InputNormal.height;
        //inverseSmoothness = EditorGUILayout.Toggle("Inverse Smoothness", inverseSmoothness);

        if(GUILayout.Button("Convert Normal Map"))
        {

            PackTextures();
            Debug.Log(path);

        }
    }

    private void PackTextures()
    {

        maskMap = new Texture2D(width, height);
        maskMap.SetPixels(ColorArray());

        byte[] tex = maskMap.EncodeToPNG();

        FileStream stream = new FileStream(path + textureName + ".png", FileMode.OpenOrCreate, FileAccess.ReadWrite);
        BinaryWriter writer = new BinaryWriter(stream);
        for (int j = 0; j < tex.Length; j++)
            writer.Write(tex[j]);

        writer.Close();
        stream.Close();

        AssetDatabase.ImportAsset(path + textureName + ".png", ImportAssetOptions.ForceUpdate);
        AssetDatabase.Refresh();

    }
    private Color[] ColorArray()
    {

        Color[] cl = new Color[width * height];

        for(int j = 0;j < cl.Length;j++)
        {
            
            cl[j] = new Color();
            if (InputNormal != null)
                cl[j].r = InputNormal.GetPixel(j % width, j / width).r;
            else
                cl[j].r = 1;
            if (InputNormal != null)
                cl[j].g = InputNormal.GetPixel(j % width, j / width).g;
            else
                cl[j].g = 1;
            if (InputNormal != null)
                cl[j].b = InputNormal.GetPixel(j % width, j / width).a;
            else
                cl[j].b = 1;
            if (1 == 1)
            {
                //cl[j].a = InputNormal.GetPixel(j % width, j / width).b;

                cl[j].a = 1 - InputNormal.GetPixel(j % width, j / width).b;

            }

        }

        return cl;

    }

    public Texture2D ShowTexGUI(string fieldName,Texture2D texture)
    {

        return (Texture2D)EditorGUILayout.ObjectField(fieldName, texture, typeof(Texture2D), false);

    }

}
