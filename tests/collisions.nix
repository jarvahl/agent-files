{ ... }:
{
  agentFiles.instructions = "generated";

  perSystem = { pkgs, ... }: {
    files.file."AGENTS.md".text = "manual";
    packages.default = pkgs.writeShellApplication {
      name = "test-collisions";
      text = ''
        if nix flake check 2>err; then
          echo "expected collision failure" >&2
          exit 1
        fi
        grep -i "conflicting\|not.*unique\|defined" err >/dev/null
      '';
    };
  };
}
