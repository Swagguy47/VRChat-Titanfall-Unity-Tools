using System.Collections;
using System.Collections.Generic;
using System.IO;
using TFAssetTools.Editor;
using UnityEditor;
using UnityEngine;

public class TFPrefabGen : EditorWindow
{
    public Texture TFLogo;
    public Vector2 scrollPos;

    public string outputDir = "Assets/";
    public GameObject[] Models;

    [MenuItem("Titanfall Asset Tools/Maps/Prefab Generator")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(TFPrefabGen));
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

        GUILayout.Label("Converts models to prefabs, useful for prop instancing.");

        //Array field
        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialJson = serialObj.FindProperty("Models");

        EditorGUILayout.PropertyField(serialJson, true);
        serialObj.ApplyModifiedProperties();
        //-----

        GUILayout.Space(5);

        GUILayout.Label("Output folder:");
        outputDir = EditorGUILayout.TextField(outputDir);
        if (GUILayout.Button("Use Selected Folder"))
        {
            SelectedFolder();
        }

        GUILayout.Space(5);

        if(GUILayout.Button("Generate"))
            MakePrefabs();

        GUILayout.Space(5); 

        GUILayout.Label("Info:\nBy having each prop's model converted to a prefab you can add\nextra functionality like: lights, colliders, sfx, animators, etc to props\nand have it apply everywhere in the map instantly, while also being\nnon-destructive in-case you reimport the model.\n");

        GUILayout.EndScrollView();
    }

    void MakePrefabs()
    {
        for(int i = 0; i < Models.Length; i++)
        {
            var model = (GameObject)PrefabUtility.InstantiatePrefab(Models[i]);

            PrefabUtility.SaveAsPrefabAssetAndConnect(model, outputDir + Models[i].name + ".prefab", InteractionMode.UserAction);

            DestroyImmediate(model);
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
                outputDir = Getpath + "/";
                Debug.Log("Path Set! (" + outputDir + ")");
            }
        }
    }
}
