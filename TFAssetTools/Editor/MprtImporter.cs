using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.AssetImporters;
using UnityEngine;

[ScriptedImporter(1, "mprt")]
public class BMFSDK_ModImporter : ScriptedImporter
{
    public override void OnImportAsset(AssetImportContext ctx)
    {
        TextAsset desc = new TextAsset("Contains prop placement data for Respawn Entertainment .bsp files");
        Texture2D icon = Resources.Load<Texture2D>("MprtIcon");

        ctx.AddObjectToAsset(ctx.assetPath, desc, icon);
    }
}
