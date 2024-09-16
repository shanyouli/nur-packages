{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  darwin,
  nvd,
  nix-output-monitor,
  source,
}: let
  version = "3.5.15";
  runtimeDeps = [nvd nix-output-monitor];
in
  rustPlatform.buildRustPackage {
    inherit (source) src pname;
    version =
      if (builtins.hasAttr "date" source)
      then source.date
      else lib.removePrefix "v" source.version;
    cargoLock = source.cargoLock."Cargo.lock";

    strictDeps = true;

    nativeBuildInputs = [
      installShellFiles
      makeBinaryWrapper
    ];

    buildInputs = lib.optionals stdenv.isDarwin [darwin.apple_sdk.frameworks.SystemConfiguration];
    postInstall =
      ''
        mv $out/bin/nh_darwin $out/bin/nh
        wrapProgram $out/bin/nh --prefix PATH : ${lib.makeBinPath runtimeDeps}
      ''
      + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        installShellCompletion --cmd nh \
          --bash <("$out/bin/nh" completions --shell bash) \
          --zsh <("$out/bin/nh" completions --shell zsh) \
          --fish <("$out/bin/nh" completions --shell fish)
      '';
    meta = {
      description = "Yet another nix cli helper";
      homepage = "https://github.com/viperML/nh";
      license = lib.licenses.eupl12;
      mainProgram = "nh";
      # maintainers = with lib.maintainers; [ drupol viperML ];
    };
  }
