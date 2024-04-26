// Upgrade NOTE: upgraded instancing buffer 'HiddenTITANFALLTransparentStandardOptimized' to new syntax.

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/TITANFALL/Transparent/Standard Optimized"
{
	Properties
	{
		[Header(________________________________________________________________________________________________)][Header(Surface)]_Color("Color", Color) = (1,1,1,1)
		[SingleLineTexture]_MainTex("_Col", 2D) = "white" {}
		[SingleLineTexture]_Opacity("Opacity", 2D) = "white" {}
		_AlphaClip("Alpha Clip", Float) = 0.1
		_Tiling("Tiling | Offset", Vector) = (1,1,0,0)
		[SingleLineTexture]_BumpMap("_Nml", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		[Header(________________________________________________________________________________________________)][Header(Lighting)][SingleLineTexture]_SpecGlossMap("_Spec", 2D) = "black" {}
		[Header(________________________________________________________________________________________________)][Header(Packed Textures)][SingleLineTexture]_Atlas("Gls_Cav_Ao", 2D) = "white" {}
		[Gamma]_Glossiness("Smoothness", Range( 0 , 1)) = 1
		[Header(________________________________________________________________________________________________)][Header(Emission Glow)][SingleLineTexture]_EmissionMap("_Ilm", 2D) = "white" {}
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
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		Offset  [_DepthOffset] , 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
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
		uniform sampler2D _Opacity;
		float _AlphaClip;

		UNITY_INSTANCING_BUFFER_START(HiddenTITANFALLTransparentStandardOptimized)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Tiling)
#define _Tiling_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float4, _DetailTiling)
#define _DetailTiling_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionColor)
#define _EmissionColor_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(int, _DepthOffset)
#define _DepthOffset_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(int, _CullMode)
#define _CullMode_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
#define _NormalScale_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float, _DetailBumpStrength)
#define _DetailBumpStrength_arr HiddenTITANFALLTransparentStandardOptimized
			UNITY_DEFINE_INSTANCED_PROP(float, _Glossiness)
#define _Glossiness_arr HiddenTITANFALLTransparentStandardOptimized
		UNITY_INSTANCING_BUFFER_END(HiddenTITANFALLTransparentStandardOptimized)

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			int _DepthOffset_Instance = UNITY_ACCESS_INSTANCED_PROP(_DepthOffset_arr, _DepthOffset);
			int _CullMode_Instance = UNITY_ACCESS_INSTANCED_PROP(_CullMode_arr, _CullMode);
			float4 _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float2 appendResult110 = (float2(_Tiling_Instance.x , _Tiling_Instance.y));
			float2 appendResult111 = (float2(_Tiling_Instance.z , _Tiling_Instance.w));
			float2 uv_TexCoord112 = i.uv_texcoord * appendResult110 + appendResult111;
			float2 MainUV113 = uv_TexCoord112;
			float _NormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalScale_arr, _NormalScale);
			float4 _DetailTiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailTiling_arr, _DetailTiling);
			float2 appendResult114 = (float2(_DetailTiling_Instance.x , _DetailTiling_Instance.y));
			float2 appendResult115 = (float2(_DetailTiling_Instance.z , _DetailTiling_Instance.w));
			float2 uv_TexCoord116 = i.uv_texcoord * appendResult114 + appendResult115;
			float2 DetailUV117 = uv_TexCoord116;
			float _DetailBumpStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailBumpStrength_arr, _DetailBumpStrength);
			float3 DetailBump73 = UnpackScaleNormal( tex2D( _DetailNormalMap, DetailUV117 ), _DetailBumpStrength_Instance );
			float3 Normal16 = BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, MainUV113 ), _NormalScale_Instance ) , DetailBump73 );
			o.Normal = Normal16;
			float4 break105 = tex2D( _Atlas, MainUV113 );
			float Cav33 = break105.g;
			float4 Albedo53 = ( tex2D( _MainTex, MainUV113 ) * Cav33 );
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 temp_output_2_0 = ( Albedo53 * _Color_Instance );
			float4 CamoTex63 = ( tex2D( _DetailAlbedoMap, DetailUV117 ) * Cav33 );
			float4 CamoMask60 = tex2D( _DetailMask, MainUV113 );
			float4 lerpResult58 = lerp( temp_output_2_0 , CamoTex63 , CamoMask60);
			float4 Color48 = lerpResult58;
			o.Albedo = Color48.rgb;
			float4 _EmissionColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionColor_arr, _EmissionColor);
			float4 Emisision26 = ( tex2D( _EmissionMap, MainUV113 ) * _EmissionColor_Instance );
			o.Emission = Emisision26.rgb;
			float Ao32 = ( break105.g * break105.b );
			float4 DetailSpec75 = tex2D( _CamoSpc, DetailUV117 );
			float4 lerpResult90 = lerp( ( tex2D( _SpecGlossMap, MainUV113 ) * Ao32 ) , DetailSpec75 , CamoMask60);
			float4 Specular43 = lerpResult90;
			o.Specular = Specular43.rgb;
			float GlsExp106 = break105.r;
			float _Glossiness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Glossiness_arr, _Glossiness);
			float4 temp_cast_3 = (( GlsExp106 * _Glossiness_Instance * Ao32 )).xxxx;
			float4 DetailGloss77 = tex2D( _CamoGls, DetailUV117 );
			float4 lerpResult93 = lerp( temp_cast_3 , DetailGloss77 , CamoMask60);
			float4 Gloss41 = lerpResult93;
			o.Smoothness = Gloss41.r;
			o.Occlusion = Ao32;
			float4 OpaMask100 = tex2D( _Opacity, MainUV113 );
			float4 Opacity46 = ( OpaMask100 * temp_output_2_0.a );
			float4 temp_output_47_0 = Opacity46;
			o.Alpha = temp_output_47_0.r;
			clip( temp_output_47_0.r - _AlphaClip );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "OTFShaderGUIT"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;108;-2684.932,368;Inherit;False;1026.927;324.9287;Packed Texture;7;121;104;106;33;32;31;105;;0,1,0.6912031,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;102;-2606.51,1090.394;Inherit;False;994;1304;Camos / Detail;15;60;59;62;63;68;69;73;72;75;76;77;74;78;120;127;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2687.295,-590.9303;Inherit;False;1049.673;382.7239;Albedo;8;1;97;100;67;70;53;123;124;;1,0.02937273,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1600,720;Inherit;False;895.0516;333.681;Normal;6;80;79;15;14;16;126;;1,0,0.8207312,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1600,-592;Inherit;False;893.7484;381.5861;Color;11;54;48;46;6;2;7;61;58;64;99;101;;1,0.524459,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1600,368;Inherit;False;888.2646;325.1341;Specular;7;43;18;35;36;91;92;125;;0,0.1942768,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1600,-176;Inherit;False;891.6624;508.7013;Gloss;7;41;34;21;20;94;95;107;;0.1407661,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2685.198,-174.9305;Inherit;False;1044.858;509.1329;Emission;5;122;22;25;26;23;;1,0.9970177,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2055.198,-126.9304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1863.198,-126.9304;Inherit;False;Emisision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;-2359.198,65.06909;Inherit;False;InstancedProperty;_EmissionColor;GlowCol;11;2;[HDR];[Gamma];Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1424,144;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-640,-16;Inherit;False;16;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-640,48;Inherit;False;26;Emisision;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-640,112;Inherit;False;43;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-640,176;Inherit;False;41;Gloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-640,-80;Inherit;False;48;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;38;-640,464;Inherit;False;InstancedProperty;_DepthOffset;DepthOffset;20;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;37;-640,368;Inherit;False;InstancedProperty;_CullMode;CullMode;19;2;[Header];[Enum];Create;True;2;________________________________________________________________________________________________;Extras;3;Both;0;Back;1;Front;2;0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1360,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1216,-416;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1216,-480;Inherit;False;63;CamoTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;-1024,-544;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-880,-544;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1536,64;Inherit;False;InstancedProperty;_Glossiness;Smoothness;9;1;[Gamma];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-384,-16;Float;False;True;-1;2;OTFShaderGUIT;0;0;StandardSpecular;Hidden/TITANFALL/Transparent/Standard Optimized;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;True;0;True;_DepthOffset;0;False;_DepthOffset;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;True;_AlphaClip;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-640,240;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-640,304;Inherit;False;46;Opacity;1;0;OBJECT;;False;1;COLOR;0
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
Node;AmplifyShaderEditor.RangedFloatNode;96;-640,560;Inherit;False;InstancedProperty;_AlphaClip;Alpha Clip;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-880,-288;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1008,-304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2336,-352;Inherit;False;33;Cav;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-1824,-416;Inherit;False;OpaMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-1168,-320;Inherit;False;100;OpaMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-1280,-352;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-2030.509,1458.394;Inherit;False;CamoMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-1838.509,1138.394;Inherit;False;CamoTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1966.509,1138.394;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2238.51,1330.394;Inherit;False;33;Cav;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-2030.509,1698.394;Inherit;False;DetailBump;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-2030.509,2162.394;Inherit;False;DetailGloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2558.51,1746.394;Inherit;False;InstancedProperty;_DetailBumpStrength;Normal Strength;15;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2030.509,1922.394;Inherit;False;DetailSpec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1424,-128;Inherit;False;106;GlsExp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;105;-2192,480;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1968,592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1840,592;Inherit;False;Ao;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1840,496;Inherit;False;Cav;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1840,416;Inherit;False;GlsExp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;76;-2366.51,2162.394;Inherit;True;Property;_CamoGls;Detail Gloss;17;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-2366.51,1922.394;Inherit;True;Property;_CamoSpc;Detail Specular;16;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;-2366.51,1698.394;Inherit;True;Property;_DetailNormalMap;Detail Normal;14;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-2366.51,1458.394;Inherit;True;Property;_DetailMask;_Msk;12;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Detail or Camo;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-2366.51,1138.394;Inherit;True;Property;_DetailAlbedoMap;Detail/Camo;13;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Camo or Detail Maps;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;104;-2496,480;Inherit;True;Property;_Atlas;Gls_Cav_Ao;8;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Packed Textures;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-2455.198,-126.9304;Inherit;True;Property;_EmissionMap;_Ilm;10;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Emission Glow;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;97;-2096,-416;Inherit;True;Property;_Opacity;Opacity;2;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2471.198,-542.9304;Inherit;True;Property;_MainTex;_Col;1;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;51f497e5dba247d45abedea2919207fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;109;-1577.677,1097.238;Inherit;False;851.3975;645.8995;Tiling;10;119;118;117;116;115;114;113;112;111;110;;0,0,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1350.281,1147.238;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;111;-1350.281,1259.238;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-1161.69,1165.995;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-950.28,1163.238;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;-1351.678,1496.138;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;-1351.678,1608.138;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-1159.678,1512.138;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-951.6775,1512.138;Inherit;False;DetailUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;118;-1526.28,1163.238;Inherit;False;InstancedProperty;_Tiling;Tiling | Offset;4;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;119;-1527.677,1512.138;Inherit;False;InstancedProperty;_DetailTiling;Tiling | Offset;18;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1552,-544;Inherit;False;53;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-1584,-464;Inherit;False;InstancedProperty;_Color;Color;0;1;[Header];Create;True;2;________________________________________________________________________________________________;Surface;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1568,416;Inherit;True;Property;_SpecGlossMap;_Spec;7;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Lighting;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1408,768;Inherit;True;Property;_BumpMap;_Nml;5;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Normal Map;0;0;False;0;False;-1;None;fcc32c8ff9ed7b74f9e7235788c7640c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2560,1664;Inherit;False;117;DetailUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2656,496;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-2624,-112;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-2640,-528;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2336,-288;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-1584,608;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1568,768;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1568,848;Inherit;False;InstancedProperty;_NormalScale;NormalScale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-2560,1472;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
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
WireConnection;0;9;47;0
WireConnection;0;10;47;0
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
WireConnection;46;0;99;0
WireConnection;99;0;101;0
WireConnection;99;1;7;3
WireConnection;100;0;97;0
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
WireConnection;76;1;120;0
WireConnection;74;1;120;0
WireConnection;72;1;120;0
WireConnection;72;5;78;0
WireConnection;59;1;127;0
WireConnection;62;1;120;0
WireConnection;104;1;121;0
WireConnection;22;1;122;0
WireConnection;97;1;124;0
WireConnection;1;1;123;0
WireConnection;110;0;118;1
WireConnection;110;1;118;2
WireConnection;111;0;118;3
WireConnection;111;1;118;4
WireConnection;112;0;110;0
WireConnection;112;1;111;0
WireConnection;113;0;112;0
WireConnection;114;0;119;1
WireConnection;114;1;119;2
WireConnection;115;0;119;3
WireConnection;115;1;119;4
WireConnection;116;0;114;0
WireConnection;116;1;115;0
WireConnection;117;0;116;0
WireConnection;18;1;125;0
WireConnection;14;1;126;0
WireConnection;14;5;15;0
ASEEND*/
//CHKSM=3E1A22962E907FAFE7CCFEA6CD7E2B53AE95F7E7