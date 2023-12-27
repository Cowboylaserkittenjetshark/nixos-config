#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq socat
getJson() {
  jq --null-input --compact-output\
    --argjson MONITORS "$(hyprctl -j monitors)"\
    --argjson WORKSPACES "$(hyprctl -j workspaces | jq 'sort_by(.id)')"\
    '{"monitors": $MONITORS, "workspaces": $WORKSPACES}'
  }
getJson
while read -r line; do
  if [[ ${line:0:16} == "destroyworkspace" || ${line:0:9} == "workspace" ]]; then
    getJson
  fi
done < <(socat -U - UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock)
