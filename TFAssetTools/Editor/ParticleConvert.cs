using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.ComponentModel;
using System.Data;

public class ParticleConvert : EditorWindow
{
    public Texture TFLogo;

    public UnityEngine.Object[] PCFInput; //all the inputted .pcf files

    public string MaterialDirectory, LocalPath;

    public bool DebugHex;
    
    //Deprecated in light of scriptedimporter
    //[MenuItem("Titanfall Asset Tools/Dev/Convert Particle Systems")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(ParticleConvert));

    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("-EXPERIMENTAL-\nThis tool takes .pcf files from Titanfall and attempts to\nrecreate the particles in Unity using that data results may\nnot be fully accurate, errors may occur, this is just a test");
        
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        //Array field
        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serial = serialObj.FindProperty("PCFInput");

        EditorGUILayout.PropertyField(serial, true);
        serialObj.ApplyModifiedProperties();
        //-----

        GUILayout.Space(10f);

        GUILayout.Label("Materials Folder:");
        MaterialDirectory = EditorGUILayout.TextField(MaterialDirectory);
        if (GUILayout.Button("Use Selected Folder"))
        {
            SelectedFolder();
        }

        GUILayout.Space(10f);

        DebugHex = GUILayout.Toggle(DebugHex, "DebugHex");

        //Starts the fun
        if ((MaterialDirectory != null && MaterialDirectory != "") && (PCFInput != null && PCFInput.Length > 0))
        {
            if (GUILayout.Button("CONVERT"))
            {
                ConvertParticles();
            }
        }
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
                MaterialDirectory = Getpath + "/";
                Debug.Log("Path Set! (" + MaterialDirectory + ")");
            }
        }
    }

    //The whole operation
    private void ConvertParticles()
    {
        foreach(UnityEngine.Object Pcf in PCFInput)
        {
            //Prepares the folder structure for assets
            string PcfPath = AssetDatabase.GetAssetPath(Pcf);

            //Creates root folder
            if (!AssetDatabase.IsValidFolder(PcfPath.Substring(0, PcfPath.Length - 4 - Pcf.name.Length) + "Converted"))
            {
                AssetDatabase.CreateFolder(PcfPath.Substring(0, PcfPath.Length - 5 - Pcf.name.Length ), "Converted");
            }

            string rootPath = (PcfPath.Substring(0, PcfPath.Length - 4 - Pcf.name.Length) + "Converted");

            //Creates particle folder
            if (!AssetDatabase.IsValidFolder(rootPath + "/" + Pcf.name))
            {
                AssetDatabase.CreateFolder(rootPath, Pcf.name);
            }

            LocalPath = rootPath + "/" + Pcf.name;

            //Debug.Log(LocalPath);
            AssetDatabase.Refresh();

            CreateParticle(Pcf);

            if (DebugHex)
            {
                DumpHex(Pcf);
            }
        }
    }

    //Creates the particle system itself in the scene
    private void CreateParticle(UnityEngine.Object Pcf)
    {
        //Instantiates new asset
        GameObject FxGO = new GameObject();
        FxGO.name = Pcf.name;
        ParticleSystem Fx = FxGO.AddComponent<ParticleSystem>();

        SaveParticle(FxGO); //makes prefab

        DestroyImmediate(FxGO); //removes gameobject
    }

    //Saves particle gameobject as prefab
    private void SaveParticle(GameObject FxGO)
    {
        bool SaveSuccess;
        PrefabUtility.SaveAsPrefabAssetAndConnect(FxGO, LocalPath + "/" + FxGO.name + ".prefab", InteractionMode.AutomatedAction, out SaveSuccess);
        if (!SaveSuccess)
        {
            Debug.LogError(FxGO.name + " failed to save to prefab as expected!\n:(");
        }
    }

    //Debugging, dumps pcf hex as int8 into console
    private void DumpHex(UnityEngine.Object Pcf)
    {
        Stream s = new FileStream(AssetDatabase.GetAssetPath(Pcf), FileMode.Open);
        BinaryReader br = new BinaryReader(s);
        //int dataVal = br.ReadUInt16();
        Byte[] dataVal;// = br.ReadString();
        dataVal = br.ReadBytes(999999999);
        string OutputDump = "";
        foreach (Byte CurrentByte in dataVal)
        {
            OutputDump += " " + CurrentByte;
        }
        Debug.Log(Pcf.name + " HEX DUMP\n(decoded as Int8 binary)\n" + OutputDump);
    }
}
