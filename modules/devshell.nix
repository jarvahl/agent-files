{ ... }:
{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          deadnix
          nixfmt-rfc-style
        ];

        shellHook = ''
          ${config.pre-commit.shellHook}
        '';
      };
    };
}
