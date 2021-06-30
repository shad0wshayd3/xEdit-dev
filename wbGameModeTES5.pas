unit wbGameModeTES5;

interface

uses
  IOUtils,
  wbGameMode;

type
  TwbGameModeSSE = class(TwbGameMode)
    public
      function GetAppName(): string;          override;
      function GetGameName(): string;         override;
      function GetGamePath(): string;         override;
      function GetDataFolderName(): string;   override;
      function GetDataPath(): string;         override;
      function GetAppDataPath(): string;      override;
      function GetMyGamesPath(): string;      override;
  end;

  TwbGameModeEnderalSE = class(TwbGameModeSSE)
    public
      function GetAppName(): string;          override;
      function GetGameName(): string;         override;
      function GetGamePath(): string;         override;
  end;

implementation
// -----------------------------------------------------------------------------
// SkyrimSE
// -----------------------------------------------------------------------------
  function TwbGameModeSSE.GetAppName;
  begin
    Result := 'SSEEdit';
  end;

  function TwbGameModeSSE.GetGameName;
  begin
    Result := 'Skyrim Special Edition';
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
      IsMicrosoftStore := True;
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

  function TwbGameModeSSE.GetAppDataPath;
  var
    path: string;
  begin
    Result := '';
    if (AppDataPath <> '') then exit(AppDataPath);

    path := GetLocalAppDataPath;
    if (path <> '') then
      if IsMicrosoftStore then
        AppDataPath := TPath.Combine(path, 'Skyrim Special Edition MS')
      else
        AppDataPath := TPath.Combine(path, GetGameName);
    Result := AppDataPath;
  end;

  function TwbGameModeSSE.GetMyGamesPath;
  var
    path: string;
  begin
    Result := '';
    if (MyGamesPath <> '') then exit(MyGamesPath);

    path := GetMyDocumentsPath;
    if (path <> '') then
      if IsMicrosoftStore then
        MyGamesPath := TPath.Combine(path, 'My Games\Skyrim Special Edition MS')
      else
        MyGamesPath := TPath.Combine(path, 'My Games\' + GetGameName);
    Result := MyGamesPath;
  end;

// -----------------------------------------------------------------------------
// EnderalSE
// -----------------------------------------------------------------------------
  function TwbGameModeEnderalSE.GetAppName;
  begin
    Result := 'EnderalSEEdit';
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
end.
