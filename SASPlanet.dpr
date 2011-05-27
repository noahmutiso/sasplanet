// JCL_DEBUG_EXPERT_INSERTJDBG ON
program SASPlanet;

uses
  Forms,
  iniFiles,
  sysutils,
  windows,
  MidasLib,
  MD5 in 'src\MD5.pas',
  RegExpr in 'src\RegExpr.pas',
  KAZip in 'src\KAZip.pas',
  TarWriter in 'src\TarWriter.pas',
  ECWReader in 'src\ECWReader.pas',
  ECWwriter in 'src\ECWwriter.pas',
  SwinHttp in 'src\SwinHttp.pas',
  gnugettext in 'src\gnugettext.pas',
  Langs in 'src\Langs.pas',
  TBXSASTheme in 'src\TBXSASTheme.pas',
  u_WideStrings in 'src\u_WideStrings.pas',
  c_ZeroGUID in 'src\c_ZeroGUID.pas',
  cUnicode in 'src\cUnicode.pas',
  cUnicodeChar in 'src\cUnicodeChar.pas',
  CPDrv in 'src\CPDrv.pas',
  BMSearch in 'src\BMSearch.pas',
  i_GUIDList in 'src\i_GUIDList.pas',
  u_GUIDList in 'src\u_GUIDList.pas',
  u_GUIDInterfaceList in 'src\u_GUIDInterfaceList.pas',
  u_GUIDObjectList in 'src\u_GUIDObjectList.pas',
  i_EnumID in 'src\i_EnumID.pas',
  i_IDList in 'src\i_IDList.pas',
  u_IdListBase in 'src\u_IdListBase.pas',
  u_IDInterfaceList in 'src\u_IDInterfaceList.pas',
  i_JclNotify in 'src\i_JclNotify.pas',
  u_JclNotify in 'src\u_JclNotify.pas',
  u_UseNewFonts in 'src\u_UseNewFonts.pas',
  i_FileNameIterator in 'src\i_FileNameIterator.pas',
  u_FileNameIteratorInFolderByMaskList in 'src\u_FileNameIteratorInFolderByMaskList.pas',
  u_FileNameIteratorFolderWithSubfolders in 'src\u_FileNameIteratorFolderWithSubfolders.pas',
  u_FileNameIteratorInFolderByMask in 'src\u_FileNameIteratorInFolderByMask.pas',
  u_FoldersIteratorRecursiveByLevels in 'src\u_FoldersIteratorRecursiveByLevels.pas',
  u_FoldersIteratorRecursiveByLevelsWithIgnoredFolders in 'src\u_FoldersIteratorRecursiveByLevelsWithIgnoredFolders.pas',
  u_ZmpFileNamesIteratorFactory in 'u_ZmpFileNamesIteratorFactory.pas',
  i_JclListenerNotifierLinksList in 'i_JclListenerNotifierLinksList.pas',
  u_JclListenerNotifierLinksList in 'u_JclListenerNotifierLinksList.pas',
  c_SasVersion in 'c_SasVersion.pas',
  c_CoordConverter in 'c_CoordConverter.pas',
  c_GeoCoderGUIDSimple in 'c_GeoCoderGUIDSimple.pas',
  c_SensorsGUIDSimple in 'c_SensorsGUIDSimple.pas',
  t_GeoTypes in 't_GeoTypes.pas',
  t_CommonTypes in 't_CommonTypes.pas',
  i_Datum in 'i_Datum.pas',
  u_Datum in 'u_Datum.pas',
  u_TimeZones in 'u_TimeZones.pas',
  u_ResStrings in 'u_ResStrings.pas',
  u_CommonFormAndFrameParents in 'u_CommonFormAndFrameParents.pas',
  u_TBXSubmenuItemWithIndicator in 'u_TBXSubmenuItemWithIndicator.pas',
  i_ConfigDataProvider in 'i_ConfigDataProvider.pas',
  i_ConfigDataWriteProvider in 'i_ConfigDataWriteProvider.pas',
  u_ConfigDataProviderByKaZip in 'u_ConfigDataProviderByKaZip.pas',
  u_ConfigDataProviderByIniFile in 'u_ConfigDataProviderByIniFile.pas',
  u_ConfigDataProviderByIniFileSection in 'u_ConfigDataProviderByIniFileSection.pas',
  u_ConfigDataProviderByFolder in 'u_ConfigDataProviderByFolder.pas',
  u_ConfigDataProviderWithLocal in 'u_ConfigDataProviderWithLocal.pas',
  u_ConfigDataProviderVirtualWithSubItem in 'u_ConfigDataProviderVirtualWithSubItem.pas',
  u_ConfigDataProviderWithUseDepreciated in 'u_ConfigDataProviderWithUseDepreciated.pas',
  u_ConfigDataProviderWithReplacedSubItem in 'u_ConfigDataProviderWithReplacedSubItem.pas',
  u_ConfigDataProviderZmpComplex in 'u_ConfigDataProviderZmpComplex.pas',
  u_ConfigDataWriteProviderByIniFileSection in 'u_ConfigDataWriteProviderByIniFileSection.pas',
  u_ConfigDataWriteProviderByIniFile in 'u_ConfigDataWriteProviderByIniFile.pas',
  u_SaveLoadTBConfigByConfigProvider in 'u_SaveLoadTBConfigByConfigProvider.pas',
  u_ConfigProviderHelpers in 'u_ConfigProviderHelpers.pas',
  i_ConfigDataElement in 'i_ConfigDataElement.pas',
  u_ConfigDataElementBase in 'u_ConfigDataElementBase.pas',
  u_ConfigDataElementComplexBase in 'u_ConfigDataElementComplexBase.pas',
  i_ConfigSaveLoadStrategy in 'i_ConfigSaveLoadStrategy.pas',
  u_ConfigSaveLoadStrategyBasicUseProvider in 'u_ConfigSaveLoadStrategyBasicUseProvider.pas',
  u_ConfigSaveLoadStrategyBasicProviderSubItem in 'u_ConfigSaveLoadStrategyBasicProviderSubItem.pas',
  i_TileError in 'i_TileError.pas',
  u_TileErrorInfo in 'u_TileErrorInfo.pas',
  i_TileErrorLogProviedrStuped in 'i_TileErrorLogProviedrStuped.pas',
  u_TileErrorLogProviedrStuped in 'u_TileErrorLogProviedrStuped.pas',
  i_LogSimple in 'i_LogSimple.pas',
  i_LogForTaskThread in 'i_LogForTaskThread.pas',
  i_TileDownlodSession in 'i_TileDownlodSession.pas',
  i_SimpleFactory in 'i_SimpleFactory.pas',
  i_ListOfObjectsWithTTL in 'i_ListOfObjectsWithTTL.pas',
  i_ObjectWithTTL in 'i_ObjectWithTTL.pas',
  i_PoolElement in 'i_PoolElement.pas',
  i_MemObjCache in 'i_MemObjCache.pas',
  i_TileObjCache in 'i_TileObjCache.pas',
  u_TileCacheSimpleGlobal in 'u_TileCacheSimpleGlobal.pas',
  u_ThreadDownloadTiles in 'RegionProcess\u_ThreadDownloadTiles.pas',
  u_ThreadMapCombineBase in 'RegionProcess\u_ThreadMapCombineBase.pas',
  u_ThreadMapCombineBMP in 'RegionProcess\u_ThreadMapCombineBMP.pas',
  u_ThreadMapCombineECW in 'RegionProcess\u_ThreadMapCombineECW.pas',
  u_ThreadMapCombineJPG in 'RegionProcess\u_ThreadMapCombineJPG.pas',
  u_ThreadMapCombineKMZ in 'RegionProcess\u_ThreadMapCombineKMZ.pas',
  u_ThreadRegionProcessAbstract in 'RegionProcess\u_ThreadRegionProcessAbstract.pas',
  u_ThreadExportAbstract in 'RegionProcess\u_ThreadExportAbstract.pas',
  u_ThreadExportToZip in 'RegionProcess\u_ThreadExportToZip.pas',
  u_ThreadExportToTar in 'RegionProcess\u_ThreadExportToTar.pas',
  u_ThreadExportToFileSystem in 'RegionProcess\u_ThreadExportToFileSystem.pas',
  u_ThreadExportIPhone in 'RegionProcess\u_ThreadExportIPhone.pas',
  u_ThreadExportKML in 'RegionProcess\u_ThreadExportKML.pas',
  u_ThreadExportYaMaps in 'RegionProcess\u_ThreadExportYaMaps.pas',
  u_ThreadExportYaMapsNew in 'RegionProcess\u_ThreadExportYaMapsNew.pas',
  u_ThreadExportToAUX in 'RegionProcess\u_ThreadExportToAUX.pas',
  u_ThreadDeleteTiles in 'RegionProcess\u_ThreadDeleteTiles.pas',
  u_ThreadGenPrevZoom in 'RegionProcess\u_ThreadGenPrevZoom.pas',
  u_TileDownloaderBase in 'u_TileDownloaderBase.pas',
  u_TileDownloaderUI in 'u_TileDownloaderUI.pas',
  u_TileDownloaderUIOneTile in 'u_TileDownloaderUIOneTile.pas',
  u_TileDownloaderThreadBase in 'u_TileDownloaderThreadBase.pas',
  u_LogForTaskThread in 'u_LogForTaskThread.pas',
  i_InternalPerformanceCounter in 'i_InternalPerformanceCounter.pas',
  u_InternalPerformanceCounter in 'u_InternalPerformanceCounter.pas',
  u_InternalPerformanceCounterList in 'u_InternalPerformanceCounterList.pas',
  u_NotifyEventListener in 'u_NotifyEventListener.pas',
  u_NotifyWithGUIDEvent in 'u_NotifyWithGUIDEvent.pas',
  u_NotifyEventPosChangeListener in 'u_NotifyEventPosChangeListener.pas',
  u_MapLayerWithThreadDraw in 'MapLayers\u_MapLayerWithThreadDraw.pas',
  i_VectorDataItemSimple in 'i_VectorDataItemSimple.pas',
  u_VectorDataItemBase in 'u_VectorDataItemBase.pas',
  u_VectorDataItemPoint in 'u_VectorDataItemPoint.pas',
  u_VectorDataItemPolygon in 'u_VectorDataItemPolygon.pas',
  u_VectorDataItemList in 'u_VectorDataItemList.pas',
  i_KmlLayerConfig in 'i_KmlLayerConfig.pas',
  u_KmlLayerConfig in 'u_KmlLayerConfig.pas',
  u_MapLayerWiki in 'MapLayers\u_MapLayerWiki.pas',
  i_MiniMapLayerConfig in 'i_MiniMapLayerConfig.pas',
  u_MiniMapMapsConfig in 'u_MiniMapMapsConfig.pas',
  u_MiniMapLayerConfig in 'u_MiniMapLayerConfig.pas',
  u_PLT in 'u_PLT.pas',
  u_GeoFun in 'u_GeoFun.pas',
  u_GlobalCahceConfig in 'u_GlobalCahceConfig.pas',
  u_GlobalState in 'u_GlobalState.pas',
  u_GPSState in 'u_GPSState.pas',
  i_LastSelectionInfo in 'i_LastSelectionInfo.pas',
  u_LastSelectionInfo in 'u_LastSelectionInfo.pas',
  u_GeoToStr in 'u_GeoToStr.pas',
  u_KmlInfoSimple in 'u_KmlInfoSimple.pas',
  i_KmlInfoSimpleLoader in 'i_KmlInfoSimpleLoader.pas',
  u_KmlInfoSimpleParser in 'u_KmlInfoSimpleParser.pas',
  u_KmzInfoSimpleParser in 'u_KmzInfoSimpleParser.pas',
  u_ECWWrite in 'u_ECWWrite.pas',
  u_BmpUtil in 'u_BmpUtil.pas',
  i_BitmapTileSaveLoad in 'i_BitmapTileSaveLoad.pas',
  u_BitmapTileVampyreLoader in 'BitmapTileSaveLoad\u_BitmapTileVampyreLoader.pas',
  u_BitmapTileVampyreSaver in 'BitmapTileSaveLoad\u_BitmapTileVampyreSaver.pas',
  u_BitmapTileGELoader in 'BitmapTileSaveLoad\u_BitmapTileGELoader.pas',
  u_BitmapTileGEDXTextureLoader in 'BitmapTileSaveLoad\u_BitmapTileGEDXTextureLoader.pas',
  i_BitmapTypeExtManager in 'i_BitmapTypeExtManager.pas',
  u_BitmapTypeExtManagerSimple in 'u_BitmapTypeExtManagerSimple.pas',
  u_MapTypeCacheConfig in 'u_MapTypeCacheConfig.pas',
  u_MapType in 'u_MapType.pas',
  u_MapTypesMainList in 'u_MapTypesMainList.pas',
  i_MapTypeIconsList in 'i_MapTypeIconsList.pas',
  u_MapTypeIconsList in 'u_MapTypeIconsList.pas',
  u_MemFileCache in 'u_MemFileCache.pas',
  u_ProxyConfig in 'u_ProxyConfig.pas',
  u_InetConfig in 'u_InetConfig.pas',
  i_GSMGeoCodeConfig in 'i_GSMGeoCodeConfig.pas',
  u_GSMGeoCodeConfig in 'u_GSMGeoCodeConfig.pas',
  u_YaMobileWrite in 'u_YaMobileWrite.pas',
  u_PosFromGSM in 'u_PosFromGSM.pas',
  i_DownloadInfoSimple in 'i_DownloadInfoSimple.pas',
  u_DownloadInfoSimple in 'u_DownloadInfoSimple.pas',
  i_LocalCoordConverter in 'i_LocalCoordConverter.pas',
  u_LocalCoordConverter in 'u_LocalCoordConverter.pas',
  i_LocalCoordConverterFactorySimpe in 'i_LocalCoordConverterFactorySimpe.pas',
  u_LocalCoordConverterFactorySimpe in 'u_LocalCoordConverterFactorySimpe.pas',
  u_UrlGenerator in 'u_UrlGenerator.pas',
  u_UrlGeneratorHelpers in 'u_UrlGeneratorHelpers.pas',
  i_CoordConverter in 'i_CoordConverter.pas',
  u_CoordConverterAbstract in 'u_CoordConverterAbstract.pas',
  u_CoordConverterBasic in 'u_CoordConverterBasic.pas',
  u_CoordConverterMercatorOnEllipsoid in 'u_CoordConverterMercatorOnEllipsoid.pas',
  u_CoordConverterMercatorOnSphere in 'u_CoordConverterMercatorOnSphere.pas',
  u_CoordConverterSimpleLonLat in 'u_CoordConverterSimpleLonLat.pas',
  i_CoordConverterFactory in 'i_CoordConverterFactory.pas',
  u_CoordConverterFactorySimple in 'u_CoordConverterFactorySimple.pas',
  i_ContentTypeInfo in 'i_ContentTypeInfo.pas',
  i_ContentTypeManager in 'i_ContentTypeManager.pas',
  i_ContentConverter in 'i_ContentConverter.pas',
  u_ContentTypeInfo in 'u_ContentTypeInfo.pas',
  u_ContentConverterBase in 'u_ContentConverterBase.pas',
  u_ContentConverterBitmap in 'u_ContentConverterBitmap.pas',
  u_ContentConverterKmz2Kml in 'u_ContentConverterKmz2Kml.pas',
  u_ContentConverterKml2Kmz in 'u_ContentConverterKml2Kmz.pas',
  u_ContentTypeListByKey in 'u_ContentTypeListByKey.pas',
  u_ContentTypeManagerBase in 'u_ContentTypeManagerBase.pas',
  u_ContentTypeManagerSimple in 'u_ContentTypeManagerSimple.pas',
  u_ContentConvertersListByKey in 'u_ContentConvertersListByKey.pas',
  u_ContentConverterMatrix in 'u_ContentConverterMatrix.pas',
  i_MarkPicture in 'i_MarkPicture.pas',
  u_MarkPictureSimple in 'u_MarkPictureSimple.pas',
  u_MarkPictureListSimple in 'u_MarkPictureListSimple.pas',
  i_TileInfoBasic in 'i_TileInfoBasic.pas',
  u_TileInfoBasic in 'u_TileInfoBasic.pas',
  i_TileIterator in 'i_TileIterator.pas',
  u_TileIteratorAbstract in 'u_TileIteratorAbstract.pas',
  u_TileIteratorStuped in 'u_TileIteratorStuped.pas',
  u_TileIteratorSpiralByRect in 'u_TileIteratorSpiralByRect.pas',
  u_TileIteratorByRect in 'u_TileIteratorByRect.pas',
  i_TileStorageTypeConfig in 'i_TileStorageTypeConfig.pas',
  i_TileStorageTypeList in 'i_TileStorageTypeList.pas',
  i_TileStorageTypeListItem in 'i_TileStorageTypeListItem.pas',
  u_TileStorageTypeListItem in 'u_TileStorageTypeListItem.pas',
  i_TileStorage in 'i_TileStorage.pas',
  i_TileStorageType in 'i_TileStorageType.pas',
  i_TileStorageTypeInfo in 'i_TileStorageTypeInfo.pas',
  u_TileStorageTypeInfo in 'u_TileStorageTypeInfo.pas',
  u_TileStorageTypeList in 'u_TileStorageTypeList.pas',
  u_TileStorageTypeListSimple in 'u_TileStorageTypeListSimple.pas',
  u_GECrypt in 'u_GECrypt.pas',
  u_GEIndexFile in 'u_GEIndexFile.pas',
  i_GeoCoder in 'i_GeoCoder.pas',
  u_GeoCodePlacemark in 'u_GeoCodePlacemark.pas',
  u_EnumUnknown in 'u_EnumUnknown.pas',
  u_GeoCodeResult in 'u_GeoCodeResult.pas',
  i_ProxySettings in 'i_ProxySettings.pas',
  u_GeoCoderBasic in 'u_GeoCoderBasic.pas',
  u_GeoCoderByYandex in 'u_GeoCoderByYandex.pas',
  u_GeoCoderByGoogle in 'u_GeoCoderByGoogle.pas',
  i_LayerBitmapClearStrategy in 'i_LayerBitmapClearStrategy.pas',
  u_LayerBitmapClearStrategy in 'u_LayerBitmapClearStrategy.pas',
  u_LayerBitmapClearStrategyFactory in 'u_LayerBitmapClearStrategyFactory.pas',
  i_MapViewGoto in 'i_MapViewGoto.pas',
  u_MapViewGotoOnFMain in 'u_MapViewGotoOnFMain.pas',
  i_SearchResultPresenter in 'i_SearchResultPresenter.pas',
  u_SearchResultPresenterStuped in 'u_SearchResultPresenterStuped.pas',
  i_UsedMarksConfig in 'i_UsedMarksConfig.pas',
  u_UsedMarksConfig in 'u_UsedMarksConfig.pas',
  u_UsedMarksConfigStatic in 'u_UsedMarksConfigStatic.pas',
  i_MarksSimple in 'i_MarksSimple.pas',
  i_MarksDbSmlInternal in 'i_MarksDbSmlInternal.pas',
  u_MarksSubset in 'u_MarksSubset.pas',
  u_MarksOnlyDb in 'u_MarksOnlyDb.pas',
  u_MarkTemplates in 'u_MarkTemplates.pas',
  i_MarkNameGenerator in 'i_MarkNameGenerator.pas',
  u_MarkNameGenerator in 'u_MarkNameGenerator.pas',
  i_MarksFactoryConfig in 'i_MarksFactoryConfig.pas',
  u_MarksFactoryConfig in 'u_MarksFactoryConfig.pas',
  u_MarkTemplateConfigBase in 'u_MarkTemplateConfigBase.pas',
  u_MarkPolyTemplateConfig in 'u_MarkPolyTemplateConfig.pas',
  u_MarkPointTemplateConfig in 'u_MarkPointTemplateConfig.pas',
  u_MarkLineTemplateConfig in 'u_MarkLineTemplateConfig.pas',
  u_MarkFactory in 'u_MarkFactory.pas',
  i_MarkCategoryDB in 'i_MarkCategoryDB.pas',
  i_MarkCategoryDBSmlInternal in 'i_MarkCategoryDBSmlInternal.pas',
  u_MarkCategoryDB in 'u_MarkCategoryDB.pas',
  u_MarkId in 'u_MarkId.pas',
  u_MarkPoint in 'u_MarkPoint.pas',
  u_MarkPoly in 'u_MarkPoly.pas',
  u_MarkLine in 'u_MarkLine.pas',
  i_MarkFactory in 'i_MarkFactory.pas',
  i_MarkFactoryDbInternal in 'i_MarkFactoryDbInternal.pas',
  i_MarkCategoryFactory in 'i_MarkCategoryFactory.pas',
  i_MarkCategoryFactoryDbInternal in 'i_MarkCategoryFactoryDbInternal.pas',
  u_MarkCategoryFactory in 'u_MarkCategoryFactory.pas',
  i_MarkCategoryFactoryConfig in 'i_MarkCategoryFactoryConfig.pas',
  u_MarkCategoryFactoryConfig in 'u_MarkCategoryFactoryConfig.pas',
  u_MarksDb in 'u_MarksDb.pas',
  u_MarksDbGUIHelper in 'u_MarksDbGUIHelper.pas',
  i_BitmapLayerProvider in 'i_BitmapLayerProvider.pas',
  u_MapMarksBitmapLayerProviderByMarksSubset in 'u_MapMarksBitmapLayerProviderByMarksSubset.pas',
  u_ClipPolygonByRect in 'u_ClipPolygonByRect.pas',
  u_WindowLayerBasic in 'MapLayers\u_WindowLayerBasic.pas',
  u_WindowLayerWithPos in 'MapLayers\u_WindowLayerWithPos.pas',
  u_WindowLayerBasicList in 'u_WindowLayerBasicList.pas',
  u_MiniMapLayer in 'MapLayers\u_MiniMapLayer.pas',
  u_CenterScale in 'MapLayers\u_CenterScale.pas',
  u_LayerStatBar in 'MapLayers\u_LayerStatBar.pas',
  u_MapLayerBasic in 'MapLayers\u_MapLayerBasic.pas',
  u_MapLayerTileGrid in 'MapLayers\u_MapLayerTileGrid.pas',
  u_MapLayerGrids in 'MapLayers\u_MapLayerGrids.pas',
  u_MapMainLayer in 'MapLayers\u_MapMainLayer.pas',
  u_MapMarksLayer in 'MapLayers\u_MapMarksLayer.pas',
  u_MapLayerNavToMark in 'MapLayers\u_MapLayerNavToMark.pas',
  u_SelectionLayer in 'MapLayers\u_SelectionLayer.pas',
  u_LayerScaleLine in 'MapLayers\u_LayerScaleLine.pas',
  u_MapGPSLayer in 'MapLayers\u_MapGPSLayer.pas',
  u_MapLayerShowError in 'MapLayers\u_MapLayerShowError.pas',
  u_MapLayerGoto in 'MapLayers\u_MapLayerGoto.pas',
  u_MapLayerGPSMarker in 'MapLayers\u_MapLayerGPSMarker.pas',
  u_PolyLineLayerBase in 'MapLayers\u_PolyLineLayerBase.pas',
  u_CalcLineLayer in 'MapLayers\u_CalcLineLayer.pas',
  u_MarkPolyLineLayer in 'MapLayers\u_MarkPolyLineLayer.pas',
  u_MarkPolygonLayer in 'MapLayers\u_MarkPolygonLayer.pas',
  u_SelectionPolygonLayer in 'MapLayers\u_SelectionPolygonLayer.pas',
  u_SelectionRectLayer in 'MapLayers\u_SelectionRectLayer.pas',
  i_Thread in 'i_Thread.pas',
  u_InterfacedThread in 'u_InterfacedThread.pas',
  i_BackgroundTask in 'i_BackgroundTask.pas',
  u_BackgroundTask in 'u_BackgroundTask.pas',
  u_BackgroundTaskLayerDrawBase in 'u_BackgroundTaskLayerDrawBase.pas',
  u_MapLayerFillingMap in 'MapLayers\u_MapLayerFillingMap.pas',
  i_Marks in 'i_Marks.pas',
  i_MarkCategory in 'i_MarkCategory.pas',
  u_MarkCategory in 'u_MarkCategory.pas',
  dm_MarksDb in 'dm_MarksDb.pas' {DMMarksDb: TDataModule},
  u_EnumUnknownEmpty in 'u_EnumUnknownEmpty.pas',
  i_TileFileNameGenerator in 'i_TileFileNameGenerator.pas',
  u_TileFileNameSAS in 'u_TileFileNameSAS.pas',
  u_TileFileNameGMV in 'u_TileFileNameGMV.pas',
  u_TileFileNameES in 'u_TileFileNameES.pas',
  u_TileFileNameGM1 in 'u_TileFileNameGM1.pas',
  u_TileFileNameGM2 in 'u_TileFileNameGM2.pas',
  i_TileFileNameGeneratorsList in 'i_TileFileNameGeneratorsList.pas',
  u_TileStorageAbstract in 'u_TileStorageAbstract.pas',
  u_TileStorageGE in 'u_TileStorageGE.pas',
  u_TileStorageFileSystem in 'u_TileStorageFileSystem.pas',
  i_MemCache in 'i_MemCache.pas',
  u_TileFileNameGeneratorsSimpleList in 'u_TileFileNameGeneratorsSimpleList.pas',
  u_TileDownloaderBaseFactory in 'u_TileDownloaderBaseFactory.pas',
  u_GarbageCollectorThread in 'u_GarbageCollectorThread.pas',
  u_ListOfObjectsWithTTL in 'u_ListOfObjectsWithTTL.pas',
  u_PoolElement in 'u_PoolElement.pas',
  u_PoolOfObjectsSimple in 'u_PoolOfObjectsSimple.pas',
  i_MapCalibration in 'i_MapCalibration.pas',
  u_MapCalibrationOzi in 'u_MapCalibrationOzi.pas',
  u_MapCalibrationDat in 'u_MapCalibrationDat.pas',
  u_MapCalibrationKml in 'u_MapCalibrationKml.pas',
  u_MapCalibrationTab in 'u_MapCalibrationTab.pas',
  u_MapCalibrationWorldFiles in 'u_MapCalibrationWorldFiles.pas',
  u_MapCalibrationListBasic in 'u_MapCalibrationListBasic.pas',
  i_ImportConfig in 'i_ImportConfig.pas',
  u_ImportConfig in 'u_ImportConfig.pas',
  i_ImportFile in 'i_ImportFile.pas',
  u_MarksImportBase in 'u_MarksImportBase.pas',
  u_ImportKML in 'u_ImportKML.pas',
  u_ImportPLT in 'u_ImportPLT.pas',
  u_ImportHLG in 'u_ImportHLG.pas',
  u_ImportByFileExt in 'u_ImportByFileExt.pas',
  u_ExportMarks2KML in 'u_ExportMarks2KML.pas',
  i_UrlByCoordProvider in 'i_UrlByCoordProvider.pas',
  i_PathDetalizeProvider in 'i_PathDetalizeProvider.pas',
  u_PathDetalizeProviderYourNavigation in 'u_PathDetalizeProviderYourNavigation.pas',
  u_PathDetalizeProviderMailRu in 'u_PathDetalizeProviderMailRu.pas',
  i_Sensor in 'i_Sensor.pas',
  u_SensorViewTextTBXPanel in 'u_SensorViewTextTBXPanel.pas',
  u_SensorBase in 'u_SensorBase.pas',
  u_SensorTextFromGPSRecorder in 'u_SensorTextFromGPSRecorder.pas',
  u_SensorsFromGPSRecorder in 'u_SensorsFromGPSRecorder.pas',
  u_SensorTextFromNavToPoint in 'u_SensorTextFromNavToPoint.pas',
  u_SensorBatteryStatus in 'u_SensorBatteryStatus.pas',
  i_SensorListGenerator in 'i_SensorListGenerator.pas',
  u_SensorListGeneratorStuped in 'u_SensorListGeneratorStuped.pas',
  i_SensorViewListGenerator in 'i_SensorViewListGenerator.pas',
  u_SensorViewConfigSimple in 'u_SensorViewConfigSimple.pas',
  u_SensorViewListGeneratorStuped in 'u_SensorViewListGeneratorStuped.pas',
  i_AntiBan in 'i_AntiBan.pas',
  u_AntiBanStuped in 'u_AntiBanStuped.pas',
  i_MapTypes in 'i_MapTypes.pas',
  u_MapTypeBasic in 'u_MapTypeBasic.pas',
  u_MapTypeList in 'u_MapTypeList.pas',
  u_ActiveMapTBXItem in 'u_ActiveMapTBXItem.pas',
  u_MapTypeMenuItemsGeneratorBasic in 'u_MapTypeMenuItemsGeneratorBasic.pas',
  i_PosChangeMessage in 'i_PosChangeMessage.pas',
  u_PosChangeMessage in 'u_PosChangeMessage.pas',
  u_PosChangeListener in 'u_PosChangeListener.pas',
  u_ActiveMapConfig in 'u_ActiveMapConfig.pas',
  u_ActiveMapSingleAbstract in 'u_ActiveMapSingleAbstract.pas',
  u_ActiveMapsSet in 'u_ActiveMapsSet.pas',
  u_MainActiveMap in 'u_MainActiveMap.pas',
  u_ActivMapWithLayers in 'u_ActivMapWithLayers.pas',
  u_MainMapsConfig in 'u_MainMapsConfig.pas',
  i_ActiveMapsConfig in 'i_ActiveMapsConfig.pas',
  i_ViewPortState in 'i_ViewPortState.pas',
  u_MapViewPortStateNew in 'u_MapViewPortStateNew.pas',
  u_ShortcutManager in 'u_ShortcutManager.pas',
  i_LanguageManager in 'i_LanguageManager.pas',
  u_LanguageManager in 'u_LanguageManager.pas',
  u_LanguagesEx in 'u_LanguagesEx.pas',
  u_LanguageTBXItem in 'u_LanguageTBXItem.pas',
  i_ImageResamplerFactory in 'i_ImageResamplerFactory.pas',
  u_ImageResamplerFactory in 'u_ImageResamplerFactory.pas',
  u_ImageResamplerFactoryListStatic in 'u_ImageResamplerFactoryListStatic.pas',
  u_ImageResamplerFactoryListStaticSimple in 'u_ImageResamplerFactoryListStaticSimple.pas',
  i_ImageResamplerConfig in 'i_ImageResamplerConfig.pas',
  u_ImageResamplerConfig in 'u_ImageResamplerConfig.pas',
  i_MainMemCacheConfig in 'i_MainMemCacheConfig.pas',
  u_MainMemCacheConfig in 'u_MainMemCacheConfig.pas',
  i_GeoCoderList in 'i_GeoCoderList.pas',
  u_GeoCoderListEntity in 'u_GeoCoderListEntity.pas',
  u_GeoCoderListBase in 'u_GeoCoderListBase.pas',
  u_GeoCoderListSimple in 'u_GeoCoderListSimple.pas',
  i_MainGeoCoderConfig in 'i_MainGeoCoderConfig.pas',
  u_MainGeoCoderConfig in 'u_MainGeoCoderConfig.pas',
  i_MainFormBehaviourByGPSConfig in 'i_MainFormBehaviourByGPSConfig.pas',
  u_MainFormBehaviourByGPSConfig in 'u_MainFormBehaviourByGPSConfig.pas',
  i_ValueToStringConverter in 'i_ValueToStringConverter.pas',
  u_ValueToStringConverter in 'u_ValueToStringConverter.pas',
  u_ValueToStringConverterConfig in 'u_ValueToStringConverterConfig.pas',
  i_StatBarConfig in 'i_StatBarConfig.pas',
  u_StatBarConfig in 'u_StatBarConfig.pas',
  i_NavigationToPoint in 'i_NavigationToPoint.pas',
  u_NavigationToPoint in 'u_NavigationToPoint.pas',
  i_MapLayerGPSTrackConfig in 'i_MapLayerGPSTrackConfig.pas',
  u_MapLayerGPSTrackConfig in 'u_MapLayerGPSTrackConfig.pas',
  i_CenterScaleConfig in 'i_CenterScaleConfig.pas',
  u_CenterScaleConfig in 'u_CenterScaleConfig.pas',
  i_ScaleLineConfig in 'i_ScaleLineConfig.pas',
  u_ScaleLineConfig in 'u_ScaleLineConfig.pas',
  i_LastSelectionLayerConfig in 'i_LastSelectionLayerConfig.pas',
  u_LastSelectionLayerConfig in 'u_LastSelectionLayerConfig.pas',
  i_PolyLineLayerConfig in 'i_PolyLineLayerConfig.pas',
  u_PolyLineLayerConfig in 'u_PolyLineLayerConfig.pas',
  i_PolygonLayerConfig in 'i_PolygonLayerConfig.pas',
  u_PolygonLayerConfig in 'u_PolygonLayerConfig.pas',
  i_CalcLineLayerConfig in 'i_CalcLineLayerConfig.pas',
  u_CalcLineLayerConfig in 'u_CalcLineLayerConfig.pas',
  i_SelectionRectLayerConfig in 'i_SelectionRectLayerConfig.pas',
  u_SelectionRectLayerConfig in 'u_SelectionRectLayerConfig.pas',
  i_SelectionPolygonLayerConfig in 'i_SelectionPolygonLayerConfig.pas',
  u_SelectionPolygonLayerConfig in 'u_SelectionPolygonLayerConfig.pas',
  i_MarkPolygonLayerConfig in 'i_MarkPolygonLayerConfig.pas',
  u_MarkPolygonLayerConfig in 'u_MarkPolygonLayerConfig.pas',
  i_MarkPolyLineLayerConfig in 'i_MarkPolyLineLayerConfig.pas',
  u_MarkPolyLineLayerConfig in 'u_MarkPolyLineLayerConfig.pas',
  i_FillingMapLayerConfig in 'i_FillingMapLayerConfig.pas',
  u_FillingMapLayerConfigStatic in 'u_FillingMapLayerConfigStatic.pas',
  u_FillingMapLayerConfig in 'u_FillingMapLayerConfig.pas',
  u_FillingMapMapsConfig in 'u_FillingMapMapsConfig.pas',
  i_MapLayerGridsConfig in 'i_MapLayerGridsConfig.pas',
  u_BaseGridConfig in 'u_BaseGridConfig.pas',
  u_TileGridConfig in 'u_TileGridConfig.pas',
  u_GenShtabGridConfig in 'u_GenShtabGridConfig.pas',
  u_MapLayerGridsConfig in 'u_MapLayerGridsConfig.pas',
  i_MapLayerGPSMarkerConfig in 'i_MapLayerGPSMarkerConfig.pas',
  u_MapLayerGPSMarkerConfig in 'u_MapLayerGPSMarkerConfig.pas',
  i_BitmapPostProcessingConfig in 'i_BitmapPostProcessingConfig.pas',
  u_BitmapPostProcessingConfigStatic in 'u_BitmapPostProcessingConfigStatic.pas',
  u_BitmapPostProcessingConfig in 'u_BitmapPostProcessingConfig.pas',
  i_MainFormConfig in 'i_MainFormConfig.pas',
  u_MainFormMainConfig in 'u_MainFormMainConfig.pas',
  u_MainFormConfig in 'u_MainFormConfig.pas',
  u_MainFormLayersConfig in 'u_MainFormLayersConfig.pas',
  i_MapLayerNavToPointMarkerConfig in 'i_MapLayerNavToPointMarkerConfig.pas',
  u_MapLayerNavToPointMarkerConfig in 'u_MapLayerNavToPointMarkerConfig.pas',
  i_DownloadUIConfig in 'i_DownloadUIConfig.pas',
  u_DownloadUIConfig in 'u_DownloadUIConfig.pas',
  i_MainWindowPosition in 'i_MainWindowPosition.pas',
  u_MainWindowPositionConfig in 'u_MainWindowPositionConfig.pas',
  u_MainWindowToolbarsLock in 'u_MainWindowToolbarsLock.pas',
  i_LineOnMapEdit in 'i_LineOnMapEdit.pas',
  u_LineOnMapEdit in 'u_LineOnMapEdit.pas',
  i_GlobalViewMainConfig in 'i_GlobalViewMainConfig.pas',
  u_GlobalViewMainConfig in 'u_GlobalViewMainConfig.pas',
  i_GPSRecorder in 'i_GPSRecorder.pas',
  u_GPSRecorderStuped in 'u_GPSRecorderStuped.pas',
  i_GPS in 'i_GPS.pas',
  i_GPSModule in 'i_GPSModule.pas',
  i_GPSModuleByCOM in 'i_GPSModuleByCOM.pas',
  i_GPSModuleByCOMFactory in 'i_GPSModuleByCOMFactory.pas',
  i_GPSModuleByCOMPortSettings in 'i_GPSModuleByCOMPortSettings.pas',
  i_GPSModuleByCOMPortConfig in 'i_GPSModuleByCOMPortConfig.pas',
  u_GPSModuleByCOMPortConfig in 'u_GPSModuleByCOMPortConfig.pas',
  u_GPSModuleByCOMPortSettings in 'u_GPSModuleByCOMPortSettings.pas',
  i_SatellitesInViewMapDraw in 'i_SatellitesInViewMapDraw.pas',
  u_SatellitesInViewMapDrawSimple in 'u_SatellitesInViewMapDrawSimple.pas',
  i_GPSConfig in 'i_GPSConfig.pas',
  u_GPSConfig in 'u_GPSConfig.pas',
  u_GPSSatelliteInfo in 'u_GPSSatelliteInfo.pas',
  u_GPSSatellitesInView in 'u_GPSSatellitesInView.pas',
  u_GPSPositionStatic in 'u_GPSPositionStatic.pas',
  u_GPSModuleAbstract in 'u_GPSModuleAbstract.pas',
  u_GPSModuleByZylGPS in 'u_GPSModuleByZylGPS.pas',
  u_GPSModuleFactoryByZylGPS in 'u_GPSModuleFactoryByZylGPS.pas',
  i_TrackWriter in 'i_TrackWriter.pas',
  u_GPSLogWriterToPlt in 'u_GPSLogWriterToPlt.pas',
  u_ExportProviderAbstract in 'RegionProcess\u_ExportProviderAbstract.pas',
  fr_ExportYaMaps in 'RegionProcess\fr_ExportYaMaps.pas' {frExportYaMaps: TFrame},
  u_ExportProviderYaMaps in 'RegionProcess\u_ExportProviderYaMaps.pas',
  u_ExportProviderYaMapsNew in 'RegionProcess\u_ExportProviderYaMapsNew.pas',
  fr_ExportGEKml in 'RegionProcess\fr_ExportGEKml.pas' {frExportGEKml: TFrame},
  u_ExportProviderGEKml in 'RegionProcess\u_ExportProviderGEKml.pas',
  fr_ExportIPhone in 'RegionProcess\fr_ExportIPhone.pas' {frExportIPhone: TFrame},
  u_ExportProviderIPhone in 'RegionProcess\u_ExportProviderIPhone.pas',
  fr_ExportAUX in 'RegionProcess\fr_ExportAUX.pas' {frExportAUX: TFrame},
  u_ExportProviderAUX in 'RegionProcess\u_ExportProviderAUX.pas',
  fr_ExportToFileCont in 'RegionProcess\fr_ExportToFileCont.pas' {frExportToFileCont: TFrame},
  u_ExportProviderZip in 'RegionProcess\u_ExportProviderZip.pas',
  u_ExportProviderTar in 'RegionProcess\u_ExportProviderTar.pas',
  fr_TilesDelete in 'RegionProcess\fr_TilesDelete.pas' {frTilesDelete: TFrame},
  u_ProviderTilesDelete in 'RegionProcess\u_ProviderTilesDelete.pas',
  fr_TilesGenPrev in 'RegionProcess\fr_TilesGenPrev.pas' {frTilesGenPrev: TFrame},
  u_ProviderTilesGenPrev in 'RegionProcess\u_ProviderTilesGenPrev.pas',
  fr_TilesCopy in 'RegionProcess\fr_TilesCopy.pas' {frTilesCopy: TFrame},
  u_ProviderTilesCopy in 'RegionProcess\u_ProviderTilesCopy.pas',
  fr_MapCombine in 'RegionProcess\fr_MapCombine.pas' {frMapCombine: TFrame},
  u_ProviderMapCombine in 'RegionProcess\u_ProviderMapCombine.pas',
  fr_TilesDownload in 'RegionProcess\fr_TilesDownload.pas' {frTilesDownload: TFrame},
  u_ProviderTilesDownload in 'RegionProcess\u_ProviderTilesDownload.pas',
  fr_ShortCutList in 'fr_ShortCutList.pas' {frShortCutList: TFrame},
  fr_MarkDescription in 'fr_MarkDescription.pas' {frMarkDescription: TFrame},
  fr_LonLat in 'fr_LonLat.pas' {frLonLat: TFrame},
  frm_Main in 'frm_Main.pas' {frmMain},
  frm_GoTo in 'frm_GoTo.pas' {frmGoTo},
  frm_DebugInfo in 'frm_DebugInfo.pas' {frmDebugInfo},
  frm_About in 'frm_About.pas' {frmAbout},
  frm_Settings in 'frm_Settings.pas' {frmSettings},
  frm_RegionProcess in 'frm_RegionProcess.pas' {frmRegionProcess},
  frm_ProgressDownload in 'frm_ProgressDownload.pas' {frmProgressDownload},
  frm_SearchResults in 'frm_SearchResults.pas' {frmSearchResults},
  frm_InvisibleBrowser in 'frm_InvisibleBrowser.pas' {frmInvisibleBrowser},
  frm_MarkEditPoint in 'frm_MarkEditPoint.pas' {frmMarkEditPoint},
  frm_ProgressSimple in 'frm_ProgressSimple.pas' {frmProgressSimple},
  frm_StartLogo in 'frm_StartLogo.pas' {frmStartLogo},
  frm_LonLatRectEdit in 'frm_LonLatRectEdit.pas' {frmLonLatRectEdit},
  frm_IntrnalBrowser in 'frm_IntrnalBrowser.pas' {frmIntrnalBrowser},
  frm_MarkEditPath in 'frm_MarkEditPath.pas' {frmMarkEditPath},
  frm_MarkEditPoly in 'frm_MarkEditPoly.pas' {frmMarkEditPoly},
  frm_MapTypeEdit in 'frm_MapTypeEdit.pas' {frmMapTypeEdit},
  frm_MarksExplorer in 'frm_MarksExplorer.pas' {frmMarksExplorer},
  frm_ImportConfigEdit in 'frm_ImportConfigEdit.pas' {frmImportConfigEdit},
  frm_MarkCategoryEdit in 'frm_MarkCategoryEdit.pas' {frmMarkCategoryEdit},
  frm_DGAvailablePic in 'frm_DGAvailablePic.pas' {frmDGAvailablePic},
  frm_ShortCutEdit in 'frm_ShortCutEdit.pas' {frmShortCutEdit};

{$R *.res} {$R *Pics.res}
begin 
  GState := TGlobalState.Create;
  try
    Application.Initialize;
    Application.Title := SAS_STR_ApplicationTitle;
    //logo
    if GState.Show_logo then begin
      TfrmStartLogo.ShowLogo;
    end;
    try
      GState.LoadConfig;
    except
      on E: Exception do begin
        Application.ShowException(E);
        Exit;
      end;
    end;
    //xLogo
    Application.HelpFile := '';
    Application.CreateForm(TfrmMain, frmMain);
    Application.CreateForm(TfrmGoTo, frmGoTo);
    Application.CreateForm(TfrmAbout, frmAbout);
    Application.CreateForm(TfrmSettings, frmSettings);
    Application.CreateForm(TfrmRegionProcess, frmRegionProcess);
    Application.CreateForm(TfrmMarksExplorer, frmMarksExplorer);
    Application.CreateForm(TfrmImportConfigEdit, frmImportConfigEdit);
    Application.CreateForm(TfrmMarkCategoryEdit, frmMarkCategoryEdit);
    Application.CreateForm(TfrmDGAvailablePic, frmDGAvailablePic);
    Application.CreateForm(TfrmMarkEditPoint, frmMarkEditPoint);
    Application.CreateForm(TfrmIntrnalBrowser, frmIntrnalBrowser);
    Application.CreateForm(TfrmMarkEditPath, frmMarkEditPath);
    Application.CreateForm(TfrmMarkEditPoly, frmMarkEditPoly);
    Application.CreateForm(TfrmMapTypeEdit, frmMapTypeEdit);
    Application.CreateForm(TfrmShortCutEdit, frmShortCutEdit);
    Application.CreateForm(TfrmInvisibleBrowser, frmInvisibleBrowser);
    if GState.ShowDebugInfo then begin
      frmDebugInfo := TfrmDebugInfo.Create(Application, GState.PerfCounterList);
    end;
    GState.StartExceptionTracking;
    try
      frmInvisibleBrowser.NavigateAndWait('about:blank');
      frmIntrnalBrowser.Navigate('about:blank');
      Application.Run;
    finally
      GState.StopExceptionTracking;
    end;
  finally
    GState.Free;
  end;
end.
