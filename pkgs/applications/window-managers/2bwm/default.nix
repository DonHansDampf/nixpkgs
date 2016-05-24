{ stdenv, libXinerama, libxcb, fetchurl, xcbutil, xcbutilkeysyms, xcbutilwm, xproto }:

stdenv.mkDerivation rec {
  version = "0.0.1";
  name = "2bwm-${version}";

  src = fetchurl {
    url = "https://github.com/venam/2bwm/archive/master.tar.gz";
    sha256 = "a1a139a6960de91e0dda59487e5555e9815481ba544fdad99c3cf8b52d54008d";
  };

  buildInputs = [libxcb libXinerama xcbutil xcbutilkeysyms xcbutilwm xproto ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = {
    description = "A fast floating WM written over the XCB library and derived from mcwm.";
  };
}
