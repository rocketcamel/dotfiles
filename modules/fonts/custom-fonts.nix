{ stdenv, lib }:
stdenv.mkDerivation {
  pname = "custom-fonts";
  version = "0.1.0";

  src = ../../custom/fonts;

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r $src/* $out/share/fonts
  '';
}
