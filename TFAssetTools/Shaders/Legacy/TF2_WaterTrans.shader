// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TITANFALL/Legacy/Transparent/Water"
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

        [Header(___________________________________________________________________________________________________________________________)][Header(Ambient Occlusion Map)][Space]_OcclusionMap("_Ao", 2D) = "white" {}
        _AOInt("Occlusion Intensity", Range(0, 1)) = 1

        [Header(___________________________________________________________________________________________________________________________)][Header(Cavity Map)][Space]_Cav("_Cav", 2D) = "white" {}

        [Header(___________________________________________________________________________________________________________________________)][Header(Opacity Map)]_Opacity("_Opa", 2D) = "white" {}

        [Toggle] _ZWrite("ZWrite", Float) = 1
        _Offset("Offset", Float) = 0

        [Header(___________________________________________________________________________________________________________________________)][Header(Water)]_BlendMap("_Bm", 2D) = "white" {}
        _WaterNml("Secondary Water Normal", 2D) = "bump" {}
        _WaterMsk("Static Opacity Mask", 2D) = "black" {}
        _WaterOpa("Transparency override", Float) = 0

        _ScrollXSpeed("X Scroll Speed (Primary)",Range(-1,1)) = 0.1
        _ScrollYSpeed("Y Scroll Speed (Primary)",Range(-1,1)) = 0.1

        _ScrollXSpeed2("X Scroll Speed (Secondary)",Range(-1,1)) = 0.1
        _ScrollYSpeed2("Y Scroll Speed (Secondary)",Range(-1,1)) = 0.1

        _ScrollXSpeed3("X Scroll Speed (Blend)",Range(-1,1)) = 0.1
        _ScrollYSpeed3("Y Scroll Speed (Blend)",Range(-1,1)) = 0.1

        _ScrollXSpeed4("X Scroll Speed (Opacity)",Range(-1,1)) = 0.1
        _ScrollYSpeed4("Y Scroll Speed (Opacity)",Range(-1,1)) = 0.1

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
        sampler2D _OcclusionMap;
        sampler2D _Cav;
        sampler2D _Opacity;
        sampler2D _BlendMap;
        sampler2D _WaterNml;
        sampler2D _WaterMsk;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_SpecGlossMap;
            float2 uv_GlossMap;
            float2 uv_OcclusionMap;
            float2 uv_Cav;
            float2 uv_Opacity;
            float2 uv_BlendMap;
            float2 uv_WaterNml;
            float2 uv_WaterMsk;
            float4 vertColor;
        };

        half _Glossiness;
        half _AOInt;
        half _WaterOpa;
        fixed3 _SpecularColor;
        fixed4 _Color;

        //Primary scroll
        fixed _ScrollXSpeed; 
        fixed _ScrollYSpeed;
        //Secondary normal scroll
        fixed _ScrollXSpeed2;
        fixed _ScrollYSpeed2;
        //BlendMap scroll
        fixed _ScrollXSpeed3;
        fixed _ScrollYSpeed3;
        //Opacity
        fixed _ScrollXSpeed4;
        fixed _ScrollYSpeed4;


        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert(inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.vertColor = v.color;
        }

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            //Panning
            fixed2 scrolledUV = IN.uv_MainTex;

            fixed xScrollValue = frac(_ScrollXSpeed * _Time.y);
            fixed yScrollValue = frac(_ScrollYSpeed * _Time.y);
            scrolledUV += fixed2(xScrollValue, yScrollValue);

            //2
            fixed2 scrolledUV2 = IN.uv_WaterNml;

            fixed xScrollValue2 = frac(_ScrollXSpeed2 * _Time.y);
            fixed yScrollValue2 = frac(_ScrollYSpeed2 * _Time.y);
            scrolledUV2 += fixed2(xScrollValue2, yScrollValue2);

            //3
            fixed2 scrolledUV3 = IN.uv_BlendMap;

            fixed xScrollValue3 = frac(_ScrollXSpeed3 * _Time.y);
            fixed yScrollValue3 = frac(_ScrollYSpeed3 * _Time.y);
            scrolledUV3 += fixed2(xScrollValue3, yScrollValue3);

            //4
            fixed2 scrolledUV4 = IN.uv_Opacity;

            fixed xScrollValue4 = frac(_ScrollXSpeed4 * _Time.y);
            fixed yScrollValue4 = frac(_ScrollYSpeed4 * _Time.y);
            scrolledUV4 += fixed2(xScrollValue4, yScrollValue4);

            // Maintex
            fixed4 c = tex2D(_MainTex, scrolledUV) * _Color * tex2D(_Cav, scrolledUV);
            o.Albedo = c;
            //AO
            o.Occlusion = tex2D(_OcclusionMap, scrolledUV) * tex2D(_Cav, scrolledUV) * _AOInt;
            // Specular Jazz
            o.Specular = tex2D(_SpecGlossMap, scrolledUV) * _SpecularColor * tex2D(_MainTex, scrolledUV).a * (1 - tex2D(_WaterMsk, IN.uv_WaterMsk).a);
            o.Smoothness = _Glossiness * tex2D(_GlossMap, scrolledUV) * tex2D(_MainTex, scrolledUV).a * (1 - tex2D(_WaterMsk, IN.uv_WaterMsk).a);
            // Normal Jazz
            o.Normal = UnpackNormal(tex2D(_BumpMap, scrolledUV)) + (UnpackNormal(tex2D(_WaterNml, scrolledUV2 * 8)) * (tex2D(_BlendMap, scrolledUV3)));
            //Opacity
            //o.Emission = tex2D(_WaterMsk, IN.uv_WaterMsk);
            o.Alpha = (c.a - (1 - tex2D(_Opacity, scrolledUV4 * 2))) * (1 - tex2D(_WaterMsk, IN.uv_WaterMsk).a) + _WaterOpa * IN.vertColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
