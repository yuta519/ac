{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  packages = with pkgs; [ 
    git 

    ghc                       # GHC compiler
    # Haskell toolchain (custom GHC with packages)
    (pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
      containers      # <- you need this for Data.Set
      text            # commonly needed
      bytestring      # commonly needed
    ]))
    cabal-install             # Cabal
    haskell-language-server   # HLS (the LSP server)

    # Formatting & linting (pick one formatter)
    ormolu
    hlint

    (python3.withPackages (ps: with ps; [
      online-judge-tools
    ]))
  ];
  languages.haskell.enable = true;
  languages.haskell.package = pkgs.haskell.compiler.ghc96;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # Re-solve a problem from scratch, starting from its pre/<problem> tag.
  # Each invocation creates a fresh attempt branch (attempt/01-..., 02-..., ...).
  # Usage: redo abc137-d
  scripts.redo.exec = ''
    if [ -z "$1" ]; then
      echo "usage: redo <problem>" >&2
      echo "example: redo abc137-d" >&2
      exit 1
    fi
    if ! git rev-parse "pre/$1" >/dev/null 2>&1; then
      echo "tag pre/$1 not found" >&2
      echo "available tags:" >&2
      git tag -l 'pre/*' | head -20 >&2
      exit 1
    fi
    last=$(git for-each-ref --format='%(refname:short)' "refs/heads/attempt/*-$1" \
      | sed -nE "s|attempt/0*([0-9]+)-$1|\1|p" \
      | sort -n | tail -1)
    next=$(printf "%02d" $(( ''${last:-0} + 1 )))
    branch="attempt/$next-$1"
    git checkout -b "$branch" "pre/$1"
    echo "Started $branch (from pre/$1)"
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';


  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
