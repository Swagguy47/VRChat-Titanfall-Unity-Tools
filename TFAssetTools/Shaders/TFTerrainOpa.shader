// Upgrade NOTE: upgraded instancing buffer 'TITANFALLTerrain' to new syntax.

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TITANFALL/Terrain"
{
	Properties
	{
		[Header(________________________________________________________________________________________________)][Header(Surface)]_Color("Color", Color) = (1,1,1,1)
		[SingleLineTexture]_MainTex("_Col", 2D) = "white" {}
		_Tiling("Tiling | Offset", Vector) = (1,1,0,0)
		[Header(________________________________________________________________________________________________)][Header(Lighting)][SingleLineTexture]_BumpMap("_Nml", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		[SingleLineTexture]_SpecGlossMap("_Spec", 2D) = "black" {}
		[SingleLineTexture]_GlossMap("_Gls/_Exp", 2D) = "gray" {}
		[Gamma]_Glossiness("Smoothness", Range( 0 , 1)) = 1
		[SingleLineTexture]_OcclusionMap("_Ao", 2D) = "white" {}
		[SingleLineTexture]_ParallaxMap("_Cav", 2D) = "white" {}
		[Header(________________________________________________________________________________________________)][Header(Emission)][SingleLineTexture]_EmissionMap("_Ilm", 2D) = "white" {}
		[HDR][Gamma]_EmissionColor("GlowCol", Color) = (0,0,0,0)
		[Header(________________________________________________________________________________________________)][Header(Terrain Blending (Red))][SingleLineTexture]_DetailMask("_Msk", 2D) = "white" {}
		[SingleLineTexture]_DetailAlbedoMap("Detail/Camo", 2D) = "white" {}
		[SingleLineTexture]_DetailNormalMap("Detail Normal", 2D) = "bump" {}
		_DetailBumpStrength("Normal Strength", Float) = 1
		[SingleLineTexture]_CamoSpc("Detail Specular", 2D) = "black" {}
		[SingleLineTexture]_CamoGls("Detail Gloss", 2D) = "black" {}
		_DetailTiling("Tiling | Offset", Vector) = (1,1,0,0)
		[Header(________________________________________________________________________________________________)][Header(Extras)][Enum(Both,0,Back,1,Front,2)]_CullMode("CullMode", Int) = 2
		_DepthOffset("DepthOffset", Int) = 0
		_DetailSmoothness("DetailSmoothness", Range( 0 , 1)) = 1
		_MaskBlending("MaskBlend", Float) = 30
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		Offset  [_DepthOffset] , 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _BumpMap;
		uniform sampler2D _DetailNormalMap;
		uniform sampler2D _MainTex;
		uniform sampler2D _ParallaxMap;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _DetailMask;
		uniform sampler2D _EmissionMap;
		uniform sampler2D _SpecGlossMap;
		uniform sampler2D _OcclusionMap;
		uniform sampler2D _CamoSpc;
		uniform sampler2D _GlossMap;
		uniform sampler2D _CamoGls;

		UNITY_INSTANCING_BUFFER_START(TITANFALLTerrain)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Tiling)
#define _Tiling_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float4, _DetailTiling)
#define _DetailTiling_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionColor)
#define _EmissionColor_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(int, _DepthOffset)
#define _DepthOffset_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(int, _CullMode)
#define _CullMode_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
#define _NormalScale_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float, _DetailBumpStrength)
#define _DetailBumpStrength_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float, _MaskBlending)
#define _MaskBlending_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float, _Glossiness)
#define _Glossiness_arr TITANFALLTerrain
			UNITY_DEFINE_INSTANCED_PROP(float, _DetailSmoothness)
#define _DetailSmoothness_arr TITANFALLTerrain
		UNITY_INSTANCING_BUFFER_END(TITANFALLTerrain)

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			int _DepthOffset_Instance = UNITY_ACCESS_INSTANCED_PROP(_DepthOffset_arr, _DepthOffset);
			int _CullMode_Instance = UNITY_ACCESS_INSTANCED_PROP(_CullMode_arr, _CullMode);
			float4 _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float2 appendResult105 = (float2(_Tiling_Instance.x , _Tiling_Instance.y));
			float2 appendResult106 = (float2(_Tiling_Instance.z , _Tiling_Instance.w));
			float2 uv_TexCoord107 = i.uv_texcoord * appendResult105 + appendResult106;
			float2 MainUV108 = uv_TexCoord107;
			float _NormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalScale_arr, _NormalScale);
			float4 _DetailTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailTiling_arr, _DetailTiling);
			float2 appendResult109 = (float2(_DetailTiling_Instance.x , _DetailTiling_Instance.y));
			float2 appendResult110 = (float2(_DetailTiling_Instance.z , _DetailTiling_Instance.w));
			float2 uv_TexCoord111 = i.uv_texcoord * appendResult109 + appendResult110;
			float2 DetailUV112 = uv_TexCoord111;
			float _DetailBumpStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailBumpStrength_arr, _DetailBumpStrength);
			float3 DetailBump73 = UnpackScaleNormal( tex2D( _DetailNormalMap, DetailUV112 ), _DetailBumpStrength_Instance );
			float3 Normal16 = BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, MainUV108 ), _NormalScale_Instance ) , DetailBump73 );
			o.Normal = Normal16;
			float4 Cav33 = tex2D( _ParallaxMap, MainUV108 );
			float4 Albedo53 = ( tex2D( _MainTex, MainUV108 ) * Cav33 );
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 CamoTex63 = ( tex2D( _DetailAlbedoMap, DetailUV112 ) * Cav33 );
			float _MaskBlending_Instance = UNITY_ACCESS_INSTANCED_PROP(_MaskBlending_arr, _MaskBlending);
			float4 lerpResult130 = lerp( float4( 0,0,0,0 ) , tex2D( _DetailMask, MainUV108 ) , _MaskBlending_Instance);
			float4 CamoMask60 = ( saturate( lerpResult130 ) * i.vertexColor.r );
			float4 lerpResult58 = lerp( ( Albedo53 * _Color_Instance ) , CamoTex63 , CamoMask60);
			float4 Color48 = lerpResult58;
			o.Albedo = Color48.rgb;
			float4 _EmissionColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionColor_arr, _EmissionColor);
			float4 Emisision26 = ( tex2D( _EmissionMap, MainUV108 ) * _EmissionColor_Instance );
			o.Emission = Emisision26.rgb;
			float4 Ao32 = ( tex2D( _OcclusionMap, MainUV108 ) * Cav33 );
			float4 DetailSpec75 = tex2D( _CamoSpc, DetailUV112 );
			float4 lerpResult90 = lerp( ( tex2D( _SpecGlossMap, MainUV108 ) * Ao32 ) , DetailSpec75 , CamoMask60);
			float4 Specular43 = lerpResult90;
			o.Specular = Specular43.rgb;
			float _Glossiness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Glossiness_arr, _Glossiness);
			float _DetailSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailSmoothness_arr, _DetailSmoothness);
			float4 DetailGloss77 = ( tex2D( _CamoGls, DetailUV112 ) * _DetailSmoothness_Instance );
			float4 lerpResult93 = lerp( ( tex2D( _GlossMap, MainUV108 ) * _Glossiness_Instance * Ao32 ) , DetailGloss77 , CamoMask60);
			float4 Gloss41 = lerpResult93;
			o.Smoothness = Gloss41.r;
			o.Occlusion = Ao32.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "T0_TFShaderGUI"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;102;-2656.627,1082.411;Inherit;False;1078.359;1344.9;Camos / Detail;22;132;133;123;131;59;130;124;60;125;126;77;62;122;76;74;72;75;78;73;69;68;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;57;-2648.409,720;Inherit;False;997.2067;329.8243;Cavity;3;118;29;33;;0.5143232,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2655.695,-590.9303;Inherit;False;1018.073;390.0239;Albedo;5;115;1;67;70;53;;1,0.02937273,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1600,720;Inherit;False;895.0516;333.681;Normal;6;80;79;15;14;16;119;;1,0,0.8207312,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-2652.559,369.4026;Inherit;False;1003.36;324.9888;Ambient Occlusion;5;117;28;56;32;31;;0,0.8785672,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1600,-592;Inherit;False;893.7484;381.5861;Color;7;54;48;6;2;61;58;64;;1,0.524459,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1600,368;Inherit;False;888.2646;325.1341;Specular;7;43;18;35;36;91;92;120;;0,0.1942768,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1600,-176;Inherit;False;891.6624;508.7013;Gloss;8;41;19;34;21;20;94;95;121;;0.1407661,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2651.035,-174.9305;Inherit;False;1010.695;504.3365;Emission;5;116;22;25;26;23;;1,0.9970177,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2055.198,-126.9304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1863.198,-126.9304;Inherit;False;Emisision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;-2359.198,65.06909;Inherit;False;InstancedProperty;_EmissionColor;GlowCol;11;2;[HDR];[Gamma];Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1424,144;Inherit;False;32;Ao;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-640,-16;Inherit;False;16;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-640,48;Inherit;False;26;Emisision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-640,112;Inherit;False;43;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-640,176;Inherit;False;41;Gloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-640,-80;Inherit;False;48;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;38;-640,464;Inherit;False;InstancedProperty;_DepthOffset;DepthOffset;20;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;37;-640,368;Inherit;False;InstancedProperty;_CullMode;CullMode;19;2;[Header];[Enum];Create;True;2;________________________________________________________________________________________________;Extras;3;Both;0;Back;1;Front;2;0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1968,432;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1840,432;Inherit;False;Ao;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-2144,768;Inherit;False;Cav;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1360,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1216,-416;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1216,-480;Inherit;False;63;CamoTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;-1024,-544;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-880,-544;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2160,480;Inherit;False;33;Cav;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1536,64;Inherit;False;InstancedProperty;_Glossiness;Smoothness;7;1;[Gamma];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-384,-16;Float;False;True;-1;2;T0_TFShaderGUI;0;0;StandardSpecular;TITANFALL/Terrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;True;0;True;_DepthOffset;0;False;_DepthOffset;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;True;_AlphaClip;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-640,240;Inherit;False;32;Ao;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1552,-544;Inherit;False;53;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1920,-544;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2048,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-896,784;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1296,960;Inherit;False;73;DetailBump;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;79;-1104,864;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1440,608;Inherit;False;32;Ao;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1248,416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-1072,416;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-896,416;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1248,512;Inherit;False;75;DetailSpec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1248,592;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1200,-128;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-912,-128;Inherit;False;Gloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;93;-1056,-128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-1216,0;Inherit;False;77;DetailGloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-1216,80;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2336,-352;Inherit;False;33;Cav;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-1888.627,1130.411;Inherit;False;CamoTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2016.627,1130.411;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2288.627,1322.411;Inherit;False;33;Cav;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-2080.627,1690.411;Inherit;False;DetailBump;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2080.627,1914.411;Inherit;False;DetailSpec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;72;-2416.627,1690.411;Inherit;True;Property;_DetailNormalMap;Detail Normal;14;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-2416.627,1914.411;Inherit;True;Property;_CamoSpc;Detail Specular;16;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;-2416.627,2154.411;Inherit;True;Property;_CamoGls;Detail Gloss;17;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;29;-2448,768;Inherit;True;Property;_ParallaxMap;_Cav;9;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Cavity Map;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1568,416;Inherit;True;Property;_SpecGlossMap;_Spec;5;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Specular Map;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-2448,416;Inherit;True;Property;_OcclusionMap;_Ao;8;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Ambient Occlusion Map;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1552,-128;Inherit;True;Property;_GlossMap;_Gls/_Exp;6;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Gloss Map;0;0;False;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1408,768;Inherit;True;Property;_BumpMap;_Nml;3;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Lighting;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2471.198,-542.9304;Inherit;True;Property;_MainTex;_Col;1;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-1584,-464;Inherit;False;InstancedProperty;_Color;Color;0;1;[Header];Create;True;2;________________________________________________________________________________________________;Surface;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-2455.198,-126.9304;Inherit;True;Property;_EmissionMap;_Ilm;10;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Emission;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;104;-1556.222,1122.721;Inherit;False;851.3975;645.8995;Tiling;10;114;113;112;111;110;109;108;107;106;105;;0,0,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;105;-1328.825,1172.721;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;106;-1328.825,1284.721;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;107;-1140.234,1191.478;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-928.8245,1188.721;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;-1330.222,1521.621;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1330.222,1633.621;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;111;-1138.222,1537.621;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-930.222,1537.621;Inherit;False;DetailUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;113;-1504.825,1188.721;Inherit;False;InstancedProperty;_Tiling;Tiling | Offset;2;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;114;-1506.222,1537.621;Inherit;False;InstancedProperty;_DetailTiling;Tiling | Offset;18;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;115;-2640,-528;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2624,-112;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-2624,432;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-2624,768;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1568,864;Inherit;False;InstancedProperty;_NormalScale;NormalScale;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-1568,784;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1584,608;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-1584,144;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-2616.658,1658.411;Inherit;False;112;DetailUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1870.094,2161.588;Inherit;False;DetailGloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-1996.943,2242.336;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;124;-2112.972,1523.955;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;130;-2102.299,1392.309;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-2621.658,1453.411;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;133;-1957.299,1398.309;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-1827.299,1455.309;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-1748.552,1559.02;Inherit;False;CamoMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-2296.299,1594.309;Inherit;False;InstancedProperty;_MaskBlending;MaskBlend;22;0;Create;False;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2608.627,1738.411;Inherit;False;InstancedProperty;_DetailBumpStrength;Normal Strength;15;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-2392.889,2346.406;Inherit;False;InstancedProperty;_DetailSmoothness;DetailSmoothness;21;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-2416.627,1130.411;Inherit;True;Property;_DetailAlbedoMap;Detail/Camo;13;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Detail or Camo;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-2445.627,1400.411;Inherit;True;Property;_DetailMask;_Msk;12;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Terrain Blending (Red);0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;23;0;22;0
WireConnection;23;1;25;0
WireConnection;26;0;23;0
WireConnection;31;0;28;0
WireConnection;31;1;56;0
WireConnection;32;0;31;0
WireConnection;33;0;29;0
WireConnection;2;0;54;0
WireConnection;2;1;6;0
WireConnection;58;0;2;0
WireConnection;58;1;64;0
WireConnection;58;2;61;0
WireConnection;48;0;58;0
WireConnection;0;0;49;0
WireConnection;0;1;17;0
WireConnection;0;2;27;0
WireConnection;0;3;45;0
WireConnection;0;4;42;0
WireConnection;0;5;65;0
WireConnection;53;0;70;0
WireConnection;70;0;1;0
WireConnection;70;1;67;0
WireConnection;16;0;79;0
WireConnection;79;0;14;0
WireConnection;79;1;80;0
WireConnection;36;0;18;0
WireConnection;36;1;35;0
WireConnection;90;0;36;0
WireConnection;90;1;91;0
WireConnection;90;2;92;0
WireConnection;43;0;90;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;20;2;34;0
WireConnection;41;0;93;0
WireConnection;93;0;20;0
WireConnection;93;1;94;0
WireConnection;93;2;95;0
WireConnection;63;0;68;0
WireConnection;68;0;62;0
WireConnection;68;1;69;0
WireConnection;73;0;72;0
WireConnection;75;0;74;0
WireConnection;72;1;122;0
WireConnection;72;5;78;0
WireConnection;74;1;122;0
WireConnection;76;1;122;0
WireConnection;29;1;118;0
WireConnection;18;1;120;0
WireConnection;28;1;117;0
WireConnection;19;1;121;0
WireConnection;14;1;119;0
WireConnection;14;5;15;0
WireConnection;1;1;115;0
WireConnection;22;1;116;0
WireConnection;105;0;113;1
WireConnection;105;1;113;2
WireConnection;106;0;113;3
WireConnection;106;1;113;4
WireConnection;107;0;105;0
WireConnection;107;1;106;0
WireConnection;108;0;107;0
WireConnection;109;0;114;1
WireConnection;109;1;114;2
WireConnection;110;0;114;3
WireConnection;110;1;114;4
WireConnection;111;0;109;0
WireConnection;111;1;110;0
WireConnection;112;0;111;0
WireConnection;77;0;126;0
WireConnection;126;0;76;0
WireConnection;126;1;125;0
WireConnection;130;1;59;0
WireConnection;130;2;131;0
WireConnection;133;0;130;0
WireConnection;132;0;133;0
WireConnection;132;1;124;1
WireConnection;60;0;132;0
WireConnection;62;1;122;0
WireConnection;59;1;123;0
ASEEND*/
//CHKSM=0B15547D202DE9059CE79EB31B895DC41081883F