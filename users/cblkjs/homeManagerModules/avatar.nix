{
  lib,
  ...
}:let 
  inherit (lib) mkOption types;
in {
  options.avatar = mkOption {
    type = types.path;
    defaultText = "~/.face";
    description = "Path to avatar picture.";
  };
}
