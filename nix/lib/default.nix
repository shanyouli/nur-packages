{inputs, ...}: let
  inherit (builtins) functionArgs intersectAttrs attrNames attrValues;
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldr foldl makeExtensible nameValuePair sort mapAttrsToList;

  # map files;
  inherit (attrs) mergeAttrs';
  inherit (modules) mapModules;
  attrs = import ./attrs.nix {inherit lib;};
  modules = import ./modules.nix {inherit lib;};

  /*
    Given an attrset of nix module partials, returns it as a sorted list of
  NameValuePairs according to its callPackage-style dependencies from the
  rest of the list.

  sortLibsByDeps :: AttrSet -> [ AttrSet ... ]

  Example:
    sortLibsByDeps { libA = { libB, ... }: {}; libB = { ... }: { [...] }; }
    => [ { libB = {...}: [...]; } { libA = { libB, ...}: [...]; } ]
  */
  sortLibsByDeps = modules: let
    modulesArgs = mapAttrsToList (n: v: nameValuePair n (attrNames (builtins.functionArgs v))) modules;
    sortFn = x: y:
      if builtins.elem x.name y.value
      then true
      else if builtins.elem y.name x.value
      then false
      else (builtins.length x.value) < (builtins.length y.value);
    sortResult = sort sortFn modulesArgs;
  in
    map (n: nameValuePair n.name modules."${n.name}") sortResult;

  libConcat = a: b:
    a
    // {
      ${b.name} = b.value (intersectAttrs (functionArgs b.value) a);
    };
in {
  flake = {
    lib = let
      libModules = sortLibsByDeps (mapModules ./. (_: v: (import v)));
      libs =
        foldl libConcat {
          inherit lib inputs;
          self = libs;
        }
        libModules;
    in
      libs // (mergeAttrs' (attrValues libs));
    my = let
      libs = makeExtensible (self: mapModules ./. (_: file: import file {inherit lib inputs self;}));
    in
      libs.extend (_self: prev: foldr (a: b: a // b) {} (attrValues prev));
  };
}
