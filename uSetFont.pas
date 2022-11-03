unit uSetFont;

interface
uses FMX.Graphics;

type
  TMyDefFontFMX = class(TInterfacedObject, IFMXSystemFontService)
  public
    function GetDefaultFontFamilyName: string;
    function GetDefaultFontSize: Single;
  end;

implementation
uses FMX.DialogService, FMX.Platform;

function TMyDefFontFMX.GetDefaultFontFamilyName: string;
begin
  Result := {'MS Sans Serif'{}'Microsoft Sans Serif'{'Tahoma'{}{'MS Reference Sans Serif'{};
  //Result := 'Segoe UI';
  //Result := 'Microsoft Sans Serif'
end;
function TMyDefFontFMX.GetDefaultFontSize: Single;
begin
  Result := 11.75;
end;

initialization
  if TPlatformServices.Current.SupportsPlatformService(IFMXSystemFontService) then
    TPlatformServices.Current.RemovePlatformService(IFMXSystemFontService);
  TPlatformServices.Current.AddPlatformService(IFMXSystemFontService, TMyDefFontFMX.Create);

end.
