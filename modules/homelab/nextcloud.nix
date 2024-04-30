{config, pkgs, ...}: {
  # The nextcloud module enables nginx as the reverse proxy automatically. We're using caddy, so disable
  # * Start nxginx disable *
  services.nginx.enable = false;
  users.groups.nextcloud.members = [ config.services.caddy.user ];
  services.phpfpm.pools.nextcloud.settings = {
    "listen.owner" = config.services.caddy.user;
    "listen.group" = config.services.caddy.group;
  };
  services.caddy.virtualHosts.${config.services.nextcloud.hostName}.extraConfig = ''
    # Adapted from https://caddy.community/t/caddy-v2-configuration-nextcloud-docker-php-fpm-with-rules-from-htaccess/20662

    import cloudflare-dns
    # Nextcloud static files reside here
    # root * ${config.services.nextcloud.package}
    root * ${config.services.nginx.virtualHosts.${config.services.nextcloud.hostName}.root}

    # Encode responses with whichever is supported by the client
    encode zstd gzip

    # Enable service discovery for *dav
    redir /.well-known/carddav /remote.php/dav 301
    redir /.well-known/caldav /remote.php/dav 301

    # Nextcloud front-controller handles routes to /.well-known
    redir /.well-known/* /index.php{uri} 301 
    redir /remote/* /remote.php{uri} 301

    # Secure headers, all from .htaccess except Permissions-Policy, STS and X-Powered-By
    header {
  		Strict-Transport-Security max-age=31536000
  		Permissions-Policy interest-cohort=()
  		X-Content-Type-Options nosniff
  		X-Frame-Options SAMEORIGIN
  		Referrer-Policy no-referrer
  		X-XSS-Protection "1; mode=block"
  		X-Permitted-Cross-Domain-Policies none
  		X-Robots-Tag "noindex, nofollow"
  		-X-Powered-By
  	}

   #  # From .htaccess, deny access to sensible files and directories
  	# @forbidden {
   #    path /README
  	# 	path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
  	# 	path /.* /autotest* /occ* /issue* /indie* /db_* /console*
  	# 	not path /.well-known/*
  	# }
  	# error @forbidden 404

   #  # From .htaccess, set cache for versioned static files (cache-busting)
  	# @immutable {
  	# 	path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
  	# 	query v=*
  	# }
  	# header @immutable Cache-Control "max-age=15778463, immutable"

   #  # From .htaccess, set cache for normal static files
  	# @static {
  	# 	path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
  	# 	not query v=*
  	# }
  	# header @static Cache-Control "max-age=15778463"

  	# # From .htaccess, cache fonts for 1 week
  	# @woff2 path *.woff2
  	# header @woff2 Cache-Control "max-age=604800"

    # Proxy to fpm over unix socket
  	php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket} {
      # Enable pretty urls
  		env front_controller_active true

      # Avoid sending the security headers twice
  		env modHeadersAvailable true
  	}

    # Enable file server for static files
  	file_server
  '';
  # * End nginx disable *
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "nc.cblkjs.com";
    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
    };
    settings = {
      log_type = "file";
      log_level = "debug";
      trusted_proxies = ["127.0.0.1"];
      maintenance_window_start = 1;
      default_phone_region = "US";
    };
  };
  age.secrets.nextcloud-admin-pass = {
    file = ../../secrets/nextcloud-admin-pass.age;
    mode = "400";
    owner = "nextcloud";
    group = "nextcloud";
  };
}
