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
    public Avatar ModelAvatar;

    string[] fingerNames = { "finIndex", "finMid", "finThumb", "finPinky", "finRing" };
    string[] fingerOrder = { "A", "B", "C"};
    string[] fingerSides = { "l_", "r_" };

    bool activated;
    
    //[MenuItem("Titanfall Asset Tools/Humanoid Avatar Fixer")]
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


        ModelGO = EditorGUILayout.ObjectField("Model Asset", ModelGO, typeof(GameObject), true) as GameObject;
        ModelAvatar = EditorGUILayout.ObjectField("Avatar Asset", ModelAvatar, typeof(Avatar), true) as Avatar;

        //Avatar config UI
        //Not all are active because not all are implimented as of now
        GUILayout.Label("Bone Prefix:");
        BonePrefix = GUILayout.TextField(BonePrefix);
        GUILayout.Space(5f);
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

        if (!ModelAvatar | !ModelGO)
            return;
        if (GUILayout.Button("Auto Fix"))
        {
            Fix();
        }
    }

    void Fix()
    {
        if (FixFingerTips) //Rotates the (detected) fingertips based off bone prefix + the most common bone name used by respawn
            foreach (string name in fingerNames)
                foreach (string side in fingerSides)
                    foreach (string order in fingerOrder)
                        BoneRotation(FindBone(BonePrefix + side + name + order), Quaternion.identity);
                        //GameObject.Find(BonePrefix+side+name+order).transform.localRotation = Quaternion.identity;

        if (FixTitanHands == true)
        {
            Vector3[] fingerPos = { 
                new Vector3(0.185f - TitanArmOffset, 0f, -0.05f), //Index
                new Vector3(0.205f - TitanArmOffset, 0f, 0.01f), //Mid
                new Vector3(0.09f, 0.02f, -0.09f), //Thumb
                Vector3.zero, //Pinky
                new Vector3(0.14f - TitanArmOffset, -0.01f, 0f) };//Ring

            for (int i = 0; i < fingerNames.Length; i++)
                foreach (string side in fingerSides)
                    foreach (string order in fingerOrder)
                        switch (order)
                        {
                            case "A": BoneTransform(FindBone(BonePrefix + side + fingerNames[i] + order), fingerPos[i] * (side == "r_" ? 1 : -1)); break;
                            default: BoneTransform(FindBone(BonePrefix + side + fingerNames[i] + order), new Vector3(TitanFingerGrouping, 0, 0) * (side == "r_" ? 1 : -1)); break;
                        }

            /*GameObject.Find(BonePrefix + "r_finIndexA").transform.localPosition = new Vector3(0.185f - TitanArmOffset, 0f, -0.05f);
            GameObject.Find(BonePrefix + "r_finIndexB").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);
            GameObject.Find(BonePrefix + "r_finIndexC").transform.localPosition = new Vector3(TitanFingerGrouping, 0f, 0f);

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
            GameObject.Find(BonePrefix + "l_finThumbC").transform.localPosition = new Vector3(-TitanFingerGrouping, 0f, 0f);*/
        }

        if (FixMiddleFingers)
        {
            //ModelRig = ModelGO.GetComponent<HumanBone>();
            //ModelRig.boneName HumanBodyBones.Chest HumanBodyBones.LeftMiddleDistal;
        }

        if (BoneLengthZero)
        {
            var bone = FindBone(BonePrefix + "c_spineA");

            if (bone.position.y == 0)
                BoneTransform(bone, new Vector3(0f, 0.0001f, 0f));
        }

        var ava = AvatarBuilder.BuildHumanAvatar(ModelGO, ModelAvatar.humanDescription);

        var path = AssetDatabase.GetAssetPath(ModelGO);
        var splitPath = path.Split("/");
        var assetName = splitPath[splitPath.Length - 1];

        AssetDatabase.CreateAsset(ava, path.Substring(0, path.Length - assetName.Length) + assetName.Split(".")[0] + "_fixedAvatar.asset");
        AssetDatabase.Refresh();
    }

    SkeletonBone FindBone(string name)
    {
        SkeletonBone[] bones = ModelAvatar.humanDescription.skeleton;

        foreach (SkeletonBone bone in bones)
            if(bone.name == name)
                return bone;

        //  stupid failsafe
        return bones[0];
    }

    void BoneTransform(SkeletonBone bone, Vector3 position)
    {
        bone.position = position;
    }

    void BoneRotation(SkeletonBone bone, Quaternion rotation)
    {
        bone.rotation = rotation;
    }
}
