{lib, ...}: let
  inherit (builtins) attrValues readDir pathExists concatLists mapAttrs;
  inherit (lib) mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix mapAttrs' pathIsDirectory;
  mapFilterAttrs' = f: pred: attrs: (filterAttrs pred (mapAttrs' f attrs));
  isNixFile = n: v: v == "regular" && n != "default.nix" && (hasSuffix ".nix" n) && !(hasPrefix "_" n);
in rec {
  # fileFn :: 将文件作为一个参数调用该 fn 函数
  fileFn = fn: f: let
    fpath = toString f;
  in
    if pathIsDirectory fpath
    then fn (fpath + "/default.nix")
    else if pathExists (fpath + ".nix")
    then fn (fpath + ".nix")
    else throw "unknown path ${f}";

  # moduleFiles :: 获取当前目录下所有的 nix 路径，
  moduleFiles = dir:
    mapFilterAttrs'
    (n: v: let
      path = "${toString dir}/${n}";
    in
      if v == "directory" && pathExists "${path}/default.nix"
      then nameValuePair n "${path}/default.nix"
      else if (isNixFile n v)
      then nameValuePair (removeSuffix ".nix" n) path
      else nameValuePair "" null)
    (n: v: v != null && !(hasPrefix "_" n))
    (readDir dir);

  # moduleFilesRec :: 递归获取当前目录包含子目录的所有 nix 路径，但如果子目录包含 default.nix 文件
  #   则不获取该目录下的其他文件
  #   str -> list
  moduleFilesRec = dir: let
    dirs = let
      p = toString dir;
    in
      mapAttrsToList (k: _: "${p}/${k}") (filterAttrs
        (n: v: v == "directory" && !(hasPrefix "_" n) && !(pathExists "${p}/${n}/default.nix"))
        (readDir p));
    files = attrValues (moduleFiles dir);
  in
    files ++ concatLists (map (d: (moduleFilesRec d)) dirs);

  # moduleFilesRec' :: 递归获取当前目录包含子目录的所有 nix 文件
  # str -> list
  moduleFilesRec' = dir: let
    dirs = let
      p = toString dir;
    in
      mapAttrsToList (k: _: "${p}/${k}") (filterAttrs
        (n: v: v == "directory" && !(hasPrefix "_" n))
        (readDir p));
    files = attrValues (moduleFiles dir);
  in
    files ++ concatLists (map (d: (moduleFilesRec' d)) dirs);

  # mapModules :: 对获取的 nix attrs 执行函数，不能修改 k 值，仅可以修改 v 值
  # dir -> attr -> attr (name 不变， value 可以变化)
  mapModules = dir: fn: mapAttrs fn (moduleFiles dir);
  mapModules' = dir: fn: mapAttrs' fn (moduleFiles dir);

  # mapModulesRec' :: 对获取的所有 nix 路径，执行 函数
  # dirs -> attr -> list -> fn element
  mapModulesRec = dir: fn: map fn (moduleFilesRec dir);
  mapModulesRec' = dir: fn: map fn (moduleFilesRec' dir);
}
