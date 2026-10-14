{
  lib,
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      testsDir = self + "/tests";
      allTests =
        builtins.readDir testsDir
        |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name)
        |> builtins.attrNames
        |> map (lib.removeSuffix ".nix");
      tests = lib.remove "collisions" allTests;
      testFlake =
        name:
        pkgs.writeText "test-${name}-flake.nix" ''
          {
            inputs = {
              agent-files.url = "${self}";
              flake-parts.url = "${inputs.flake-parts}";
              nixpkgs.url = "${inputs.nixpkgs}";
              systems.url = "${inputs.systems}";
            };

            outputs =
              inputs:
              inputs.flake-parts.lib.mkFlake { inherit inputs; } {
                systems = import inputs.systems;
                imports = [
                  inputs.agent-files.flakeModules.default
                  ./module.nix
                ];
              };
          }
        '';
      integrationTests = pkgs.writeShellApplication {
        name = "integration-tests";
        runtimeInputs = [
          pkgs.git
          pkgs.nix
        ];
        text = lib.concatMapStringsSep "\n" (name: ''
          echo "== ${name} =="
          work=$(mktemp -d)
          cp ${testFlake name} "$work/flake.nix"
          cp ${testsDir + "/${name}.nix"} "$work/module.nix"
          for resource in ${testsDir + "/${name}"}-*; do
            [ -e "$resource" ] && cp "$resource" "$work/''${resource##*/${name}-}"
          done
          git -C "$work" init -q
          git -C "$work" config user.name test
          git -C "$work" config user.email test@example.com
          git -C "$work" add .
          git -C "$work" commit -qm init
          (cd "$work" && nix --extra-experimental-features 'nix-command flakes' run .)
          rm -rf "$work"
        '') tests;
      };
    in
    {
      apps.integration-tests = {
        type = "app";
        program = lib.getExe integrationTests;
        meta.description = "Run integration flake-parts module tests outside the Nix sandbox";
      };

      checks.tests-present = pkgs.runCommandLocal "tests-present" { } ''
        test ${toString (builtins.length allTests)} -ge 15
        touch $out
      '';
    };
}
