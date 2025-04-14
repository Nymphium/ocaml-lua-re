{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    opam-repository = {
      url = "github:ocaml/opam-repository";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";

    opam-nix = {
      url = "github:tweag/opam-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        opam-repository.follows = "opam-repository";
      };
    };
  };
  outputs =
    {
      flake-utils,
      opam-nix,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        on = opam-nix.lib.${system};
        src = ./.;
        localPackages =
          with builtins;
          filter (f: !isNull f) (
            map (
              f:
              let
                f' = match "(.*)\.opam$" f;
              in
              if isNull f' then null else elemAt f' 0
            ) (attrNames (readDir src))
          );

        devPackagesQuery = {
          ocaml-lsp-server = "*";
          utop = "*";
        };

        scope =
          let
            localPackagesQuery =
              with builtins;
              listToAttrs (
                map (p: {
                  name = p;
                  value = "*";
                }) localPackages
              );
            query =
              {
                ocaml-system = "*";
                ocamlformat = "*";
              }
              // devPackagesQuery
              // localPackagesQuery;

            # FIXME: it seems problems with opam-nix dealing with depexts
            overlay =
              final: prev:
              {
                utop = prev.utop.overrideAttrs (previousAttrs: {
                  # Fix for "unpacker produced multiple directories"
                  # See: https://stackoverflow.com/a/77161896
                  sourceRoot = ".";
                });
                conf-lua = prev.conf-lua.overrideAttrs (oa: {
                  buildInputs = oa.buildInputs ++ [
                    pkgs.lua
                  ];
                  buildPhase = ''
                    ${pkgs.pkg-config}/bin/pkg-config lua
                  '';
                });
                conf-libffi = prev.conf-libffi.overrideAttrs (oa: {
                  buildPhase = ''
                    ${pkgs.pkg-config}/bin/pkg-config libffi
                  '';
                });
              }
              // builtins.mapAttrs (
                p: _:
                prev.${p}.overrideAttrs (_: {
                  doNixSupport = false;
                })
              ) localPackagesQuery;

            scp = on.buildOpamProject' {
              inherit pkgs;
              resolveArgs = {
                with-test = true;
                with-doc = true;
              };
            } src query;
          in
          scp.overrideScope overlay;

        devPackages = with builtins; attrValues (pkgs.lib.getAttrs (attrNames devPackagesQuery) scope);
        formatter = pkgs.nixfmt-rfc-style;

        devShells = rec {
          ci = pkgs.mkShell {
            inputsFrom = builtins.map (p: scope.${p}) localPackages;
            packages = [
              formatter
              scope.ocamlformat
            ];
          };
          default = pkgs.mkShell {
            inputsFrom = [ ci ];
            buildInputs = devPackages ++ [ pkgs.nil ];
          };
        };

      in
      {
        legacyPackages = pkgs;
        opamPackages = scope;
        packages =
          with builtins;
          listToAttrs (
            map (p: {
              name = p;
              value = scope.${p};
            }) localPackages
          );

        inherit devShells;
        inherit formatter;
      }
    );
}
