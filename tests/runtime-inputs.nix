{ ... }:
{
  agentFiles.skills.example = {
    description = "Example";
    instructions = "Body";
    scripts.hello = {
      description = "Hello";
      runtimeInputs = { pkgs }: [ pkgs.hello ];
      text = "hello";
    };
  };

  perSystem = { pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-runtime-inputs";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        nix run .#agent-example-hello | grep -F Hello
      '';
    };
  };
}
