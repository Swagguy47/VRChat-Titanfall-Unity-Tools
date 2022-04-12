using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using System;

public class TitanHatchFix : EditorWindow
{
    public Texture TFLogo;

    public Transform TitanSpineGO;

    public string SelectedGOName;

    public UnityEngine.Object TitanSpineO;

    int selected = 0;

    [MenuItem("Titanfall Asset Tools/Titan Hatch Fixer")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(TitanHatchFix));
        
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

        if (EditorSceneManager.GetActiveScene().name != "Avatar Configuration")
        {

            GUILayout.Label("Repositions the hatch parts in the scene");

            GUILayout.Space(5f);

            string[] options = new string[]
            {
                "Tone", "Ion", "Monarch", "BT 7274",
            };
            selected = EditorGUILayout.Popup("Hatch Positioning:", selected, options);

            //TitanSpineO = EditorGUILayout.ObjectField("Titan Spine C Bone:", TitanSpineGO, typeof(Transform), true);

            //exampleGO = (GameObject)EditorGUILayout.ObjectField("Example GO", exampleGO, typeof(GameObject), true);

            //fuck it
            if (Selection.activeTransform != null)
            {
                SelectedGOName = Selection.activeTransform.gameObject.name;
            }


            GUILayout.Label("Have the 'Spine C' bone selected on the \nmodel you wish to use\n\nHover back over this window when doing so");
            if (Selection.activeTransform != null)
            {
                if (SelectedGOName == "def_c_spineC") //Queue the dogshit code
                {
                    if (GUILayout.Button("Reposition Hatch Transforms"))
                    {

                        if (selected == 0) //Tone
                        {
                            Selection.activeTransform.Find("def_embark_hatch_high").transform.localPosition = new Vector3(0f, 0.61f, 0.065f);
                            Selection.activeTransform.Find("def_embark_hatch_low").transform.localPosition = new Vector3(0f, -0.069f, 0.265f);
                            Selection.activeTransform.Find("def_embark_hatch_top").transform.localPosition = new Vector3(0f, 0.625f, -0.16f);
                        }
                        else if (selected == 1) //Ion
                        {
                            Selection.activeTransform.Find("def_embark_hatch_high").transform.localPosition = new Vector3(0f, 0.605f, 0.073f);
                            Selection.activeTransform.Find("def_embark_hatch_low").transform.localPosition = new Vector3(0f, -0.07f, 0.27f);
                            Selection.activeTransform.Find("def_embark_hatch_top").transform.localPosition = new Vector3(0f, 0.595f, -0.17f);
                        }
                        else if (selected == 2) //Monarch
                        {

                            Selection.activeTransform.Find("def_embark_hatch_low").transform.localPosition = new Vector3(0f, -0.08f, 0.255f);
                            Selection.activeTransform.Find("def_embark_hatch_top").transform.localPosition = new Vector3(0f, 0.629f, -0.165f);
                            Selection.activeTransform.Find("def_embark_hatch_high").transform.localPosition = new Vector3(0f, 0.6f, 0.06f);

                        }
                        else if (selected == 3) //BT
                        {
                            Selection.activeTransform.Find("def_c_hatchBot").transform.localPosition = new Vector3(0f, -0.08f, 0.29f);
                            Selection.activeTransform.Find("def_c_hatchHead").transform.localPosition = new Vector3(8.692306e-21f, 0.5889677f, -0.08825906f);//Should be fine by default, but just in case
                            Selection.activeTransform.Find("def_c_hatchTop").transform.localPosition = new Vector3(0f, 0.49f, 0.23f);
                            Selection.activeTransform.Find("def_c_hatchTop").transform.Find("def_c_neck1").transform.localPosition = new Vector3(0f, -0.18f, 0.055f);//Head
                        }
                    }//I'm too tired to actually put in effort fight me
                }
            }
        }
    }
}
