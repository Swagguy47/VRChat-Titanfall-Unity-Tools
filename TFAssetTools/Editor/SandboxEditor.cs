using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using VRC.Udon;
using VRC.SDKBase;
using VRC.Udon.Common.Interfaces;

public class SandboxEditor : EditorWindow
{
    public List<Wep> Weapons;

    [Serializable]
    public struct Wep
    {
        [Header("UI")]
        public string Name;
        public string Description;
        public Sprite HudIcon;
        [Header("Visuals")]
        public GameObject Model;
        public AudioClip Fire, EmptyFire, MagOut, MagIn, BoltPull, BoltRelease;
        [Header("Stats")]
        public bool Auto;
    }

    [MenuItem("TFPVP/Sandbox Editor")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(SandboxEditor));
    }

    private void OnGUI()
    {
        GUILayout.Space(15f);
        GUILayout.Label("Edit the global weapon sandbox in an organized\nstruct array rather than Udon's abomination");
        //Array field
        ScriptableObject scriptableObj = this;
        SerializedObject serialObj = new SerializedObject(scriptableObj);
        SerializedProperty serialJson = serialObj.FindProperty("Weapons");

        EditorGUILayout.PropertyField(serialJson, true);
        serialObj.ApplyModifiedProperties();
        //-----
        if (GUILayout.Button("Fetch"))
        {
            if (EditorUtility.DisplayDialog("Confirm:", "This will replace any weapon stats currently open in this window", "cool bro 👍", "Cancel :,("))
            {
                FetchWeapons();
            }
        }
        if (GUILayout.Button("Set"))
        {
            if (EditorUtility.DisplayDialog("Confirm:", "This will replace any previous weapon stats set on the UdonBehavior (Make sure array lengths are correct)", "cool bro 👍", "Cancel :,("))
            {
                //TODO
            }
        }
    }

    private void FetchWeapons()
    {
        //Init
        UdonBehaviour Sandbox = GameObject.Find("<Sandbox>").GetComponent<UdonBehaviour>();
        Weapons.Clear();

        IUdonProgram Program = Sandbox.programSource.SerializedProgramAsset.RetrieveProgram();

        IUdonVariableTable Variables = Sandbox.publicVariables;

        //Grabbing values
        //UI
        string[] Name;
        Variables.TryGetVariableValue<string[]>("Name", out Name);
        string[] Desciption;
        Variables.TryGetVariableValue<string[]>("Description", out Desciption);
        Sprite[] HudIcon;
        Variables.TryGetVariableValue<Sprite[]>("HudIcon", out HudIcon);
        //visuals
        GameObject[] Model;
        Variables.TryGetVariableValue<GameObject[]>("Model", out Model);
        AudioClip[] Fire;
        Variables.TryGetVariableValue<AudioClip[]>("Fire", out Fire);
        AudioClip[] EmptyFire;
        Variables.TryGetVariableValue<AudioClip[]>("EmptyFire", out EmptyFire);
        AudioClip[] MagOut;
        Variables.TryGetVariableValue<AudioClip[]>("MagOut", out MagOut);
        AudioClip[] MagIn;
        Variables.TryGetVariableValue<AudioClip[]>("MagIn", out MagIn);
        AudioClip[] BoltPull;
        Variables.TryGetVariableValue<AudioClip[]>("BoltPull", out BoltPull);
        AudioClip[] BoltRelease;
        Variables.TryGetVariableValue<AudioClip[]>("BoltRelease", out BoltRelease);
        //stats
        bool[] Auto;
        Variables.TryGetVariableValue<bool[]>("Auto", out Auto);

        for (int i = 0; i < Name.Length; i++)
        {
            //FetchStats
            Wep CurrentWep = new Wep();

            //UI
            CurrentWep.Name = Name[i];
            CurrentWep.Description = Desciption[i];
            CurrentWep.HudIcon = HudIcon[i];
            //Visuals
            CurrentWep.Model = Model[i];
            CurrentWep.Fire = Fire[i];
            CurrentWep.EmptyFire = EmptyFire[i];
            CurrentWep.MagOut = MagOut[i];
            CurrentWep.MagIn = MagIn[i];
            CurrentWep.BoltPull = BoltPull[i];
            CurrentWep.BoltRelease = BoltRelease[i];
            //Stats
            CurrentWep.Auto = Auto[i];

            //Finish
            Weapons.Add(CurrentWep);
        }

        //InputWeapons = Weapons.ToArray();
        Debug.Log("<color=green>Successfully fetched all weapons from sandbox gameobject!</color>");
    }
}
