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
