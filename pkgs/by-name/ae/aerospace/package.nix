{ stdenv, fetchzip, lib, callPackage }:

let
  pname = "aerospace";
  # Version must be a literal string as package has a capital letter in it
  # whilst nixpkgs forbids capitals in version names
  ghReleaseVersion = "0.9.2-Beta";
  version = lib.strings.toLower ghReleaseVersion;
  meta = with lib; {
    license = licenses.mit;
    mainProgram = "aerospace";
    homepage = "https://github.com/nikitabobko/AeroSpace";
    description = "an i3-like tiling window manager for macOS";
    platforms = [ "aarch64-darwin" ];
    maintainers = with maintainers; [ t-monaghan ];
  };
in
stdenv.mkDerivation {
  inherit pname version meta;

  src = fetchzip {
    url = "https://github.com/nikitabobko/${pname}/releases/download/v${ghReleaseVersion}/AeroSpace-v${ghReleaseVersion}.zip";
    hash = "sha256-vglOSPIG5l2pIMSTOP1CfsR5seoivfx7j7jNO/CbPNo=";
  };

  unpackPhase = ''
    mkdir -p $out/Applications
    cp -r $src/ $out/
    cp -r $src/AeroSpace.app $out/Applications/
    ls $out/Applications
  '';

  passthru.tests.can-print-version = callPackage ./test-can-print-version.nix { };
}
