# pkgs.lib 我的扩展
{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    my =
      lib.makeExtensible (_: (self.my.mapModules ./. (_v: f: pkgs.callPackage f {})
        // (self.my.mapModules ./build-support (_: f: pkgs.callPackage f {}))));
    mylib = self.my // (my.extend (_final: prev: lib.foldr (a: b: a // b) {} (lib.attrValues prev)));
  in {
    _module.args.my = mylib;
  };
}
