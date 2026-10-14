{ ... }:
{
  agents.instructions = ''
    Follow the repository conventions.
  '';

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-agents-md";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        test -f AGENTS.md
        grep -F "Follow the repository conventions." AGENTS.md
      '';
    };
  };
}
