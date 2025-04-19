let
  flakeDir = ../.;
  flake = builtins.getFlake "${flakeDir}";
in
flake
