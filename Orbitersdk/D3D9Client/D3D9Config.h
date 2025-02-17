// ==============================================================
// Part of the ORBITER VISUALISATION PROJECT (OVP)
// Dual licensed under GPL v3 and LGPL v3
// Copyright (C) 2006-2016 Martin Schweiger
//				 2012-2016 Jarmo Nikkanen
// ==============================================================

#ifndef __D3D9CONFIG_H
#define __D3D9CONFIG_H

extern class D3D9Config *Config;

/**
 * \brief Configuration Manager
 *
 * This class provides access to config-parameters that were read from the
 * config file.
 */
class D3D9Config {
public:
	bool bFlatsEnabled;

	D3D9Config ();
	~D3D9Config ();

	void Reset();
	bool ReadParams();
	void WriteParams();
	int  MaxLights();

	/// Bit flags for "LabelDisplayFlags" parameter.
	static const int LABEL_DISPLAY_RECORD = 0x1; ///< Display label "Record" on active recording session
	static const int LABEL_DISPLAY_REPLAY = 0x2; ///< Display label "Replay" on active playback session


	int PlanetPreloadMode;			///< Planet preload mode setting (0=load on demand, 1=preload)
	int PlanetLoadFrequency;		///< Load frequency for on-demand textures \[Hz\] (1...1000)
	int Anisotrophy;				///< Anisotropic filtering setting \[factor\] (1...16)
	int SceneAntialias;				///< Antialiasing setting \[factor\] (0...)
	int DisableDriverManagement;	///< Disable the D3D9 driver management \[sets the D3DCREATE_DISABLE_DRIVER_MANAGEMENT behavior flag\]  (0=default, 1:disabled)
	int DisableVisualHelperReadout;	///< Disable the hooking of the visual helper windows, to allow acces to config parameter that Orbiter core doesn't provide (0=normal mode, 1=disable any hooking)
	int NearClipPlane;				///< Near clip plane mode (0,1)
	int DebugBreak;					///< Enable Debug Break
	int PreLBaseVis;				///< Preload base visuals (0=load on demand, 1=preload)
	int DebugFontSize;				///< Debug font height \[pixel\] (default=18px)
	int UseNormalMap;				///< Enable normal mapping (0,1)
	int SketchpadFont;				///< Sketchpad Font (0=Crisp, 1=Default, 2=Cleartype, 3=Proof Quality)
	int RwyLightAnimate;			///< Runway light animate (0,1)
	double RwyLightAngle;			///< Runway light angle \[deg\] (10...180)
	double RwyBrightness;			///< Runway light brightness (0.3...3.0)
	double VCNearPlane;				///< Virtual cockpit near clip-plane distance \[m\] (-1.0...1.0, default=0.1)
	double Convergence;				///< StereoScopic 3D convergence distance \[m\] (0.05...1.0, default=0.2)
	double Separation;				///< StereoScopic 3D depth of field separation \[m\] (10.0...100.0, default=65)
	double SunAngle;				///< Sun-angle above horizon when night-lights set it \[deg\] (0.1...20.0, default=10)
	double BumpAmp;					///< Bump map amplification setting (0.1...10.0, default=1)
	double PlanetGlow;				///< Intensity of planet glow effect (0.01...2.0, default=0.7)
	double FrameRate;				///< Framerate limiter
	double OrbitalShadowMult;		///< Multiplier for cloudshadows for Orbital flight
	int EnableLimiter;				///< Enable framerate limiter
	int DebugLvl;					///< Level of debug output 'verbosity'. Higher values create more detailed output (0...4, default=1)
	int LabelDisplayFlags;			///< Label display option flags. For example the "Record" and "Replay" labels (0=all disabled, 1=show record label, 2=show replay label, 3=show both \[default\])
	int LightConfig;				///< Light emitter configuration
	int NVPerfHUD;					///< ??? (0,1)
	int EnvMapSize;					///< Environment map size (64...512)
	int EnvMapMode;					///< Environment map mode (0=disabled, 1=planet only, 2=fullscene)
	int EnvMapFaces;				///< Number of environment map faces render per frame (1..6, default=1)
	int EnableGlass;				///< Enable improved glass shading (Fresnel reflection)
	int EnableMeshDbg;				///< Enable mesh debugger
	int ShadowMapMode;				///< Shadow Mapping Mode
	int ShadowFilter;				///< Shadow Mapping Filter
	int ShadowMapSize;				///< Shadow Map size
	int TerrainShadowing;
	int CustomCamMode;				///< Custom Camera Mode
	int TileMipmaps;				///< Enable surface tile mipmaps
	int ShaderDebug;
	double LODBias;					///< 3D Terrain resolution bias
	int MeshRes;					///< Tile patch mesh resolution
	int TileDebug;					///< Enable tile debugger
	int TextureMips;				///< Texture mipmap autogen policy
	int PostProcess;				///< Enable postprocessing effects
	int MicroMode;
	int MicroFilter;
	int BlendMode;
	int PresentLocation;
	int MicroBias;					///< Mipmap LOD Bias for surface micro textures
	int CloudMicro;					///< Cloud layer micro textures
	int PlanetTileLoadFlags;		///< Planet Tile Load Flags (0x1=load tiles from directory tree, 0x2=load tiles from compressed archive, 0x3=both \[try directory tree first, then archive\])
	int GDIOverlay;					///< GDI Overlay
	int gcGUIMode;					///< gcGUI Operation Mode
	int bAbsAnims;					///< Absolute animations
	int bCloudNormals;				///< Felix24's Cound normals implementation test
	int bFlats;						///< Face's terrain flattening
	char *DebugFont;				///< Font face for debug lines (default="Fixed")
	char *SolCfg;					///< Solar system to use (default="Sol")
	double GFXIntensity;
	double GFXDistance;
	double GFXThreshold;
	double GFXSunIntensity;
	double GFXGamma;
	double GFXLocalMax;

private:

};

#endif // !__D3D9CONFIG_H
