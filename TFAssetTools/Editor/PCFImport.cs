using System;
using System.Diagnostics;
using UnityEditor;
using UnityEditor.Experimental.AssetImporters;
using UnityEngine;

[ScriptedImporter(1, "pcf")]
public class PCFImport : ScriptedImporter
{
    private string LocalPath;

    public override void OnImportAsset(AssetImportContext ctx)
    {
        TextAsset desc = new TextAsset("Titanfall particle system file, auto-converted on: " + DateTime.Now);
        Texture2D icon = Resources.Load<Texture2D>("PCFIcon");

        ctx.AddObjectToAsset(ctx.assetPath, desc, icon);

        ctx.AddObjectToAsset(ctx.assetPath, AssetDatabase.LoadAssetAtPath("Assets/PCF Testing/Converted/item_pickup/item_pickup.prefab", typeof(UnityEngine.Object)));

        //AutoConvert(ctx);
    }

    private void AutoConvert(AssetImportContext ctx)
    {
        //-------------------------------------
        //Auto Convert testing

        //Prepares the folder structure for assets
        string PcfPath = ctx.assetPath;

        //Creates root folder
        if (!AssetDatabase.IsValidFolder(PcfPath.Substring(0, PcfPath.Length - 4 - ctx.mainObject.name.Length) + "Converted"))
        {
            AssetDatabase.CreateFolder(PcfPath.Substring(0, PcfPath.Length - 5 - ctx.mainObject.name.Length), "Converted");
        }

        string rootPath = (PcfPath.Substring(0, PcfPath.Length - 4 - ctx.mainObject.name.Length) + "Converted");

        //Creates particle folder
        if (!AssetDatabase.IsValidFolder(rootPath + "/" + ctx.mainObject.name))
        {
            AssetDatabase.CreateFolder(rootPath, ctx.mainObject.name);
        }

        LocalPath = rootPath + "/" + ctx.mainObject.name;

        //Debug.Log(LocalPath);
        AssetDatabase.Refresh();

        //CreateParticle(ctx.mainObject);


    }
}