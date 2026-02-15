{
  description = "My flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      baseHook = name: ''
        export PS1="(nix-env ${name}) $PS1"
        mkdir -p .cache
        mkdir -p .config
      '';

    in {
      devShells.x86_64-linux = {

        js = pkgs.mkShell {
          buildInputs = [ pkgs.bun pkgs.nodejs_24 ];
          shellHook = (baseHook "js") + ''
            export npm_config_cache="$PWD/.cache/npm"
            export npm_config_prefix="$PWD/.npm_global"
            export npm_config_userconfig="$PWD/.npmrc_local"
            export BUN_INSTALL="$PWD/.bun"
            export PATH="$PWD/.npm_global/bin:$BUN_INSTALL/bin:$PATH"
          '';
        };

        go = pkgs.mkShell {
          buildInputs = [ pkgs.go_1_25 ];
          shellHook = (baseHook "go") + ''
            export GOPATH="$PWD/.go"
            export GOCACHE="$PWD/.cache/go-build"
            export GOMODCACHE="$PWD/.cache/go-mod"
            export PATH="$GOPATH/bin:$PATH"
          '';
        };

        python = pkgs.mkShell {
          buildInputs = [
            pkgs.python312
            pkgs.python312Packages.pip
            pkgs.python312Packages.virtualenv
          ];
          shellHook = (baseHook "python") + ''
            export PIP_CACHE_DIR="$PWD/.cache/pip"
            export PYTHONPYCACHEPREFIX="$PWD/.cache/pycache"
          '';
        };

        # --- PHP (Laravel & Composer Ready) ---
        php = pkgs.mkShell {
          buildInputs = [
            pkgs.php83            # Menggunakan PHP 8.3 (Stabil & support Laravel terbaru)
            pkgs.php83Packages.composer
            pkgs.unzip            # Penting untuk composer install/update
          ];
          shellHook = (baseHook "php") + ''
            export COMPOSER_HOME="$PWD/.config/composer"
            export COMPOSER_CACHE_DIR="$PWD/.cache/composer"
            export PATH="$PWD/vendor/bin:$PWD/.config/composer/vendor/bin:$PATH"
            
            mkdir -p "$COMPOSER_HOME"
            mkdir -p "$COMPOSER_CACHE_DIR"
          '';
        };

        cpp = pkgs.mkShell {
          buildInputs = [
            pkgs.gcc        # Termasuk gcc dan g++
            pkgs.gnumake    # Command 'make'
            pkgs.cmake      # Build system standard
            pkgs.gdb        # Debugger
            pkgs.clang-tools # Untuk linter/formatter (opsional)
          ];
          shellHook = (baseHook "cpp") + ''
            export CC=gcc
            export CXX=g++
          '';
        };

        default = pkgs.mkShell {
          shellHook = baseHook "default";
        };
      };
    };
}
