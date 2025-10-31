{
  description = "A template Kotlin project with Maven";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
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
          in
        pkgs.maven.buildMavenPackage {
          pname = name;
          version = "1.0-SNAPSHOT";

          src = ./.;

          mvnHash = "sha256-27+YGMjQJJRq/Avp30cVkTShPhYjcfVIt6wZ48xyhJ8=";

          nativeBuildInputs = with pkgs; [
            makeWrapper
          ];

          installPhase = ''
            mkdir -p $out/bin $out/share/${name}
            install -Dm644 target/${name}-1.0-SNAPSHOT.jar $out/share/${name}

            makeWrapper ${pkgs.jre}/bin/java $out/bin/${name} \
              --add-flags "-jar $out/share/${name}/${name}-1.0-SNAPSHOT.jar"
          '';

          meta = {
            description = "A template Kotlin project with Maven";
            homepage = "https://gitlab.com/esoterictemplates/templates/template-maven-kotlin-project";
          };
        });
      });
}
