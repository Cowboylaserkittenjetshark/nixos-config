{config, ...}: {
  services.openvpn.servers = {
    windscribe-Atlanta-Mountain.config = '' config ${config.age.secrets.Windscribe-Atlanta-Mountain-conf.path} '';
  };
  age.secrets = {
    Windscribe-Atlanta-Mountain-conf = {
        file = ../../secrets/Windscribe-Atlanta-Mountain-conf.age;
        mode = "400";
      };
    Windscribe-Atlanta-Mountain-auth = {
        file = ../../secrets/Windscribe-Atlanta-Mountain-auth.age;
        mode = "400";
      };
  };
}
