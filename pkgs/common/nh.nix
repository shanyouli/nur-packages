{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  apple-sdk_13,
  nvd,
  nix-output-monitor,
  source,
}: let
  version = "3.5.15";
  runtimeDeps = [nvd nix-output-monitor];
in
  rustPlatform.buildRustPackage {
    inherit (source) src pname version;
    cargoLock = source.cargoLock."Cargo.lock";

    strictDeps = true;

    nativeBuildInputs = [installShellFiles makeBinaryWrapper];

    buildInputs = lib.optionals stdenv.isDarwin [apple-sdk_13];
    postInstall =
      ''
        wrapProgram $out/bin/nh --prefix PATH : ${lib.makeBinPath runtimeDeps}
      ''
      + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        installShellCompletion --cmd nh \
          --bash <("$out/bin/nh" completions bash) \
          --zsh <("$out/bin/nh" completions  zsh) \
          --fish <("$out/bin/nh" completions fish)
      '';
    meta = {
      description = "Yet another nix cli helper";
      homepage = "https://github.com/viperML/nh";
      license = lib.licenses.eupl12;
      mainProgram = "nh";
      # maintainers = with lib.maintainers; [ drupol viperML ];
    };
  }
