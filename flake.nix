{
  description = "Patrik's macOS Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
  let
    system = "aarch64-darwin";
    hostname = "Patriks-MacBook-Pro";
    username = "patrikduksin";
  in
  {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs username; };
      modules = [
        ./darwin
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs username; };
            users.${username} = import ./home;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience
    darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
  };
}
