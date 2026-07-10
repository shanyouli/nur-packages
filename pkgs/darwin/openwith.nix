{
  lib,
  rustPlatform,
  installShellFiles,
  source,
  apple-sdk,
  ...
}:
rustPlatform.buildRustPackage rec {
  inherit (source) pname src version;
  cargoLock = source.cargoLock."Cargo.lock";
  doCheck = false;

  # v0.5.0 引入 GUI（Tauri，crates/openwith-gui）后仓库变成 Cargo 工作区。
  # 这里只需 CLI，对应 `cargo install --path crates/openwith-cli`：只构建
  # openwith-cli 及其依赖闭包（openwith-core），跳过 GUI 成员及其前端构建链。
  buildAndTestSubdir = "crates/openwith-cli";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ apple-sdk ];

  postInstall = ''
    installShellCompletion --cmd openwith \
      --bash <($out/bin/openwith completions bash) \
      --fish <($out/bin/openwith completions fish) \
      --zsh  <($out/bin/openwith completions zsh )
  '';
  meta = with lib; {
    description = "Manage macOS file extension associations from the terminal ";
    homepage = "https://github.com/ColeMei/openwith";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "openwith";
  };
}
