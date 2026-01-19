{
  lib,
  stdenv,
  source,
  lua,
  fennel,
  pandoc,
}:
stdenv.mkDerivation rec {
  inherit (source) pname src;
  version = if (source ? date) then source.date else lib.removePrefix "v" source.version;
  makeFlags = [
    "PREFIX=$(out)"
    "LUA=${lua}/bin/lua"
  ];
  nativeBuildInputs = [
    lua
    fennel
    pandoc
  ];
  meta = with lib; {
    description = "Turn Lua code into Fennel code";
    homepage = "https://git.sr.ht/~technomancy/antifennel";
    license = licenses.mit; # FIXME: nix-init did not found a license
    mainProgram = "antifennel";
    platforms = platforms.all;
  };
}
