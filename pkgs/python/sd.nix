{
  lib,
  python3,
  installShellFiles,
  source,
  stdenv,
  darwin,
}: let
  inherit (python3.pkgs) typer buildPythonApplication hatchling wcwidth; # rich 丰富色彩
in
  buildPythonApplication rec {
    version =
      if (builtins.hasAttr "date" source)
      then source.date
      else lib.removePrefix "v" source.version;
    inherit (source) pname src;
    pyproject = true;
    nativeBuildInputs = [hatchling installShellFiles] ++ lib.optional stdenv.isDarwin [darwin.ps];
    propagatedBuildInputs = [typer wcwidth];
    postInstall = ''
      installShellCompletion --cmd sd \
        --bash <($out/bin/sd completion show bash) \
        --zsh <($out/bin/sd completion show zsh) \
        --fish <($out/bin/sd completion show fish)
    '';
    meta = with lib; {
      description = "My system command line";
      platforms = platforms.all;
      license = licenses.mit;
    };
  }
