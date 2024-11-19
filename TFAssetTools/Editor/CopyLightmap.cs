#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public class CopyLightmap : ScriptableWizard
{
    public GameObject sourceParent;
    public GameObject destParent;

    void OnWizardCreate ()
    {
        var srcR = sourceParent.GetComponentsInChildren<MeshRenderer>();
        var dstR = destParent.GetComponentsInChildren<MeshRenderer>();

        var storageGO = GameObject.Find("!ftraceLightmaps");
        if (storageGO == null) {
            storageGO = new GameObject();
            storageGO.name = "!ftraceLightmaps";
            storageGO.hideFlags = HideFlags.HideInHierarchy;
        }
        var storage = storageGO.GetComponent<ftLightmapsStorage>();
        if (storage == null) {
            storage = storageGO.AddComponent<ftLightmapsStorage>();
        }

        for(int i=0; i<dstR.Length; i++)
        {
            var dstName = dstR[i].name;
            for(int j=0; j<srcR.Length; j++)
            {
                var srcName = srcR[j].name;
                if (dstName == srcName)
                {
                    dstR[i].lightmapIndex = srcR[j].lightmapIndex;
                    dstR[i].lightmapScaleOffset = srcR[j].lightmapScaleOffset;

                    storage.bakedRenderers.Add(dstR[i]);
                    storage.bakedIDs.Add(dstR[i].lightmapIndex);
                    storage.bakedScaleOffset.Add(dstR[i].lightmapScaleOffset);
                    storage.bakedVertexOffset.Add(-1);
                    storage.bakedVertexColorMesh.Add(null);
                    break;
                }
            }
        }

        EditorUtility.SetDirty(storage);
        EditorSceneManager.MarkAllScenesDirty();
    }

    [MenuItem ("Custom/Copy lightmap")]
    public static void CopyLightmap2 () {
        ScriptableWizard.DisplayWizard("Copy Lightmap", typeof(CopyLightmap), "Copy");
    }
}

#endif
