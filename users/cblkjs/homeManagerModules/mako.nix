{...}: {
  services.mako = {
    enable = true;
    backgroundColor = "#1E1E2ECC";
    textColor = "#cdd6f4";
    borderColor = "#89b4facc";
    progressColor = "over #313244cc";
    borderRadius = 7;
    borderSize = 2;
    defaultTimeout = 5000;
    extraConfig = ''
      [urgency=high]
      border-color=#fab387
    '';
  };
}
