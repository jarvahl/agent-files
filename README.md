# agent-files

Declarative Agent files for Nix flakes.

`agent-files` exposes a flake-parts module that generates tracked agent files through [`mightyiam/files`](https://github.com/mightyiam/files): `AGENTS.md`, Agent Skills, references, and Nix-backed script commands.

## Use

```nix
{
  inputs.agent-files.url = "github:jarvahl/agent-files";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.agent-files.flakeModules.default ];
    };
}
```

```nix
{
  "agent-files".instructions = ''
    Follow the repository conventions.
  '';

  "agent-files".skills.nix-testing = {
    description = "Test Nix modules";
    instructions = { references, scripts, ... }: ''
      # Nix Module Testing
      Read ${references.patterns}.
      Validate using ${scripts.check}.
    '';

    references.patterns = {
      description = "Testing patterns";
      text = "Use lib.evalModules for isolated tests.";
    };

    scripts.check = {
      description = "Validate the configuration";
      runtimeInputs = { pkgs }: [ pkgs.nix pkgs.git ];
      text = ''
        nix flake check "$@"
      '';
    };
  };
}
```

Generated files:

```text
AGENTS.md
.agents/skills/nix-testing/SKILL.md
.agents/skills/nix-testing/references/patterns.md
```

Each generated Markdown file starts with an invisible HTML DO-NOT-EDIT notice and points to `nix run .#write-files` for regeneration.

## References

References can use `text` or `source`:

```nix
"agent-files".skills.example.references = {
  guide = {
    description = "Main guide";
    text = { references, ... }: ''
      See ${references.examples}.
    '';
  };
  examples.source = ./examples.md;
};
```

Reference paths are resolved relative to the file being rendered. From `SKILL.md`, `references.guide` is `references/guide.md`; from `references/guide.md`, `references.examples` is `examples.md`.

`SKILL.md` automatically gets a References section when references exist. Disable it with:

```nix
"agent-files".skills.example.autoReferences = false;
```

## Scripts

Scripts are flake apps generated with `pkgs.writeShellApplication` and run only through `nix run`:

```nix
"agent-files".skills.example.scripts.validate = {
  description = "Validate project";
  runtimeInputs = { pkgs }: [ pkgs.nix pkgs.git ];
  text = ''
    nix flake check "$@"
  '';
};
```

This creates:

```sh
nix run .#agent-example-validate
```

`SKILL.md` automatically documents script commands. Disable it with:

```nix
"agent-files".skills.example.autoScripts = false;
```

## Write and check generated files

`agent-files` uses `mightyiam/files`, so generated files are regular tracked files:

```sh
nix run .#write-files
nix flake check
```
