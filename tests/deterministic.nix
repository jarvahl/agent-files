{ ... }:
{
  "agent-files".skills.example = {
    description = "Example";
    instructions = "Body";
    references.guide.text = "Guide";
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-deterministic";
      text = ''
        ${config.files.writer.drv}/bin/write-files
        first=$(sha256sum .agents/skills/example/SKILL.md .agents/skills/example/references/guide.md)
        ${config.files.writer.drv}/bin/write-files
        second=$(sha256sum .agents/skills/example/SKILL.md .agents/skills/example/references/guide.md)
        test "$first" = "$second"
      '';
    };
  };
}
