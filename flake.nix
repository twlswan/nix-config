{
  description = "flake setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          # We pass the specially configured 'pkgs' to the modules
          specialArgs = { inherit pkgs; };
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