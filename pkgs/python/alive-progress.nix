{
  lib,
  source,
  buildPythonPackage,
  about-time,
  graphemeu,
  ...
}:
buildPythonPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;

  propagatedBuildInputs = [
    graphemeu
    about-time
  ];
  format = "setuptools";
  doCheck = false;
}
