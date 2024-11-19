using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
/*using VRC.SDK3.Avatars.ScriptableObjects;
using VRC.SDK3.Editor;
using VRC.SDK3.Avatars.Components;*/

public class CamoAnimMaker : EditorWindow
{
    public Texture TFLogo;
    public SkinnedMeshRenderer AnimMesh;
    public string Path = "Assets/", UniAnimName = "Camo", ParamName = "Camo";
    public int CurrentMatIndex, iteration, AnimIteration, AnimLayer, SubIterator, min, max, counter, IconCounter, IconRelapse, AllMenuIterator, GuiCount;
    public Material[] CamoMaterials;
    public bool UniversalAnimNames = true, MakeAnimator = true, MakeVRC, CombineAnims = false;
    public Animator ExistingAnimator;
    public Material OGMat;
    public Vector2 scrollPos;
    public float Progress;
    /*public VRCExpressionsMenu.Control MenuControl;
    public VRCExpressionsMenu.Control.Parameter MenuParam;
    public VRCExpressionsMenu CurrentMenu;
    public VRCExpressionParameters.Parameter ExpressionParam;
    public VRCExpressionParameters.Parameter[] ExpParams = { null };*/
    public Texture2D[] MenuIcons;
    public int[] Dumb = { 0, 0, 0, 0, 0, 0, 0, 0 };
    //public List<VRCExpressionsMenu> AllMenus; 

    public List<AnimationClip> AllAnims;

    //[MenuItem("TF-Automation/Camo Anim Maker")]
    [MenuItem("Titanfall Asset Tools/Camos/Camo Anim Maker")]

    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(CamoAnimMaker));
    }

    /*struct VRCParams
    {
        //Variable declaration
        //Note: I'm explicitly declaring them as public, but they are public by default. You can use private if you choose.
        public bool Saved;
        public string Name;
        public VRCExpressionParameters.ValueType ValueType;

        //Constructor (not necessary, but helpful)
        public VRCParams(string Name, VRCExpressionParameters.ValueType ValueType, bool Saved)
        {
            this.Name = "Camo";
            this.ValueType = VRCExpressionParameters.ValueType.Int;
            this.Saved = true;
        }
    }*/

    private void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    private void OnGUI()
    {
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

        //UI
        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);


        GUILayout.Label("----ADVANCED----\n\nInput all generated camo materials in the same order as on\nthe specified mesh and this will create animations for all of them");
        
        GUILayout.Space(10f);

        AnimMesh = EditorGUILayout.ObjectField("Mesh to animate", AnimMesh, typeof(SkinnedMeshRenderer), true) as SkinnedMeshRenderer;

        if (AnimMesh != null)
        {
            GuiCount = 0;
            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
            GUILayout.Label("Material Order:");
            foreach (Material currentMat in AnimMesh.sharedMaterials)
            {
                GUILayout.Label(GuiCount + " - " + currentMat.name);
                GuiCount++;
            }
            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        }
        
        
        //Array field
        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialJson = serialObj.FindProperty("CamoMaterials");

        EditorGUILayout.PropertyField(serialJson, true);
        serialObj.ApplyModifiedProperties();
        //-----

        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        GUILayout.Label("Output Folder:");
        Path = EditorGUILayout.TextField(Path);
        if (GUILayout.Button("Use Selected Folder"))
        {
            SelectedFolder();
        }
        GUILayout.Space(5f);
        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        UniversalAnimNames = GUILayout.Toggle(UniversalAnimNames, "Use Universal Animation Names");
        if (UniversalAnimNames)
        {
            UniAnimName = EditorGUILayout.TextField(UniAnimName);
        }
        GUILayout.Space(20f);

        MakeAnimator = GUILayout.Toggle(MakeAnimator, "Generate Animator Controller");
        if (MakeAnimator)
        {
            GUILayout.Label("Camo Parameter Name:");
            ParamName = EditorGUILayout.TextField(ParamName);
            //ExistingAnimator = EditorGUILayout.ObjectField("Add to existing animator", ExistingAnimator, typeof(Animator), true) as Animator;
        }
        GUILayout.Space(20f);
        GUILayout.Label("-currently disabled-");
        MakeVRC = GUILayout.Toggle(MakeVRC, "Generate VRChat Components (Experimental)");
        if (MakeVRC)
        {
            GUILayout.Label("All menu icons in same order as camo materials/parameters\n(Yes this is required)");
            //Array field
            ScriptableObject scriptableObj2 = this;
            SerializedObject serialObj2 = new SerializedObject(scriptableObj2);
            SerializedProperty serialJson2 = serialObj2.FindProperty("MenuIcons");

            EditorGUILayout.PropertyField(serialJson2, true);
            serialObj2.ApplyModifiedProperties();
            //-----
        }

        GUILayout.Space(20f);
        //CombineAnims = GUILayout.Toggle(CombineAnims, "Combine related animations");

        GUILayout.Space(15f);

        if (GUILayout.Button("Create Animations!"))
        {
            if (CombineAnims)
            {
                AnimateCombined();
            }
            else
            {
                Animate();
            }
        }
        GUILayout.Space(15f);
        EditorGUILayout.EndScrollView();
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
                Path = Getpath + "/";
                Debug.Log("Path Set! (" + Path + ")");
            }
        }
    }

    private void Animate()
    {
        AllAnims.Clear();
        CurrentMatIndex = 0;
        iteration = 0;
        SubIterator = 0;
        counter = 0;
        Progress = 0;

        foreach (Material CurrentMat in AnimMesh.materials)
        {
            foreach (Material mat in CamoMaterials)
            {
                min = ((CamoMaterials.Length / AnimMesh.materials.Length) * CurrentMatIndex);
                max = (min + (CamoMaterials.Length / AnimMesh.materials.Length));
                //Debug.Log("Setting slot: " + CurrentMatIndex + " to: " + mat.name + "\nCurrentMatIndex: " + CurrentMatIndex + " Iteration: " + iteration + " SubIterator: " + SubIterator + " Range: " + min + " - " + max);

                if (SubIterator >= min && SubIterator < max)
                {

                    EditorCurveBinding curveBinding = new EditorCurveBinding();
                    curveBinding.type = typeof(SkinnedMeshRenderer);
                    // Regular path to the gameobject that will be changed (empty string means root)
                    curveBinding.path = AnimationUtility.CalculateTransformPath(AnimMesh.transform, AnimMesh.transform.parent.transform);
                    curveBinding.propertyName = "m_Materials.Array.data[" + CurrentMatIndex + "]";

                    AnimationClip clip = new AnimationClip();
                    ObjectReferenceKeyframe[] keyFrames = new ObjectReferenceKeyframe[1];

                    keyFrames[0] = new ObjectReferenceKeyframe();

                    //AnimMesh.sharedMaterials[CurrentMatIndex] = OGMat;
                    keyFrames[0].value = mat;
                    AnimationUtility.SetObjectReferenceCurve(clip, curveBinding, keyFrames);
                    AnimationUtility.CalculateTransformPath(AnimMesh.transform.parent, AnimMesh.transform);

                    //clip.SetCurve(AnimationUtility.CalculateTransformPath(AnimMesh.transform.parent, AnimMesh.transform), typeof(Material), "mesh", mat);
                    if (UniversalAnimNames)
                    {
                        AssetDatabase.CreateAsset(clip, Path + UniAnimName + "_" + CurrentMatIndex + "_" + counter + ".anim");
                        AllAnims.Add((AnimationClip)AssetDatabase.LoadAssetAtPath(Path + UniAnimName + "_" + CurrentMatIndex + "_" + counter + ".anim", typeof(AnimationClip)));
                    }
                    else
                    {
                        AssetDatabase.CreateAsset(clip, Path + mat.name + ".anim");
                        AllAnims.Add((AnimationClip)AssetDatabase.LoadAssetAtPath(Path + mat.name + ".anim", typeof(AnimationClip)));
                    }

                    counter++;
                }
                SubIterator += 1;
                iteration += 1;
                Progress++;
                EditorUtility.DisplayProgressBar("Generating Animations:", "Iteration: (" + iteration + " / " + (CamoMaterials.Length * AnimMesh.materials.Length) + ") Ouput: (" + AllAnims.Count + " / " + ((CamoMaterials.Length / AnimMesh.materials.Length) * AnimMesh.materials.Length) + ") Material Slot: (" + CurrentMatIndex + " / " + AnimMesh.materials.Length + ")", (Progress / (CamoMaterials.Length * AnimMesh.materials.Length)));
            }
            CurrentMatIndex += 1;
            SubIterator = 0;
            counter = 0;
        }

        if (MakeAnimator)
        {
            EditorUtility.DisplayProgressBar("Generating Animator Controller:", "Almost done!", CamoMaterials.Length / iteration);
            GenerateAnimator();
        }
        else
        {
            EditorUtility.ClearProgressBar();
        }

        if (MakeVRC)
        {
            MakeVRCComponents();
        }
    }

    private void AnimateCombined()
    {
        AllAnims.Clear();
        CurrentMatIndex = 0;
        iteration = 0;
        SubIterator = 0;
        counter = 0;
        Progress = 0;

        foreach (Material mat in CamoMaterials)
        {
            min = ((CamoMaterials.Length / AnimMesh.materials.Length) * CurrentMatIndex);
            max = (min + (CamoMaterials.Length / AnimMesh.materials.Length));
            //Debug.Log("Setting slot: " + CurrentMatIndex + " to: " + mat.name + "\nCurrentMatIndex: " + CurrentMatIndex + " Iteration: " + iteration + " SubIterator: " + SubIterator + " Range: " + min + " - " + max);

            if (SubIterator >= min && SubIterator < max)
            {

                EditorCurveBinding curveBinding = new EditorCurveBinding();
                curveBinding.type = typeof(SkinnedMeshRenderer);
                // Regular path to the gameobject that will be changed (empty string means root)
                curveBinding.path = AnimationUtility.CalculateTransformPath(AnimMesh.transform, AnimMesh.transform.parent.transform);
                curveBinding.propertyName = "m_Materials.Array.data[" + CurrentMatIndex + "]";

                AnimationClip clip = new AnimationClip();
                ObjectReferenceKeyframe[] keyFrames = new ObjectReferenceKeyframe[1];

                keyFrames[0] = new ObjectReferenceKeyframe();

                //AnimMesh.sharedMaterials[CurrentMatIndex] = OGMat;
                keyFrames[0].value = mat;
                AnimationUtility.SetObjectReferenceCurve(clip, curveBinding, keyFrames);
                AnimationUtility.CalculateTransformPath(AnimMesh.transform.parent, AnimMesh.transform);

                //clip.SetCurve(AnimationUtility.CalculateTransformPath(AnimMesh.transform.parent, AnimMesh.transform), typeof(Material), "mesh", mat);
                if (UniversalAnimNames)
                {
                    AssetDatabase.CreateAsset(clip, Path + UniAnimName + "_" + CurrentMatIndex + "_" + counter + ".anim");
                    AllAnims.Add((AnimationClip)AssetDatabase.LoadAssetAtPath(Path + UniAnimName + "_" + CurrentMatIndex + "_" + counter + ".anim", typeof(AnimationClip)));
                }
                else
                {
                    AssetDatabase.CreateAsset(clip, Path + mat.name + ".anim");
                    AllAnims.Add((AnimationClip)AssetDatabase.LoadAssetAtPath(Path + mat.name + ".anim", typeof(AnimationClip)));
                }

                counter++;
            }
            SubIterator += 1;
            iteration += 1;
            Progress++;
            EditorUtility.DisplayProgressBar("Generating Animations:", "Iteration: (" + iteration + " / " + (CamoMaterials.Length * AnimMesh.materials.Length) + ") Ouput: (" + AllAnims.Count + " / " + ((CamoMaterials.Length / AnimMesh.materials.Length) * AnimMesh.materials.Length) + ") Material Slot: (" + CurrentMatIndex + " / " + AnimMesh.materials.Length + ")", (Progress / (CamoMaterials.Length * AnimMesh.materials.Length)));
        }

        if (MakeAnimator)
        {
            EditorUtility.DisplayProgressBar("Generating Animator Controller:", "Almost done!", CamoMaterials.Length / iteration);
            GenerateAnimator();
        }
        else
        {
            EditorUtility.ClearProgressBar();
        }

        if (MakeVRC)
        {
            MakeVRCComponents();
        }
    }

    private void GenerateAnimator()
    {
        AnimIteration = 0;
        AnimLayer = 0;

        // Creates the controller
        var controller = UnityEditor.Animations.AnimatorController.CreateAnimatorControllerAtPath(Path + "CamoController.controller");

        //controller.AddLayer("Camos " + AnimLayer);
        controller.layers[0].name = ("Camos " + AnimLayer);
        controller.AddParameter(ParamName, AnimatorControllerParameterType.Int);

        foreach (AnimationClip CurrentClip in AllAnims)
        {
            if (AnimIteration > ((CamoMaterials.Length - 1) / AnimMesh.materials.Length))
            {
                AnimLayer += 1;
                controller.AddLayer("Camos " + AnimLayer);
                AnimIteration = 0;
            }

            //controller.AddMotion(CurrentClip, AnimLayer)
            var CurrentTransition = controller.layers[AnimLayer].stateMachine.AddAnyStateTransition(controller.AddMotion(CurrentClip, AnimLayer));
            CurrentTransition.AddCondition(UnityEditor.Animations.AnimatorConditionMode.Equals, AnimIteration, ParamName);
            CurrentTransition.exitTime = 0;
            CurrentTransition.hasExitTime = false;
            CurrentTransition.interruptionSource = UnityEditor.Animations.TransitionInterruptionSource.Destination;
            CurrentTransition.duration = 0;
            CurrentTransition.canTransitionToSelf = false;

            AnimIteration += 1;
        }
        EditorUtility.ClearProgressBar();
    }

    private void MakeVRCComponents() 
    {
        /*EditorUtility.DisplayProgressBar("Generating VRChat Components:", "Almost Done!", CamoMaterials.Length / iteration);
        AllMenus.Clear();

        //Creates the vrc paramteters asset
        VRCExpressionParameters ParamDriver = ScriptableObject.CreateInstance<VRCExpressionParameters>();
        //ParamDriver.parameters.SetValue(, 0);
        ExpressionParam.name = ParamName;
        ExpressionParam.valueType = VRCExpressionParameters.ValueType.Int;
        ExpressionParam.saved = true;

        ExpParams[0] = ExpressionParam;
        ParamDriver.parameters = ExpParams;
        //ParamDriver.parameters.SetValue(ExpressionParam, 0); //Causes Errors

        AssetDatabase.CreateAsset(ParamDriver, Path + "Params.asset");

        //Creates the vrc menu assets
        MenuParam.name = ParamName;
        IconCounter = 7;
        IconRelapse = 1;

        foreach (AnimationClip thisanim in AllAnims)
        {
            if (IconCounter == 7 && AllAnims.Count > (IconCounter * IconRelapse))
            {
                Debug.Log("RELAPSE");
                IconRelapse++;
                IconCounter = 0;
                if (IconRelapse > 2)
                {
                    MenuControl.name = "Camo: " + (IconCounter * IconRelapse);
                    MenuControl.type = VRCExpressionsMenu.Control.ControlType.SubMenu;
                    //MenuControl.icon = null;
                    //MenuControl.parameter = CurrentMenu;

                    //CurrentMenu.controls.Add(MenuControl);
                    AllMenus.Add(CurrentMenu);
                    AssetDatabase.CreateAsset(CurrentMenu, Path + "Menu" + (IconRelapse - 2) + ".asset");
                    AssetDatabase.Refresh();
                }
                
                VRCExpressionsMenu ParamMenu = ScriptableObject.CreateInstance<VRCExpressionsMenu>();
                CurrentMenu = ParamMenu;
            }

            VRCExpressionsMenu.Control ControlThing = MenuControl;

            Debug.Log(IconCounter + " / " + AllAnims.Count);
            ControlThing.name = "Camo: " + (IconCounter + (8 * IconRelapse));
            ControlThing.type = VRCExpressionsMenu.Control.ControlType.Toggle;
            if (IconRelapse > 2)
            {
                ControlThing.icon = MenuIcons[(IconCounter + (8 * IconRelapse))];
            }
            ControlThing.parameter = MenuParam;
            ControlThing.value = (IconCounter + (8 * IconRelapse));

            CurrentMenu.controls.Add(ControlThing);
            IconCounter++;
            //foreach (int Pos in Dumb)
            //{
            //    
            //}
        }
        AssetDatabase.CreateAsset(CurrentMenu, Path + "Menu" + (IconRelapse - 2) + ".asset");
        AssetDatabase.Refresh();

        //Adds the submenu "Next Page" buttons at the end of all menus that aren't full
        AllMenuIterator = 0;
        foreach (VRCExpressionsMenu ThisMenu in AllMenus)
        {
            if (AllMenuIterator != AllMenus.Count - 1)
            {
                MenuControl.name = ">Next Page>";
                MenuControl.type = VRCExpressionsMenu.Control.ControlType.SubMenu;
                MenuControl.icon = null;
                MenuControl.parameter = null;
                MenuControl.value = 0;
                MenuControl.subMenu = AllMenus[AllMenuIterator + 1];
                ThisMenu.controls.Add(MenuControl);
                AllMenuIterator++;
            }
        }
*/
        EditorUtility.ClearProgressBar();
    }
}
