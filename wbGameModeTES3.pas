unit wbGameModeTES3;

interface

uses
  IOUtils,
  StrUtils,
  wbGameMode;

type
  TwbGameModeTES3 = class(TwbGameMode)
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

implementation
// -----------------------------------------------------------------------------
// Morrowind
// -----------------------------------------------------------------------------
  function TwbGameModeTES3.GetToolName;
  begin
    Result := 'TES3';
  end;

  function TwbGameModeTES3.GetGameName;
  begin
    Result := 'Morrowind';
  end;

  function TwbGameModeTES3.GetGameType;
  begin
    Result := gmTES3;
  end;

  function TwbGameModeTES3.GetGamePath;
  begin
    Result := '';
    if (GamePath <> '') then exit(GamePath);

    GamePath := GetRegValue(
      '\SOFTWARE\Bethesda Softworks\Morrowind',
      'Installed Path');
    if (GamePath <> '') then exit(GamePath);

    GamePath := GetMSStorePath(
      'BethesdaSoftworks.TESMorrowind-PC_3275kfvn8vcwc');
    if (GamePath <> '') then begin
      case IndexStr(Copy(GetMSStoreLanguage, 1, 2), ['de', 'fr']) of
        0: GamePath := TPath.Combine(GamePath, 'Morrowind GOTY German');
        1: GamePath := TPath.Combine(GamePath, 'Morrowind GOTY French');
      else GamePath := TPath.Combine(GamePath, 'Morrowind GOTY English');
      end;
      IsMSStore := True;
      Result := GamePath;
    end;
  end;

  function TwbGameModeTES3.GetDataFolderName;
  begin
    Result := 'Data Files';
  end;

  function TwbGameModeTES3.GetDataPath;
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

  function TwbGameModeTES3.GetMasterName;
  begin
    Result := 'Morrowind.esm';
  end;

  function TwbGameModeTES3.GetExecutableName;
  begin
    Result := 'Morrowind';
  end;

  function TwbGameModeTES3.GetAppDataPath;
  var
    path: string;
  begin
    Result := '';
    if (AppDataPath <> '') then exit(AppDataPath);

    path := GetLocalAppDataPath;
    if (path <> '') then
      AppDataPath := TPath.Combine(path, GetGameName);
    Result := AppDataPath;
  end;

  function TwbGameModeTES3.GetPluginsPath;
  var
    path: string;
  begin
    Result := '';
    if (PluginsFilePath <> '') then exit(PluginsFilePath);

    path := GetGamePath;
    if (path <> '') then
      PluginsFilePath := TPath.Combine(path, 'Morrowind.ini');
    Result := PluginsFilePath;
  end;

  function TwbGameModeTES3.GetMyGamesPath;
  var
    path: string;
  begin
    Result := '';
    if (MyGamesPath <> '') then exit(MyGamesPath);

    path := GetGamePath;
    if (path <> '') then
      MyGamesPath := path;
    Result := MyGamesPath;
  end;

  function TwbGameModeTES3.GetIniFiles;
  begin
    Result := ['Morrowind.ini'];
  end;

  function TwbGameModeTES3.GetIniSetting;
  begin
    Result := TryGetIniSetting(a_section, a_ident, a_default);
  end;
end.
