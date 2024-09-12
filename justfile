# Update the flake lock file
update: abortIfDirty && (commit "chore" "update lock file")
    nix flake update
    git add flake.lock

# Format all nix files
format: abortIfDirty && (commit "chore" "format")
    nix fmt
    git add -u

[private]
abortIfDirty:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain)" ]; then
        echo "Working directory is not clean, commit changes before proceeding" 1>&2
        exit 1
    fi        

[private]
commit type message:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain)" ]; then
        git commit --message "{{ type }}: {{ message }}"
    fi
