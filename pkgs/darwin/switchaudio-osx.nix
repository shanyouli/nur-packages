{
  lib,
  stdenv,
  xcodebuild,
  darwin,
  source,
}:
stdenv.mkDerivation rec {
  inherit (source) pname version src;
  nativeBuildInputs = [
    xcodebuild
    darwin.apple_sdk_12_3.frameworks.CoreServices
    darwin.apple_sdk_12_3.frameworks.CoreAudio
  ];
  # see @https://github.com/NixOS/nixpkgs/pull/285603
  # postPatch = ''
  #   substituteInPlace audio_switch.c --replace-fail kAudioObjectPropertyElementMain kAudioObjectPropertyElementMaster
  # '';
  installPhase = ''
    _dir=$(find . -type d -iname 'build' -maxdepth 2 | head -n 1)
    echo $_dir
    if [[ -n $_dir ]] ; then
      cd $_dir
      # ls -al
      # find . -type d
      # find .
      install -D -m755 -t $out/bin Products/Release/SwitchAudioSource
    else
      echo "ERROR Compilation Failure"
    fi
  '';
  meta = with lib; {
    description = "Change the audio source for Mac OS X from the command line";
    homepage = "https://github.com/deweller/switchaudio-osx";
    license = licenses.mit;
    mainProgram = "switchaudio-osx";
    platforms = platforms.darwin;
    broken = true;
  };
}
