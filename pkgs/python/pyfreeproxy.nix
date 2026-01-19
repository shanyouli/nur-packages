{
  lib,
  source,
  buildPythonPackage,
  requests,
  beautifulsoup4,
  fake-useragent,
  prettytable,
  lxml,
  platformdirs,
  playwright,
  ...
}:
buildPythonPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  propagatedBuildInputs = [

    requests
    beautifulsoup4
    fake-useragent
    prettytable
    lxml
    platformdirs
    playwright
  ];
  doCheck = false;
  format = "setuptools";
  meta = with lib; {
    description = "FreeProxy: Collecting free proxies from internet";
    homepage = "https://github.com/CharlesPikachu/freeproxy";
    platforms = platforms.unix;
    maintainers = with maintainers; [ lye ];
    license = licenses.asl20;
  };
}
