{
  rustPlatform,
  source,
  lib,
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."./src-tauri/Cargo.lock";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";
  # The upstream repository owns the Rust test suite. The flake package is
  # intended to build and install the CLI on NixOS without depending on
  # host-specific assistant CLIs or live config fixtures during checkPhase.
  doCheck = false;

  meta = with lib; {
    description = "CLI manager for Claude Code, Codex, Gemini, OpenCode, and OpenClaw";
    homepage = "https://github.com/saladday/cc-switch-cli";
    license = licenses.mit;
    mainProgram = "cc-switch";
    platforms = platforms.unix;
  };
}
