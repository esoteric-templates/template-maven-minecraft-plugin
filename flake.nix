{
  description = "A template Kotlin Minecraft plugin project with Maven";

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
            name = "plugin";
            about = "A template Kotlin Minecraft plugin project with Maven";
            url = "https://gitlab.com/esoteric-templates/templates/template-maven-minecraft-plugin";

            revision = self.shortRev or self.dirtyRev or "unknown";
          in
        pkgs.maven.buildMavenPackage {
          pname = name;
          version = revision;

          src = ./.;

          mvnHash = "sha256-e9sPCEA3xCCvaWD2s+EERXEU4LLnhQymsx1G+l4A0SQ=";

          nativeBuildInputs = with pkgs; [
            makeWrapper

            xmlstarlet
          ];

          preBuild = ''
            xmlstarlet ed --inplace \
              -N pom="http://maven.apache.org/POM/4.0.0" \
              -u '/pom:project/pom:version' -v '${revision}' \
              pom.xml

            xmlstarlet ed --inplace \
              -N pom="http://maven.apache.org/POM/4.0.0" \
              -s "/pom:project/pom:properties" \
              -t elem -n "project.url" -v "${url}" \
              pom.xml

            xmlstarlet ed --inplace \
              -N pom="http://maven.apache.org/POM/4.0.0" \
              -s "/pom:project/pom:properties" \
              -t elem -n "project.about" -v "${about}" \
              pom.xml
          '';

          installPhase = ''
            mkdir -p $out/share/${name}
            install -Dm644 target/${name}-${revision}.jar $out/share/${name}
          '';

          meta = {
            description = about;
            homepage = url;
          };
        });
      });
}
