{
  description = "Wallpapers for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
      pkgs = forEachSystem (system: import nixpkgs { inherit system; });
    in
    {
      packages = forEachSystem (
        system: with pkgs.${system}; {
          wallpapers = stdenv.mkDerivation {
            name = "wallpapers";

            version = "20250409";

            src = ./wallpapers;

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/share/wallpapers
              cp -r * $out/share/wallpapers
            '';

            meta = with lib; {
              description = "A collection of wallpapers";
              license = licenses.mit;
            };
          };

          default = self.packages.${system}.wallpapers;
        }
      );
    };
}
