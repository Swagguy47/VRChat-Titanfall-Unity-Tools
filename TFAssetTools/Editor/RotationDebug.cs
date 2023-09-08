using System;
using UnityEngine;
using UnityEditor;
using static MapLightFix;

public class RotationDebug : EditorWindow
{
    public Texture TFLogo;
    public Vector3 InputVector;
    public float WInput, OrgMult = 1;
    public rotMode RotationMode;
    public Quaternion SavedRot, SavedDif, DifUndo, OrgUndo;
    public bool LiveApply, LiveReorg;
    public Transform LiveTrans;

    public int[] RotationOps = { 0, 1, 2, 3};

    public DebugRotPreview.RotOptions Inverses;

    string[] RotVals = new string[]
        {
                "X", "Y", "Z", "W",
        };

    [Serializable]
    public enum rotMode
    {
        Euler, Quaternion
    }

    public Vector2 scrollPos;

    [MenuItem("Titanfall Asset Tools/Dev/Rotation Debug")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(RotationDebug));
    }

    public void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        EditorGUILayout.BeginVertical();
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);
        GUILayout.Label("Debug logs rotation data for selected transforms");
        GUILayout.Space(5f);
        if (GUILayout.Button("Log"))
        {
            Run();
        }

        GUILayout.Space(5f);
        GUILayout.Label("INPUT:");
        RotationMode = (rotMode)EditorGUILayout.EnumPopup("Rotation Mode", RotationMode);
        InputVector = EditorGUILayout.Vector3Field("Input Vector", InputVector);
        WInput = EditorGUILayout.FloatField("Quaternion W", WInput);
        //fills editor variables with rotationd data of selected object
        if (GUILayout.Button("Get")) {
            if (Selection.gameObjects.Length > 0) {
                Quaternion SelRot = Selection.gameObjects[0].transform.rotation;
                if (RotationMode == rotMode.Quaternion)
                {
                    InputVector = new Vector3(SelRot.x, SelRot.y, SelRot.z);
                    WInput = SelRot.w;
                } else {
                    InputVector = SelRot.eulerAngles;
                    WInput = 0;
                }
            }
        }

        if (GUILayout.Button("Set")) {
            if (Selection.gameObjects.Length > 0)
            {
                Transform SelTrans = Selection.gameObjects[0].transform;
                if (RotationMode == rotMode.Quaternion) {
                    SelTrans.rotation = new Quaternion(InputVector.x, InputVector.y, InputVector.z, WInput);
                } else {
                    SelTrans.rotation = Quaternion.Euler(InputVector);
                }
            }
        }
        LiveApply = GUILayout.Toggle(LiveApply, "Set Live");

        if (LiveApply && Selection.gameObjects.Length > 0) {
            Transform SelTrans = Selection.gameObjects[0].transform;

            if (LiveTrans == null || LiveTrans == SelTrans)
            {
                if (RotationMode == rotMode.Quaternion)
                {
                    SelTrans.rotation = new Quaternion(InputVector.x, InputVector.y, InputVector.z, WInput);
                }
                else
                {
                    SelTrans.rotation = Quaternion.Euler(InputVector);
                }
            } else {
                LiveTrans = null;
                LiveApply = false;
            }
            
        }

        GUILayout.Space(10f);

        if (GUILayout.Button("Save")) {
            if (Selection.gameObjects.Length > 0 ){
                Transform SelTrans = Selection.gameObjects[0].transform;
                SavedRot = SelTrans.rotation;
            }
        }

        if (GUILayout.Button("Load"))
        {
            if (Selection.gameObjects.Length > 0)
            {
                Transform SelTrans = Selection.gameObjects[0].transform;
                SelTrans.rotation = SavedRot;
                if (LiveApply) {
                    Quaternion SelRot = Selection.gameObjects[0].transform.rotation;
                if (RotationMode == rotMode.Quaternion)
                {
                    InputVector = new Vector3(SelRot.x, SelRot.y, SelRot.z);
                    WInput = SelRot.w;
                } else {
                    InputVector = SelRot.eulerAngles;
                    WInput = 0;
                }
                }
            }
        }

        GUILayout.Space(10f);

        if (GUILayout.Button("Save Difference"))
        {
            if (Selection.gameObjects.Length > 0)
            {
                Transform SelTrans = Selection.gameObjects[0].transform;
                SavedDif = (SavedRot * Quaternion.Inverse(SelTrans.rotation));
            }
        }

        if (GUILayout.Button("Apply Difference"))
        {
            if (Selection.gameObjects.Length > 0)
            {
                Transform SelTrans = Selection.gameObjects[0].transform;
                DifUndo= SelTrans.rotation;
                SelTrans.rotation = SavedDif * SelTrans.rotation;
            }
        }
        
        if (GUILayout.Button("Undo Applied Difference"))
        {
            if (Selection.gameObjects.Length > 0)
            {
                Transform SelTrans = Selection.gameObjects[0].transform;
                SelTrans.rotation = DifUndo;
            }
        }
        
        GUILayout.Space(10f);
        GUILayout.Label("Reorganize quaternion values:");
        RotationOps[0] = EditorGUILayout.Popup("X = ", RotationOps[0], RotVals);
        RotationOps[1] = EditorGUILayout.Popup("Y = ", RotationOps[1], RotVals);
        RotationOps[2] = EditorGUILayout.Popup("Z = ", RotationOps[2], RotVals);
        RotationOps[3] = EditorGUILayout.Popup("W = ", RotationOps[3], RotVals);
        Inverses = (DebugRotPreview.RotOptions)EditorGUILayout.EnumFlagsField("Inverses", Inverses);
        GUILayout.Label("Multiplier:");
        OrgMult = EditorGUILayout.FloatField(OrgMult);
        
        GUILayout.Space(10f);
        if (GUILayout.Button("Reorganize values")) {
            if (Selection.gameObjects.Length > 0)
            {
                Transform SelTrans = Selection.gameObjects[0].transform;
                SelTrans.rotation = organize(SelTrans);
            }
        }
        if (GUILayout.Button("Undo Reorganization")) {
            if (Selection.gameObjects.Length > 0)
            {
                Transform SelTrans = Selection.gameObjects[0].transform;
                Reorganize(SelTrans);
            }
        }
        LiveReorg = GUILayout.Toggle(LiveReorg, "Stream data to preview component");
        if (GUILayout.Button("Add Preview Component")) {
            if (Selection.gameObjects.Length > 0) {
                Selection.gameObjects[0].AddComponent<DebugRotPreview>();
            }
        }
        if (GUILayout.Button("Remove Preview Component")) {
            if (Selection.gameObjects.Length > 0) {
                DestroyImmediate(Selection.gameObjects[0].GetComponent<DebugRotPreview>());
                LiveReorg = false;
            }
        }
        if (LiveReorg)
        {
            if (Selection.gameObjects.Length > 0){
                DebugRotPreview preview = Selection.gameObjects[0].GetComponent<DebugRotPreview>();

                preview.Inverses = Inverses;
                preview.RotationOps = RotationOps;
                preview.RotVals = RotVals;
                preview.OrgMult= OrgMult;
            }
        }

        GUILayout.Space(5f);
        GUILayout.Label("Saved Rotation:\n\nQuaternion: \n" + SavedRot +"\nEuler: \n" + SavedRot.eulerAngles);
        GUILayout.Space(25f);
        GUILayout.Label("Saved Difference:\n\nQuaternion: \n" + SavedDif + "\nEuler: \n" + SavedDif.eulerAngles);
        
        GUILayout.Space(5f);
        EditorGUILayout.EndScrollView();
        EditorGUILayout.EndVertical();
    }

    public void Run()
    {
        foreach (GameObject obj in Selection.gameObjects)
        {
            if (obj != null) {
                Debug.Log(obj.name + "\nQuaternion: " + obj.transform.rotation + "  |  Euler: " + obj.transform.rotation.eulerAngles);
            }
        }
    }

    public Quaternion organize(Transform ThisLight)
    {
        Quaternion LightRot = ThisLight.rotation;
        OrgUndo = LightRot;

        float x, y, z, w;

        float[] vals = { LightRot.x, LightRot.y, LightRot.z, LightRot.w };

        x = (vals[RotationOps[0]]) * (Convert.ToInt32(Inverses == DebugRotPreview.RotOptions.X) == 1 ? -1 : 1) * OrgMult;
        y = (vals[RotationOps[1]]) * (Convert.ToInt32(Inverses == DebugRotPreview.RotOptions.Y) == 1 ? -1 : 1) * OrgMult;
        z = (vals[RotationOps[2]]) * (Convert.ToInt32(Inverses == DebugRotPreview.RotOptions.Z) == 1 ? -1 : 1) * OrgMult;
        w = (vals[RotationOps[3]]) * (Convert.ToInt32(Inverses == DebugRotPreview.RotOptions.W) == 1 ? -1 : 1) * OrgMult;

        return new Quaternion(x, y, z, w);
    }

    public void Reorganize(Transform ThisLight)
    {
        ThisLight.rotation = OrgUndo;
    }
}
