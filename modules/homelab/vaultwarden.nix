{config, ...}: {
  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-env.path;
    config = {
      ROCKET_PORT = 8222;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_LOG = "critical";
    };
  };

  age.secrets.vaultwarden-env = {
    file = ../../secrets/vaultwarden-env.age;
    mode = "400";
    owner = "vaultwarden";
    group = "vaultwarden";
  };
}
