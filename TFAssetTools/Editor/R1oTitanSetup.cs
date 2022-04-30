using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;

public class R1oTitanSetup : EditorWindow
{

    public Texture TFLogo;

    public int Titan;

    public int TitanVariant;

    public Vector2 scrollPos;

    public Transform RootTransform;

    public Transform SearchTransform;

    public List<GameObject> ArmorList;

    public List<String> NameList;

    public int ArmorCount;

    public GameObject CurrentPiece;

    public bool UseMdlName;

    public bool FixRotation = true;

    //Pieces:
    //-------------------------------------
    public GameObject c_spinec;
    public GameObject l_body_jiggle;
    public GameObject l_shouldertwist;
    public GameObject l_shoulder;
    public GameObject r_shoulder;
    public GameObject l_shouldermid;
    public GameObject r_shouldermid;
    public GameObject l_thigh;
    public GameObject l_thighbackjiggle;
    public GameObject l_thighfrontjiggle;
    public GameObject r_bodyjiggle;
    public GameObject r_shouldertwist;
    public GameObject r_thigh;
    public GameObject r_thighbackjiggle;
    public GameObject r_thighfrontjiggle;
    public GameObject l_elbow;
    public GameObject r_elbow;
    public GameObject l_knee;
    public GameObject r_knee;
    public GameObject hatch_panel;
    public GameObject l_rocket_pod;
    public GameObject c_hatchtop_og;//only ogre
    public GameObject c_spinect;//only destroyer
    public GameObject jx_railgun;//only destroyer
    public GameObject l_jigglebag;//only ogre
    public GameObject r_jigglebag;//only ogre
    public GameObject l_jigglebagc;//only ogre
    public GameObject r_jigglebagc;//only ogre
    public GameObject c_jigglehip;//only ogre
    //-------------------------------------

    [MenuItem("Titanfall Asset Tools/TF|O Titan Setup")]
    // Start is called before the first frame update
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(R1oTitanSetup));
    }

    private void OnEnable()
    {
        TFLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/TFAssetTools/Editor/TFToolsBanner.png", typeof(Texture));
    }

    public void OnGUI()
    {
        //UI
        EditorGUILayout.BeginVertical();
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos);

        GUI.DrawTexture(new Rect(10, 10, 200, 60), TFLogo, ScaleMode.ScaleToFit, true, 3.0F);
        GUILayout.Space(75f);



        GUILayout.Label("Places Titanfall Online Titan Tier Pieces");

        GUILayout.Space(5f);

        string[] options = new string[]
        {
                "Stryder", "Atlas", "Ogre", "Destroyer",
        };
        Titan = EditorGUILayout.Popup("Titan:", Titan, options);

        GUILayout.Space(5f);

        string[] options2 = new string[]
            {
                "Tier 1", "Tier 2", "Tier 3",
            };
        //TitanVariant = EditorGUILayout.Popup("Tier:", TitanVariant, options2);
        //Don't know if this will be needed or not

        GUILayout.Space(5f);

        RootTransform = EditorGUILayout.ObjectField("Titan Gameobject", RootTransform, typeof(Transform), true) as Transform;
        
        GUILayout.Space(5f);
        
        UseMdlName = GUILayout.Toggle(UseMdlName, "Use Model Names for Placement");

        FixRotation = GUILayout.Toggle(FixRotation, "Attempt to Fix Rotaiton");

        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);
        GUILayout.Space(5f);

        GUILayout.Label("Drag armor assets from project window, not scene:");
        GUILayout.Label("(Not all slots have to be filled)");

        GUILayout.Space(5f);

        //Armor Piece GUI
        //--------------------------------------------------------------------------------------

        if (Titan == 0) // stryder
        {
            c_spinec = EditorGUILayout.ObjectField("c_spinec", c_spinec, typeof(GameObject), true) as GameObject;
            l_thigh = EditorGUILayout.ObjectField("l_thigh", l_thigh, typeof(GameObject), true) as GameObject;
            r_thigh = EditorGUILayout.ObjectField("r_thigh", r_thigh, typeof(GameObject), true) as GameObject;
            l_elbow = EditorGUILayout.ObjectField("l_elbow", l_elbow, typeof(GameObject), true) as GameObject;
            r_elbow = EditorGUILayout.ObjectField("r_elbow", r_elbow, typeof(GameObject), true) as GameObject;
            l_knee = EditorGUILayout.ObjectField("l_knee", l_knee, typeof(GameObject), true) as GameObject;
            r_knee = EditorGUILayout.ObjectField("r_knee", r_knee, typeof(GameObject), true) as GameObject;
            l_shoulder = EditorGUILayout.ObjectField("l_shoulder", l_shoulder, typeof(GameObject), true) as GameObject;
            r_shoulder = EditorGUILayout.ObjectField("r_shoulder", r_shoulder, typeof(GameObject), true) as GameObject;
            hatch_panel = EditorGUILayout.ObjectField("hatch_panel", hatch_panel, typeof(GameObject), true) as GameObject;
            l_rocket_pod = EditorGUILayout.ObjectField("l_rocket_pod", l_rocket_pod, typeof(GameObject), true) as GameObject;
            
        }
        else if (Titan == 1) //atlas
        {
            c_spinec = EditorGUILayout.ObjectField("c_spinec", c_spinec, typeof(GameObject), true) as GameObject;
            l_thigh = EditorGUILayout.ObjectField("l_thigh", l_thigh, typeof(GameObject), true) as GameObject;
            r_thigh = EditorGUILayout.ObjectField("r_thigh", r_thigh, typeof(GameObject), true) as GameObject;
            l_elbow = EditorGUILayout.ObjectField("l_elbow", l_elbow, typeof(GameObject), true) as GameObject;
            r_elbow = EditorGUILayout.ObjectField("r_elbow", r_elbow, typeof(GameObject), true) as GameObject;
            l_knee = EditorGUILayout.ObjectField("l_knee", l_knee, typeof(GameObject), true) as GameObject;
            r_knee = EditorGUILayout.ObjectField("r_knee", r_knee, typeof(GameObject), true) as GameObject;
            l_shouldermid = EditorGUILayout.ObjectField("l_shouldermid", l_shouldermid, typeof(GameObject), true) as GameObject;
            r_shouldermid = EditorGUILayout.ObjectField("r_shouldermid", r_shouldermid, typeof(GameObject), true) as GameObject;
            hatch_panel = EditorGUILayout.ObjectField("hatch_panel", hatch_panel, typeof(GameObject), true) as GameObject;
            l_jigglebagc = EditorGUILayout.ObjectField("l_jigglebagc", l_jigglebagc, typeof(GameObject), true) as GameObject;
            r_jigglebagc = EditorGUILayout.ObjectField("r_jigglebagc", r_jigglebagc, typeof(GameObject), true) as GameObject;
            l_jigglebag = EditorGUILayout.ObjectField("l_jigglebag", l_jigglebag, typeof(GameObject), true) as GameObject;
            r_jigglebag = EditorGUILayout.ObjectField("r_jigglebag", r_jigglebag, typeof(GameObject), true) as GameObject;
            c_jigglehip = EditorGUILayout.ObjectField("c_jigglehip", c_jigglehip, typeof(GameObject), true) as GameObject;
        }
        else if (Titan == 2) //ogre
        {
            c_spinec = EditorGUILayout.ObjectField("c_spinec", c_spinec, typeof(GameObject), true) as GameObject;
            l_body_jiggle = EditorGUILayout.ObjectField("l_bodyjiggle", l_body_jiggle, typeof(GameObject), true) as GameObject;
            l_shouldertwist = EditorGUILayout.ObjectField("l_shouldertwist", l_shouldertwist, typeof(GameObject), true) as GameObject;
            l_thigh = EditorGUILayout.ObjectField("l_thigh", l_thigh, typeof(GameObject), true) as GameObject;
            l_thighbackjiggle = EditorGUILayout.ObjectField("l_thightbackjiggle", l_thighbackjiggle, typeof(GameObject), true) as GameObject;
            l_thighfrontjiggle = EditorGUILayout.ObjectField("l_thightfrontjiggle", l_thighfrontjiggle, typeof(GameObject), true) as GameObject;
            r_bodyjiggle = EditorGUILayout.ObjectField("r_bodyjiggle", r_bodyjiggle, typeof(GameObject), true) as GameObject;
            r_shouldertwist = EditorGUILayout.ObjectField("r_shouldertwist", r_shouldertwist, typeof(GameObject), true) as GameObject;
            r_thigh = EditorGUILayout.ObjectField("r_thigh", r_thigh, typeof(GameObject), true) as GameObject;
            r_thighbackjiggle = EditorGUILayout.ObjectField("r_thightbackjiggle", r_thighbackjiggle, typeof(GameObject), true) as GameObject;
            r_thighfrontjiggle = EditorGUILayout.ObjectField("r_thightfrontjiggle", r_thighfrontjiggle, typeof(GameObject), true) as GameObject;
            l_elbow = EditorGUILayout.ObjectField("l_elbow", l_elbow, typeof(GameObject), true) as GameObject;
            r_elbow = EditorGUILayout.ObjectField("r_elbow", r_elbow, typeof(GameObject), true) as GameObject;
            l_knee = EditorGUILayout.ObjectField("l_knee", l_knee, typeof(GameObject), true) as GameObject;
            r_knee = EditorGUILayout.ObjectField("r_knee", r_knee, typeof(GameObject), true) as GameObject;
            hatch_panel = EditorGUILayout.ObjectField("hatch_panel", hatch_panel, typeof(GameObject), true) as GameObject;
            c_hatchtop_og = EditorGUILayout.ObjectField("c_hatchtop_og", c_hatchtop_og, typeof(GameObject), true) as GameObject;
            l_rocket_pod = EditorGUILayout.ObjectField("l_rocket_pod", l_rocket_pod, typeof(GameObject), true) as GameObject;
        }
        else if (Titan == 3) //destroyer
        {
            c_spinec = EditorGUILayout.ObjectField("c_spinec", c_spinec, typeof(GameObject), true) as GameObject;
            l_thigh = EditorGUILayout.ObjectField("l_thigh", l_thigh, typeof(GameObject), true) as GameObject;
            r_thigh = EditorGUILayout.ObjectField("r_thigh", r_thigh, typeof(GameObject), true) as GameObject;
            l_knee = EditorGUILayout.ObjectField("l_knee", l_knee, typeof(GameObject), true) as GameObject;
            r_knee = EditorGUILayout.ObjectField("r_knee", r_knee, typeof(GameObject), true) as GameObject;
            l_shouldermid = EditorGUILayout.ObjectField("l_shouldermid", l_shouldermid, typeof(GameObject), true) as GameObject;
            r_shouldermid = EditorGUILayout.ObjectField("r_shouldermid", r_shouldermid, typeof(GameObject), true) as GameObject;
            hatch_panel = EditorGUILayout.ObjectField("hatch_panel", hatch_panel, typeof(GameObject), true) as GameObject;
            c_spinect = EditorGUILayout.ObjectField("c_spinect", c_spinect, typeof(GameObject), true) as GameObject;
            jx_railgun = EditorGUILayout.ObjectField("jx_railgun", jx_railgun, typeof(GameObject), true) as GameObject;
        }

        //--------------------------------------------------------------------------------------

        EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

        if (GUILayout.Button("Setup Titan"))
        {
            PrepList();
            TitanSetup();
        }
        
        if (GUILayout.Button("Reset"))
        {
            //shoudl've just made a list :/
            c_spinec = null;
            l_body_jiggle = null;
            l_shouldertwist = null;
            l_shoulder = null;
            r_shoulder = null;
            l_shouldermid = null;
            r_shouldermid = null;
            l_thigh = null;
            l_thighbackjiggle = null;
            l_thighfrontjiggle = null;
            r_bodyjiggle = null;
            r_shouldertwist = null;
            r_thigh = null;
            r_thighbackjiggle = null;
            r_thighfrontjiggle = null;
            l_elbow = null;
            r_elbow = null;
            l_knee = null;
            r_knee = null;
            hatch_panel = null;
            l_rocket_pod = null;
            c_hatchtop_og = null;
            c_spinect = null;
            jx_railgun = null;
            l_jigglebag = null;
            r_jigglebag = null;
            l_jigglebagc = null;
            r_jigglebagc = null;
            c_jigglehip = null;
        }
        GUILayout.Space(5f);

        GUILayout.Label("This tool is nowhere near perfect, in fact it usually\ndoes a pretty bad job, but can get things placed\ndecently enough for manual adjustment, usually just\nrotation and cleaning up extra clones.");

        GUILayout.Space(5f);
        EditorGUILayout.EndScrollView();
        EditorGUILayout.EndVertical();
    }

    void PrepList() //Creates the list of transfirst it can find
    {
        ArmorList.Clear();
        
        //PrepsList:
        ArmorList.Add(c_spinec);
        ArmorList.Add(l_body_jiggle);
        ArmorList.Add(l_shouldertwist);
        ArmorList.Add(l_shoulder);
        ArmorList.Add(r_shoulder);
        ArmorList.Add(l_shouldermid);
        ArmorList.Add(r_shouldermid);
        ArmorList.Add(l_thigh);
        ArmorList.Add(l_thighbackjiggle);
        ArmorList.Add(l_thighfrontjiggle);
        ArmorList.Add(r_bodyjiggle);
        ArmorList.Add(r_shouldertwist);
        ArmorList.Add(r_thigh);
        ArmorList.Add(r_thighbackjiggle);
        ArmorList.Add(r_thighfrontjiggle);
        ArmorList.Add(l_elbow);
        ArmorList.Add(r_elbow);
        ArmorList.Add(l_knee);
        ArmorList.Add(r_knee);
        ArmorList.Add(hatch_panel);
        ArmorList.Add(l_rocket_pod);
        ArmorList.Add(c_hatchtop_og);
        ArmorList.Add(c_spinect);
        ArmorList.Add(jx_railgun);
        ArmorList.Add(l_jigglebag);
        ArmorList.Add(r_jigglebag);
        ArmorList.Add(l_jigglebagc);
        ArmorList.Add(r_jigglebagc);
        ArmorList.Add(c_jigglehip);

        NameList.Add("c_spinec");
        NameList.Add("l_body_jiggle");
        NameList.Add("l_shouldertwist");
        NameList.Add("l_shoulder");
        NameList.Add("r_shoulder");
        NameList.Add("l_shouldermid");
        NameList.Add("r_shouldermid");
        NameList.Add("l_thigh");
        NameList.Add("l_thighbackjiggle");
        NameList.Add("l_thighfrontjiggle");
        NameList.Add("r_bodyjiggle");
        NameList.Add("r_shouldertwist");
        NameList.Add("r_thigh");
        NameList.Add("r_thighbackjiggle");
        NameList.Add("r_thighfrontjiggle");
        NameList.Add("l_elbow");
        NameList.Add("r_elbow");
        NameList.Add("l_knee");
        NameList.Add("r_knee");
        NameList.Add("hatch_panel");
        NameList.Add("l_rocket_pod");
        NameList.Add("c_hatchtop_og");
        NameList.Add("c_spinect");
        NameList.Add("jx_railgun");
        NameList.Add("l_jigglebag");
        NameList.Add("r_jigglebag");
        NameList.Add("l_jigglebagc");
        NameList.Add("r_jigglebagc");
        NameList.Add("c_jigglehip");
        //As you can tell, this is gonna be an unoptimized mess
    }

    void TitanSetup()//Does the magic
    {
        ArmorCount = -1;
        foreach(GameObject Armor in ArmorList)
        {
            ArmorCount += 1;
            if(Armor != null)
            {
                CurrentPiece = Instantiate(Armor);
                CurrentPiece.name = "(Auto) " + Armor.name;

                foreach(Transform Child in RootTransform)
                {
                    if(Child.transform.childCount > 0)
                    {
                        SearchTransform = Child;
                        SearchChild();

                        //foreach (Transform SubChild in Child)
                        //{
                            //Debug.Log(SubChild.name);
                            //SearchTransform = Child;
                            //SearchChild();
                        //}
                    }
                }

                //CurrentPiece.transform.parent = RootTransform.Find(Armor.name);
                CurrentPiece.transform.localPosition = new Vector3(0f,0f,0f);
                if(FixRotation)
                {
                    if (CurrentPiece.name.Contains("r_"))//Flips if piece belongs to right side
                    {
                        CurrentPiece.transform.localRotation = new Quaternion(180f, 0f, 0f, 1f);
                    }
                }
                else
                {
                    CurrentPiece.transform.localRotation = new Quaternion(0f, 0f, 0f, 1f);
                }
            }
        }
    }
    void SearchChild()
    {
        foreach (Transform Child in SearchTransform)
        {
            if (Child.transform.childCount > 0)
            {
                foreach (Transform SubChild in Child)
                {
                    SearchTransform = SubChild;
                    SearchChild();
                    if (SubChild.name.Contains(NameList[ArmorCount]) && UseMdlName == false)
                    {
                        //Debug.Log(ArmorList[ArmorCount].name + " = " + SubChild.name);
                        CurrentPiece.transform.parent = SubChild;
                        //Debug.Log(CurrentPiece.name + " set at: " + SubChild.name + "!");
                    }
                    else if (SubChild.name.Contains(ArmorList[ArmorCount].name) && UseMdlName == true)
                    {
                        CurrentPiece.transform.parent = SubChild;
                        //Debug.Log(CurrentPiece.name + " set at: " + SubChild.name + "!");
                    }
                }
            }
        }
    }
}
