{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    futils = {
      url = "github:numtide/flake-utils";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    nvim = {
      url = "github:Orysse/nixvim";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      futils,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      inherit (futils.lib) eachDefaultSystemMap;

      system = "x86_64-linux";
      username = "abelc";

      mkDefaultArgs =
        system:
        let
          pkgs = import nixpkgs {
            config.allowUnfree = true;
            config.allowUnsupportedSystem = true;
            inherit system;
          };
          pkgs-local = self.packages.${system};
        in
        {
          inherit (self) inputs outputs;
          inherit
            pkgs
            pkgs-local
            system
            username
            lib
            ;
        };

      defaultArgs = mkDefaultArgs system;
    in
    {
      packages = eachDefaultSystemMap (
        system:
        let
          defaultArgs = mkDefaultArgs system;
        in
        { home-manager = home-manager.packages.${system}.default; } // (import ./packages defaultArgs)
      );

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;

      homeManagerModules = import ./modules/home-manager;

      # nixosConfigurations = (import ./hosts (defaultArgs));

      homeConfigurations = (import ./homes { inherit (self) inputs outputs; });

      formatter = eachDefaultSystemMap (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
