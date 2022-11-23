using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class CamoGenerator : EditorWindow
{

    public Texture TFLogo;
    public Texture HelpImg;

    public Texture2D InputNormal, maskMap, InputMask, InputCamo, Overlay;
    public string textureName = "Untitled"; //set automatically
    public int width, height, CamoWidth, CamoHeight, CamoTileX, CamoTileY;
    public bool inverseSmoothness;
    public bool OutputPNG = true; //If false, encode jpg
    public TextureImporterCompression InputCompression; //For copy compression
    public Texture2D Output; //for post process effects

    //CrunchCompression
    public bool CrunchCompressOutput;
    public int CrunchQuality = 75;

    public Color CamoColor = Color.white;
    public bool Recolor;

    //Batch params
    public bool FixMasks;
    public Texture2D[] InputSkin31Albedos; //Skin31
    public Texture2D[] InputMasks; //Mask
    public Texture2D[] InputCamos; //Camos
    public int CurrentTexture;
    public float Progress;
    public Vector2 scrollPos;

    public int JpegQuality = 80;

    public bool MakeMats;
    public Material CurrentMat;

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
    
    [MenuItem("Titanfall Asset Tools/Camos/Camo Texture Generator")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(CamoGenerator));
    }

    private void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
        HelpImg = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFCamoTool.png", typeof(Texture));
    }

    public void OnGUI()
    {
        //Scrolling
        //EditorGUILayout.BeginVertical();
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

        //UI
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        //Texture examples image
        GUI.DrawTexture(new Rect(10, 75, 230, 90), HelpImg, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(100f);

        GUILayout.Label("Generates new textures with\ncamos properly applied");
        GUILayout.Space(10f);

        GUILayout.Space(5f);
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        //Array field
        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialTex = serialObj.FindProperty("InputSkin31Albedos");

        EditorGUILayout.PropertyField(serialTex, true);
        serialObj.ApplyModifiedProperties();
        //-----
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        //Array field
        ScriptableObject scriptableObj1 = this;
        SerializedObject serialObj1 = new SerializedObject(scriptableObj);
        SerializedProperty serialTex1 = serialObj.FindProperty("InputMasks");

        EditorGUILayout.PropertyField(serialTex1, true);
        serialObj.ApplyModifiedProperties();
        //-----
        GUILayout.Label("Masks must be in the same order as their\n albedo counterparts.");
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        //Array field
        ScriptableObject scriptableObj2 = this;
        SerializedObject serialObj2 = new SerializedObject(scriptableObj);
        SerializedProperty serialTex2 = serialObj.FindProperty("InputCamos");

        EditorGUILayout.PropertyField(serialTex2, true);
        serialObj.ApplyModifiedProperties();
        //-----

        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        GUILayout.Space(5f);

        //Recolor Instead of camo if there are no camo textures
        if (InputCamos == null)
        {
            GUILayout.Label("Camo Color:");
            CamoColor = EditorGUILayout.ColorField(CamoColor);
            Recolor = true;
        }
        else if (InputCamos.Length < 1)
        {
            GUILayout.Label("Camo Color:");
            CamoColor = EditorGUILayout.ColorField(CamoColor);
            Recolor = true;
        }
        else if (InputCamos.Length > 0)
        {
            Recolor = false;
        }

        OutputPNG = GUILayout.Toggle(OutputPNG, "Encode Output as PNG");
        if (!OutputPNG)
        {
            GUILayout.Label("Jpeg Quality Level:");
            JpegQuality = EditorGUILayout.IntSlider(JpegQuality, 0, 100);
            GUILayout.Space(15f);
        }
        MakeMats = GUILayout.Toggle(MakeMats, "Generate Materials");

        //CrunchCompressOutput = GUILayout.Toggle(CrunchCompressOutput, "Crunch Compress Output");

        if (CrunchCompressOutput)
        {
            GUILayout.Label("Compression Quality Level:");
            CrunchQuality = EditorGUILayout.IntSlider(CrunchQuality, 0, 100);
            GUILayout.Space(15f);
        }

        //Start button
        if (GUILayout.Button("Generate") && InputSkin31Albedos.Length == InputMasks.Length)
        {
            BatchConvert();
            //Debug.Log(path);
        }

        GUILayout.Label("\nThis may take awhile if you inputted a lot\n of textures, so sit back and get cozy\n");
        
//Annoying it has to be this complicated for a simple label but assuming the array has a length throws errors
        if (InputCamos != null && InputMasks != null && InputSkin31Albedos != null)
        {
            GUILayout.Label("(This will generate " + (InputCamos.Length * InputMasks.Length) + " new textures)");
        }
        
        EditorGUILayout.EndScrollView();
    }

    private void PackTextures()//Start of conversion process
    {
        if (InputNormal != null)
        {
            width = InputNormal.width;
            height = InputNormal.height;

            if (!Recolor)
            {
                CamoWidth = InputCamo.width;
                CamoHeight = InputCamo.height;

                CamoTileX = width / CamoWidth;
                CamoTileY = height / CamoHeight;
            }

            if (!Recolor)
            {
                textureName = InputNormal.name + "_Camo_" + InputCamo.name;
            }
            else
            {
                textureName = InputNormal.name + "_Recolor_" + CamoColor;
            }
        }
        FixInput();

        //Sets the texture that will be written to:
        maskMap = new Texture2D(width, height);


        maskMap.SetPixels(ColorArray());
        
        if (FixMasks && !AssetDatabase.IsValidFolder(path + "Camos"))
        {
            AssetDatabase.CreateFolder(path.Substring(0, path.Length - 1), "Camos");
        }

        if (OutputPNG) //PNG
        {
            byte[] tex = maskMap.EncodeToPNG();

            FileStream stream = new FileStream(path + "Camos/" + textureName + ".png", FileMode.OpenOrCreate, FileAccess.ReadWrite);
            BinaryWriter writer = new BinaryWriter(stream);
            for (int j = 0; j < tex.Length; j++)
                writer.Write(tex[j]);

            writer.Close();
            stream.Close();

            AssetDatabase.ImportAsset(path + "Camos/" + textureName + ".png", ImportAssetOptions.ForceUpdate);
            Output = (Texture2D)AssetDatabase.LoadAssetAtPath(path + "Camos/" + textureName + ".png", typeof(Texture2D));

        }
        else
        {
            byte[] tex = maskMap.EncodeToJPG(JpegQuality); //JPG

            FileStream stream = new FileStream(path + "Camos/" + textureName + ".jpg", FileMode.OpenOrCreate, FileAccess.ReadWrite);
            BinaryWriter writer = new BinaryWriter(stream);
            for (int j = 0; j < tex.Length; j++)
                writer.Write(tex[j]);

            writer.Close();
            stream.Close();

            AssetDatabase.ImportAsset(path + "Camos/" + textureName + ".jpg", ImportAssetOptions.ForceUpdate);
            Output = (Texture2D)AssetDatabase.LoadAssetAtPath(path + "Camos/" + textureName + ".jpg", typeof(Texture2D));

        }

        //FixOutput();

        //Generating Materials
        if (MakeMats)
        {
            var material = new Material(Shader.Find("Standard"));
            AssetDatabase.CreateAsset(material, path + "Camos/" + textureName + "_mat" + ".mat");
            CurrentMat = (Material)AssetDatabase.LoadAssetAtPath(path + "Camos/" + textureName + "_mat" + ".mat", typeof(Material));
            CurrentMat.mainTexture = Output;

            //Attempts to find extra maps, assuming they use a consistent naming scheme
            if (AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_nml" + ".png", typeof(Texture2D)) != null)
            {
                CurrentMat.SetTexture("_BumpMap", (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_nml" + ".png", typeof(Texture2D)));
            }
            else if (AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_nml" + ".jpg", typeof(Texture2D)) != null)
            {
                CurrentMat.SetTexture("_BumpMap", (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_nml" + ".jpg", typeof(Texture2D)));
            }

            if (AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_spc" + ".png", typeof(Texture2D)) != null)
            {
                CurrentMat.SetTexture("_SpecGlossMap", (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_spc" + ".png", typeof(Texture2D)));
            }
            else if (AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_spc" + ".jpg", typeof(Texture2D)) != null)
            {
                CurrentMat.SetTexture("_SpecGlossMap", (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_spc" + ".jpg", typeof(Texture2D)));
            }

            if (AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_ilm" + ".png", typeof(Texture2D)) != null)
            {
                CurrentMat.SetTexture("_EmissionMap", (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_ilm" + ".png", typeof(Texture2D)));
            }
            else if(AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_ilm" + ".jpg", typeof(Texture2D)) != null)
            {
                CurrentMat.SetTexture("_EmissionMap", (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName.Substring(0, textureName.Length - 25) + "_ilm" + ".jpg", typeof(Texture2D)));
            }
        }

        AssetDatabase.Refresh();

    }
    private Color[] ColorArray() //Tiles camo texture and masks it out, then adds that to the skin31
    {

        Color[] cl = new Color[width * height];

        for(int j = 0;j < cl.Length;j++)
        {
            //'InputNormal' actually is the skin31, I was too lazy to rename

            cl[j] = new Color();

            if (!Recolor)
            {
                //All the magic
                cl[j] = InputNormal.GetPixel(j % width, j / width) + (InputCamo.GetPixel(j % CamoWidth, j / height) * InputMask.GetPixel(j % width, j / width));
            }
            else //Recolor camo
            {
                cl[j] = InputNormal.GetPixel(j % width, j / width) + (CamoColor * InputMask.GetPixel(j % width, j / width));
            }

            //Alpha
            cl[j].a = InputNormal.GetPixel(j % width, j / width).a;
        }

        return cl;

    }

    private void FixInput() //Does as title suggests
    {
        if (FixMasks)
        {
            //Skin31
            TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal));
            A.isReadable = true;
            A.crunchedCompression = false;

            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)InputNormal), ImportAssetOptions.ForceUpdate);
            InputNormal = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal), typeof(Texture2D));
            //Mask
            TextureImporter B = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)InputMask));
            B.isReadable = true;
            B.crunchedCompression = false;

            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)InputMask), ImportAssetOptions.ForceUpdate);
            InputMask = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)InputMask), typeof(Texture2D));
        }
        if (!Recolor)
        {
            //Camo
            TextureImporter C = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)InputCamo));
            C.isReadable = true;
            C.crunchedCompression = false;

            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)InputCamo), ImportAssetOptions.ForceUpdate);
            InputCamo = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)InputCamo), typeof(Texture2D));
        }
    }

    private void FixOutput() //Does as title suggests
    {
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)Output));
        A.isReadable = true;
        if (CrunchCompressOutput)
        {
            A.crunchedCompression = true;
            A.compressionQuality = CrunchQuality;
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
        CurrentTexture = -1;
        Progress = InputCamos.Length * InputSkin31Albedos.Length;
        foreach (Texture2D CurrentTex in InputSkin31Albedos)
        {
            FixMasks = true;
            CurrentTexture++;

            InputNormal = CurrentTex;
            InputMask = InputMasks[CurrentTexture];
            if (!Recolor)
            {
                foreach (Texture2D CamoTex in InputCamos)
                {
                    InputCamo = CamoTex;
                    PackTextures();

                    FixMasks = false;

                    //Progress logs
                    Progress--;

                    EditorUtility.DisplayProgressBar("Processing Camos...", "Outputted:" + (Mathf.Abs(Progress - (InputCamos.Length * InputSkin31Albedos.Length))) + "/" + InputCamos.Length * InputSkin31Albedos.Length + " Current Texture: " + InputNormal.name, (Mathf.Abs(Progress - (InputCamos.Length * InputSkin31Albedos.Length)) / (InputCamos.Length * InputSkin31Albedos.Length)));
                    //Debug.Log("Processing Camos... Outputted:" + Progress + "/" + InputCamos.Length * InputSkin31Albedos.Length + "\nCurrent Texture: " + InputNormal.name + " With Camo: " + InputCamo.name);
                }
            }
            else // Recoloring camo
            {
                PackTextures();
                Progress--;
                EditorUtility.DisplayProgressBar("Processing Camos...", "Outputted:" + (Mathf.Abs(Progress - (InputSkin31Albedos.Length))) + "/" + InputSkin31Albedos.Length + " Current Texture: " + InputNormal.name, (Mathf.Abs(Progress - (InputSkin31Albedos.Length)) / (InputSkin31Albedos.Length)));
            }
        }
        EditorUtility.ClearProgressBar();
        if (!Recolor)
        {
            Debug.Log("<color=lime>PROCESSING COMPLETE!</color> <color=white>" + (InputCamos.Length * InputSkin31Albedos.Length) + " TEXTURES FINALIZED!</color>");
        }
        else
        {
            Debug.Log("<color=lime>PROCESSING COMPLETE!</color> <color=white>" + InputSkin31Albedos.Length + " TEXTURES RECOLORED!</color>");
        }
    }

}
