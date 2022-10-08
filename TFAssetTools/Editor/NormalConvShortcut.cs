using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public static class NormalConvShortcut
{
    new static Texture2D InputNormal, maskMap;
    new static string textureName = "Untitled"; //set automatically
    new static int width, height;
    new static bool inverseSmoothness;
    new static bool replaceInput = true;
    new static bool AutoFix = true;
    new static bool OutputFix = true;
    new static bool OutputPNG = false; //If false, encode jpg
    new static bool CopyCompression = true;
    new static TextureImporterCompression InputCompression; //For copy compression
    new static Texture2D Output; //for post process effects

    //Batch params
    new static Texture2D[] InputTextures;
    new static Material[] InputMaterials;
    new static Vector2 scrollPos;

    new static float Progress;

    new static string path //To get input normal asset path
    {
        get
        {
            string a = "";
            if (InputNormal != null)
            {
                a = AssetDatabase.GetAssetPath((Object)InputNormal);
                a = a.Substring(0, a.IndexOf(((Object)InputNormal).name));
                return a;

            }
            return a;
        }
    }

    private static void PackTextures()//Start of conversion process
    {
        if (InputNormal != null)
        {
            width = InputNormal.width;
            height = InputNormal.height;

            if (replaceInput == false)
            {
                textureName = InputNormal.name + "_Converted";
            }
            else
            {
                textureName = InputNormal.name;
            }
        }


        if (AutoFix == true)
        {
            FixInput();
        }

        if (replaceInput == false)
        {
            maskMap = new Texture2D(width, height);
        }
        else if (replaceInput == true)//just to be safe
        {
            maskMap = InputNormal;
        }


        maskMap.SetPixels(ColorArray());

        if (OutputPNG == true) //PNG
        {
            byte[] tex = maskMap.EncodeToPNG();

            FileStream stream = new FileStream(path + textureName + ".png", FileMode.OpenOrCreate, FileAccess.ReadWrite);
            BinaryWriter writer = new BinaryWriter(stream);
            for (int j = 0; j < tex.Length; j++)
                writer.Write(tex[j]);

            writer.Close();
            stream.Close();


            AssetDatabase.ImportAsset(path + textureName + ".png", ImportAssetOptions.ForceUpdate);
            Output = (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName + ".png", typeof(Texture2D));

        }
        else
        {
            byte[] tex = maskMap.EncodeToJPG(); //JPG

            FileStream stream = new FileStream(path + textureName + ".jpg", FileMode.OpenOrCreate, FileAccess.ReadWrite);
            BinaryWriter writer = new BinaryWriter(stream);
            for (int j = 0; j < tex.Length; j++)
                writer.Write(tex[j]);

            writer.Close();
            stream.Close();


            AssetDatabase.ImportAsset(path + textureName + ".jpg", ImportAssetOptions.ForceUpdate);
            Output = (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName + ".jpg", typeof(Texture2D));

        }
        if (OutputFix == true)
        {
            FixOutput();
        }

        if (replaceInput == true)//to handle formats different than output
        {
            if (InputNormal != Output)
            {
                AssetDatabase.DeleteAsset(AssetDatabase.GetAssetPath(InputNormal));
            }
        }

        AssetDatabase.Refresh();

    }
    new static Color[] ColorArray() //Where the magic happens, fips around the color channels
    {

        Color[] cl = new Color[width * height];

        for (int j = 0; j < cl.Length; j++)
        {

            cl[j] = new Color();
            if (InputNormal != null)
                cl[j].r = InputNormal.GetPixel(j % width, j / width).r;
            else
                cl[j].r = 1;
            if (InputNormal != null)
                cl[j].g = 1 - InputNormal.GetPixel(j % width, j / width).g;
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

    private static void FixInput() //Does as title suggests
    {
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal));
        A.isReadable = true;
        A.textureType = TextureImporterType.Default; //This is nolonger being used as Normal Map to prevent output miscoloration
        if (replaceInput == true)
        {
            if (CopyCompression == true)
            {
                InputCompression = A.textureCompression;
            }
            A.textureCompression = TextureImporterCompression.Uncompressed;
        }


        //Figures out which format it is so it can be outputted the same format.
        if (A.assetPath.Substring(A.assetPath.Length - 4) == ".png")
        {
            OutputPNG = true;
        }
        else
        {
            OutputPNG = false;
        }
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)InputNormal), ImportAssetOptions.ForceUpdate);
        InputNormal = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal), typeof(Texture2D));
    }

    private static void FixOutput() //Does as title suggests
    {
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)Output));
        A.isReadable = true;
        A.textureType = TextureImporterType.NormalMap;
        if (CopyCompression == true)
        {
            A.textureCompression = InputCompression;
        }
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)Output), ImportAssetOptions.ForceUpdate);
        Output = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)Output), typeof(Texture2D));
    }

    new static Texture2D ShowTexGUI(string fieldName, Texture2D texture) //Honestly forgot what this does
    {

        return (Texture2D)EditorGUILayout.ObjectField(fieldName, texture, typeof(Texture2D), false);

    }


    [MenuItem("Assets/- Titanfall Tool Shortcuts -/Convert Normal Map(s)")]
    public static void BatchConvert()
    {
        Progress = 0;
        foreach (Texture2D CurrentTex in Selection.objects)
        {
            InputNormal = CurrentTex;

            PackTextures();
            Progress++;
            //EditorUtility.DisplayProgressBar("Batch Converting Normal Maps", "Progress: ( " + Progress + " / " + InputTextures.Length + " )", Progress / InputTextures.Length);
        }
        //EditorUtility.ClearProgressBar();
    }
}
