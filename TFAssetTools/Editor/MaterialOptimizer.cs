using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class MaterialOptimizer : EditorWindow
{
    public Texture TFLogo;

    //Pulled over from normalmapconverter
    public Texture2D InputNormal, maskMap, Output;
    public string textureName = "Untitled"; //set automatically
    public int width, height;

    public bool NowAlbedo, NowNormal;

    public bool CrunchCompress = true;

    [Range(0, 100)] public float QualityLevel = 75f;

    [Range(0, 100)] public int JpegQuality = 75;

    public bool JpegMaps = false;

    public bool JpegAlbedos = false;

    public bool PackTFAtlas = true;

    public Material[] MaterialsToCompress;

    //UI Scrolling
    public Vector2 scrollPos;

    public float Progress;
    public int Step, MaxStep;

    private string path //To get input normal asset path
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


    [MenuItem("Titanfall Asset Tools/Materials/Material Optimizer")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(MaterialOptimizer));

    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));

    }

    private void OnGUI()
    {
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

        //GUILayout.Label(TFLogo);
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Automatically goes through batches of materials \nand compresses textures to use less file size & ram");

        GUILayout.Space(15f);
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        //Materials:

        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialTex = serialObj.FindProperty("MaterialsToCompress");

        EditorGUILayout.PropertyField(serialTex, true);
        serialObj.ApplyModifiedProperties();

        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        //Options:
        GUILayout.Space(15f);
        GUILayout.Label("Compression Settings:");
        CrunchCompress = GUILayout.Toggle(CrunchCompress, "Crunch Compress Textures");

        if (CrunchCompress)
        {
            GUILayout.Label("Quality Level ("+ Mathf.Round(QualityLevel) + " / 100)");
            QualityLevel = GUILayout.HorizontalSlider(QualityLevel, 0, 100);
            GUILayout.Space(15f);
        }
        PackTFAtlas = GUILayout.Toggle(PackTFAtlas, "Pack GLS, AO & CAV maps into a single texture (Requires Titanfall Shader)");
        JpegMaps = GUILayout.Toggle(JpegMaps, "Convert all extra maps to jpegs (Lossy)");
        JpegAlbedos = GUILayout.Toggle(JpegAlbedos, "Convert all opaque albedos to jpegs (Lossy)");
        if (JpegAlbedos || JpegMaps)
        {
            GUILayout.Label("Jpeg Quality Level (" + JpegQuality + " / 100)");
            JpegQuality = Mathf.RoundToInt(GUILayout.HorizontalSlider(JpegQuality, 0, 100));
            GUILayout.Space(15f);
        }
        GUILayout.Space(25f);

        //Activation
        if (GUILayout.Button("Compress") && MaterialsToCompress.Length > 0)
        {
            if (JpegAlbedos || JpegMaps)
            {
                if (EditorUtility.DisplayDialog("WARNING:", "Compressing textures to jpegs irreversibly replaces them. Make backups if you need to.", "cool bro 👍", "Cancel :,("))
                {
                    //Debug.Log("Started");
                    BatchCompress();
                }
            }
            else
            {
                BatchCompress();
            }
        }

        GUILayout.Space(10f);
        GUILayout.Label("Warning:\nThis tool can take a long time to finish as it has\n to process every texture in the inputted materials\n\n\nThis tool was primarily designed & tested with\nStandard & Standard (Specular Setup) shaders in mind\nOther shaders may not be fully compatible, and textures\ncould get overlooked or cause errors.");

        EditorGUILayout.EndScrollView();
    }

    public void BatchCompress()
    {
        Progress = -1;
        foreach (Material CurrentMat in MaterialsToCompress)
        {
            //Progress display
            Progress++;
            Step = 0;
            UpdateProgress();

            string[] properties = CurrentMat.GetTexturePropertyNames();

            MaxStep = properties.Length;

            for (int i = 0; i< properties.Length; i++)
            {
                //Debug.Log(properties[i] + " == _MainTex : " + properties[i] == "_MainTex");
                
                Shader swapShader = CurrentMat.shader == Shader.Find("TITANFALL/Standard") ? Shader.Find("TITANFALL/Standard Optimized") : CurrentMat.shader == Shader.Find("Hidden/TITANFALL/Transparent/Standard") ? Shader.Find("Hidden/TITANFALL/Transparent/Standard Optimized") : null;

                if (swapShader != null) {
                    TFShaderUtils.OptimizeShaderFromMat(swapShader, CurrentMat);
                }

                OptimizeTex(properties[i], CurrentMat, properties[i] == "_MainTex");
                UpdateProgress();
            }
/*
            //Albedo
            OptimizeTex("_MainTex", CurrentMat, true);
            UpdateProgress();
            //Normal
            OptimizeTex("_BumpMap", CurrentMat, false);
            UpdateProgress();
            //Metallic
            OptimizeTex("_MetallicGlossMap", CurrentMat, false);    //  skip progress update since you can't have both metallic & spec
            //Specular
            OptimizeTex("_SpecGlossMap", CurrentMat, false);
            UpdateProgress();
            //AO
            OptimizeTex("_OcclusionMap", CurrentMat, false);
            UpdateProgress();
            //Height
            OptimizeTex("_ParallaxMap", CurrentMat, false);
            UpdateProgress();
            //Emission
            OptimizeTex("_EmissionMap", CurrentMat, false);
            UpdateProgress();
            //Detail Mask
            OptimizeTex("_DetailMask", CurrentMat, false);
            UpdateProgress();
            //Detail Albedo
            OptimizeTex("_DetailAlbedoMap", CurrentMat, false);
            UpdateProgress();
            //Detail Normal
            OptimizeTex("_DetailNormalMap", CurrentMat, false);*/
        }

        EditorUtility.ClearProgressBar();
        Debug.Log("<color=lime>PROCESSING COMPLETE!</color> <color=white>" + MaterialsToCompress.Length + " MATERIALS COMPRESSED!</color>");
    }

    void OptimizeTex(string propertyName, Material currentMat, bool albedo)
    {
        if (currentMat.GetTexture(propertyName) != null)
        {
            if (albedo)
                NowAlbedo = true;
            InputNormal = currentMat.GetTexture(propertyName) as Texture2D;
            PackTextures(currentMat);
            NowAlbedo = false;
            currentMat.SetTexture(propertyName, Output);
        }
    }


    //Copied from NormalMapConverter as template
    private void PackTextures(Material currentMat)//Start of conversion process
    {
        if (InputNormal != null)
        {
            width = InputNormal.width;
            height = InputNormal.height;

            textureName = InputNormal.name;
        }

        FixInput();

        maskMap = InputNormal;

        //Chooses if to convert map to jpeg depending on map type and whether albedo is transparent if its an albedo
        if ((NowAlbedo && currentMat.renderQueue < 2450 && JpegAlbedos) || (!NowAlbedo && JpegMaps))
        {
            CompressAsJpeg();
        }
        else
        {
            Output = InputNormal;
        }

        FixOutput();

        if (InputNormal != Output)
        {
            AssetDatabase.DeleteAsset(AssetDatabase.GetAssetPath(InputNormal));
        }

        AssetDatabase.Refresh();

    }
    private Color[] ColorArray() //Where the magic happens, fips around the color channels
    {

        Color[] cl = new Color[width * height];

        for (int j = 0; j < cl.Length; j++)
        {

            cl[j] = new Color();

            cl[j] = InputNormal.GetPixel(j % width, j / width);

        }

        return cl;

    }

    private void FixInput() //Does as title suggests
    {
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal));
        A.isReadable = true;
        A.textureCompression = TextureImporterCompression.Uncompressed;
        if (A.textureType == TextureImporterType.NormalMap)
        {
            NowNormal = true;
            A.textureType = TextureImporterType.Default;
        }

        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)InputNormal), ImportAssetOptions.ForceUpdate);
        InputNormal = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)InputNormal), typeof(Texture2D));
    }

    private void FixOutput() //Does as title suggests
    {
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((Object)Output));
        A.isReadable = true;
        A.textureCompression = TextureImporterCompression.Compressed;

        if (NowNormal)
        {
            NowNormal = false;
            A.textureType = TextureImporterType.NormalMap;
        }

        //Here is where crunch compression is applied
        if (CrunchCompress)
        {
            A.crunchedCompression = true;
            A.compressionQuality = Mathf.RoundToInt(QualityLevel);
        }
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((Object)Output), ImportAssetOptions.ForceUpdate);
        Output = (Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((Object)Output), typeof(Texture2D));
    }

    private void CompressAsJpeg()
    {
        maskMap.SetPixels(ColorArray());

        byte[] tex = maskMap.EncodeToJPG(JpegQuality); //JPG

        FileStream stream = new FileStream(path + textureName + ".jpg", FileMode.OpenOrCreate, FileAccess.ReadWrite);
        BinaryWriter writer = new BinaryWriter(stream);
        for (int j = 0; j < tex.Length; j++)
            writer.Write(tex[j]);

        writer.Close();
        stream.Close();


        AssetDatabase.ImportAsset(path + textureName + ".jpg", ImportAssetOptions.ForceUpdate);
        Output = (Texture2D)AssetDatabase.LoadAssetAtPath(path + textureName + ".jpg", typeof(Texture2D));
    }

    private void UpdateProgress()
    {
        Step++;
        EditorUtility.DisplayProgressBar("Processing Textures, this will take a while.", "Compressed (" + Progress + " / " + MaterialsToCompress.Length + ") Sub Step: (" + Step + " / "+ MaxStep +")", Progress / MaterialsToCompress.Length);
    }
}
