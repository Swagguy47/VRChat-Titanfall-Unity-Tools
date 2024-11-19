using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

//This is a modified version of my simplified Halo 2 Anniversary Material Converter tool for Titanfall usage
namespace TFAssetTools.Editor
{
    public class MatSetup : EditorWindow
    {
        public Texture TFLogo;
        public Vector2 scrollPos;

        public Material[] InputMaterials;

        private string TextureDirectory = "Assets/";

        private string FileType = ".png";

        //Methods
        private int ShaderType;

        //Overrides
        private bool ChangeTex = true;
        private bool ChangeProperties = true;

        private bool skipAlbedo;
        private bool skipNormal;
        private bool skipSpecular;
        private bool skipEmission;
        private bool skipAO;
        private bool skipGloss;
        private bool skipCavity;
        private bool skipOpacity;

        private float OverrideNormal = 1;
        [Range(0,1)] private float OverrideSpecular = 0.6f;
        private float OverrideEmission = 3, Progress;
        private bool NarrowSearch;
        private Texture[] AllTex;

        [ColorUsage(false, true)]
        private Color glowCol = Color.white * 6;

        [MenuItem("Titanfall Asset Tools/Materials/Auto Texture Materials")]
        public static void ShowWindow()
        {
            EditorWindow.GetWindow(typeof(MatSetup));
        }

        private void OnEnable()
        {
            TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
        }

        private void OnGUI()
        {
            scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

            GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
            GUILayout.Space(75f);

            GUILayout.Label("Applies textures to materials assuming folders & textures are named accordingly.");
            GUILayout.Space(5f);
            GUILayout.Label("(Tip: Select all the material files and drag them over the dropdown)");
            GUILayout.Space(5f);

            //ShaderType Method
            string[] options = new string[]
            {
                "Standard", "Standard (Specular Setup)", "Titanfall 2 Standard"
            };

            //BATCH SETTING
            ShaderType = EditorGUILayout.Popup("Expected Shader:", ShaderType, options);

            //Array field
            ScriptableObject scriptableObj = this;
            SerializedObject serialObj = new SerializedObject(scriptableObj);
            SerializedProperty serialJson = serialObj.FindProperty("InputMaterials");

            EditorGUILayout.PropertyField(serialJson, true);
            serialObj.ApplyModifiedProperties();
            //-----

            GUILayout.Label("Textures folder:");
            TextureDirectory = EditorGUILayout.TextField(TextureDirectory);
            if (GUILayout.Button("Use Selected Folder"))
            {
                SelectedFolder();
            }
            GUILayout.Space(5f);

            GUILayout.Label("Texture File Type:");
            FileType = EditorGUILayout.TextField(FileType);
            GUILayout.Space(15f);

            //Placeholders
            GUILayout.Label("Overrides:");
            ChangeTex = GUILayout.Toggle(ChangeTex, "Change textures");
            ChangeProperties = GUILayout.Toggle(ChangeProperties, "Change material properties");
            if (ChangeTex)
            {
                skipAlbedo = GUILayout.Toggle(skipAlbedo, "Skip Albedo maps");
                skipNormal = GUILayout.Toggle(skipNormal, "Skip Normal maps");
                skipSpecular = GUILayout.Toggle(skipSpecular, "Skip Specular maps");
                if (ShaderType == 2) //Titanfall shader
                {
                    skipGloss = GUILayout.Toggle(skipGloss, "Skip Gloss maps");
                    skipCavity = GUILayout.Toggle(skipCavity, "Skip Cavity maps");
                }
                skipEmission = GUILayout.Toggle(skipEmission, "Skip Emission maps");
                skipAO = GUILayout.Toggle(skipAO, "Skip Occlusion maps");
                if(ShaderType == 2)
                    skipOpacity = GUILayout.Toggle(skipOpacity, "Skip Opacity Maps");
            }

            if (ChangeProperties)
            {
                GUILayout.Label("Normal Intensity:");
                OverrideNormal = EditorGUILayout.FloatField(OverrideNormal);

                //GUILayout.Label("Emission Color:");
                GUIContent colorTitle = new GUIContent("Emission Color");
                glowCol = EditorGUILayout.ColorField(colorTitle, glowCol, true, false, true);
                //GUILayout.Label("Emission Intensity:");
                //OverrideEmission = EditorGUILayout.FloatField(OverrideEmission);

                GUILayout.Label("Smoothness:");
                OverrideSpecular = EditorGUILayout.Slider(OverrideSpecular, 0, 1);
            }
            else
            {
                GUILayout.Space(30f);
            }

            NarrowSearch = GUILayout.Toggle(NarrowSearch, "Specific Texture Search (Not Recommended)");
            GUILayout.Space(5f);

            if (GUILayout.Button("Texture!"))
            {
                ConvertMaterials();
            }

            EditorGUILayout.EndScrollView();
        }

        private void SelectedFolder()
        {
            var Getpath = "";
            var obj = Selection.activeObject;
            if (obj == null) Getpath = "Assets";
            else Getpath = AssetDatabase.GetAssetPath(obj.GetInstanceID());
            if (Getpath.Length > 0)
            {
                if (Directory.Exists(Getpath))
                {
                    TextureDirectory = Getpath + "/";
                    Debug.Log("Path Set! (" + TextureDirectory + ")");
                }
            }
        }

        public void ConvertMaterials()
        {
            Debug.Log("Setting up materials...");
            Progress = 0;

            foreach (Material Mat in InputMaterials)
            {
                if (ChangeTex) //Texture Changing
                {
                    //Universal Textures
                    SetTexture(Mat, "_col", "_MainTex", skipAlbedo); //Albedo
                    SetTexture(Mat, "_nml", "_BumpMap", skipNormal); //Normal
                    SetTexture(Mat, "_ao", "_OcclusionMap", skipAO); //AO
                    SetTexture(Mat, "_ilm", "_EmissionMap", skipEmission); //EmisisonTex
                    Mat.EnableKeyword("_EMISSION"); //Enables Emission

                    if (ShaderType == 0) //Standard
                    {
                        SetTexture(Mat, "_spc", "_MetallicGlossMap", skipSpecular);
                    }
                    else //Specular & TF|2
                    {
                        SetTexture(Mat, "_spc", "_SpecGlossMap", skipSpecular);
                    }

                    if (ShaderType == 2) //TF|2
                    {
                        SetTexture(Mat, "_cav", "_Cav", skipCavity);    //  old shader
                        SetTexture(Mat, "_cav", "_ParallaxMap", skipCavity);    //  new shader
                        SetTexture(Mat, "_gls", "_GlossMap", skipCavity);
                    }
                }

                if (ChangeProperties) //Parameter changing
                {
                    Mat.SetColor("_Color", Color.white);
                    if (!skipNormal) //Normal
                    {
                        Mat.SetFloat("_BumpScale", OverrideNormal);
                    }
                    if (!skipSpecular) //Specular
                    {
                        Mat.SetFloat("_GlossMapScale", OverrideSpecular);
                        Mat.SetFloat("_Glossiness", OverrideSpecular);
                    }
                    if (!skipEmission && CheckTexture(Mat, "_ilm"))
                    {
                        Mat.EnableKeyword("_EMISSION");
                        Mat.SetColor("_EmissionColor", glowCol);
                        Mat.SetFloat("_EmissionIntensity", OverrideEmission);
                        Mat.globalIlluminationFlags = MaterialGlobalIlluminationFlags.BakedEmissive;
                    }
                    if (!skipOpacity && CheckTexture(Mat, "_opa") && ShaderType == 2)
                    {
                        Mat.shader = Mat.shader == Shader.Find("TITANFALL/Standard") ? Shader.Find("Hidden/TITANFALL/Transparent/Standard") : Mat.shader == Shader.Find("TITANFALL/Standard Optimized") ? Shader.Find("Hidden/TITANFALL/Transparent/Standard Optimized") : Mat.shader;
                        SetTexture(Mat, "_opa", "_Opacity", false);
                    }
                }
                //Editor progressbar popup
                Progress++;
                EditorUtility.DisplayProgressBar("Texturing your materials for you... Sit tight.", "Progress: ( " + Progress + " / " + InputMaterials.Length + " )", Progress / InputMaterials.Length);
            }
            Debug.Log("DONE!");
            EditorUtility.ClearProgressBar();
        }

        private void SetTexture(Material CurrentMat, string Identifier, string ShaderName, bool Toggler)
        {
            //  filter unused property names
            if (!CurrentMat.GetPropertyNames(MaterialPropertyType.Texture).Contains<string>(ShaderName))
                return;

            if (!Toggler)
            {
                
                var folders = Directory.GetDirectories(TextureDirectory, CurrentMat.name, SearchOption.AllDirectories);//AssetDatabase.GetSubFolders(TextureDirectory.Substring(0, TextureDirectory.Length - 1));
                var newDir = TextureDirectory + CurrentMat.name;
                foreach (var folder in folders)
                {
                    if (Directory.GetFiles(folder, "*" + "_col" + FileType).Length > 0) {
                        //Debug.Log("Found subfolder!");
                        newDir = folder;
                        break;
                    }
                }

                if (Directory.Exists(newDir))
                {
                    FindTextures(CurrentMat, Identifier, ShaderName, Toggler, "", newDir);
                    //Debug.Log(TextureDirectory + CurrentMat.name + " EXISTS! Grabbing:" + Identifier);
                }
                else if (Directory.Exists(newDir + "_colpass"))
                {
                    FindTextures(CurrentMat, Identifier, ShaderName, Toggler, "_colpass", newDir);
                    //Debug.Log(TextureDirectory + CurrentMat.name + "_colpass EXISTS! Grabbing: " + Identifier);
                }
            }
        }

        private void FindTextures(Material CurrentMat, string Identifier, string ShaderName, bool Toggler, string PathAppend, string Dir)
        {
            foreach (var file in Directory.GetFiles(Dir + PathAppend, "*" + FileType, SearchOption.TopDirectoryOnly))
            {
                Texture ThisTex = (Texture)AssetDatabase.LoadAssetAtPath(file, typeof(Texture));

                if (ThisTex.name.Contains(Identifier))
                {
                    CurrentMat.SetTexture(ShaderName, ThisTex);
                }
            }
        }

        //Just checks if a texture exists
        private bool CheckTexture(Material CurrentMat, string Identifier)
        {
            var folders = Directory.GetDirectories(TextureDirectory, CurrentMat.name, SearchOption.AllDirectories);//AssetDatabase.GetSubFolders(TextureDirectory.Substring(0, TextureDirectory.Length - 1));
            var newDir = TextureDirectory + CurrentMat.name;
            foreach (var folder in folders)
            {
                if (Directory.GetFiles(folder, "*" + "_col" + FileType).Length > 0)
                {
                    //Debug.Log("Found subfolder!");
                    newDir = folder;
                    break;
                }
            }

            bool returnVal = false;
            if (Directory.Exists(newDir))
            {
                foreach(var file in Directory.GetFiles("" + newDir, "*" + FileType, SearchOption.TopDirectoryOnly))
                {
                    if (Path.GetFileName(file).Contains(Identifier))
                    {
                        returnVal = true;
                        break;
                    }
                }
                //Debug.Log(returnVal);
            }
            return returnVal;
        }
    }
}