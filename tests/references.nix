{ ... }:
{
  agentFiles.skills.example = {
    description = "Example";
    instructions = "Body";
    references = {
      text-ref = {
        description = "Text Ref";
        text = "Text body";
      };
      source-ref = {
        description = "Source Ref";
        source = ./source.md;
      };
    };
  };

  perSystem = { config, pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-references";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        ${config.files.writer.drv}/bin/write-files
        grep -F "Text body" .agents/skills/example/references/text-ref.md
        grep -F "# Source Reference" .agents/skills/example/references/source-ref.md
      '';
    };
  };
}
