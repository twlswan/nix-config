{
  description = "flake setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }
          ];
        };
      };

      # Usage: nix develop github:username/repo#android
      devShells.${system} = {
        android = import ./shells/android.nix { inherit pkgs; };
      };
    };
}