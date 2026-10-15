{ ... }:
{
  agent-files.skills.example = {
    description = "Example";
    instructions = "Body";
    scripts.validate = {
      description = "Validate project";
      runtimeInputs = { pkgs }: [ pkgs.git ];
      text = ''
        git --version >/dev/null
        echo validated
      '';
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-scripts";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F 'nix run .#agent-example-validate' .agents/skills/example/SKILL.md
        nix run .#agent-example-validate | grep -F validated
        test ! -e .agents/skills/example/scripts
      '';
    };
  };
}
