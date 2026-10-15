{ ... }:
{
  agent-files.skills.example = {
    description = "Example";
    instructions = { references, ... }: "Read ${references.guide}.";
    references = {
      guide = {
        description = "Guide";
        text = { references, ... }: "See ${references.examples}.";
      };
      examples.source = ./examples.md;
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-relative-references";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F "Read references/guide.md." .agents/skills/example/SKILL.md
        grep -F "See examples.md." .agents/skills/example/references/guide.md
      '';
    };
  };
}
