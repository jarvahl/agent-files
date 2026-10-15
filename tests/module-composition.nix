{ lib, ... }:
{
  "agent-files".instructions = lib.mkDefault "default instructions";
  "agent-files".skills.example = {
    description = "Example";
    instructions = lib.mkForce "forced instructions";
    references.guide.text = lib.mkDefault "default guide";
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-module-composition";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F "default instructions" AGENTS.md
        grep -F "forced instructions" .agents/skills/example/SKILL.md
        grep -F "default guide" .agents/skills/example/references/guide.md
      '';
    };
  };
}
