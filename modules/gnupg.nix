{...}: {
  programs.gnupg = {
    agent.enable = true;
    agent.pinentryFlavor = "gnome3";
  };
}
