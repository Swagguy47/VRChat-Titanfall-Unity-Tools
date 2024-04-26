// Upgrade NOTE: upgraded instancing buffer 'TITANFALLStandardOptimized' to new syntax.

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TITANFALL/Standard Optimized"
{
	Properties
	{
		[Header(________________________________________________________________________________________________)][Header(Surface)]_Color("Color", Color) = (1,1,1,1)
		[SingleLineTexture]_MainTex("_Col", 2D) = "white" {}
		_Tiling("Tiling | Offset", Vector) = (1,1,0,0)
		[Header(________________________________________________________________________________________________)][Header(Lighting)][SingleLineTexture]_BumpMap("_Nml", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		[SingleLineTexture]_SpecGlossMap("_Spec", 2D) = "black" {}
		[Header(________________________________________________________________________________________________)][Header(Packed Textures)][SingleLineTexture]_Atlas("Gls_Cav_Ao", 2D) = "white" {}
		[Gamma]_Glossiness("Smoothness", Range( 0 , 1)) = 1
		[Header(________________________________________________________________________________________________)][Header(Emission)][SingleLineTexture]_EmissionMap("_Ilm", 2D) = "white" {}
		[HDR][Gamma]_EmissionColor("GlowCol", Color) = (0,0,0,0)
		[Header(________________________________________________________________________________________________)][Header(Detail or Camo)][SingleLineTexture]_DetailMask("_Msk", 2D) = "black" {}
		[SingleLineTexture]_DetailAlbedoMap("Detail/Camo", 2D) = "white" {}
		[SingleLineTexture]_DetailNormalMap("Detail Normal", 2D) = "bump" {}
		_DetailBumpStrength("Normal Strength", Float) = 1
		[SingleLineTexture]_CamoSpc("Detail Specular", 2D) = "black" {}
		[SingleLineTexture]_CamoGls("Detail Gloss", 2D) = "black" {}
		_DetailTiling("Tiling | Offset", Vector) = (1,1,0,0)
		[Header(________________________________________________________________________________________________)][Header(Extras)][Enum(Both,0,Back,1,Front,2)]_CullMode("CullMode", Int) = 2
		_DepthOffset("DepthOffset", Int) = 0
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
		};

		uniform sampler2D _BumpMap;
		uniform sampler2D _DetailNormalMap;
		uniform sampler2D _MainTex;
		uniform sampler2D _Atlas;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _DetailMask;
		uniform sampler2D _EmissionMap;
		uniform sampler2D _SpecGlossMap;
		uniform sampler2D _CamoSpc;
		uniform sampler2D _CamoGls;

		UNITY_INSTANCING_BUFFER_START(TITANFALLStandardOptimized)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Tiling)
#define _Tiling_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float4, _DetailTiling)
#define _DetailTiling_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionColor)
#define _EmissionColor_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(int, _DepthOffset)
#define _DepthOffset_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(int, _CullMode)
#define _CullMode_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
#define _NormalScale_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float, _DetailBumpStrength)
#define _DetailBumpStrength_arr TITANFALLStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float, _Glossiness)
#define _Glossiness_arr TITANFALLStandardOptimized
		UNITY_INSTANCING_BUFFER_END(TITANFALLStandardOptimized)

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			int _DepthOffset_Instance = UNITY_ACCESS_INSTANCED_PROP(_DepthOffset_arr, _DepthOffset);
			int _CullMode_Instance = UNITY_ACCESS_INSTANCED_PROP(_CullMode_arr, _CullMode);
			float4 _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float2 appendResult112 = (float2(_Tiling_Instance.x , _Tiling_Instance.y));
			float2 appendResult113 = (float2(_Tiling_Instance.z , _Tiling_Instance.w));
			float2 uv_TexCoord111 = i.uv_texcoord * appendResult112 + appendResult113;
			float2 MainUV114 = uv_TexCoord111;
			float _NormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalScale_arr, _NormalScale);
			float4 _DetailTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailTiling_arr, _DetailTiling);
			float2 appendResult120 = (float2(_DetailTiling_Instance.x , _DetailTiling_Instance.y));
			float2 appendResult121 = (float2(_DetailTiling_Instance.z , _DetailTiling_Instance.w));
			float2 uv_TexCoord122 = i.uv_texcoord * appendResult120 + appendResult121;
			float2 DetailUV124 = uv_TexCoord122;
			float _DetailBumpStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailBumpStrength_arr, _DetailBumpStrength);
			float3 DetailBump73 = UnpackScaleNormal( tex2D( _DetailNormalMap, DetailUV124 ), _DetailBumpStrength_Instance );
			float3 Normal16 = BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, MainUV114 ), _NormalScale_Instance ) , DetailBump73 );
			o.Normal = Normal16;
			float4 break105 = tex2D( _Atlas, MainUV114 );
			float Cav33 = break105.g;
			float4 Albedo53 = ( tex2D( _MainTex, MainUV114 ) * Cav33 );
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 temp_output_2_0 = ( Albedo53 * _Color_Instance );
			float4 CamoTex63 = ( tex2D( _DetailAlbedoMap, DetailUV124 ) * Cav33 );
			float4 CamoMask60 = tex2D( _DetailMask, DetailUV124 );
			float4 lerpResult58 = lerp( temp_output_2_0 , CamoTex63 , CamoMask60);
			float4 Color48 = lerpResult58;
			o.Albedo = Color48.rgb;
			float4 _EmissionColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionColor_arr, _EmissionColor);
			float4 Emisision26 = ( tex2D( _EmissionMap, MainUV114 ) * _EmissionColor_Instance );
			o.Emission = Emisision26.rgb;
			float Ao32 = ( break105.g * break105.b );
			float4 DetailSpec75 = tex2D( _CamoSpc, DetailUV124 );
			float4 lerpResult90 = lerp( ( tex2D( _SpecGlossMap, MainUV114 ) * Ao32 ) , DetailSpec75 , CamoMask60);
			float4 Specular43 = lerpResult90;
			o.Specular = Specular43.rgb;
			float GlsExp106 = break105.r;
			float _Glossiness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Glossiness_arr, _Glossiness);
			float4 temp_cast_3 = (( GlsExp106 * _Glossiness_Instance * Ao32 )).xxxx;
			float4 DetailGloss77 = tex2D( _CamoGls, DetailUV124 );
			float4 lerpResult93 = lerp( temp_cast_3 , DetailGloss77 , CamoMask60);
			float4 Gloss41 = lerpResult93;
			o.Smoothness = Gloss41.r;
			o.Occlusion = Ao32;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "OTFShaderGUI"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;127;-1582.525,1088.076;Inherit;False;851.3975;645.8995;Tiling;10;112;113;111;114;120;121;122;124;109;123;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;108;-2681.932,368;Inherit;False;1037.927;327.9287;Packed Texture;7;117;104;106;33;32;31;105;;0,1,0.6912031,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;102;-2669.558,1088;Inherit;False;994;1304;Camos / Detail;14;60;59;62;63;68;69;73;72;75;76;77;74;78;125;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2686.295,-590.9303;Inherit;False;1048.673;379.7239;Albedo;5;116;1;67;70;53;;1,0.02937273,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1600,720;Inherit;False;895.0516;333.681;Normal;6;80;79;15;14;16;119;;1,0,0.8207312,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1600,-592;Inherit;False;893.7484;381.5861;Color;9;54;48;46;6;2;7;61;58;64;;1,0.524459,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1600,368;Inherit;False;888.2646;325.1341;Specular;6;43;18;35;36;91;92;;0,0.1942768,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1600,-176;Inherit;False;891.6624;508.7013;Gloss;7;41;34;21;20;94;95;107;;0.1407661,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2686.198,-174.9305;Inherit;False;1045.858;513.4329;Emission;5;115;22;25;26;23;;1,0.9970177,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2055.198,-126.9304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1863.198,-126.9304;Inherit;False;Emisision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;-2359.198,65.06909;Inherit;False;InstancedProperty;_EmissionColor;GlowCol;10;2;[HDR];[Gamma];Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1424,144;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-640,-16;Inherit;False;16;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-640,48;Inherit;False;26;Emisision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-640,112;Inherit;False;43;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-640,176;Inherit;False;41;Gloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-640,-80;Inherit;False;48;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;38;-640,464;Inherit;False;InstancedProperty;_DepthOffset;DepthOffset;19;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;37;-640,368;Inherit;False;InstancedProperty;_CullMode;CullMode;18;2;[Header];[Enum];Create;True;2;________________________________________________________________________________________________;Extras;3;Both;0;Back;1;Front;2;0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1360,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1216,-416;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1216,-480;Inherit;False;63;CamoTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;-1024,-544;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-880,-544;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1536,64;Inherit;False;InstancedProperty;_Glossiness;Smoothness;8;1;[Gamma];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-384,-16;Float;False;True;-1;2;OTFShaderGUI;0;0;StandardSpecular;TITANFALL/Standard Optimized;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;True;0;True;_DepthOffset;0;False;_DepthOffset;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;True;_AlphaClip;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-640,240;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-640,304;Inherit;False;46;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1552,-544;Inherit;False;53;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1920,-544;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2048,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-896,784;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1296,960;Inherit;False;73;DetailBump;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;79;-1104,864;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1440,608;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1248,416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-1072,416;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-896,416;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1248,512;Inherit;False;75;DetailSpec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1248,592;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1200,-128;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-912,-128;Inherit;False;Gloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;93;-1056,-128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-1216,0;Inherit;False;77;DetailGloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-1216,80;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-640,560;Inherit;False;InstancedProperty;_AlphaClip;Alpha Clip;2;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-880,-288;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2336,-352;Inherit;False;33;Cav;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-1280,-352;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-2093.562,1456;Inherit;False;CamoMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-1901.564,1136;Inherit;False;CamoTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2029.564,1136;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2301.558,1328;Inherit;False;33;Cav;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-2093.562,1696;Inherit;False;DetailBump;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-2093.562,2160;Inherit;False;DetailGloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2621.558,1744;Inherit;False;InstancedProperty;_DetailBumpStrength;Normal Strength;14;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2093.562,1920;Inherit;False;DetailSpec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1424,-128;Inherit;False;106;GlsExp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;105;-2192,480;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1968,592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1840,592;Inherit;False;Ao;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1840,496;Inherit;False;Cav;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1840,416;Inherit;False;GlsExp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;76;-2429.558,2160;Inherit;True;Property;_CamoGls;Detail Gloss;16;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-2429.558,1920;Inherit;True;Property;_CamoSpc;Detail Specular;15;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;-2429.558,1696;Inherit;True;Property;_DetailNormalMap;Detail Normal;13;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2471.198,-542.9304;Inherit;True;Property;_MainTex;_Col;1;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;51f497e5dba247d45abedea2919207fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2656,-528;Inherit;False;114;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-2656,-112;Inherit;False;114;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-2656,496;Inherit;False;114;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1616,608;Inherit;False;114;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1568,864;Inherit;False;InstancedProperty;_NormalScale;NormalScale;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-1568,784;Inherit;False;114;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-2653.558,1824;Inherit;False;124;DetailUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;104;-2496,480;Inherit;True;Property;_Atlas;Gls_Cav_Ao;7;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Packed Textures;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;112;-1355.128,1138.076;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1355.128,1250.076;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;111;-1166.537,1156.833;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-955.1278,1154.076;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;120;-1356.525,1486.976;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-1356.525,1598.976;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-1164.525,1502.976;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-956.5253,1502.976;Inherit;False;DetailUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;109;-1531.128,1154.076;Inherit;False;InstancedProperty;_Tiling;Tiling | Offset;3;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;123;-1532.525,1502.976;Inherit;False;InstancedProperty;_DetailTiling;Tiling | Offset;17;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-1584,-464;Inherit;False;InstancedProperty;_Color;Color;0;1;[Header];Create;True;2;________________________________________________________________________________________________;Surface;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-2455.198,-126.9304;Inherit;True;Property;_EmissionMap;_Ilm;9;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Emission;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1568,416;Inherit;True;Property;_SpecGlossMap;_Spec;6;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Specular Map;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1408,768;Inherit;True;Property;_BumpMap;_Nml;4;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Lighting;0;0;False;0;False;-1;None;fcc32c8ff9ed7b74f9e7235788c7640c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-2429.558,1456;Inherit;True;Property;_DetailMask;_Msk;11;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Detail or Camo;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-2429.558,1136;Inherit;True;Property;_DetailAlbedoMap;Detail/Camo;12;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Camo or Detail Maps;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;23;0;22;0
WireConnection;23;1;25;0
WireConnection;26;0;23;0
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
WireConnection;20;0;107;0
WireConnection;20;1;21;0
WireConnection;20;2;34;0
WireConnection;41;0;93;0
WireConnection;93;0;20;0
WireConnection;93;1;94;0
WireConnection;93;2;95;0
WireConnection;46;0;7;3
WireConnection;7;0;2;0
WireConnection;60;0;59;0
WireConnection;63;0;68;0
WireConnection;68;0;62;0
WireConnection;68;1;69;0
WireConnection;73;0;72;0
WireConnection;77;0;76;0
WireConnection;75;0;74;0
WireConnection;105;0;104;0
WireConnection;31;0;105;1
WireConnection;31;1;105;2
WireConnection;32;0;31;0
WireConnection;33;0;105;1
WireConnection;106;0;105;0
WireConnection;76;1;125;0
WireConnection;74;1;125;0
WireConnection;72;1;125;0
WireConnection;72;5;78;0
WireConnection;1;1;116;0
WireConnection;104;1;117;0
WireConnection;112;0;109;1
WireConnection;112;1;109;2
WireConnection;113;0;109;3
WireConnection;113;1;109;4
WireConnection;111;0;112;0
WireConnection;111;1;113;0
WireConnection;114;0;111;0
WireConnection;120;0;123;1
WireConnection;120;1;123;2
WireConnection;121;0;123;3
WireConnection;121;1;123;4
WireConnection;122;0;120;0
WireConnection;122;1;121;0
WireConnection;124;0;122;0
WireConnection;22;1;115;0
WireConnection;18;1;118;0
WireConnection;14;1;119;0
WireConnection;14;5;15;0
WireConnection;59;1;125;0
WireConnection;62;1;125;0
ASEEND*/
//CHKSM=83E8BD86BEF932640942BC8B81616607D312F1A0