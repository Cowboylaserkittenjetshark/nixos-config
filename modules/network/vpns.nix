{config, ...}: {
  services.openvpn.servers = {
    windscribe-Atlanta-Mountain = {
      config = ''
        config ${config.age.secrets.Windscribe-Atlanta-Mountain-conf.path}
      
        auth-user-pass ${config.age.secrets.Windscribe-Atlanta-Mountain-auth.path}
        route 10.64.0.0 255.192.0.0 net_gateway
      '';
      autoStart = false;
    };
    Windscribe-WashingtonDC-Precedent = {
      config = ''
        config ${config.age.secrets.Windscribe-WashingtonDC-Precedent-conf.path}
      
        auth-user-pass ${config.age.secrets.Windscribe-WashingtonDC-Precedent-auth.path}
        route 10.64.0.0 255.192.0.0 net_gateway
      '';
      autoStart = true;
    };
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
    Windscribe-WashingtonDC-Precedent-conf = {
        file = ../../secrets/Windscribe-WashingtonDC-Precedent-conf.age;
        mode = "400";
      };
    Windscribe-WashingtonDC-Precedent-auth = {
        file = ../../secrets/Windscribe-WashingtonDC-Precedent-auth.age;
        mode = "400";
      };
  };
}
