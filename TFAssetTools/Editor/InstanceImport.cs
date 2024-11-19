using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

public class InstanceImport : EditorWindow
{
    public Texture TFLogo;
    public string CSVDir, MdlDir, MdlSuffix = ".fbx";
    public float Progress;
    public int Errors = 0, Cancel = 0;
    public string ErrorList = "", ProgName = "";
    public bool FastMode;

    [MenuItem("Titanfall Asset Tools/Maps/Prop Instancer (Legacy)")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(InstanceImport));
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Want to drastically improve the file size and performance\nof your map port by importing prop models\nas instances instead of giant models?");
        GUILayout.Space(5f);
        if(GUILayout.Button("Learn how this works"))
        {
            Application.OpenURL("https://youtu.be/V-4rb4wx498");
        }
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        GUILayout.Space(5f);

        GUILayout.Label("Instance Data .CSV File:");
        CSVDir = EditorGUILayout.TextField(CSVDir);
        if (GUILayout.Button("Use Selected File"))
        {
            SelectedCSV();
        }
        GUILayout.Space(5f);

        GUILayout.Label("Prop Models Folder:");
        MdlDir = EditorGUILayout.TextField(MdlDir);
        if (GUILayout.Button("Use Selected Folder"))
        {
            SelectedFolder();
        }
        GUILayout.Label("Prop Model Suffix: (examples: '.fbx', '_LOD0.fbx', '.obj', '.prefab')");
        MdlSuffix = EditorGUILayout.TextField(MdlSuffix);
        
        GUILayout.Space(5f);
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        GUILayout.Space(5f);
        FastMode = GUILayout.Toggle(FastMode, "Use fast importer (does not retain model/prefab packing)");
        if (GUILayout.Button("Import Prop Instances"))
        {
            ParseInstances();
        }

        GUILayout.Label("Note:\nThis tool has become redundant with the addition of\nthe mprt importer. For a faster workflow use that instead.");
    }

    private void SelectedCSV()
    {
        var Getpath = "";
        var obj = Selection.activeObject;
        if (obj == null) Getpath = "Assets";
        else Getpath = AssetDatabase.GetAssetPath(obj.GetInstanceID());
        if (Getpath.Length > 0)
        {
            string extension = Getpath.Substring(Getpath.Length - 4);
            if (extension == ".csv" || extension == ".txt" || extension == "mprt") {
                CSVDir = Getpath; //+ "/";
                Debug.Log("Path Set! (" + CSVDir + ")");
            }
            else {
                Debug.Log("Path cannot be set. This tool only supports .csv and .txt InstanceData files");
            }
            
        }
    }

    private void SelectedFolder() //suboptimial duplicate
    {
        var Getpath = "";
        var obj = Selection.activeObject;
        if (obj == null) Getpath = "Assets";
        else Getpath = AssetDatabase.GetAssetPath(obj.GetInstanceID());
        if (Getpath.Length > 0)
        {
            if (Directory.Exists(Getpath))
            {
                MdlDir = Getpath + "/";
                Debug.Log("Path Set! (" + MdlDir + ")");
            }
        }
    }

    private void ParseInstances()
    {
        Cancel = 0;

        //var Getpath = "";
        string extension = CSVDir.Substring(CSVDir.Length - 5);

        string Data;
        if (extension == ".mprt")
        {
            Byte[] bytes = File.ReadAllBytes(CSVDir);

            Byte[] testData = { };

            using (var fs = new FileStream(CSVDir, FileMode.Create))
            {
                var formatter = new BinaryFormatter();
                Debug.Log(formatter.Deserialize(fs));
                //formatter.Serialize(fs, testData);
            }

            foreach (Byte rawdata in testData)
            {
                Debug.Log(rawdata);
            }
            Data = "";
        }
        else
        {
            Data = System.IO.File.ReadAllText(CSVDir);
        }

        Progress = 0;
        Errors= 0;
        ErrorList = "";

        string[] SplitData = Data.Split(Environment.NewLine.ToCharArray());

        Transform root = new GameObject().transform;
        root.name = "-Prop Instances-";

        UnityEngine.Object SelObj;
        SelObj = Selection.activeObject;

        foreach (string obj in SplitData)
        {
            if (Cancel > 0) { if (Cancel == 2) DestroyImmediate(root.gameObject); break; }

            //Debug.Log("<color=orange>" + obj + "</color>");
            string[] ObjectData = obj.Split(",".ToCharArray());
            if (Progress > 0 && Progress % 2 == 0 && ObjectData.Length >= 11)
            {
                // 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
                //,id,nm,tx,ty,tz,rx,ry,rz,sx,sy,sz
                string[] mdlName = ObjectData[1].Split(".".ToCharArray());
                //Debug.Log(mdlName[0]);

                //PrefabUtility.InstantiatePrefab()
                
                    Transform go;
                if (!FastMode)
                {
                    GameObject OBJECT = (GameObject)AssetDatabase.LoadAssetAtPath(MdlDir + "/" + mdlName[0] + MdlSuffix, typeof(GameObject));
                    if (OBJECT != null) { 
                        Selection.activeObject = PrefabUtility.InstantiatePrefab(OBJECT, root);

                        go = Selection.activeGameObject.transform;//Instantiate(OBJECT).transform;
                        SetupObject(go, ObjectData, mdlName, root);
                    }
                    else {
                        MdlError("model is missing: " + mdlName[0] + MdlSuffix, root);
                    }
                }
                else // old method
                {
                    GameObject OBJECT = (GameObject)AssetDatabase.LoadAssetAtPath(MdlDir + "/" + mdlName[0] + MdlSuffix, typeof(GameObject));
                    if (OBJECT != null) {
                        go = Instantiate(OBJECT).transform;
                        SetupObject(go, ObjectData, mdlName, root);
                    }
                    else {
                        MdlError("model is missing: " + mdlName[0] + MdlSuffix, root);
                    }
                }
            }
            else if (Progress % 2 == 0 && !(Progress == 0 || Progress == SplitData.Length))
            {
                MdlError("incomplete data", root);
            }

            Progress++;
            //EditorUtility.DisplayProgressBar("Importing instanced props...  Sit Tight.", "Progress: ( Object: " + Convert.ToInt32(Progress / 2) + " / " + Convert.ToInt32(SplitData.Length / 2) + ")  |  " + ProgName, Progress / (SplitData.Length));
            if (EditorUtility.DisplayCancelableProgressBar("Importing instanced props...  Sit Tight.", "Progress: ( Object: " + Convert.ToInt32(Progress / 2) + " / " + Convert.ToInt32(SplitData.Length / 2) + ")  |  " + ProgName, Progress / (SplitData.Length))) {
                Cancel = 1;
                if (EditorUtility.DisplayDialog("Cancelled import.", "Would you like the already imported props removed?", "Pretty please? :3", "nah they're chill"))
                {
                    Cancel = 2;
                    //DestroyImmediate(root.gameObject);
                }
            }
            Selection.activeObject = SelObj;
            //DEBUGGING ONLY
            /*if (Progress > 5) {
                break;
            }*/
        }

        if (root != null) { //null if cancelled
            root.localScale = new Vector3(0.025f, 0.025f, 0.025f);
        }
        //root.rotation = Quaternion.Euler(90, 0, 0);
        
        if (Cancel == 0) {
            Debug.Log("<color=lime>DONE!</color> Imported: " + Convert.ToInt32(SplitData.Length / 2) + " objects across:" + (SplitData.Length * 10) + " steps with: <color=red>" + Errors + " skips</color>\nList of skips:\n" + ErrorList);
        } else {
            Debug.Log("<color=yellow>Import Cancelled</color>");
        }
        
        EditorUtility.ClearProgressBar();
    }

    private void SetupObject(Transform go, string[] ObjectData, string[] mdlName, Transform root)
    {
        go.parent = root;
        go.name = mdlName[0] + " (obj: " + Progress / 2 + " )";
        go.position = new Vector3(-float.Parse(ObjectData[2]), float.Parse(ObjectData[4]), -float.Parse(ObjectData[3]));
        go.rotation = new Quaternion(float.Parse(ObjectData[5]), -float.Parse(ObjectData[7]), float.Parse(ObjectData[6]), float.Parse(ObjectData[8]));

        //go.SetPositionAndRotation(new Vector3(-float.Parse(ObjectData[2]), float.Parse(ObjectData[4]), -float.Parse(ObjectData[3])), Quaternion.Euler(float.Parse(ObjectData[5]), -float.Parse(ObjectData[7]), -float.Parse(ObjectData[6])));
        //go.SetPositionAndRotation(new Vector3(-float.Parse(ObjectData[2]), float.Parse(ObjectData[4]), -float.Parse(ObjectData[3])), Quaternion.Euler(float.Parse(ObjectData[7]), -float.Parse(ObjectData[5]), float.Parse(ObjectData[6])));
        go.localScale = new Vector3(float.Parse(ObjectData[9]), float.Parse(ObjectData[10]), float.Parse(ObjectData[11]));
        //go.localScale = new Vector3(float.Parse(ObjectData[8]), float.Parse(ObjectData[9]), float.Parse(ObjectData[10]));
        ProgName = mdlName[0];
    }

    private void MdlError(string error, Transform root)
    {
        GameObject go = new GameObject();
        go.name = "skipped! ( " + error + " obj: " + Progress / 2 +" )";
        go.transform.parent = root;
        Errors++;
        ErrorList += "<color=red>" + error + "</color>\n";
    }
}
