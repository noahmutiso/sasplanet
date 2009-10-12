program SASPlanet;

uses
  reinit,
  Forms,
  iniFiles,
  sysutils,
  windows,
  Unit1 in 'Unit1.pas' {Fmain},
  Unit2 in 'Unit2.pas' {FGoTo},
  UAbout in 'UAbout.pas' {Fabout},
  Usettings in 'Usettings.pas' {FSettings},
  USaveas in 'USaveas.pas' {Fsaveas},
  UProgress in 'UProgress.pas' {FProgress},
  UaddPoint in 'UaddPoint.pas' {FaddPoint},
  UTrAllLoadMap in 'UTrAllLoadMap.pas',
  UThreadScleit in 'UThreadScleit.pas',
  Unit4 in 'Unit4.pas' {Fprogress2},
  ULogo in 'ULogo.pas' {FLogo},
  UWikiLayer in 'UWikiLayer.pas',
  UOzi in 'UOzi.pas',
  USelLonLat in 'USelLonLat.pas' {FSelLonLat},
  Ugeofun in 'Ugeofun.pas',
  UKmlParse in 'UKmlParse.pas',
  Ubrowser in 'Ubrowser.pas' {Fbrowser},
  Uimgfun in 'Uimgfun.pas',
  UMapType in 'UMapType.pas',
  UTimeZones in 'UTimeZones.pas',
  UaddLine in 'UaddLine.pas' {FaddLine},
  UaddPoly in 'UaddPoly.pas' {FAddPoly},
  UThreadExport in 'UThreadExport.pas',
  UEditMap in 'UEditMap.pas' {FEditMap},
  UResStrings in 'UResStrings.pas',
  USearchResult in 'USearchResult.pas' {FSearchResult},
  UOpDelTiles in 'UOpDelTiles.pas',
  UOpGenPreviousZoom in 'UOpGenPreviousZoom.pas',
  UFillingMap in 'UFillingMap.pas',
  UMarksExplorer in 'UMarksExplorer.pas' {FMarksExplorer},
  UImport in 'UImport.pas' {FImport},
  UAddCategory in 'UAddCategory.pas' {FAddCategory},
  UPLT in 'UPLT.pas',
  UFDGAvailablePic in 'UFDGAvailablePic.pas' {FDGAvailablePic},
  u_MemFileCache in 'u_MemFileCache.pas',
  UYaMobile in 'UYaMobile.pas',
  u_UrlGenerator in 'u_UrlGenerator.pas',
  u_CoordConverterAbstract in 'u_CoordConverterAbstract.pas',
  u_CoordConverterMercatorOnEllipsoid in 'u_CoordConverterMercatorOnEllipsoid.pas',
  u_CoordConverterMercatorOnSphere in 'u_CoordConverterMercatorOnSphere.pas',
  u_CoordConverterSimpleLonLat in 'u_CoordConverterSimpleLonLat.pas',
  ImgMaker in 'ImgMaker.pas',
  t_GeoTypes in 't_GeoTypes.pas',
  t_CommonTypes in 't_CommonTypes.pas',
  u_GeoToStr in 'u_GeoToStr.pas',
  u_GlobalState in 'u_GlobalState.pas',
  u_MiniMap in 'u_MiniMap.pas',
  u_TileDownloaderBase in 'u_TileDownloaderBase.pas';

var
  loc:integer;
   {$R *.res}{$R SASR.RES}
begin
  GState := TGlobalState.Create;
  if FileExists(GState.ProgramPath+'SASPlanet.RUS') then
   begin
    RenameFile(GState.ProgramPath+'SASPlanet.RUS',GState.ProgramPath+'SASPlanet.~RUS');
   end;
  if SysLocale.PriLangID<>CProgram_Lang_Default then loc:=LANG_ENGLISH
                                       else loc:=CProgram_Lang_Default;
  GState.Localization:= GState.MainIni.Readinteger('VIEW','localization',loc);
  GState.WebReportToAuthor:=GState.MainIni.ReadBool('NPARAM','stat',true);
  Application.Initialize;
  Application.Title := 'SAS.�������';
  //logo
  LoadNewResourceModule(GState.Localization);
  if GState.MainIni.ReadBool('VIEW','Show_logo',true) then
   begin
    FLogo:=TFLogo.Create(application);
    FLogo.Label1.Caption:='v '+SASVersion;
    FLogo.Show;
    Application.ProcessMessages;
   end;
  LoadMaps;
  //xLogo
  Application.HelpFile := '';
  Application.CreateForm(TFmain, Fmain);
  Application.CreateForm(TFGoTo, FGoTo);
  Application.CreateForm(TFabout, Fabout);
  Application.CreateForm(TFSettings, FSettings);
  Application.CreateForm(TFsaveas, Fsaveas);
  Application.CreateForm(TFSearchResult, FSearchResult);
  Application.CreateForm(TFMarksExplorer, FMarksExplorer);
  Application.CreateForm(TFImport, FImport);
  Application.CreateForm(TFAddCategory, FAddCategory);
  Application.CreateForm(TFDGAvailablePic, FDGAvailablePic);
  Application.CreateForm(TFaddPoint, FaddPoint);
  Application.CreateForm(TFprogress2, Fprogress2);
  Application.CreateForm(TFbrowser, Fbrowser);
  Application.CreateForm(TFaddLine, FaddLine);
  Application.CreateForm(TFAddPoly, FAddPoly);
  Application.CreateForm(TFEditMap, FEditMap);
  Fmain.WebBrowser1.Navigate('about:blank');
  Fbrowser.EmbeddedWB1.Navigate('about:blank');
  Application.Run;
  FreeAndNil(GState);
end.
