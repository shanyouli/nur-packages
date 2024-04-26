with builtins; let
  flake = builtins.getFlake (toString ../.);
  isBuildable = p: !(p.meta.broken or false) && p.meta.license.free or true;

  nameValuePair = n: v: {
    name = n;
    value = v;
  };

  nurAttrs = flake.packages;
  fn = pkgs: system:
    listToAttrs (map (n:
      nameValuePair n {
        pname = pkgs."${system}".${n}.pname or n;
        version = pkgs."${system}".${n}.version or null;
        description = pkgs."${system}".${n}.meta.description or null;
        url = pkgs."${system}".${n}.meta.homepage or null;
        broken = ! isBuildable pkgs."${system}".${n};
      })
    (attrNames pkgs."${system}"));
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
  result = listToAttrs (map (s: nameValuePair s (fn nurAttrs s)) systems);
in
  result
# in   toJSON result

