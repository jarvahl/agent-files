{ ... }:
{
  agents.skills = {
    one = {
      description = "One";
      instructions = "First";
    };
    two = {
      description = "Two";
      instructions = "Second";
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-multiple-skills";
      text = ''
        ${config.files.writer.drv}/bin/write-files
        test -f .agents/skills/one/SKILL.md
        test -f .agents/skills/two/SKILL.md
      '';
    };
  };
}
