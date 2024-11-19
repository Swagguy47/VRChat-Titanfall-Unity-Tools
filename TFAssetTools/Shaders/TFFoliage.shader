// Upgrade NOTE: upgraded instancing buffer 'TITANFALLFoliage' to new syntax.

// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TITANFALL/Foliage"
{
	Properties
	{
		[Header(________________________________________________________________________________________________)][Header(Surface)]_Color("Color", Color) = (1,1,1,1)
		[SingleLineTexture]_MainTex("_Col", 2D) = "white" {}
		[SingleLineTexture]_Opacity("Opacity", 2D) = "white" {}
		_AlphaClip("Alpha Clip", Float) = 0.75
		_Tiling("Tiling | Offset", Vector) = (1,1,0,0)
		[Header(________________________________________________________________________________________________)][Header(Lighting)][SingleLineTexture]_BumpMap("_Nml", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		[SingleLineTexture]_SpecGlossMap("_Spec", 2D) = "black" {}
		[Header(________________________________________________________________________________________________)][Header(Packed Textures)][SingleLineTexture]_Atlas("Gls_Cav_Ao", 2D) = "white" {}
		[Gamma]_Glossiness("Smoothness", Range( 0 , 1)) = 1
		[Header(________________________________________________________________________________________________)][Header(Extras)][Enum(Both,0,Back,1,Front,2)]_CullMode("CullMode", Int) = 2
		_DepthOffset("DepthOffset", Int) = 0
		_WindMovement("WindMovement", Vector) = (1,1,0,0)
		_WindDensity("WindDensity", Float) = 0.3
		_WindStrength("WindStrength", Float) = 0.15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull [_CullMode]
		Offset  [_DepthOffset] , 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform sampler2D _Atlas;
		uniform sampler2D _SpecGlossMap;
		uniform sampler2D _Opacity;
		float _AlphaClip;

		UNITY_INSTANCING_BUFFER_START(TITANFALLFoliage)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Tiling)
#define _Tiling_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(float2, _WindMovement)
#define _WindMovement_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(int, _DepthOffset)
#define _DepthOffset_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(int, _CullMode)
#define _CullMode_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(float, _WindDensity)
#define _WindDensity_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(float, _WindStrength)
#define _WindStrength_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
#define _NormalScale_arr TITANFALLFoliage
			UNITY_DEFINE_INSTANCED_PROP(float, _Glossiness)
#define _Glossiness_arr TITANFALLFoliage
		UNITY_INSTANCING_BUFFER_END(TITANFALLFoliage)


		//https://www.shadertoy.com/view/XdXGW8
		float2 GradientNoiseDir( float2 x )
		{
			const float2 k = float2( 0.3183099, 0.3678794 );
			x = x * k + k.yx;
			return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
		}
		
		float GradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 i = floor( p );
			float2 f = frac( p );
			float2 u = f * f * ( 3.0 - 2.0 * f );
			return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
					lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			int _DepthOffset_Instance = UNITY_ACCESS_INSTANCED_PROP(_DepthOffset_arr, _DepthOffset);
			int _CullMode_Instance = UNITY_ACCESS_INSTANCED_PROP(_CullMode_arr, _CullMode);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 _WindMovement_Instance = UNITY_ACCESS_INSTANCED_PROP(_WindMovement_arr, _WindMovement);
			float _WindDensity_Instance = UNITY_ACCESS_INSTANCED_PROP(_WindDensity_arr, _WindDensity);
			float gradientNoise141 = GradientNoise((ase_worldPos*1.0 + float3( ( _Time.y * _WindMovement_Instance ) ,  0.0 )).xy,_WindDensity_Instance);
			gradientNoise141 = gradientNoise141*0.5 + 0.5;
			float _WindStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_WindStrength_arr, _WindStrength);
			float temp_output_144_0 = ( ( gradientNoise141 - 0.5 ) * _WindStrength_Instance );
			float3 temp_cast_2 = (temp_output_144_0).xxx;
			float3 worldToObjDir152 = mul( unity_WorldToObject, float4( temp_cast_2, 0 ) ).xyz;
			float3 VertexOffset153 = worldToObjDir152;
			v.vertex.xyz += VertexOffset153;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float4 _Tiling_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tiling_arr, _Tiling);
			float2 appendResult110 = (float2(_Tiling_Instance.x , _Tiling_Instance.y));
			float2 appendResult111 = (float2(_Tiling_Instance.z , _Tiling_Instance.w));
			float2 uv_TexCoord112 = i.uv_texcoord * appendResult110 + appendResult111;
			float2 MainUV113 = uv_TexCoord112;
			float _NormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalScale_arr, _NormalScale);
			float3 Normal16 = BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, MainUV113 ), _NormalScale_Instance ) , half3(0,0,0) );
			o.Normal = Normal16;
			float4 tex2DNode1 = tex2D( _MainTex, MainUV113 );
			float4 break105 = tex2D( _Atlas, MainUV113 );
			float Cav33 = break105.g;
			float4 break129 = ( tex2DNode1 * Cav33 );
			float4 appendResult130 = (float4(break129.r , break129.g , break129.b , tex2DNode1.a));
			float4 Albedo53 = appendResult130;
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 temp_output_2_0 = ( Albedo53 * _Color_Instance );
			float4 lerpResult58 = lerp( temp_output_2_0 , half4(0,0,0,0) , half4(0,0,0,0));
			float4 Color48 = lerpResult58;
			o.Albedo = Color48.rgb;
			float Ao32 = ( break105.g * break105.b );
			float4 lerpResult90 = lerp( ( tex2D( _SpecGlossMap, MainUV113 ) * Ao32 ) , half4(0,0,0,0) , half4(0,0,0,0));
			float4 Specular43 = lerpResult90;
			o.Specular = Specular43.rgb;
			float GlsExp106 = break105.r;
			float _Glossiness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Glossiness_arr, _Glossiness);
			float4 temp_cast_4 = (( GlsExp106 * _Glossiness_Instance * Ao32 )).xxxx;
			float4 lerpResult93 = lerp( temp_cast_4 , half4(0,0,0,0) , half4(0,0,0,0));
			float4 Gloss41 = lerpResult93;
			o.Smoothness = Gloss41.r;
			o.Occlusion = Ao32;
			float4 OpaMask100 = tex2D( _Opacity, MainUV113 );
			float LODVal162 = ( unity_LODFade.x > 0.0 ? unity_LODFade.x : 1.0 );
			float4 Opacity46 = ( ( OpaMask100 * temp_output_2_0.w ) * LODVal162 );
			float4 temp_output_47_0 = Opacity46;
			o.Alpha = temp_output_47_0.r;
			clip( temp_output_47_0.r - _AlphaClip );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
				surfIN.worldPos = worldPos;
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
	CustomEditor "TFShaderGUIBasic"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;178;-2482,206;Inherit;False;626;238;LOD CrossFading;3;174;162;168;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;108;-2673.932,-164.4;Inherit;False;1026.927;324.9287;Packed Texture;7;121;104;106;33;32;31;105;;0,1,0.6912031,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2687.295,-590.9303;Inherit;False;1049.673;382.7239;Albedo;10;1;97;100;67;70;53;123;124;129;130;;1,0.02937273,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1600,720;Inherit;False;895.0516;333.681;Normal;6;80;79;15;14;16;126;;1,0,0.8207312,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1600,-592;Inherit;False;893.7484;381.5861;Color;12;54;48;6;2;7;61;58;64;99;101;177;165;;1,0.524459,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1600,368;Inherit;False;888.2646;325.1341;Specular;7;43;18;35;36;91;92;125;;0,0.1942768,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1600,-176;Inherit;False;891.6624;508.7013;Gloss;7;41;34;21;20;94;95;107;;0.1407661,1,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1424,144;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-640,-16;Inherit;False;16;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-640,-80;Inherit;False;48;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1536,64;Inherit;False;InstancedProperty;_Glossiness;Smoothness;9;1;[Gamma];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-384,-16;Float;False;True;-1;2;TFShaderGUIBasic;0;0;StandardSpecular;TITANFALL/Foliage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;True;0;True;_DepthOffset;0;False;_DepthOffset;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;True;_AlphaClip;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-896,784;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1296,960;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;79;-1104,864;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1440,608;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1248,416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-1072,416;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-896,416;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1248,512;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1248,592;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1200,-128;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-912,-128;Inherit;False;Gloss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;93;-1056,-128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-1216,0;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-1216,80;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-1824,-416;Inherit;False;OpaMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1424,-128;Inherit;False;106;GlsExp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;105;-2181,-52.40002;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1957,59.59997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1829,59.59997;Inherit;False;Ao;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1829,-36.40002;Inherit;False;Cav;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1829,-116.4;Inherit;False;GlsExp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;-2485,-52.40002;Inherit;True;Property;_Atlas;Gls_Cav_Ao;8;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Packed Textures;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;97;-2096,-416;Inherit;True;Property;_Opacity;Opacity;2;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;109;-1577.677,1097.238;Inherit;False;838.3975;288.3995;Tiling;5;118;113;112;111;110;;0,0,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1350.281,1147.238;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;111;-1350.281,1259.238;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-1161.69,1165.995;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-950.28,1163.238;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;118;-1526.28,1163.238;Inherit;False;InstancedProperty;_Tiling;Tiling | Offset;4;0;Create;False;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1552,-544;Inherit;False;53;Albedo;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;6;-1584,-464;Inherit;False;InstancedProperty;_Color;Color;0;1;[Header];Create;True;2;________________________________________________________________________________________________;Surface;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2645,-36.40002;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-1584,608;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1568,768;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1568,848;Inherit;False;InstancedProperty;_NormalScale;NormalScale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2544,-560;Inherit;True;Property;_MainTex;_Col;1;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;123;-2688,-544;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;18;-1568,416;Inherit;True;Property;_SpecGlossMap;_Spec;7;1;[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Lighting;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1408,768;Inherit;True;Property;_BumpMap;_Nml;5;2;[Header];[SingleLineTexture];Create;False;2;________________________________________________________________________________________________;Lighting;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1824,-560;Inherit;False;Albedo;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;130;-1968,-560;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;129;-2080,-560;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2240,-560;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2272,-288;Inherit;False;113;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2416,-368;Inherit;False;33;Cav;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;132;-2718.676,-1262.656;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;136;-2407.295,-1226.992;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-2577.295,-1008.992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;139;-2801.295,-907.9918;Inherit;False;InstancedProperty;_WindMovement;WindMovement;12;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;140;-2800.295,-1018.992;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;141;-2098.295,-1144.992;Inherit;False;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;143;-1888.295,-1150.992;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-1669.295,-1149.992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-1488.295,-1078.992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;148;-1303.295,-919.9918;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;147;-1696,-912;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;149;-1093.295,-965.9918;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;-615.7661,-919.7119;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;150;-1312,-768;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformDirectionNode;152;-865.2954,-926.9918;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;142;-2270.295,-1026.992;Inherit;False;InstancedProperty;_WindDensity;WindDensity;13;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-1884.295,-975.9918;Inherit;False;InstancedProperty;_WindStrength;WindStrength;14;0;Create;True;0;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-688,112;Inherit;False;43;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-688,176;Inherit;False;41;Gloss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-688,240;Inherit;False;32;Ao;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-688,304;Inherit;False;46;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-688,-336;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1216,-448;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-1216,-512;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1360,-560;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;58;-1024,-560;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-880,-560;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-1280,-384;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.IntNode;38;-647.0273,567.6526;Inherit;False;InstancedProperty;_DepthOffset;DepthOffset;11;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;37;-647.0273,471.6527;Inherit;False;InstancedProperty;_CullMode;CullMode;10;2;[Header];[Enum];Create;True;2;________________________________________________________________________________________________;Extras;3;Both;0;Back;1;Front;2;0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-647.0273,663.6527;Inherit;False;InstancedProperty;_AlphaClip;Alpha Clip;3;0;Create;True;0;0;0;False;0;False;0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-691.809,375.8702;Inherit;False;153;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-848,-384;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;-1040,-288;Inherit;False;162;LODVal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-1168,-368;Inherit;False;100;OpaMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1008,-384;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;174;-2240,256;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-2080,256;Inherit;False;LODVal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LODFadeNode;168;-2432,272;Inherit;False;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;49;0
WireConnection;0;1;17;0
WireConnection;0;3;45;0
WireConnection;0;4;42;0
WireConnection;0;5;131;0
WireConnection;0;9;47;0
WireConnection;0;10;47;0
WireConnection;0;11;175;0
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
WireConnection;100;0;97;0
WireConnection;105;0;104;0
WireConnection;31;0;105;1
WireConnection;31;1;105;2
WireConnection;32;0;31;0
WireConnection;33;0;105;1
WireConnection;106;0;105;0
WireConnection;104;1;121;0
WireConnection;97;1;124;0
WireConnection;110;0;118;1
WireConnection;110;1;118;2
WireConnection;111;0;118;3
WireConnection;111;1;118;4
WireConnection;112;0;110;0
WireConnection;112;1;111;0
WireConnection;113;0;112;0
WireConnection;1;1;123;0
WireConnection;18;1;125;0
WireConnection;14;1;126;0
WireConnection;14;5;15;0
WireConnection;53;0;130;0
WireConnection;130;0;129;0
WireConnection;130;1;129;1
WireConnection;130;2;129;2
WireConnection;130;3;1;4
WireConnection;129;0;70;0
WireConnection;70;0;1;0
WireConnection;70;1;67;0
WireConnection;136;0;132;0
WireConnection;136;2;137;0
WireConnection;137;0;140;0
WireConnection;137;1;139;0
WireConnection;141;0;136;0
WireConnection;141;1;142;0
WireConnection;143;0;141;0
WireConnection;144;0;143;0
WireConnection;144;1;145;0
WireConnection;146;0;144;0
WireConnection;146;1;147;1
WireConnection;148;0;146;0
WireConnection;148;1;147;2
WireConnection;148;2;147;3
WireConnection;149;0;148;0
WireConnection;149;1;150;0
WireConnection;153;0;152;0
WireConnection;152;0;144;0
WireConnection;46;0;177;0
WireConnection;2;0;54;0
WireConnection;2;1;6;0
WireConnection;58;0;2;0
WireConnection;58;1;64;0
WireConnection;58;2;61;0
WireConnection;48;0;58;0
WireConnection;7;0;2;0
WireConnection;177;0;99;0
WireConnection;177;1;165;0
WireConnection;99;0;101;0
WireConnection;99;1;7;3
WireConnection;174;0;168;1
WireConnection;174;2;168;1
WireConnection;162;0;174;0
ASEEND*/
//CHKSM=9A3DEB91CFE7612676C67B7C897637D73A3ACD9C