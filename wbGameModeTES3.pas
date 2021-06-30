unit wbGameModeTES3;

interface

uses
  IOUtils,
  StrUtils,
  wbGameMode;

type
  TwbGameModeTES3 = class(TwbGameMode)
    public
      function GetAppName(): string;          override;
      function GetGameName(): string;         override;
      function GetGamePath(): string;         override;
      function GetDataFolderName(): string;   override;
      function GetDataPath(): string;         override;
      function GetAppDataPath(): string;      override;
      function GetMyGamesPath(): string;      override;
  end;

implementation
// -----------------------------------------------------------------------------
// Morrowind
// -----------------------------------------------------------------------------
  function TwbGameModeTES3.GetAppName;
  begin
    Result := 'TES3Edit';
  end;

  function TwbGameModeTES3.GetGameName;
  begin
    Result := 'Morrowind';
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
end.
