{ ... }:
{
  "agent-files".instructions = ''
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
        if test -e .agents/README.md; then exit 1; fi
        grep -F "DO-NOT-EDIT" AGENTS.md
        grep -F "github:jarvahl/agent-files" AGENTS.md
        grep -F "Use \`nix run .#write-files\` to regenerate it." AGENTS.md
        grep -F "Follow the repository conventions." AGENTS.md
      '';
    };
  };
}
