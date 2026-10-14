{ ... }:
{
  agents.skills.nix-testing = {
    description = "Test Nix modules";
    instructions = "Body";
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-frontmatter";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F -- "---" .agents/skills/nix-testing/SKILL.md
        grep -F 'name: "nix-testing"' .agents/skills/nix-testing/SKILL.md
        grep -F 'description: "Test Nix modules"' .agents/skills/nix-testing/SKILL.md
      '';
    };
  };
}
