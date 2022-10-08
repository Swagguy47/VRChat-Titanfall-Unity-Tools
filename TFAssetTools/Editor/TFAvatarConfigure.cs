using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class TFAvatarConfigure : EditorWindow
{
    public Texture TFLogo;

    public string BonePrefix = "def_";

    public bool FixMiddleFingers = true;
    public bool FixFingerTips = true;
    public bool FixUpperArms = true;
    public bool FixUpperChest = true;
    public bool FixHead = false;
    public bool FixTitanHands = false;
    public bool RetargetTitanLegs = false;
    public float TitanFingerGrouping = 0.08f;
    public float TitanArmOffset = 0f;
    public bool BoneLengthZero = true;

    public GameObject ModelGO;
    public HumanBone ModelRig;

    bool activated;
    
    [MenuItem("Titanfall Asset Tools/Humanoid Avatar Fixer")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(TFAvatarConfigure));
        
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        //UI
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);

        if (EditorSceneManager.GetActiveScene().name == "Avatar Configuration")//Checks if configuring avatar
        {
            if(activated == false)
            {
                //Avatar config UI
                //Not all are active because not all are implimented as of now
                GUILayout.Label("Bone Prefix:");
                BonePrefix = GUILayout.TextField(BonePrefix);
                GUILayout.Space(5f);
                //ModelGO = EditorGUILayout.ObjectField("Model Asset", ModelGO, typeof(GameObject), true) as GameObject;
                //GUILayout.Space(5f);
                GUILayout.Label("This Script is still heavily WIP");
                GUILayout.Space(5f);
                //FixMiddleFingers = GUILayout.Toggle(FixMiddleFingers, "Fix Swapped Middle Fingers");//Previously Disabled
                FixFingerTips = GUILayout.Toggle(FixFingerTips, "Fix Rotated Fingertips");
                //FixUpperArms = GUILayout.Toggle(FixUpperArms, "Fix Upperarms / Clavicles");
                //FixUpperChest = GUILayout.Toggle(FixUpperChest, "Retarget Upperchest");
                //FixHead = GUILayout.Toggle(FixHead, "Fix Stretched Forehead");
                BoneLengthZero = GUILayout.Toggle(BoneLengthZero, "Check Spine For Length of Zero");
                FixTitanHands = GUILayout.Toggle(FixTitanHands, "Fix Titan Hands");

                
                
                if (FixTitanHands == true)
                {
                    //GUILayout.HorizontalSlider(TitanFingerGrouping, 0.5f, 1f);
                    GUILayout.Label("Finger Grouping: (Recommended 0.08)");
                    TitanFingerGrouping = EditorGUILayout.Slider(TitanFingerGrouping, 0.05f, 0.125f);
                    GUILayout.Label("Wrist Base Offset: (Default 0) -Experimental-");
                    TitanArmOffset = EditorGUILayout.Slider(TitanArmOffset, -0.75f, 0.75f);
                    //GUILayout.Space(5f);
                }
                //GUILayout.Toggle(RetargetTitanLegs, "Retarget Titan Legs");

                
                if (GUILayout.Button("Auto Fix"))
                {
                    if(FixFingerTips == true) //Rotates the (detected) fingertips based off bone prefix + the most common bone name used by respawn
                    {
                        GameObject.Find(BonePrefix + "l_finIndexC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                        GameObject.Find(BonePrefix + "l_finMidC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                        GameObject.Find(BonePrefix + "l_finThumbC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);

                        GameObject.Find(BonePrefix + "r_finIndexC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                        GameObject.Find(BonePrefix + "r_finMidC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                        GameObject.Find(BonePrefix + "r_finThumbC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);

                        //These last so that three & four fingered models, such as titans and stalkers, don't throw errors and mess with the others
                        GameObject.Find(BonePrefix + "l_finRingC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                        GameObject.Find(BonePrefix + "r_finRingC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                        GameObject.Find(BonePrefix + "l_finPinkyC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                        GameObject.Find(BonePrefix + "r_finPinkyC").transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                    }

                    if(FixTitanHands == true)
                    {
                        GameObject.Find(BonePrefix + "r_finIndexA").transform.localPosition = new Vector3(0.185f - TitanArmOffset, 0f, -0.05f);
                        GameObject.Find(BonePrefix + "r_finIndexB").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);
                        GameObject.Find(BonePrefix + "r_finIndexC").transform.localPosition = new Vector3(TitanFingerGrouping, 0f,0f);

                        GameObject.Find(BonePrefix + "l_finIndexA").transform.localPosition = new Vector3(-0.185f - TitanArmOffset, 0f, 0.05f);
                        GameObject.Find(BonePrefix + "l_finIndexB").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);
                        GameObject.Find(BonePrefix + "l_finIndexC").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);

                        GameObject.Find(BonePrefix + "r_finMidA").transform.localPosition = new Vector3(0.205f - TitanArmOffset, 0f, 0.01f);
                        GameObject.Find(BonePrefix + "r_finMidB").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);
                        GameObject.Find(BonePrefix + "r_finMidC").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);

                        GameObject.Find(BonePrefix + "l_finMidA").transform.localPosition = new Vector3(-0.205f - TitanArmOffset, 0f, -0.01f);
                        GameObject.Find(BonePrefix + "l_finMidB").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);
                        GameObject.Find(BonePrefix + "l_finMidC").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);

                        GameObject.Find(BonePrefix + "r_finRingA").transform.localPosition = new Vector3(-0.14f - TitanArmOffset, -0.01f, 0f);
                        GameObject.Find(BonePrefix + "r_finRingB").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);
                        GameObject.Find(BonePrefix + "r_finRingC").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);

                        GameObject.Find(BonePrefix + "l_finRingA").transform.localPosition = new Vector3(0.14f - TitanArmOffset, -0.01f, 0f);
                        GameObject.Find(BonePrefix + "l_finRingB").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);
                        GameObject.Find(BonePrefix + "l_finRingC").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);

                        GameObject.Find(BonePrefix + "r_finThumbA").transform.localPosition = new Vector3(0.09f, 0.02f, -0.09f);
                        GameObject.Find(BonePrefix + "r_finThumbB").transform.localPosition = new Vector3(TitanFingerGrouping / 2f, 0f, 0f);
                        GameObject.Find(BonePrefix + "r_finThumbC").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);

                        GameObject.Find(BonePrefix + "l_finThumbA").transform.localPosition = new Vector3(-0.09f, -0.02f, 0.09f);
                        GameObject.Find(BonePrefix + "l_finThumbB").transform.localPosition = new Vector3(-TitanFingerGrouping / 2f, 0f, 0f);
                        GameObject.Find(BonePrefix + "l_finThumbC").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);
                    }

                    if(FixMiddleFingers)
                    {
                        //ModelRig = ModelGO.GetComponent<HumanBone>();
                        //ModelRig.boneName HumanBodyBones.Chest HumanBodyBones.LeftMiddleDistal;
                    }

                    if (BoneLengthZero)
                    {
                        if (GameObject.Find(BonePrefix + "c_spineA").transform.localPosition.y == 0)
                        {
                            GameObject.Find(BonePrefix + "c_spineA").transform.localPosition = new Vector3(0f, 0.0001f, 0f);
                        }
                    }

                    activated = true;
                }
            }
            else //Reset script functionality
            {
                GUILayout.Label("AVATAR HAS BEEN MODIFIED\n\nverify script functioned correctly\nthen press 'Apply' at the bottom right\n\n(if it doesn't give you the option\n to apply, click on a bone then check)");
                if (GUILayout.Button("Reset"))
                {
                    activated = false;
                }
            }
        }
        else
        {
            GUILayout.Label("You must be in the 'avatar configure' \nscene for this to work\n\n\nSet the model rig to humanoid\nthen press configure.");
            activated = false;
        }
    }
}
