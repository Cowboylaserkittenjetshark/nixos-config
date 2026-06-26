{
  caddy = rec {
    both = domain: "http://${domain}, https://${domain}";
    site = domain: handler: { ${both domain}.extraConfig = handler; };
  };
}
