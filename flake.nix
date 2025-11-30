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

          mvnHash = "sha256-HkjQwqKV6k4RyMUAP+FB/8KVEZH18CmM1aoyenbdyBw=";

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
