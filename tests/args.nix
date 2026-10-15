{ ... }:
{
  agent-files.skills.example = {
    description = "Example";
    instructions = "Body";
    scripts.echo = {
      description = "Echo args";
      text = ''
        printf '%s\n' "$@"
      '';
    };
  };

  perSystem = { pkgs, ... }: {
    packages.default = pkgs.writeShellApplication {
      name = "test-args";
      runtimeInputs = [ pkgs.gnugrep ];
      text = ''
        nix run .#agent-example-echo -- one two | grep -F one
        nix run .#agent-example-echo -- one two | grep -F two
      '';
    };
  };
}
