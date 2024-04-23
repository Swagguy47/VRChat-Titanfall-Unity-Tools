Shader "TITANFALL/Legacy/Transparent/Titanfall 2 Standard"
{
    Properties
    {
        //Too lazy to write a custom editor for this thing rn so take a bunch of underscore headers lmaooooo
        [Header(___________________________________________________________________________________________________________________________)] [Header(Albedo Map)][Space]_Color("Color", Color) = (1,1,1,1)
        _MainTex ("_Col", 2D) = "white" {}

        [Header(___________________________________________________________________________________________________________________________)][Header(Normal Map)][Space]_BumpMap("_Nml", 2D) = "bump" {}

        [Header(___________________________________________________________________________________________________________________________)][Header(Specular Map)][Space]_SpecGlossMap("_Spec", 2D) = "black" {}
        _SpecularColor("SpecularInt", Color) = (0.8, 0.8, 0.8)

        [Header(___________________________________________________________________________________________________________________________)][Header(Gloss Map)][Space]_GlossMap("_Gls/_Exp", 2D) = "white" {}
        _Glossiness("Smoothness", Float) = 0.75
        

        [Header(___________________________________________________________________________________________________________________________)][Header(Emission Glow)][Space]_EmissionMap("_Ilm", 2D) = "black" {}
        _EmissionColor("EmissionColor", Color) = (1,1,1,1)
        _EmissionInt("EmissionInt", Float) = 1

        [Header(___________________________________________________________________________________________________________________________)][Header(Ambient Occlusion Map)][Space]_OcclusionMap("_Ao", 2D) = "white" {}
        _AOInt("Occlusion Intensity", Range(0, 1)) = 1

        [Header(___________________________________________________________________________________________________________________________)][Header(Cavity Map)][Space]_Cav("_Cav", 2D) = "white" {}

        [Header(___________________________________________________________________________________________________________________________)][Header(Camo or Detail Maps)][Space]_CamoTex("Detail/Camo", 2D) = "black" {}
        _CamoNml("Detail Normal", 2D) = "bump" {}
        _CamoMsk("_Msk", 2D) = "white" {}

        [Header(___________________________________________________________________________________________________________________________)][Header(Opacity Map)]_Opacity("_Opa", 2D) = "white" {}

        [Toggle] _ZWrite("ZWrite", Float) = 1
        _Offset("Offset", float) = 0

        [Header(___________________________________________________________________________________________________________________________)][Header(Extras)][Space][Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 2
    }
    SubShader
    {
        Tags{ "RenderType" = "Transparent" "Queue" = "AlphaTest+50"}
        Blend SrcAlpha OneMinusSrcAlpha

        
        Cull[_Cull]
        
        LOD 200

        ZWrite[_ZWrite]
        
        Offset[_Offset],[_Offset]

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecular fullforwardshadows alpha

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 4.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _SpecGlossMap;
        sampler2D _GlossMap;
        sampler2D _EmissionMap;
        sampler2D _OcclusionMap;
        sampler2D _Cav;
        sampler2D _Opacity;
        sampler2D _CamoTex;
        sampler2D _CamoNml;
        sampler2D _CamoMsk;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_SpecGlossMap;
            float2 uv_GlossMap;
            float2 uv_EmissionMap;
            float2 uv_OcclusionMap;
            float2 uv_Cav;
            float2 uv_Opacity;
            float2 uv_CamoTex;
            float2 uv_CamoNml;
            float2 uv_CamoMsk;
        };

        half _Glossiness;
        half _AOInt;
        half _EmissionInt;
        fixed3 _SpecularColor;
        fixed4 _Color;
        fixed4 _EmissionColor;

        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            // Maintex + camo
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color + (tex2D (_CamoTex, IN.uv_CamoTex * 8) * tex2D (_CamoMsk, IN.uv_CamoMsk));
            // Camo'd Maintex + AO & Cav
            o.Albedo = c.rgb * tex2D(_Cav, IN.uv_Cav);
            o.Occlusion = tex2D(_OcclusionMap, IN.uv_OcclusionMap) * tex2D(_Cav, IN.uv_Cav) * _AOInt;
            // Specular Jazz
            o.Specular = tex2D(_SpecGlossMap, IN.uv_SpecGlossMap) * _SpecularColor * tex2D(_MainTex, IN.uv_MainTex).a;
            o.Smoothness = _Glossiness * tex2D(_GlossMap, IN.uv_GlossMap) * tex2D(_MainTex, IN.uv_MainTex).a;
            // Normal Jazz
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)) + (UnpackNormal(tex2D(_CamoNml, IN.uv_CamoNml * 8)) * (tex2D(_CamoMsk, IN.uv_CamoMsk)));
            //Illum
            o.Emission = tex2D(_EmissionMap, IN.uv_EmissionMap) * _EmissionColor * _EmissionInt;
            //Opacity
            o.Alpha = c.a - (1 - tex2D(_Opacity, IN.uv_Opacity));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
