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

          mvnHash = "sha256-TqkF0Ga2OuP/nndpL2F3oKB2j+J6setIrX8H+xBAvso=";

          nativeBuildInputs = with pkgs; [
            makeWrapper

            xmlstarlet
          ];

          preBuild = ''
            xmlstarlet ed --inplace \
              -N pom="http://maven.apache.org/POM/4.0.0" \
              -u '/pom:project/pom:version' -v '${revision}' \
              pom.xml
          '';

          installPhase = ''
            mkdir -p $out/bin $out/share/${name}
            install -Dm644 target/${name}-${revision}.jar $out/share/${name}

            makeWrapper ${pkgs.jre}/bin/java $out/bin/${name} \
              --add-flags "-jar $out/share/${name}/${name}-${revision}.jar"
          '';

          meta = {
            description = "A template Kotlin project with Maven";
            homepage = "https://gitlab.com/esoteric-templates/templates/template-maven-kotlin-project";
          };
        });
      });
}
