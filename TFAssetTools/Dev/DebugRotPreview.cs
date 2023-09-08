using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugRotPreview : MonoBehaviour
{
    [HideInInspector]public int[] RotationOps = { 0, 1, 2, 3 };

    [HideInInspector]public RotOptions Inverses;

    [HideInInspector] public float OrgMult = 1;

    public string[] RotVals = new string[]
        {
                "X", "Y", "Z", "W",
        };

    [Serializable]
    public enum RotOptions
    {
        X = 1 << 0, Y = 1 << 1, Z = 1 << 2, W = 1 << 3
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawRay(transform.position, organize(transform).eulerAngles);
    }

    public Quaternion organize(Transform ThisLight)
    {
        Quaternion LightRot = ThisLight.rotation;

        float x, y, z, w;

        float[] vals = { LightRot.x, LightRot.y, LightRot.z, LightRot.w };

        x = (vals[RotationOps[0]]) * (Convert.ToInt32(Inverses == RotOptions.X) == 1 ? -1 : 1) * OrgMult;
        y = (vals[RotationOps[1]]) * (Convert.ToInt32(Inverses == RotOptions.Y) == 1 ? -1 : 1) * OrgMult;
        z = (vals[RotationOps[2]]) * (Convert.ToInt32(Inverses == RotOptions.Z) == 1 ? -1 : 1) * OrgMult;
        w = (vals[RotationOps[3]]) * (Convert.ToInt32(Inverses == RotOptions.W) == 1 ? -1 : 1) * OrgMult;

        return new Quaternion(x, y, z, w);
    }
}
