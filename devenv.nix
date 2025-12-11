{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [ 
    git 

    # Toolchain
    ghc                       # GHC compiler
    # Haskell toolchain (custom GHC with packages)
    (pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
      containers      # <- you need this for Data.Set
      text            # commonly needed
      bytestring      # commonly needed
      # add more if needed
    ]))
    cabal-install             # Cabal
    stack                     # Optional, if you use Stack projects
    haskell-language-server   # HLS (the LSP server)

    # Formatting & linting (pick one formatter)
    # fourmolu
    ormolu
    hlint
  ];
  languages.haskell.enable = true;
  languages.haskell.package = pkgs.haskell.compiler.ghc96;

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
