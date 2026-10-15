{ ... }:
{
  "agent-files".skills.example = {
    description = "Example";
    instructions = { scripts, ... }: "Run ${scripts.check}.";
    references.guide.text = "Guide";
    scripts.check = {
      description = "Check";
      text = "echo ok";
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-no-store-paths";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        test -f .agents/skills/example/SKILL.md
        test ! -L .agents/skills/example/SKILL.md
        if grep -R /nix/store AGENTS.md .agents 2>/dev/null; then exit 1; fi
      '';
    };
  };
}
