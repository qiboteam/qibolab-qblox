{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      inputs = {nixpkgs.follows = "nixpkgs";};
    };
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    devShells =
      forEachSystem
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;

          modules = [
            ({
              lib,
              pkgs,
              config,
              ...
            }: {
              packages = with pkgs; [pre-commit poethepoet jupyter];

              env = {
                QIBOLAB_PLATFORMS = (dirOf config.env.DEVENV_ROOT) + "/qibolab_platforms_qrc";
              };

              languages.python = {
                enable = true;
                libraries = with pkgs; [zlib];
                poetry = {
                  enable = true;
                  install = {
                    enable = true;
                    groups = ["dev" "analysis" "tests"];
                  };
                };
              };
            })
          ];
        };
      });
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };
}
