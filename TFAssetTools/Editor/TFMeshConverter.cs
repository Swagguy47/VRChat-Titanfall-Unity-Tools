using System.Collections;
using System.Collections.Generic;
using System.IO;
using TFAssetTools.Editor;
using UnityEditor;
using UnityEngine;

public class TFMeshConverter : EditorWindow
{
    public Texture TFLogo;
    public Vector2 scrollPos;

    public GameObject[] Prefabs;

    [MenuItem("Titanfall Asset Tools/Maps/Prefab Mesh Converter")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(TFMeshConverter));
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

        GUILayout.Label("Converts all SkinnedMeshRenderer components to MeshRenderer");

        //Array field
        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialJson = serialObj.FindProperty("Prefabs");

        EditorGUILayout.PropertyField(serialJson, true);
        serialObj.ApplyModifiedProperties();
        //-----

        GUILayout.Space(5);

        if(GUILayout.Button("Skinned Mesh -> Mesh"))
            FixPrefabs();

        GUILayout.EndScrollView();
    }

    void FixPrefabs()
    {
        for(int i = 0; i < Prefabs.Length; i++)
        {
            var outputDir = AssetDatabase.GetAssetPath(Prefabs[i]);
            var model = (GameObject)PrefabUtility.InstantiatePrefab(Prefabs[i]);
            foreach (Transform child in model.transform)
            {
                Debug.Log(child.name);
                var skinnedMesh = child.gameObject.GetComponent<SkinnedMeshRenderer>();
                if (skinnedMesh)
                {
                    Debug.Log("Skinned mesh found");
                    var meshR = child.gameObject.AddComponent<MeshRenderer>();
                    var meshF = child.gameObject.AddComponent<MeshFilter>();

                    meshF.sharedMesh = skinnedMesh.sharedMesh;
                    meshR.sharedMaterials = skinnedMesh.sharedMaterials;
                    meshR.shadowCastingMode = skinnedMesh.shadowCastingMode;
                    meshR.receiveShadows = skinnedMesh.receiveShadows;

                    DestroyImmediate(skinnedMesh);

                    var meshCol = child.gameObject.GetComponent<MeshCollider>();
                    if (meshCol)
                    {
                        Debug.Log("Mesh collider found");
                        meshCol.sharedMesh = meshF.sharedMesh;
                    }
                }
            }

            PrefabUtility.SaveAsPrefabAssetAndConnect(model, outputDir, InteractionMode.UserAction);

            DestroyImmediate(model);
        }
    }
}
