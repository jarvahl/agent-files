{ ... }:
{
  "agent-files".skills.example = {
    description = "Example";
    instructions = { references, scripts, ... }: ''
      Read ${references.guide}.
      Run ${scripts.validate}.
    '';
    references.guide = {
      description = "Guide";
      text = "Guide text";
    };
    scripts.validate = {
      description = "Validate";
      text = "echo ok";
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-function-instructions";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F "Read references/guide.md." .agents/skills/example/SKILL.md
        grep -F "Run nix run .#agent-example-validate." .agents/skills/example/SKILL.md
      '';
    };
  };
}
