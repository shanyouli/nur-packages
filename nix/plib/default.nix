# pkgs.lib 我的扩展
{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    my = lib.makeExtensible (_: self.my.mapModules ./. (f: pkgs.callPackage f {}));
    mylib = self.my // (my.extend (_final: prev: lib.foldr (a: b: a // b) {} (lib.attrValues prev)));
  in {
    _module.args.my = mylib;
  };
}
