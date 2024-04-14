{pkgs, inputs, ...}: {
	imports = [ inputs.agenix.nixosModules.default ];
	
	environment.systemPackages = [
		inputs.agenix.packages.${pkgs.system}.default
		pkgs.age-plugin-yubikey
	];
	
	services.pcscd.enable = true;
}
