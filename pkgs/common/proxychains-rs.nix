{
  lib,
  rustPlatform,
  # pkg-config,
  # openssl,
  # stdenv,
  source,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src;
  version =
    if (builtins.hasAttr "date" source) then source.date else lib.removePrefix "v" source.version;
  cargoBuildFlags = [ "--workspace" ];
  cargoHash = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
  # nativeBuildInputs = [
  #   pkg-config
  #   rustPlatform.bindgenHook
  # ];

  # buildInputs = [
  #   openssl
  # ]
  # ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ];
  doCheck = false;
  # env = {
  #   OPENSSL_NO_VENDOR = true;
  # };
  meta = with lib; {
    description = "Proxychains-rs";
    homepage = "https://github.com/tianrking/proxychains-rs";
    mainProgram = "proxychinas4";
  };
}
