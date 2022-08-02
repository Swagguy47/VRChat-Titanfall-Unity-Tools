using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class NormalConverter : EditorWindow
{

    public Texture TFLogo;

    public Texture2D InputNormal, maskMap;
    public string textureName = "Untitled"; //set automatically
    public int width, height;
    public bool inverseSmoothness;
    public bool replaceInput = false;
    public bool AutoFix = true;
    public bool OutputFix = true;
    public bool OutputPNG = false; //If false, encode jpg
    public bool CopyCompression = false;
    public TextureImporterCompression InputCompression; //For copy compression
    public Texture2D Output; //for post process effects

    //Batch params
    public int selected; //Input Method
    public Texture2D[] InputTextures;
    public Material[] InputMaterials;
    public Vector2 scrollPos;

    private string path //To get input normal asset path
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
        if (selected != 0) //scrolling for batch
        {
            EditorGUILayout.BeginVertical();
            scrollPos = EditorGUILayout.BeginScrollView(scrollPos);
        }
        
        //UI
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Converts yellow normal maps to standard\npurple ones, especially useful for Quest");
        GUILayout.Space(10f);

        string[] options = new string[]
           {
                "Individual Texture", "Multiple Textures", "Multiple Materials",
           };

        //BATCH SETTING
        selected = EditorGUILayout.Popup("Method:", selected, options);

        //Methods:
        if (selected == 0) //Individual texture
        {
            InputNormal = ShowTexGUI("Input (Yellow) Normal Map:", InputNormal);
        }
        else if (selected == 1) //Multiple textures
        {
            GUILayout.Space(5f);
            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
            //Array field
            ScriptableObject scriptableObj = this;
            SerializedObject serialObj = new SerializedObject(scriptableObj);
            SerializedProperty serialTex = serialObj.FindProperty("InputTextures");

            EditorGUILayout.PropertyField(serialTex, true);
            serialObj.ApplyModifiedProperties();
            //-----
            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
            GUILayout.Space(5f);
        }
        else if (selected == 2) //Multiple materials
        {
            GUILayout.Space(5f);
            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
            //Array field
            ScriptableObject scriptableObj = this;
            SerializedObject serialObj = new SerializedObject(scriptableObj);
            SerializedProperty serialMat = serialObj.FindProperty("InputMaterials");

            EditorGUILayout.PropertyField(serialMat, true);
            serialObj.ApplyModifiedProperties();
            //-----
            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
            GUILayout.Space(5f);
        }
        AutoFix = GUILayout.Toggle(AutoFix, "Automatically Setup Input Texture");
        OutputFix = GUILayout.Toggle(OutputFix, "Setup Output Texture");
        OutputPNG = GUILayout.Toggle(OutputPNG, "Encode Output as PNG");
        replaceInput = GUILayout.Toggle(replaceInput, "Replace Input Texture");
        if(OutputFix && AutoFix)
        {
            CopyCompression = GUILayout.Toggle(CopyCompression, "Copy Input Compression");
        }


        //inverseSmoothness = EditorGUILayout.Toggle("Inverse Smoothness", inverseSmoothness);
        if(AutoFix != true)
        {
            if (GUILayout.Button("(Manual) Setup Input Texture") && InputNormal != null)
            {
                FixInput();
                Debug.Log(InputNormal.name + " Now ready for use!");
            }
        }
        if (selected == 0) //Regular conversion & batch conversion buttons
        {
            if (GUILayout.Button("Convert Normal Map") && InputNormal != null)
            {
                PackTextures();
                Debug.Log(path);
            }
        }
        else
        {
            if (GUILayout.Button("Batch Convert Normal Maps"))
            {
                Debug.Log("Batch conversion in process");
                BatchConvert();
            }
        }
        
        if (replaceInput)
        {
            GUILayout.Space(5f);
            GUILayout.Label("This has no undo");
            GUILayout.Space(5f);
        }

        GUILayout.Label("Notice:\nHigh input compression settings may\nimpact conversion speed");

        if (selected != 0)
        {
            GUILayout.Space(5f);
            GUILayout.Label("Tip:\nSelect all assets you want to batch\nconvert and drag them over the array label");
            
            //Batch scroll view
            GUILayout.Space(5f);
            EditorGUILayout.EndScrollView();
            EditorGUILayout.EndVertical();
        }
    }

    private void PackTextures()//Start of conversion process
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
        
        if(replaceInput == false)
        {
            maskMap = new Texture2D(width, height);
        }
        else if (replaceInput == true)//just to be safe
        {
            maskMap = InputNormal;
        }


        maskMap.SetPixels(ColorArray());
        
        if(OutputPNG == true) //PNG
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
    private Color[] ColorArray() //Where the magic happens, fips around the color channels
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

    private void FixInput() //Does as title suggests
    {
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal));
        A.isReadable = true;
        A.textureType = TextureImporterType.Default; //This is nolonger being used as Normal Map to prevent output miscoloration
        if(replaceInput == true)
        {
            if(CopyCompression == true)
            {
                InputCompression = A.textureCompression;
            }
            A.textureCompression = TextureImporterCompression.Uncompressed;
        }
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)InputNormal), ImportAssetOptions.ForceUpdate);
        InputNormal = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal), typeof(Texture2D));
    }

    private void FixOutput() //Does as title suggests
    {
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)Output));
        A.isReadable = true;
        A.textureType = TextureImporterType.NormalMap;
        if(CopyCompression == true)
        {
            A.textureCompression = InputCompression;
        }
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)Output), ImportAssetOptions.ForceUpdate);
        Output = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)Output), typeof(Texture2D));
    }

    public Texture2D ShowTexGUI(string fieldName,Texture2D texture) //Honestly forgot what this does
    {

        return (Texture2D)EditorGUILayout.ObjectField(fieldName, texture, typeof(Texture2D), false);

    }


    public void BatchConvert()
    {
        if (selected == 1) //batch textures
        {
            foreach (Texture2D CurrentTex in InputTextures)
            {
                InputNormal = CurrentTex;
                PackTextures();
            }
            Debug.Log("Batch Conversion FINISHED!");
        }
        else if (selected == 2) //batch materials
        {
            foreach (Material CurrentMat in InputMaterials)
            {
                InputNormal = CurrentMat.GetTexture("_BumpMap") as Texture2D;
                PackTextures();
            }
            Debug.Log("Batch Conversion FINISHED!");
        }
    }

}
