{...}:
{
  services.cloudflared = {
    enable = true;
    tunnels.container-stack = {
      credentialsFile = "/etc/cloudflared/container-stack.json";
      default = "http_status:404";
      ingress = {
        "cblkjs.com".service = "https://127.0.0.1";
        "*.cblkjs.com".service = "https://127.0.0.1";
      };
      originRequest = {
        originServerName = "cblkjs.com";
      };
    };
  };
}
