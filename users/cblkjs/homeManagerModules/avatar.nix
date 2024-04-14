{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.avatar = mkOption {
    type = types.path;
    defaultText = "~/.face";
    apply = toString;
    description = ''
      Path to avatar picture.
    '';
  };
}
