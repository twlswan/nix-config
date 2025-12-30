{ pkgs }:

let
  fhs = pkgs.buildFHSUserEnv {
    name = "android-env";
    targetPkgs = pkgs: with pkgs; [
      android-tools
      bc binutils bison ccache curl flex gcc git git-repo git-lfs 
      gnumake gnupg gperf imagemagick libxml2 libxslt lz4 lzop 
      m4 nettools openssl.dev perl pngcrush procps python3 rsync 
      schedtool SDL squashfsTools unzip util-linux xml2 zip zsh
      libxcrypt-legacy freetype fontconfig yaml-cpp ncurses5
    ];
    multiPkgs = pkgs: with pkgs; [
      zlib ncurses5 libcxx readline libgcc iconv
    ];
    runScript = "zsh";
    profile = ''
      export ALLOW_NINJA_ENV=true
      export USE_CCACHE=1
    '';
  };
in
pkgs.stdenv.mkDerivation {
  name = "android-env-shell";
  nativeBuildInputs = [ fhs ];
  shellHook = "exec android-env";
}