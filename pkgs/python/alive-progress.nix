{
  lib,
  source,
  buildPythonPackage,
  grapheme,
  about-time,
  ...
}:
buildPythonPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;

  propagatedBuildInputs = [
    grapheme
    about-time
  ];
  format = "setuptools";
  doCheck = false;
}
