update:
    nix flake update
    git add flake.nix
    git commit --message "chore: update lock file"

format:
    #!/usr/bin/env bash
    if [ -z "$(git status --porcelain)" ]; then
        nix fmt
        git add -u
        git commit --message "chore: format"
    else
        echo "Working directory is not clean, commit changes before formatting" 1>&2
        exit 1 
    fi
