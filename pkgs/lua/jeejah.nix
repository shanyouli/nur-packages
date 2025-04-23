{
  source,
  luaPackages,
  fetchurl,
  fetchFromGitHub,
  sources,
}:
let
  inherit (luaPackages) luaOlder luasocket buildLuarocksPackage;
in
buildLuarocksPackage rec {
  inherit (source) pname src version;
  knownRockspec = sources.jeejah-rock.src.outPath;
  disabled = luaOlder "5.1";
  propagatedBuildInputs = [
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
