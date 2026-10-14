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
      testCasesDir = self + "/test-cases";
      allTestCases = builtins.attrNames (
        lib.filterAttrs (_name: type: type == "directory") (builtins.readDir testCasesDir)
      );
      testCases = lib.remove "collisions" allTestCases;
      testFlake =
        dirname:
        pkgs.writeText "test-case-${dirname}-flake.nix" ''
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
        text = lib.concatMapStringsSep "\n" (dirname: ''
          echo "== ${dirname} =="
          work=$(mktemp -d)
          cp ${testFlake dirname} "$work/flake.nix"
          cp -r ${testCasesDir + "/${dirname}"}/* "$work/"
          git -C "$work" init -q
          git -C "$work" config user.name test
          git -C "$work" config user.email test@example.com
          git -C "$work" add .
          git -C "$work" commit -qm init
          (cd "$work" && nix --extra-experimental-features 'nix-command flakes' run .)
          rm -rf "$work"
        '') testCases;
      };
    in
    {
      apps.integration-tests = {
        type = "app";
        program = lib.getExe integrationTests;
        meta.description = "Run integration test cases outside the Nix sandbox";
      };

      checks.test-cases-present = pkgs.runCommandLocal "test-cases-present" { } ''
        test ${toString (builtins.length allTestCases)} -ge 15
        touch $out
      '';
    };
}
