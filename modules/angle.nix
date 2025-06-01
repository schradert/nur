{
  flake.overlays.angle = final: prev: {
    # TODO how do I actually do this build?
    unofficial-angle = final.callPackage ({
      lib,
      stdenv,
      fetchFromGitHub,
      cmake,
      vcpkg,
    }:
      stdenv.mkDerivation rec {
        pname = "angle";
        version = "0.16";
        src = fetchFromGitHub {
          owner = "google";
          repo = "angle";
          rev = "v${version}";
          hash = "";
        };
        postPatch = "cp ${vcpkg.src}/ports/angle/CMakeLists.txt .";
        nativeBuildInputs = [cmake];
        meta = {
          description = "A conformant OpenGL ES implementation for Windows, Mac, Linux, iOS and Android.";
          homepage = "https://github.com/google/angle";
          license = lib.licenses.bsd3;
          maintainers = with lib.maintainers; [schradert];
          platforms = lib.platforms.all;
        };
      }) {};
  };
}
