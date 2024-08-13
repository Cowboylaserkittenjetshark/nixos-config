{
  lib,
  ...
}:
with lib; {
  options.avatar = mkOption {
    type = types.path;
    defaultText = "~/.face";
    description = "Path to avatar picture.";
  };
}
