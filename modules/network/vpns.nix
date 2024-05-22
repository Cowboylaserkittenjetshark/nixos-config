{config, ...}: {
  services.openvpn.servers = {
    windscribe-Atlanta-Mountain.config = ''
      config ${config.age.secrets.Windscribe-Atlanta-Mountain-conf.path}
      
      auth-user-pass ${config.age.secrets.Windscribe-Atlanta-Mountain-auth.path}
      route 10.64.0.0 255.192.0.0 net_gateway
    '';
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
