using System.IO;
using UnityEditor;
using UnityEngine;


public class TFShaderUtils : Editor
{
    public enum ShaderTypes
    {
        Opaque = 0,
        Transparent = 1,
    }

    public enum TerrainShaderTypes
    {
        OneChannel = 0,
        TwoChannels = 1,
        ThreeChannels = 2,
        Transparent = 3,
        Debug = 4,
    }

    public static string[] shaderNames = {
            "TITANFALL/Terrain",
            "Hidden/TITANFALL/Terrain (Two Blends)",
            "Hidden/TITANFALL/Terrain (Three Blends)",
            "Hidden/TITANFALL/Terrain (Transparent)",
            "Hidden/TITANFALL/VColDebug" };

    public static void UnOptimizeShader(string shader, MaterialEditor editor, MaterialProperty[] properties)
    {
        //  Get output
        Texture2D atlas = null;

        for (int i = 0; i < properties.Length; i++)
        {
            if (properties[i].name == "_Atlas")
                atlas = (Texture2D)properties[i].textureValue;
        }

        ChangeShader(shader, editor);

        //  failsafe if there is no output texture
        if (atlas == null)
            return;

        FixInput(atlas);

        //  overwrite prompt
        if (!EditorUtility.DisplayDialog("Overwrite existing texture fields?", "Unpack the atlased channels into individual textures, and repopulate the Gloss, Cavity & Ambient Occlusion fields accordingly. Note: No files are being replaced.", "Unpack", "Use Existing"))
            return;

        //  output path
        string path = Path.GetDirectoryName(AssetDatabase.GetAssetPath(atlas)) + "/Unpack_";

        //  R Progress
        float progress = 0;
        string desc = "Extracting Gloss from Red channel...";
        EditorUtility.DisplayProgressBar("Unpacking!", desc, progress);
        //  R Output
        Texture2D gls = UnpackTexture(atlas, Color.red, path + "Gls.jpg");
        
        //  G Progress
        progress = 0.33f;
        desc = "Extracting Cavity from Green channel...";
        EditorUtility.DisplayProgressBar("Unpacking!", desc, progress);
        //  G Output
        Texture2D cav = UnpackTexture(atlas, Color.green, path + "Cav.jpg");
        
        //  B Progress
        progress = 0.66f;
        desc = "Extracting Ambient Occlusion from Blue channel...";
        EditorUtility.DisplayProgressBar("Unpacking!", desc, progress);
        //  B Output
        Texture2D ao = UnpackTexture(atlas, Color.blue, path + "Ao.jpg");

        //  setup output
        for (int i = 0; i < properties.Length; i++)
        {
            if (properties[i].name == "_Atlas")
                atlas = (Texture2D)properties[i].textureValue;
        }
        SetTexture("_GlossMap", gls, properties, editor);
        SetTexture("_ParallaxMap", cav, properties, editor);
        SetTexture("_OcclusionMap", ao, properties, editor);

        EditorUtility.ClearProgressBar();
    }

    static void SetTexture(string name, Texture value, MaterialProperty[] properties, MaterialEditor editor)
    {
        bool set = false;
        for (int i = 0; i < properties.Length; i++)
        {
            if (properties[i].name == name) {
                properties[i].textureValue = value;
                set = true;
            }
        }
        //  failsafe
        if (set)
            return;
#pragma warning disable
        //  SetTexture is obsolete
        editor.SetTexture(name, value);
#pragma warning restore 
    }

    public static void OptimizeShaderFromMat(Shader to, Material mat)
    {
        //  get textures
        string[] properties = mat.GetTexturePropertyNames();

        Texture2D gls = null, cav = null, ao = null;
        for (int i = 0; i < properties.Length; i++)
        {
            switch (properties[i])
            {
                case "_GlossMap":
                    {
                        gls = (Texture2D)mat.GetTexture(properties[i]);
                        break;
                    }
                case "_ParallaxMap":
                    {
                        cav = (Texture2D)mat.GetTexture(properties[i]);
                        break;
                    }
                case "_OcclusionMap":
                    {
                        ao = (Texture2D)mat.GetTexture(properties[i]);
                        break;
                    }
            }
        }

        //  ensure texture readability
        FixInput(gls);
        FixInput(cav);
        FixInput(ao);

        Texture2D scaler = null;
        scaler = gls ? gls : cav ? cav : ao ? ao : null;

        if (!scaler)
        {
            Debug.LogWarning("No textures to pack! Aborting");
            return;
        }

        //  output path
        string path = Path.GetDirectoryName(AssetDatabase.GetAssetPath(scaler)) + "/PackedTex.jpg";

        Texture2D atlas = PackTextures(gls, cav, ao, path, scaler);

        //  swap shader
        mat.shader = to;
        mat.SetTexture("_Atlas", atlas);
    }

    public static void OptimizeShader(Shader to, MaterialEditor editor, MaterialProperty[] properties)
    {
        //  get textures
        Texture2D gls = null, cav = null, ao = null;
        for(int i = 0; i < properties.Length; i++)
        {
            switch (properties[i].name)
            {
                case "_GlossMap": {
                        gls = (Texture2D)properties[i].textureValue;
                        break;
                    }
                case "_ParallaxMap":
                    {
                        cav = (Texture2D)properties[i].textureValue;
                        break;
                    }
                case "_OcclusionMap":
                    {
                        ao = (Texture2D)properties[i].textureValue;
                        break;
                    }
            }
        }

        //  ensure texture readability
        FixInput(gls);
        FixInput(cav);
        FixInput(ao);

        Texture2D scaler = null;
        scaler = gls ? gls : cav ? cav : ao ? ao : null;

        if (!scaler) {
            Debug.LogWarning("No textures to pack! Aborting");
            return;
        }

        //  output path
        string path = Path.GetDirectoryName(AssetDatabase.GetAssetPath(scaler)) + "/PackedTex.jpg";

        Texture2D atlas = PackTextures(gls, cav, ao, path, scaler);

        //  swap shader
        editor.SetShader(to);

        SetTexture("_Atlas", atlas, properties, editor);
        //editor.SetTexture("_Atlas", atlas);
    }

    static Texture2D UnpackTexture(Texture2D atlas, Color mask, string path)
    {
        int width = atlas.width;
        int height = atlas.height;

        Texture2D output = new(width, height);
        Color[] cols = new Color[width * height];

        //  sets up color
        //  could probably be refactored to look less horrendous
        for (int i = 0; i < width * height; i++)
        {
            Color red = new Color(atlas.GetPixel(i % width, i / width).r, atlas.GetPixel(i % width, i / width).r, atlas.GetPixel(i % width, i / width).r);
            Color green = new Color(atlas.GetPixel(i % width, i / width).g, atlas.GetPixel(i % width, i / width).g, atlas.GetPixel(i % width, i / width).g);
            Color blue = new Color(atlas.GetPixel(i % width, i / width).b, atlas.GetPixel(i % width, i / width).b, atlas.GetPixel(i % width, i / width).b);

            cols[i] = mask.r == 1 ? red : mask.g == 1 ? green : blue;
        }

        output.SetPixels(cols);

        //  output jpeg
        byte[] tex = output.EncodeToJPG(100);

        FileStream stream = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite);
        BinaryWriter writer = new BinaryWriter(stream);
        for (int j = 0; j < tex.Length; j++)
            writer.Write(tex[j]);

        writer.Close();
        stream.Close();

        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
        return (Texture2D)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D));
    }

    static Texture2D PackTextures(Texture2D gls, Texture2D cav, Texture2D ao, string path, Texture2D scaleRef)
    {
        int width = scaleRef.width;
        int height = scaleRef.height;

        Texture2D atlas = new(width, height);
        Color[] cols = new Color[width * height];

        for(int i = 0; i < width * height; i++)
        {
            cols[i] = new Color( gls ? gls.GetPixel(i % width, i / width).r : 0.5f, cav ? cav.GetPixel(i % width, i / width).r : 1, ao ? ao.GetPixel(i % width, i / width).r : 1);
        }

        atlas.SetPixels(cols);

        //  output jpeg
        byte[] tex = atlas.EncodeToJPG(100);

        FileStream stream = new FileStream(path, FileMode.OpenOrCreate, FileAccess.ReadWrite);
        BinaryWriter writer = new BinaryWriter(stream);
        for (int j = 0; j < tex.Length; j++)
            writer.Write(tex[j]);

        writer.Close();
        stream.Close();

        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
        return(Texture2D)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D));
    }

    static Texture2D FixInput(Texture2D input)
    {
        if (input == null)
            return null;
        TextureImporter A = (TextureImporter)AssetImporter.GetAtPath(AssetDatabase.GetAssetPath((UnityEngine.Object)input));
        A.isReadable = true;
        A.crunchedCompression = false;

        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath((UnityEngine.Object)input), ImportAssetOptions.ForceUpdate);
        return(Texture2D)AssetDatabase.LoadAssetAtPath(AssetDatabase.GetAssetPath((UnityEngine.Object)input), typeof(Texture2D));
    }


    public static void ChangeShader(string shaderName, MaterialEditor editor)
    {
        Shader to = Shader.Find(shaderName);
        editor.SetShader(to);
    }

    public static void DrawNess()
    {
        Texture ness = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/ShaderNess.png", typeof(Texture));

        if (ness == null)
            return;

        float imageWidth = EditorGUIUtility.currentViewWidth - 40;
        float imageHeight = imageWidth * ness.height / ness.width / 10;

        Rect rect = GUILayoutUtility.GetRect(imageWidth, imageHeight);

        GUI.DrawTexture(rect, ness, ScaleMode.ScaleToFit);
    }

    public static void TerrainHelper()
    {
        GUILayout.Label("(Blending is determined by mesh vertex colors)");
    }

    public static void DrawHeader()
    {
        Texture ness = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));

        if (ness == null)
            return;

        float imageWidth = EditorGUIUtility.currentViewWidth - 40;
        float imageHeight = imageWidth * ness.height / ness.width / 2.5f;

        Rect rect = GUILayoutUtility.GetRect(imageWidth, imageHeight);

        GUI.DrawTexture(rect, ness, ScaleMode.ScaleToFit);
    }

    public static void DrawShaderTypes(string opposite, MaterialEditor editor)
    {
        GUILayout.Label("Rendering Mode:");

        bool isOpaque = opposite.Contains("Hidden");

        TFShaderUtils.ShaderTypes type = (TFShaderUtils.ShaderTypes)(isOpaque ? 0 : 1);

        type = (TFShaderUtils.ShaderTypes)EditorGUILayout.EnumPopup(type);
        
        if (type == TFShaderUtils.ShaderTypes.Transparent && isOpaque)
            TFShaderUtils.ChangeShader(opposite, editor);
        else if (type == TFShaderUtils.ShaderTypes.Opaque && !isOpaque)
            TFShaderUtils.ChangeShader(opposite, editor);
    }

    public static void DrawTerrainShaderTypes(string current, MaterialEditor editor)
    {
        GUILayout.Label("Rendering Mode:");

        var currentType = 0;

        //  switch statement replaced
        for(int i = 0; i < shaderNames.Length; i++)
            if(current == shaderNames[i])
            {
                currentType = i;
                break;
            }

        TFShaderUtils.TerrainShaderTypes type = (TFShaderUtils.TerrainShaderTypes)(currentType);

        type = (TFShaderUtils.TerrainShaderTypes)EditorGUILayout.EnumPopup(type);

        if ((int)type != currentType)
            TFShaderUtils.ChangeShader(shaderNames[(int)type], editor);
    }
}

public class TFShaderGUI : ShaderGUI
{
    public override void OnGUI (MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI  
        TFShaderUtils.DrawShaderTypes("Hidden/TITANFALL/Transparent/Standard", materialEditor);

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();

        if (GUILayout.Button("Pack Textures"))
        {
            Shader optimized = Shader.Find("TITANFALL/Standard Optimized");
            TFShaderUtils.OptimizeShader(optimized, materialEditor, properties);
        }
    }
}

public class TFShaderGUIBasic : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();
    }
}

public class TFShaderGUIT : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI
        TFShaderUtils.DrawShaderTypes("TITANFALL/Standard", materialEditor);

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();

        if (GUILayout.Button("Pack Textures"))
        {
            Shader optimized = Shader.Find("Hidden/TITANFALL/Transparent/Standard Optimized");
            TFShaderUtils.OptimizeShader(optimized, materialEditor, properties);
        }
    }
}

public class OTFShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI
        TFShaderUtils.DrawShaderTypes("Hidden/TITANFALL/Transparent/Standard Optimized", materialEditor);

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();

        if (GUILayout.Button("Unpack Textures"))
        {
            TFShaderUtils.UnOptimizeShader("TITANFALL/Standard", materialEditor, properties);
        }
    }
}

public class OTFShaderGUIT : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI
        TFShaderUtils.DrawShaderTypes("TITANFALL/Standard Optimized", materialEditor);

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();

        if (GUILayout.Button("Unpack Textures"))
        {
            TFShaderUtils.UnOptimizeShader("Hidden/TITANFALL/Transparent/Standard", materialEditor, properties);
            //TFShaderUtils.OptimizeShader(optimized, materialEditor, properties);
        }
    }
}

public class T0_TFShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI  
        TFShaderUtils.DrawTerrainShaderTypes(TFShaderUtils.shaderNames[0], materialEditor);
        TFShaderUtils.TerrainHelper();

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();
    }
}

public class T1_TFShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI  
        TFShaderUtils.DrawTerrainShaderTypes(TFShaderUtils.shaderNames[1], materialEditor);
        TFShaderUtils.TerrainHelper();

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();
    }
}

public class T2_TFShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI  
        TFShaderUtils.DrawTerrainShaderTypes(TFShaderUtils.shaderNames[2], materialEditor);
        TFShaderUtils.TerrainHelper();

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();
    }
}

public class T3_TFShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI  
        TFShaderUtils.DrawTerrainShaderTypes(TFShaderUtils.shaderNames[3], materialEditor);
        TFShaderUtils.TerrainHelper();

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();
    }
}

public class T4_TFShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // ShaderType GUI  
        TFShaderUtils.DrawTerrainShaderTypes(TFShaderUtils.shaderNames[4], materialEditor);
        TFShaderUtils.TerrainHelper();

        base.OnGUI(materialEditor, properties);

        TFShaderUtils.DrawNess();
    }
}