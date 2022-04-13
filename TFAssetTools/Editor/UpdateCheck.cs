using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

public class UpdateCheck : EditorWindow
{
    [MenuItem("Titanfall Asset Tools/--Resources--/Check For Tool Updates")]
    public static void ShowWindow()
    {
        Application.OpenURL("https://github.com/Swagguy47/VRChat-Titanfall-Unity-Tools/releases");
    }
}
