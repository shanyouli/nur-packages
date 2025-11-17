{
  luaPackages,
  fetchurl,
  fetchFromGitLab,
  fetchFromGitHub,
}:
let
  inherit (luaPackages) luaOlder luasocket buildLuarocksPackage;
in
buildLuarocksPackage {
  pname = "jeejah";
  version = "0.3.2-1";
  knownRockspec =
    (fetchurl {
      url = "https://loadk.com/luarocks/jeejah-0.3.2-1.rockspec";
      sha256 = "1ybczwqgcdyxhgbzqx2c4hiylmqvdz4a22h3qd3bnf65c6xgxs1s";
    }).outPath;
  src = fetchFromGitLab {
    owner = "technomancy";
    repo = "jeejah";
    rev = "0.3.2";
    hash = "sha256-HdZ+IwituwCxu5CoqbwDrEV4hT1Qdd0H5kafcno0/wQ=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs =
    if (luaOlder "5.4") then
      [ luasocket ]
    else
      [
        (luasocket.overrideAttrs (oa: {
          version = "3.0rc1-2";
          knownRockspec =
            (fetchurl {
              url = "mirror://luarocks/luasocket-3.0rc1-2.rockspec";
              sha256 = "sha256-TBAn6ApX0vXIo1TEC1dx9wwJn23o98d52dd/cmGcy50=";
            }).outPath;
          src = fetchFromGitHub {
            owner = "lunarmodules";
            repo = "luasocket";
            rev = "v3.0-rc1";
            hash = "sha256-s+sPg/PEI8VckxcmE/gb6bjF4wfm59PJZHTEoc4/GrI=";
          };
        }))
      ];

  meta = {
    homepage = "https://gitlab.com/technomancy/jeejah";
    description = "An nREPL server";
    license.fullName = "MIT/X11";
  };
}
