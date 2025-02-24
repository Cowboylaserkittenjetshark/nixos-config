{
  lib,
  pkgs,
  ...
}: let
  ssh-forward-agent = pkgs.writeShellScriptBin "ssh-forward-agent" ''
    set -euo pipefail

    function cleanup {
      # Preserve the PID in case ssh-agent -k fails to kill the agent
      PID="''$SSH_AGENT_PID"

      echo "Killing agent"
      ssh-agent -k

      # The ssh-askpass program may keep the parent agent process alive
      if ps -p "''$PID" > /dev/null; then
        echo "Agent did not stop, killing children"
        pkill -P "''$PID"
        sleep 1

        if ps -p "''$PID" > /dev/null; then
          echo "Agent still did not stop, force killing"
          pkill -KILL -P "''$PID"
          pkill -KILL "''$PID"
        fi
      fi

      echo "Agent stopped"

    }

    if [ "''$#" -gt 0 ]; then
      trap cleanup EXIT

      echo "Starting agent"
      SSH_ASKPASS="${lib.getExe pkgs.lxqt.lxqt-openssh-askpass}"
      eval "''$(ssh-agent)"
      ssh-add "''$HOME"/.ssh/id_ed25519_sk
      ssh -A "''$1"
    else
      echo "Missing arguments"
    fi
  '';
in {
  home.packages = [ssh-forward-agent];
}
