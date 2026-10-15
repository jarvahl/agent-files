{ ... }:
{
  "agent-files" = {
    instructions = ''
      Follow the repository conventions.
    '';
    skills.nix-testing = {
      description = "Test Nix modules";
      instructions = { references, scripts, ... }: ''
        # Nix Module Testing
        Read ${references.patterns}.
        Validate using ${scripts.check}.
      '';
      references.patterns = {
        description = "Testing patterns";
        text = "Use lib.evalModules for isolated tests.";
      };
      scripts.check = {
        description = "Validate the configuration";
        runtimeInputs = { pkgs }: [ pkgs.nix ];
        text = ''
          nix --version >/dev/null
        '';
      };
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-fixture";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F "DO-NOT-EDIT" AGENTS.md
        grep -F "Follow the repository conventions." AGENTS.md
        grep -F "Read references/patterns.md." .agents/skills/nix-testing/SKILL.md
        grep -F "Validate using nix run .#agent-nix-testing-check." .agents/skills/nix-testing/SKILL.md
        grep -F "Use lib.evalModules" .agents/skills/nix-testing/references/patterns.md
        nix run .#agent-nix-testing-check
      '';
    };
  };
}
