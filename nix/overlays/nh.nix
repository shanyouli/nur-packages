{ withSystem, ... }:
{
  flake.overlays.nh =
    _final: prev:
    withSystem.prev.stdenv.hostPlatform.system (
      { config, ... }:
      {
        inherit (config.packages) nh;
      }
    );
  perSystem =
    { inputs', ... }:
    {
      packages.nh = inputs'.nh-olverlay.packages.default;
    };
}
