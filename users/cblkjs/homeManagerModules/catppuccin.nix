{inputs, ...}: 
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "green";
    sources.foot = builtins.fetchGit {
      url = "https://github.com/catppuccin/foot";
      rev = "80756a4d63ea4fae4d0fdd793017370f8b8b12ac";
    };
  };
}
