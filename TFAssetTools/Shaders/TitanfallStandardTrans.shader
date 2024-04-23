// Upgrade NOTE: upgraded instancing buffer 'TITANFALLTransparentStandard' to new syntax.

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TITANFALL/Transparent/Standard"
{
	Properties
	{
		[Header(________________________________________________________________________________________________)][Header(Albedo Map)]_Color("Color", Color) = (1,1,1,1)
		_MainTex("_Col", 2D) = "white" {}
		_Opacity("Opacity", 2D) = "white" {}
		_AlphaClip("Alpha Clip", Float) = 0.1
		[Header(________________________________________________________________________________________________)][Header(Normal Map)]_BumpMap("_Nml", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		[Header(________________________________________________________________________________________________)][Header(Specular Map)]_SpecGlossMap("_Spec", 2D) = "black" {}
		[Header(________________________________________________________________________________________________)][Header(Gloss Map)]_GlossMap("_Gls/_Exp", 2D) = "gray" {}
		[Gamma]_Glossiness("Smoothness", Range( 0 , 1)) = 1
		[Header(________________________________________________________________________________________________)][Header(Ambient Occlusion Map)]_OcclusionMap("_Ao", 2D) = "white" {}
		[Header(________________________________________________________________________________________________)][Header(Cavity Map)]_ParallaxMap("_Cav", 2D) = "white" {}
		[Header(________________________________________________________________________________________________)][Header(Emission Glow)]_EmissionMap("_Ilm", 2D) = "white" {}
		[HDR][Gamma]_EmissionColor("GlowCol", Color) = (0,0,0,0)
		[Header(________________________________________________________________________________________________)][Header(Camo or Detail Maps)]_DetailAlbedoMap("Detail/Camo", 2D) = "white" {}
		_DetailNormalMap("Detail Normal", 2D) = "bump" {}
		_DetailBumpStrength("Normal Strength", Float) = 1
		_CamoSpc("Detail Specular", 2D) = "black" {}
		_CamoGls("Detail Gloss", 2D) = "black" {}
		_DetailMask("_Msk", 2D) = "black" {}
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
		uniform sampler2D _ParallaxMap;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _DetailMask;
		uniform sampler2D _EmissionMap;
		uniform sampler2D _SpecGlossMap;
		uniform sampler2D _OcclusionMap;
		uniform sampler2D _CamoSpc;
		uniform sampler2D _GlossMap;
		uniform sampler2D _CamoGls;
		uniform sampler2D _Opacity;
		float _AlphaClip;

		UNITY_INSTANCING_BUFFER_START(TITANFALLTransparentStandard)
			UNITY_DEFINE_INSTANCED_PROP(float4, _DetailAlbedoMap_ST)
#define _DetailAlbedoMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _GlossMap_ST)
#define _GlossMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _CamoSpc_ST)
#define _CamoSpc_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _OcclusionMap_ST)
#define _OcclusionMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _SpecGlossMap_ST)
#define _SpecGlossMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionColor)
#define _EmissionColor_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionMap_ST)
#define _EmissionMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _DetailMask_ST)
#define _DetailMask_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _CamoGls_ST)
#define _CamoGls_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _Opacity_ST)
#define _Opacity_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _ParallaxMap_ST)
#define _ParallaxMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _DetailNormalMap_ST)
#define _DetailNormalMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _BumpMap_ST)
#define _BumpMap_ST_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float, _DetailBumpStrength)
#define _DetailBumpStrength_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
#define _NormalScale_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(int, _CullMode)
#define _CullMode_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(float, _Glossiness)
#define _Glossiness_arr TITANFALLTransparentStandard
			UNITY_DEFINE_INSTANCED_PROP(int, _DepthOffset)
#define _DepthOffset_arr TITANFALLTransparentStandard
		UNITY_INSTANCING_BUFFER_END(TITANFALLTransparentStandard)

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			int _DepthOffset_Instance = UNITY_ACCESS_INSTANCED_PROP(_DepthOffset_arr, _DepthOffset);
			int _CullMode_Instance = UNITY_ACCESS_INSTANCED_PROP(_CullMode_arr, _CullMode);
			float4 _BumpMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_BumpMap_ST_arr, _BumpMap_ST);
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST_Instance.xy + _BumpMap_ST_Instance.zw;
			float _NormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalScale_arr, _NormalScale);
			float4 _DetailNormalMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailNormalMap_ST_arr, _DetailNormalMap_ST);
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST_Instance.xy + _DetailNormalMap_ST_Instance.zw;
			float _DetailBumpStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailBumpStrength_arr, _DetailBumpStrength);
			float3 DetailBump73 = UnpackScaleNormal( tex2D( _DetailNormalMap, uv_DetailNormalMap ), _DetailBumpStrength_Instance );
			float3 Normal16 = BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _NormalScale_Instance ) , DetailBump73 );
			o.Normal = Normal16;
			float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			float4 _ParallaxMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_ParallaxMap_ST_arr, _ParallaxMap_ST);
			float2 uv_ParallaxMap = i.uv_texcoord * _ParallaxMap_ST_Instance.xy + _ParallaxMap_ST_Instance.zw;
			float4 Cav33 = tex2D( _ParallaxMap, uv_ParallaxMap );
			float4 Albedo53 = ( tex2D( _MainTex, uv_MainTex ) * Cav33 );
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 temp_output_2_0 = ( Albedo53 * _Color_Instance );
			float4 _DetailAlbedoMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailAlbedoMap_ST_arr, _DetailAlbedoMap_ST);
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST_Instance.xy + _DetailAlbedoMap_ST_Instance.zw;
			float4 CamoTex63 = ( tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) * Cav33 );
			float4 _DetailMask_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_DetailMask_ST_arr, _DetailMask_ST);
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST_Instance.xy + _DetailMask_ST_Instance.zw;
			float4 CamoMask60 = tex2D( _DetailMask, uv_DetailMask );
			float4 lerpResult58 = lerp( temp_output_2_0 , CamoTex63 , CamoMask60);
			float4 Color48 = lerpResult58;
			o.Albedo = Color48.rgb;
			float4 _EmissionMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionMap_ST_arr, _EmissionMap_ST);
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST_Instance.xy + _EmissionMap_ST_Instance.zw;
			float4 _EmissionColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionColor_arr, _EmissionColor);
			float4 Emisision26 = ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor_Instance );
			o.Emission = Emisision26.rgb;
			float4 _SpecGlossMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_SpecGlossMap_ST_arr, _SpecGlossMap_ST);
			float2 uv_SpecGlossMap = i.uv_texcoord * _SpecGlossMap_ST_Instance.xy + _SpecGlossMap_ST_Instance.zw;
			float4 _OcclusionMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_OcclusionMap_ST_arr, _OcclusionMap_ST);
			float2 uv_OcclusionMap = i.uv_texcoord * _OcclusionMap_ST_Instance.xy + _OcclusionMap_ST_Instance.zw;
			float4 Ao32 = ( tex2D( _OcclusionMap, uv_OcclusionMap ) * Cav33 );
			float4 _CamoSpc_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_CamoSpc_ST_arr, _CamoSpc_ST);
			float2 uv_CamoSpc = i.uv_texcoord * _CamoSpc_ST_Instance.xy + _CamoSpc_ST_Instance.zw;
			float4 DetailSpec75 = tex2D( _CamoSpc, uv_CamoSpc );
			float4 lerpResult90 = lerp( ( tex2D( _SpecGlossMap, uv_SpecGlossMap ) * Ao32 ) , DetailSpec75 , CamoMask60);
			float4 Specular43 = lerpResult90;
			o.Specular = Specular43.rgb;
			float4 _GlossMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_GlossMap_ST_arr, _GlossMap_ST);
			float2 uv_GlossMap = i.uv_texcoord * _GlossMap_ST_Instance.xy + _GlossMap_ST_Instance.zw;
			float _Glossiness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Glossiness_arr, _Glossiness);
			float4 _CamoGls_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_CamoGls_ST_arr, _CamoGls_ST);
			float2 uv_CamoGls = i.uv_texcoord * _CamoGls_ST_Instance.xy + _CamoGls_ST_Instance.zw;
			float4 DetailGloss77 = tex2D( _CamoGls, uv_CamoGls );
			float4 lerpResult93 = lerp( ( tex2D( _GlossMap, uv_GlossMap ) * _Glossiness_Instance * Ao32 ) , DetailGloss77 , CamoMask60);
			float4 Gloss41 = lerpResult93;
			o.Smoothness = Gloss41.r;
			o.Occlusion = Ao32.r;
			float4 _Opacity_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Opacity_ST_arr, _Opacity_ST);
			float2 uv_Opacity = i.uv_texcoord * _Opacity_ST_Instance.xy + _Opacity_ST_Instance.zw;
			float4 OpaMask100 = tex2D( _Opacity, uv_Opacity );
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
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;102;-2496,1088;Inherit;False;994;1304;Camos / Detail;13;60;59;62;63;68;69;73;72;75;76;77;74;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;57;-2496,720;Inherit;False;844.7975;332.8724;Cavity;2;33;29;;0.5143232,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2504.295,-590.9303;Inherit;False;866.6731;382.7239;Albedo;6;53;1;67;70;97;100;;1,0.02937273,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1600,720;Inherit;False;895.0516;333.681;Normal;5;80;79;15;14;16;;1,0,0.8207312,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-2503.198,369.4026;Inherit;False;853.9988;324.9888;Ambient Occlusion;4;28;32;31;56;;0,0.8785672,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1600,-592;Inherit;False;893.7484;381.5861;Color;11;54;48;46;6;2;7;61;58;64;99;101;;1,0.524459,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1600,368;Inherit;False;888.2646;325.1341;Specular;6;43;18;35;36;91;92;;0,0.1942768,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1600,-176;Inherit;False;891.6624;508.7013;Gloss;7;41;19;34;21;20;94;95;;0.1407661,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2503.198,-174.9305;Inherit;False;862.8578;510.4329;Emission;4;25;22;26;23;;1,0.9970177,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2055.198,-126.9304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1863.198,-126.9304;Inherit;False;Emisision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;22;-2455.198,-126.9304;Inherit;True;Property;_EmissionMap;_Ilm;11;1;[Header];Create;False;2;________________________________________________________________________________________________;Emission Glow;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;-2359.198,65.06909;Inherit;False;InstancedProperty;_EmissionColor;GlowCol;12;2;[HDR];[Gamma];Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2471.198,-542.9304;Inherit;True;Property;_MainTex;_Col;1;0;Create;False;0;0;0;False;0;False;-1;None;51f497e5dba247d45abedea2919207fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
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
Node;AmplifyShaderEditor.SamplerNode;29;-2448,768;Inherit;True;Property;_ParallaxMap;_Cav;10;1;[Header];Create;False;2;________________________________________________________________________________________________;Cavity Map;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-2144,768;Inherit;False;Cav;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1360,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1216,-416;Inherit;False;60;CamoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1216,-480;Inherit;False;63;CamoTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;-1024,-544;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-880,-544;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2160,480;Inherit;False;33;Cav;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1536,64;Inherit;False;InstancedProperty;_Glossiness;Smoothness;8;1;[Gamma];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-384,-16;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;TITANFALL/Transparent/Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;True;0;True;_DepthOffset;0;False;_DepthOffset;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;True;_AlphaClip;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-640,240;Inherit;False;32;Ao;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-640,304;Inherit;False;46;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-1552,-128;Inherit;True;Property;_GlossMap;_Gls/_Exp;7;1;[Header];Create;False;2;________________________________________________________________________________________________;Gloss Map;0;0;False;0;False;-1;None;dfc79ff13c8eaca458e71ac992bec2d6;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-2448,416;Inherit;True;Property;_OcclusionMap;_Ao;9;1;[Header];Create;False;2;________________________________________________________________________________________________;Ambient Occlusion Map;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-1584,-464;Inherit;False;InstancedProperty;_Color;Color;0;1;[Header];Create;True;2;________________________________________________________________________________________________;Albedo Map;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1552,-544;Inherit;False;53;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1920,-544;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2048,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-896,784;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;14;-1408,768;Inherit;True;Property;_BumpMap;_Nml;4;1;[Header];Create;False;2;________________________________________________________________________________________________;Normal Map;0;0;False;0;False;-1;None;fcc32c8ff9ed7b74f9e7235788c7640c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1568,816;Inherit;False;InstancedProperty;_NormalScale;NormalScale;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1296,960;Inherit;False;73;DetailBump;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;79;-1104,864;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1440,608;Inherit;False;32;Ao;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;18;-1568,416;Inherit;True;Property;_SpecGlossMap;_Spec;6;1;[Header];Create;False;2;________________________________________________________________________________________________;Specular Map;0;0;False;0;False;-1;None;d5f4e7dba9d87ae448a569216b231ebf;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
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
Node;AmplifyShaderEditor.RangedFloatNode;96;-640,560;Inherit;False;InstancedProperty;_AlphaClip;Alpha Clip;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-880,-288;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1008,-304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2336,-352;Inherit;False;33;Cav;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-1824,-416;Inherit;False;OpaMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;97;-2096,-416;Inherit;True;Property;_Opacity;Opacity;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;101;-1168,-320;Inherit;False;100;OpaMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-1280,-352;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-1920,1456;Inherit;False;CamoMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;59;-2256,1456;Inherit;True;Property;_DetailMask;_Msk;18;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-2256,1136;Inherit;True;Property;_DetailAlbedoMap;Detail/Camo;13;1;[Header];Create;False;2;________________________________________________________________________________________________;Camo or Detail Maps;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-1728,1136;Inherit;False;CamoTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1856,1136;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2128,1328;Inherit;False;33;Cav;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1920,1696;Inherit;False;DetailBump;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;72;-2256,1696;Inherit;True;Property;_DetailNormalMap;Detail Normal;14;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;-2256,2160;Inherit;True;Property;_CamoGls;Detail Gloss;17;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1920,2160;Inherit;False;DetailGloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2448,1744;Inherit;False;InstancedProperty;_DetailBumpStrength;Normal Strength;15;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;-2256,1920;Inherit;True;Property;_CamoSpc;Detail Specular;16;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-1920,1920;Inherit;False;DetailSpec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
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
WireConnection;0;9;47;0
WireConnection;0;10;47;0
WireConnection;53;0;70;0
WireConnection;70;0;1;0
WireConnection;70;1;67;0
WireConnection;16;0;79;0
WireConnection;14;5;15;0
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
WireConnection;72;5;78;0
WireConnection;77;0;76;0
WireConnection;75;0;74;0
ASEEND*/
//CHKSM=7BD3E9DA0C3C5C81574C7B11599B15B73E1F2BE7