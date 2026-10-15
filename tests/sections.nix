{ ... }:
{
  agentFiles.skills = {
    full = {
      description = "Full";
      instructions = "Body";
      references.guide.description = "Main guide";
      references.guide.text = "Guide";
      scripts.check = {
        description = "Validate project";
        text = "echo ok";
      };
    };
    empty = {
      description = "Empty";
      instructions = "Body";
    };
    disabled = {
      description = "Disabled";
      instructions = "Body";
      autoReferences = false;
      references.guide.text = "Guide";
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-sections";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F "## References" .agents/skills/full/SKILL.md
        grep -F "[Main guide](references/guide.md)" .agents/skills/full/SKILL.md
        grep -F "## Scripts" .agents/skills/full/SKILL.md
        grep -F 'nix run .#agent-full-check' .agents/skills/full/SKILL.md
        if grep -F "## References" .agents/skills/empty/SKILL.md; then exit 1; fi
        if grep -F "## Scripts" .agents/skills/empty/SKILL.md; then exit 1; fi
        if grep -F "## References" .agents/skills/disabled/SKILL.md; then exit 1; fi
      '';
    };
  };
}
