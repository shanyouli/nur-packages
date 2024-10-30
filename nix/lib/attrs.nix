{lib, ...}:
with builtins;
with lib; rec {
  # attrsToList: attrs -> set
  # eg: {a = 1, b = 2; } ==> [{name = a; value = 1;} {name = b; value = 2;}]
  attrsToList = attrs:
    mapAttrsToList (name: value: {inherit name value;}) attrs;

  # mapFilterAttrs' ::
  #     (name -> value -> bool)
  #     (name -> value -> {name = any; value = any;})
  #     attrs
  #     -> attrs
  mapFilterAttrs' = pred: f: attrs: (mapAttrs' f (filterAttrs pred attrs));

  # mergeAttrs' :: listOf attrs -> attrs
  # will deeply merge attrsets (left -> attrs)
  # eg: [{a = 1; b = 2;} {b = 3; c = 4;}] -> {a = 1; b = 3; c = 4;}
  mergeAttrs' = attrList: let
    f = attrPath:
      zipAttrsWith (n: values:
        if (tail values) == []
        then head values
        else if all isList values
        then unique (concatLists values)
        else if all isAttrs values
        then f (attrPath ++ [n]) values
        else last values);
  in
    f [] attrList;
}
