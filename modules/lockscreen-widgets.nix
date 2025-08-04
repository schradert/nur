{inputs, ...}: {
  perSystem = {pkgs, ...}: {packages = {inherit (pkgs) lockscreen-widgets;};};
  flake.overlays.lockscreen-widgets = final: _: {
    # NOTE attributes not defined in flake-parts modules are not detected on inputs', so must use inputs with system
    # FIXME why does :app:nixDownloadDeps fail? "cannot choose between the following variants of project :app"
    lockscreen-widgets = final.callPackage ({
      lib,
      stdenv,

      androidenv,
      buildGradlePackage,
      fetchurl,
      fetchFromGitHub,
      mkShell,
      runCommand,
      writeShellApplication,

      gradle,
      gradle2nix,
      jdk17,
      mktemp,
    }: let
      versions = {
        platform = "35";
        # TODO is it the 35 or 34? compileSdk in app/build.gradle.kts doesn't match README
        # aosp-android-jar = "34";
        aosp-android-jar = "35";
        cmake = "3.22.1";
        build-tools = "35.0.0";
        lockscreen-widgets = "2.20.2";
      };
      env = let
        inherit
          (androidenv.composeAndroidPackages {
            includeNDK = true;
            buildToolsVersions = [versions.build-tools];
            cmakeVersions = [versions.cmake];
            platformVersions = lib.unique [versions.platform versions.aosp-android-jar];
          })
          androidsdk
          ;
        aosp-android-jar = fetchurl {
          url = "https://github.com/Reginer/aosp-android-jar/raw/refs/heads/main/android-${versions.aosp-android-jar}/android.jar";
          # hash = "sha256-1rMkjzPKk2BqRYH6fGeCMd1uPmnztwYsjaXtLEm985Y=";
          hash = "sha256-YL5ogNeytSbWVEYNTOb6gb8j76oosC2QHQtjoBzPRnE=";
        };
        patchedsdk = runCommand "patchedsdk" {} ''
          cp --dereference --recursive ${androidsdk} $out
          aospJar=$out/libexec/android-sdk/platforms/android-${versions.aosp-android-jar}/android.jar
          permissions=$(stat -c "%a" $aospJar)
          chmod u+w $aospJar
          cp --force ${aosp-android-jar} $aospJar
          chmod $permissions $aospJar
        '';
      in {
        JAVA_HOME = jdk17.home;
        ANDROID_HOME = "${patchedsdk}/libexec/android-sdk";
        ANDROID_NDK_ROOT = "${env.ANDROID_HOME}/ndk-bundle";
        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${env.ANDROID_HOME}/build-tools/${versions.build-tools}/aapt2";
      };
    in buildGradlePackage rec {
      pname = "lockscreen-widgets";
      version = versions.lockscreen-widgets;
      meta.broken = true;

      lockFile = ./gradle.lock;
      src = fetchFromGitHub {
        owner = "zacharee";
        repo = "LockscreenWidgets";
        rev = "b4381c8ad868b83c6bd4641494fc0f14c4308bb6";
        hash = "sha256-DSR4VSO9yhmSniaqbBEIgqOEe2KzYwoVIcmRaXam95E=";
      };

      # FIXME "Unsupported class file major version 68" when "Jetifier failed to transform ~/.gradle/caches/.../byte-buddy-1.16.1.jar" to "match attributes {artifactType=android-jni, ...}"
      # FIXME why are there so many unresolved references when running ./gradlew assembleRelease
      passthru.generate-lock-file = writeShellApplication {
        name = "generate-lock-file";
        runtimeEnv = env;
        runtimeInputs = [gradle mktemp gradle2nix];
        text = ''
          tmp="$(mktemp --directory)"
          trap 'rm -rf "$tmp"' EXIT
          cp --dereference --recursive --no-preserve mode "${src}"/* "$tmp/"
          cmakePath="$(echo "$ANDROID_HOME/cmake/${versions.cmake}".*/bin)"
          export PATH="$cmakePath:$PATH"
          gradle2nix \
              --gradle-jdk "$JAVA_HOME" \
              --out-dir . \
              --project "$tmp" \
              --task :app:assembleRelease \
              -- "$GRADLE_OPTS"
        '';
      };
    }) {
      inherit (inputs.gradle2nix.builders.${final.system}) buildGradlePackage;
      inherit (inputs.gradle2nix.packages.${final.system}) gradle2nix;
    };
  };
}
