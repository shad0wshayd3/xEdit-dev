unit wbGameModeTES5;

interface

uses
  IOUtils,
  wbGameMode;

type
  TwbGameModeSSE = class(TwbGameMode)
    public
      function GetToolName(): string;                                                 override;
      function GetGameName(): string;                                                 override;
      function GetGameType(): TwbGameType;                                            override;
      function GetGamePath(): string;                                                 override;
      function GetDataFolderName(): string;                                           override;
      function GetDataPath(): string;                                                 override;
      function GetMasterName(): string;                                               override;
      function GetExecutableName(): string;                                           override;
      function GetAppDataPath(): string;                                              override;
      function GetPluginsPath(): string;                                              override;
      function GetMyGamesPath(): string;                                              override;
      function GetIniFiles(): TStringArray;                                           override;
      function GetIniSetting(const a_section, a_ident, a_default: string): string;    override;
  end;

  TwbGameModeSSEVR = class(TwbGameModeSSE)
    public
      function GetToolName(): string;         override;
      function GetGameName(): string;         override;
      function GetGameType(): TwbGameType;    override;
  end;

  TwbGameModeEnderalSE = class(TwbGameModeSSE)
    public
      function GetToolName(): string;         override;
      function GetGameName(): string;         override;
      function GetGamePath(): string;         override;
      function GetIniFiles(): TStringArray;   override;
  end;

implementation
// -----------------------------------------------------------------------------
// SkyrimSE
// -----------------------------------------------------------------------------
  function TwbGameModeSSE.GetToolName;
  begin
    Result := 'SSE';
  end;

  function TwbGameModeSSE.GetGameName;
  begin
    Result := 'Skyrim Special Edition';
  end;

  function TwbGameModeSSE.GetGameType;
  begin
    Result := gmSSE;
  end;

  function TwbGameModeSSE.GetGamePath;
  begin
    Result := '';
    if (GamePath <> '') then exit(GamePath);

    GamePath := GetRegValue(
      '\SOFTWARE\Bethesda Softworks\Skyrim Special Edition',
      'Installed Path');
    if (GamePath <> '') then exit(GamePath);

    GamePath := GetMSStorePath(
      'BethesdaSoftworks.SkyrimSE-PC_3275kfvn8vcwc');
    if (GamePath <> '') then begin
      IsMSStore := True;
      Result := GamePath;
    end;
  end;

  function TwbGameModeSSE.GetDataFolderName;
  begin
    Result := 'Data';
  end;

  function TwbGameModeSSE.GetDataPath;
  var
    path: string;
  begin
    Result := '';
    if (DataPath <> '') then exit(DataPath);

    path := GetGamePath;
    if (path <> '') then
      DataPath := TPath.Combine(path, GetDataFolderName);
    Result := DataPath;
  end;

  function TwbGameModeSSE.GetMasterName;
  begin
    Result := 'Skyrim.esm';
  end;

  function TwbGameModeSSE.GetExecutableName;
  begin
    Result := 'SkyrimSE';
  end;

  function TwbGameModeSSE.GetAppDataPath;
  var
    path: string;
  begin
    Result := '';
    if (AppDataPath <> '') then exit(AppDataPath);

    path := GetLocalAppDataPath;
    if (path <> '') then
      if IsMSStore then
        AppDataPath := TPath.Combine(path, 'Skyrim Special Edition MS')
      else
        AppDataPath := TPath.Combine(path, GetGameName);
    Result := AppDataPath;
  end;

  function TwbGameModeSSE.GetPluginsPath;
  var
    path: string;
  begin
    Result := '';
    if (PluginsFilePath <> '') then exit(PluginsFilePath);

    path := GetAppDataPath;
    if (path <> '') then
      PluginsFilePath := TPath.Combine(path, 'Plugins.txt');
    Result := PluginsFilePath;
  end;

  function TwbGameModeSSE.GetMyGamesPath;
  var
    path: string;
  begin
    Result := '';
    if (MyGamesPath <> '') then exit(MyGamesPath);

    path := GetMyDocumentsPath;
    if (path <> '') then
      if IsMSStore then
        MyGamesPath := TPath.Combine(path, 'My Games\Skyrim Special Edition MS')
      else
        MyGamesPath := TPath.Combine(path, 'My Games\' + GetGameName);
    Result := MyGamesPath;
  end;

  function TwbGameModeSSE.GetIniFiles;
  begin
    Result := ['SkyrimCustom.ini', 'Skyrim.ini'];
  end;

  function TwbGameModeSSE.GetIniSetting;
  begin
    Result := TryGetIniSetting(a_section, a_ident, a_default);
  end;

// -----------------------------------------------------------------------------
// SSEVR
// -----------------------------------------------------------------------------
  function TwbGameModeSSEVR.GetToolName;
  begin
    Result := 'SSEVR';
  end;

  function TwbGameModeSSEVR.GetGameName;
  begin
    Result := 'Skyrim VR';
  end;

  function TwbGameModeSSEVR.GetGameType;
  begin
    Result := gmSSEVR;
  end;

// -----------------------------------------------------------------------------
// EnderalSE
// -----------------------------------------------------------------------------
  function TwbGameModeEnderalSE.GetToolName;
  begin
    Result := 'EnderalSE';
  end;

  function TwbGameModeEnderalSE.GetGameName;
  begin
    Result := 'Enderal Special Edition';
  end;

  function TwbGameModeEnderalSE.GetGamePath;
  begin
    Result := '';
    if (GamePath <> '') then exit(GamePath);

    GamePath := GetRegValue(
      '\SOFTWARE\SureAI\Enderal SE',
      'Installed Path');
    if (GamePath <> '') then exit(GamePath);
  end;

  function TwbGameModeEnderalSE.GetIniFiles;
  begin
    Result := ['Enderal.ini'];
  end;
end.
