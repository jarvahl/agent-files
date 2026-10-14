{ ... }:
{
  agents.instructions = ''
    Follow the repository conventions.
  '';

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-agents-md";
      runtimeInputs = [
        pkgs.gnugrep
        pkgs.nix
      ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        test -f AGENTS.md
        test -f .agents/README.md
        grep -F "DO-NOT-EDIT" .agents/README.md
        grep -F "github:jarvahl/agent-files" .agents/README.md
        grep -F "Use \`nix run .#write-files\` to regenerate it." .agents/README.md
        grep -F "Follow the repository conventions." AGENTS.md
      '';
    };
  };
}
