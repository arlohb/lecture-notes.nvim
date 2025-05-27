{
  description = "An empty flake with a devShell and direnv";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        lecture-notes-nvim = pkgs.vimUtils.buildVimPlugin {
          name = "lecture-notes.nvim";
          src = ./.;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            lua-language-server
          ];
        };

        packages.default = lecture-notes-nvim;
      }
    );
}
