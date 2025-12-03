{
  description = "A template Kotlin project with Maven";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            maven
          ];
        };

        packages.default = (
          let
            name = "template";
            revision = self.shortRev or self.dirtyRev or "unknown";
          in
        pkgs.maven.buildMavenPackage {
          pname = name;
          version = revision;

          src = ./.;

          mvnHash = "sha256-dmq410+WxyW3XX0+LHVRZgpWPt1hpirryghre5pK7rw=";

          nativeBuildInputs = with pkgs; [
            makeWrapper
          ];

          installPhase = ''
            mkdir -p $out/share/${name}
            install -Dm644 target/${name}-1.0-SNAPSHOT.jar $out/share/${name}
          '';

          meta = {
            description = "A template Kotlin project with Maven";
            homepage = "https://gitlab.com/esoteric-templates/templates/template-maven-kotlin-project";
          };
        });
      });
}
