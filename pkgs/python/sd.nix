{
  lib,
  python3,
  installShellFiles,
  source,
  stdenv,
  coreutils,
}: let
  inherit (python3.pkgs) typer colorama rich buildPythonApplication poetry-core wcwidth; # rich 丰富色彩
in
  buildPythonApplication rec {
    version =
      if (builtins.hasAttr "date" source)
      then source.date
      else lib.removePrefix "v" source.version;
    inherit (source) pname src;
    pyproject = true;
    # nativeBuildInputs = [poetry-core installShellFiles coreutils procps];
    nativeBuildInputs = [poetry-core installShellFiles];
    propagatedBuildInputs = [typer colorama rich wcwidth];
    postPatch = ''
      substituteInPlace sd/utils/cmd.py \
        --replace "/usr/bin/env" "${coreutils}/bin/env"
    '';
    postInstall = lib.optionalString stdenv.isLinux ''
      installShellCompletion --cmd sd \
        --bash <($out/bin/sd --show-completion bash) \
        --zsh <($out/bin/sd --show-completion zsh) \
        --fish <($out/bin/sd --show-completion fish)
    '';
    meta = with lib; {
      description = "My system command line";
      platforms = platforms.all;
      license = licenses.mit;
    };
  }
