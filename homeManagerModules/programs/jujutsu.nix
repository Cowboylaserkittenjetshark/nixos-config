_: {
	programs.jujutsu = {
		enable = true;
		settings = {
			user = {
				name = "Cowboylaserkittenjetshark";
				email = "82691052+Cowboylaserkittenjetshark@users.noreply.github.com";
			};
			signing = {
				behavior = "drop";
				backend = "ssh";
	      key = "~/.ssh/id_ed25519_sk.pub";
			};
			git.sign-on-push = true;
		};
	};
}
