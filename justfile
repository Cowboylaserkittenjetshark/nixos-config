update: abortIfDirty && (commit "update lock file")
    nix flake update
    git add flake.lock

format: abortIfDirty && (commit "format")
    nix fmt
    git add -u

abortIfDirty:
    #!/usr/bin/env bash
    if [ -n "$(git status --porcelain)" ]; then
        echo "Working directory is not clean, commit changes before proceeding" 1>&2
        exit 1 
    fi        

commit message:
    #!/usr/bin/env bash
    if [ -n "$(git status --porcelain)" ]; then
        git commit --message "chore: {{ message }}"
    fi
