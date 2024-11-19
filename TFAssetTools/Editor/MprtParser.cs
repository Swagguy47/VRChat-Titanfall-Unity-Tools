using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text;

public class MprtParser : EditorWindow
{
    public Texture TFLogo;
    public string CSVDir, MdlDir, MdlSuffix = ".fbx";
    public float Progress;
    int Cancel = 0;

    [MenuItem("Titanfall Asset Tools/Maps/Import MPRT")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(MprtParser));
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Import map props directly from any Legion+ .MPRT file");
        GUILayout.Space(5f);
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        GUILayout.Space(5f);

        GUILayout.Label(".MPRT File:");
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
        if (GUILayout.Button("Import Props"))
        {
            ParseInstances();
        }
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
            if (extension == "mprt" | extension == "test") {
                CSVDir = Getpath; //+ "/";
                Debug.Log("Path Set! (" + CSVDir + ")");
            }
            else {
                Debug.Log("Path cannot be set. This tool only supports .mprt files");
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
        //var Getpath = "";
        string extension = CSVDir.Substring(CSVDir.Length - 5);

        if (extension == ".mprt")
            ParseMprt();

        Debug.Log("<color=lime>DONE!</color>");

        EditorUtility.ClearProgressBar();
    }

    void ParseMprt()
    {
        byte[] mprtdata = File.ReadAllBytes(CSVDir);

        var format = new UTF8Encoding();

        using (MemoryStream ms = new MemoryStream(mprtdata))
        {
            using (BinaryReader reader = new BinaryReader(ms, format))
            {
                //  Unpack the header
                float[] header = Unpack(reader, 3, false);

                //  Create root transform
                
                var dirSplit = CSVDir.Split("/");
                var fileName = dirSplit[dirSplit.Length - 1].Split(".")[0];
                fileName = fileName.Replace("_LOD0", "");

                Transform root = new GameObject().transform;
                root.name = "-" + fileName + " props -";

                UnityEngine.Object SelObj;
                SelObj = Selection.activeObject;

                for (int i = 0; i < header[2]; i++)
                {
                    var name = ReadNullTerminatedString(reader);

                    var posRotScale = Unpack(reader, 28/4, true);

                    var modpos = new Vector3(posRotScale[0], posRotScale[1], posRotScale[2]);

                    GameObject OBJECT = (GameObject)AssetDatabase.LoadAssetAtPath(MdlDir + "/" + name + MdlSuffix, typeof(GameObject));
                    if (OBJECT != null)
                    {
                        Selection.activeObject = PrefabUtility.InstantiatePrefab(OBJECT, root);

                        var go = Selection.activeGameObject.transform;
                        SetupProp(go, posRotScale, name, root);
                    }
                    else
                    {
                        MdlError("model is missing: " + name + MdlSuffix, root);
                    }

                    EditorUtility.DisplayProgressBar("Importing props", "Progress: ( " + i + " / " + header[2] + " ) ", i / header[2]);
                }

                root.localRotation = Quaternion.Euler(0, 180, 0);
                root.localScale = new Vector3(0.025f, 0.025f, 0.025f);

                EditorUtility.ClearProgressBar();
            }
        }
    }

    public string ReadNullTerminatedString(BinaryReader reader)
    {
        List<byte> byteList = new List<byte>();
        byte currentByte;

        // Read bytes until we encounter a null terminator (0x00)
        while ((currentByte = reader.ReadByte()) != 0)
        {
            byteList.Add(currentByte);
        }

        // Convert byte array to string (assuming ASCII or UTF-8 encoding)
        return System.Text.Encoding.ASCII.GetString(byteList.ToArray());
    }

    float[] Unpack(BinaryReader reader, int iterations, bool isFloat)
    {
        var pos = reader.BaseStream.Position;
        //Debug.Log(reader.BaseStream.Length - reader.BaseStream.Position + " < " + iterations * 4);
        // Ensure we have enough data to read 7 floats (28 bytes)
        if (reader.BaseStream.Length - reader.BaseStream.Position < iterations * 4)
        {
            throw new InvalidOperationException("Not enough data to unpack.\n" + reader.BaseStream.Length + " | " + reader.BaseStream.Position + "\n" + (reader.BaseStream.Length - reader.BaseStream.Position) + " vs " + iterations * 4);
        }

        // Read bytes
        byte[] data = reader.ReadBytes(iterations * 4);

        // Create an array to store the floats
        float[] unpackedFloats = new float[iterations];

        // Convert each 4-byte segment into a float and store it in the array
        for (int i = 0; i < iterations; i++)
        {
            unpackedFloats[i] = isFloat ? BitConverter.ToSingle(data, i * 4) : BitConverter.ToUInt32(data, i * 4);
        }

        return unpackedFloats;
    }

    public static string FloatToHex(float value)
    {
        // Get the bytes of the float value
        byte[] byteArray = BitConverter.GetBytes(value);

        // Convert each byte to a hex string and join them together
        string hex = BitConverter.ToString(byteArray).Replace("-", "");

        // Return the hex string with the "0x" prefix
        return "0x" + hex.ToUpper();
    }

    private void SetupProp(Transform go, float[] posRotScale, string name, Transform root)
    {
        go.parent = root;
        go.name = name;
        go.position = new Vector3(posRotScale[0], posRotScale[2], posRotScale[1]);
        go.rotation = Quaternion.Euler(posRotScale[3], posRotScale[5], posRotScale[4]);
        go.localScale = new Vector3(posRotScale[6], posRotScale[6], posRotScale[6]);
    }

    private void MdlError(string error, Transform root)
    {
        GameObject go = new GameObject();
        go.name = "skipped! ( " + error + " )";
        go.transform.parent = root;
    }
}
