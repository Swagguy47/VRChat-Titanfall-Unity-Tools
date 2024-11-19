// Upgrade NOTE: upgraded instancing buffer 'HiddenTITANFALLTerrainTwoBlends' to new syntax.

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/TITANFALL/Terrain (Two Blends)"
{
	Properties
	{
		[Header(________________________________________________________________________________________________)][Header(Base)]_Color("Color", Color) = (1,1,1,1)
		[SingleLineTexture]_MainTex("_Col", 2D) = "white" {}
		_Tiling("Tiling | Offset", Vector) = (1,1,0,0)
		[SingleLineTexture]_BumpMap("_Nml", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		[SingleLineTexture]_SpecGlossMap("_Spec", 2D) = "black" {}
		[SingleLineTexture]_GlossMap("_Gls/_Exp", 2D) = "gray" {}
		[Gamma]_Glossiness("Smoothness", Range( 0 , 1)) = 1
		[Header(________________________________________________________________________________________________)][Header(Terrain Blending (Red))]_ColorRed("Color", Color) = (1,1,1,1)
		[SingleLineTexture]_DetailAlbedoMap("_Col", 2D) = "white" {}
		[SingleLineTexture]_DetailNormalMap("_Nml", 2D) = "bump" {}
		_DetailBumpStrength("Normal Strength", Float) = 1
		[SingleLineTexture]_CamoSpc("_Spc", 2D) = "black" {}
		[SingleLineTexture]_CamoGls("_Gls", 2D) = "black" {}
		_DetailSmoothness("Smoothness", Range( 0 , 1)) = 1
		[Header(________________________________________________________________________________________________)][Header(Terrain Blending (Green))]_ColorGreen("Color", Color) = (1,1,1,1)
		[SingleLineTexture]_ColGreen("_Col", 2D) = "white" {}
		[SingleLineTexture]_NmlGreen("_Nml", 2D) = "bump" {}
		_NormalStrengthG("Normal Strength", Float) = 1
		[SingleLineTexture]_SpcGreen("_Spc", 2D) = "black" {}
		[SingleLineTexture]_GlsGreen("_Gls", 2D) = "black" {}
		_SmoothnessGreen("Smoothness", Range( 0 , 1)) = 1
		[Header(________________________________________________________________________________________________)][Header(Extras)][Enum(Both,0,Back,1,Front,2)]_CullMode("CullMode", Int) = 2
		_DepthOffset("DepthOffset", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull [_CullMode]
		Offset  [_DepthOffset] , 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 5.0
		#pragma multi_compile_instancing
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _BumpMap;
		uniform sampler2D _DetailNormalMap;
		uniform sampler2D _NmlGreen;
		uniform sampler2D _MainTex;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _ColGreen;
		uniform sampler2D _SpecGlossMap;
		uniform sampler2D _CamoSpc;
		uniform sampler2D _SpcGreen;
		uniform sampler2D _GlossMap;
		uniform sampler2D _CamoGls;
		uniform sampler2D _GlsGreen;

		UNITY_INSTANCING_BUFFER_START(HiddenTITANFALLTerrainTwoBlends)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Tiling)
#define _Tiling_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float4, _ColorRed)
#define _ColorRed_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float4, _ColorGreen)
#define _ColorGreen_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(int, _DepthOffset)
#define _DepthOffset_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(int, _CullMode)
#define _CullMode_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
#define _NormalScale_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float, _DetailBumpStrength)
#define _DetailBumpStrength_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalStrengthG)
#define _NormalStrengthG_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float, _Glossiness)
#define _Glossiness_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float, _DetailSmoothness)
#define _DetailSmoothness_arr HiddenTITANFALLTerrainTwoBlends
			UNITY_DEFINE_INSTANCED_PROP(float, _SmoothnessGreen)
#define _SmoothnessGreen_arr HiddenTITANFALLTerrainTwoBlends
		UNITY_INSTANCING_BUFFER_END(HiddenTITANFALLTerrainTwoBlends)

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
			float _DetailBumpStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailBumpStrength_arr, _DetailBumpStrength);
			float3 RedBump73 = UnpackScaleNormal( tex2D( _DetailNormalMap, MainUV108 ), _DetailBumpStrength_Instance );
			float _NormalStrengthG_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalStrengthG_arr, _NormalStrengthG);
			float3 GreenBump145 = UnpackScaleNormal( tex2D( _NmlGreen, MainUV108 ), _NormalStrengthG_Instance );
			float3 Normal16 = BlendNormals( BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, MainUV108 ), _NormalScale_Instance ) , RedBump73 ) , GreenBump145 );
			o.Normal = Normal16;
			float4 Albedo53 = tex2D( _MainTex, MainUV108 );
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 _ColorRed_Instance = UNITY_ACCESS_INSTANCED_PROP(_ColorRed_arr, _ColorRed);
			float4 RedCol63 = ( tex2D( _DetailAlbedoMap, MainUV108 ) * _ColorRed_Instance );
			float4 lerpResult58 = lerp( ( Albedo53 * _Color_Instance ) , RedCol63 , i.vertexColor.r);
			float4 _ColorGreen_Instance = UNITY_ACCESS_INSTANCED_PROP(_ColorGreen_arr, _ColorGreen);
			float4 GreenCol152 = ( tex2D( _ColGreen, MainUV108 ) * _ColorGreen_Instance );
			float4 lerpResult156 = lerp( lerpResult58 , GreenCol152 , i.vertexColor.g);
			float4 Color48 = lerpResult156;
			o.Albedo = Color48.rgb;
			float4 RedSpec75 = tex2D( _CamoSpc, MainUV108 );
			float4 lerpResult90 = lerp( tex2D( _SpecGlossMap, MainUV108 ) , RedSpec75 , i.vertexColor.r);
			float4 GreenSpec144 = tex2D( _SpcGreen, MainUV108 );
			float4 lerpResult159 = lerp( lerpResult90 , GreenSpec144 , i.vertexColor.g);
			float4 Specular43 = lerpResult159;
			o.Specular = Specular43.rgb;
			float _Glossiness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Glossiness_arr, _Glossiness);
			float _DetailSmoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailSmoothness_arr, _DetailSmoothness);
			float4 RedGloss77 = ( tex2D( _CamoGls, MainUV108 ) * _DetailSmoothness_Instance );
			float4 lerpResult93 = lerp( ( tex2D( _GlossMap, MainUV108 ) * _Glossiness_Instance ) , RedGloss77 , i.vertexColor.r);
			float _SmoothnessGreen_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmoothnessGreen_arr, _SmoothnessGreen);
			float4 GreenGloss143 = ( tex2D( _GlsGreen, MainUV108 ) * _SmoothnessGreen_Instance );
			float4 lerpResult157 = lerp( lerpResult93 , GreenGloss143 , i.vertexColor.g);
			float4 Gloss41 = lerpResult157;
			o.Smoothness = Gloss41.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "T1_TFShaderGUI"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;102;-3211.635,-1653.792;Inherit;False;887.1901;979.9791;RED TERRAIN;14;76;72;74;125;122;73;75;77;126;78;62;138;139;63;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2951.97,-41.37148;Inherit;False;692.4458;277.1571;Albedo;3;53;1;115;;0.5,0.01372549,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-2019.335,786.1785;Inherit;False;1323.35;432.6265;Normal;8;162;16;161;79;14;119;15;80;;0.5,0,0.4098039,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-2017.627,-606.9152;Inherit;False;1322.748;365.7555;Color;9;48;156;155;58;6;135;54;64;2;;0.5,0.2627451,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-2018.627,353.0847;Inherit;False;1326.025;394.1609;Specular;8;43;160;91;159;90;137;120;18;;0,0.09803939,0.5,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-2017.627,-190.9152;Inherit;False;1330.268;495.5854;Gloss;10;41;158;157;93;136;121;19;94;20;21;;0.07058823,0.5,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-3033.598,395.1321;Inherit;False;841.3975;283.8995;Tiling;5;113;108;107;106;105;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;140;-2295.683,-1654.105;Inherit;False;887.1901;979.9791;GREEN TERRAIN;14;154;153;152;151;150;149;148;147;146;145;144;143;142;141;;0,1,0.07855177,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-1637.11,1133.771;Inherit;False;145;GreenBump;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-568.5518,-13.46233;Inherit;False;16;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-568.5518,-77.46229;Inherit;False;48;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;38;-568.5518,466.5376;Inherit;False;InstancedProperty;_DepthOffset;DepthOffset;23;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-312.5515,-13.46233;Float;False;True;-1;7;T1_TFShaderGUI;0;0;StandardSpecular;Hidden/TITANFALL/Terrain (Two Blends);False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;True;0;True;_DepthOffset;0;False;_DepthOffset;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;True;_AlphaClip;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.IntNode;37;-568.5518,370.5376;Inherit;False;InstancedProperty;_CullMode;CullMode;22;2;[Header];[Enum];Create;True;2;________________________________________________________________________________________________;Extras;3;Both;0;Back;1;Front;2;0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.DynamicAppendNode;105;-2806.201,445.1321;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;106;-2806.201,557.132;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;107;-2617.61,463.8891;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-2406.201,461.1321;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;113;-2982.201,461.1321;Inherit;False;InstancedProperty;_Tiling;Tiling | Offset;2;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;115;-2936.275,21.55868;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1777.627,-558.9153;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1633.627,-494.9153;Inherit;False;63;RedCol;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1953.627,49.08472;Inherit;False;InstancedProperty;_Glossiness;Smoothness;7;1;[Gamma];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1969.627,-558.9153;Inherit;False;53;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1713.318,1026.177;Inherit;False;73;RedBump;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1617.627,-142.9153;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-1633.627,-14.91528;Inherit;False;77;RedGloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1985.318,930.1785;Inherit;False;InstancedProperty;_NormalScale;NormalScale;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-1985.318,850.1785;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2001.627,593.0848;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2001.627,129.0848;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;135;-1633.627,-414.9153;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;136;-1617.454,129.3364;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;137;-1659.454,570.3364;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-2001.627,-478.9153;Inherit;False;InstancedProperty;_Color;Color;0;1;[Header];Create;True;2;________________________________________________________________________________________________;Base;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;58;-1441.627,-558.9153;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-1437.656,-419.6255;Inherit;False;152;GreenCol;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;93;-1473.627,-142.9153;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;157;-1250.174,-145.0236;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-1448.661,-8.171767;Inherit;False;143;GreenGloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-1489.627,401.0847;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;159;-1278.776,403.1508;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1665.627,497.0849;Inherit;False;75;RedSpec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-1473.776,534.1511;Inherit;False;144;GreenSpec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;79;-1521.318,930.1785;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;156;-1254.048,-564.1896;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-931.3204,834.1785;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;162;-1306.111,1005.77;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-891.8257,414.0564;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-901.7202,-134.6646;Inherit;False;Gloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-916.34,-558.3729;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-2247.967,-1369.926;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-1745.13,-1597.906;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;-1767.965,-1337.926;Inherit;False;GreenBump;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-1606.027,-1597.776;Inherit;False;GreenCol;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1767.965,-1145.926;Inherit;False;GreenSpec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;-1607.964,-953.9259;Inherit;False;GreenGloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1741.165,-873.326;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-2523.919,-953.6118;Inherit;False;RedGloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2683.919,-1145.612;Inherit;False;RedSpec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-2683.919,-1337.612;Inherit;False;RedBump;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-3163.919,-1369.612;Inherit;False;108;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-2661.083,-1597.592;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-2521.982,-1597.463;Inherit;False;RedCol;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-3163.919,-1289.612;Inherit;False;InstancedProperty;_DetailBumpStrength;Normal Strength;11;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-2657.119,-876.912;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-2459.24,9.08292;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;138;-2866.269,-1527.731;Inherit;False;InstancedProperty;_ColorRed;Color;8;1;[Header];Create;False;2;________________________________________________________________________________________________;Terrain Blending (Red);0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;125;-2971.919,-761.6122;Inherit;False;InstancedProperty;_DetailSmoothness;Smoothness;14;0;Create;False;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-2055.965,-761.9263;Inherit;False;InstancedProperty;_SmoothnessGreen;Smoothness;21;0;Create;False;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-2247.967,-1289.926;Inherit;False;InstancedProperty;_NormalStrengthG;Normal Strength;18;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;153;-1950.315,-1528.045;Inherit;False;InstancedProperty;_ColorGreen;Color;15;1;[Header];Create;False;2;________________________________________________________________________________________________;Terrain Blending (Green);0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;45;-568.5518,114.5377;Inherit;False;43;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-568.5518,178.5377;Inherit;False;41;Gloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;62;-3157.837,-1604.37;Inherit;True;Property;_DetailAlbedoMap;_Col;9;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Red;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;-2971.919,-1337.612;Inherit;True;Property;_DetailNormalMap;_Nml;10;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-2971.919,-1145.612;Inherit;True;Property;_CamoSpc;_Spc;12;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;154;-2241.885,-1604.684;Inherit;True;Property;_ColGreen;_Col;16;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Red;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;148;-2055.965,-1337.926;Inherit;True;Property;_NmlGreen;_Nml;17;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;147;-2055.965,-1145.926;Inherit;True;Property;_SpcGreen;_Spc;19;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;-2971.919,-953.6118;Inherit;True;Property;_CamoGls;_Gls;13;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;149;-2055.965,-953.9259;Inherit;True;Property;_GlsGreen;_Gls;20;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1985.627,401.0847;Inherit;True;Property;_SpecGlossMap;_Spec;5;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Specular Map;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1825.318,834.1785;Inherit;True;Property;_BumpMap;_Nml;3;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1969.627,-142.9153;Inherit;True;Property;_GlossMap;_Gls/_Exp;6;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Gloss Map;0;0;False;0;False;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2767.473,6.628304;Inherit;True;Property;_MainTex;_Col;1;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;49;0
WireConnection;0;1;17;0
WireConnection;0;3;45;0
WireConnection;0;4;42;0
WireConnection;105;0;113;1
WireConnection;105;1;113;2
WireConnection;106;0;113;3
WireConnection;106;1;113;4
WireConnection;107;0;105;0
WireConnection;107;1;106;0
WireConnection;108;0;107;0
WireConnection;2;0;54;0
WireConnection;2;1;6;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;58;0;2;0
WireConnection;58;1;64;0
WireConnection;58;2;135;1
WireConnection;93;0;20;0
WireConnection;93;1;94;0
WireConnection;93;2;136;1
WireConnection;157;0;93;0
WireConnection;157;1;158;0
WireConnection;157;2;136;2
WireConnection;90;0;18;0
WireConnection;90;1;91;0
WireConnection;90;2;137;1
WireConnection;159;0;90;0
WireConnection;159;1;160;0
WireConnection;159;2;137;2
WireConnection;79;0;14;0
WireConnection;79;1;80;0
WireConnection;156;0;58;0
WireConnection;156;1;155;0
WireConnection;156;2;135;2
WireConnection;16;0;162;0
WireConnection;162;0;79;0
WireConnection;162;1;161;0
WireConnection;43;0;159;0
WireConnection;41;0;157;0
WireConnection;48;0;156;0
WireConnection;151;0;154;0
WireConnection;151;1;153;0
WireConnection;145;0;148;0
WireConnection;152;0;151;0
WireConnection;144;0;147;0
WireConnection;143;0;142;0
WireConnection;142;0;149;0
WireConnection;142;1;150;0
WireConnection;77;0;126;0
WireConnection;75;0;74;0
WireConnection;73;0;72;0
WireConnection;139;0;62;0
WireConnection;139;1;138;0
WireConnection;63;0;139;0
WireConnection;126;0;76;0
WireConnection;126;1;125;0
WireConnection;53;0;1;0
WireConnection;62;1;122;0
WireConnection;72;1;122;0
WireConnection;72;5;78;0
WireConnection;74;1;122;0
WireConnection;154;1;146;0
WireConnection;148;1;146;0
WireConnection;148;5;141;0
WireConnection;147;1;146;0
WireConnection;76;1;122;0
WireConnection;149;1;146;0
WireConnection;18;1;120;0
WireConnection;14;1;119;0
WireConnection;14;5;15;0
WireConnection;19;1;121;0
WireConnection;1;1;115;0
ASEEND*/
//CHKSM=13103856249094EF0E2C2485C56AB6E684C8A0DF