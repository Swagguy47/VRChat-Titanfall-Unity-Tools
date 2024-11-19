using System;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

[CustomEditor(typeof(Avatar))]
public class AvatarMappingEditor : Editor
{
    Editor _defaultEditor;

    string[] fingerNames = { "finIndex", "finMid", "finThumb", "finPinky", "finRing" };
    string[] fingerOrder = { "A", "B", "C" };
    string[] fingerSides = { "def_l_", "def_r_" };

    public override void OnInspectorGUI()
    {
        if (_defaultEditor != null)
        {
            _defaultEditor.OnInspectorGUI();

            if (StageUtility.GetCurrentStage().name != "")
            {
                ToggleInspectorLock(false);
                return;
            }

            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

            TFShaderUtils.DrawHeader();

            if (GUILayout.Button("Fix Bent Fingertips"))
                FixTips();

            if (GUILayout.Button("Fix Spine Length of 0"))
                FixSpineLength();

            if (GUILayout.Button("Fix Titan Finger Spacing"))
                FixTitanFingers();

            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

            ToggleInspectorLock(true);
        }
    }

    public static void ToggleInspectorLock(bool locked)
    {
        ActiveEditorTracker.sharedTracker.isLocked = locked;
        //ActiveEditorTracker.sharedTracker.ForceRebuild();
    }

    void FixTips()
    {
        var transforms = SceneView.lastActiveSceneView.camera.scene.GetRootGameObjects();

        foreach (string name in fingerNames)
            foreach (string side in fingerSides)
                BoneRotation(FindBone(side + name + fingerOrder[2], transforms), Quaternion.identity);
        //foreach (string order in fingerOrder)
    }

    void FixSpineLength()
    {
        var transforms = SceneView.lastActiveSceneView.camera.scene.GetRootGameObjects();

        var bone = FindBone("def_c_spineA", transforms);

        BoneTransform(bone, new Vector3(0f, 0.0001f, 0f));
    }

    void FixTitanFingers()
    {
        var transforms = SceneView.lastActiveSceneView.camera.scene.GetRootGameObjects();

        Vector3[] fingerPos = {
                new Vector3(0.185f, 0f, -0.05f), //Index
                new Vector3(0.205f, 0f, 0.01f), //Mid
                new Vector3(0.09f, 0.02f, -0.09f), //Thumb
                Vector3.zero, //Pinky
                new Vector3(0.14f, -0.01f, 0f) };//Ring

        for (int i = 0; i < fingerNames.Length; i++)
            foreach (string side in fingerSides)
                foreach (string order in fingerOrder) 
                    switch (order)
                    {
                        case "A": BoneTransform(FindBone(side + fingerNames[i] + order, transforms), fingerPos[i] * (side == "def_r_" ? 1 : -1) * (fingerNames[i].Contains("Ring") & order == "A" ? -1 : 1)); break;
                        default: BoneTransform(FindBone(side + fingerNames[i] + order, transforms), new Vector3(0.08f, 0, 0) * (side == "def_r_" ? 1 : -1) * (fingerNames[i].Contains("Ring") & order == "A" ? -1 : 1)); break;
                    }
    }

    void BoneTransform(Transform bone, Vector3 position)
    {
        if (bone == null)
            return;
        bone.localPosition = position;
        Selection.activeObject = bone;
    }

    void BoneRotation(Transform bone, Quaternion rotation)
    {
        if (bone == null)
            return;
        bone.localRotation = rotation;
        Selection.activeObject = bone;
    }

    Transform FindBone(string name, GameObject[] transforms)
    {
        foreach (GameObject t in transforms)
        {
            foreach(Transform t1 in t.transform)
            {
                var trans = t1.GetComponentsInChildren<Transform>();

                foreach (Transform t2 in trans)
                {
                    if (t2.name == name)
                    {
                        return t2.transform;
                    }
                }
            }
        }

        return null;
        //return GameObject.Find(name).transform;
    }

    void OnEnable()
    {
        _defaultEditor = CreateEditor(targets, Type.GetType("UnityEditor.AvatarEditor, UnityEditor"));
        //  disables lock when leaving stage
        EditorSceneManager.sceneOpening += DisableLock;
    }

    static void DisableLock(string path, OpenSceneMode mode)
    {
        ToggleInspectorLock(false);
    }

    private void OnDisable()
    {
        EditorSceneManager.sceneOpening -= DisableLock;
        if (_defaultEditor != null)
        {
            DestroyImmediate(_defaultEditor);
        }
    }
}