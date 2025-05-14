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
	      key = "~/.ssh/signing_key.pub";
			};
			git.sign-on-push = true;
		};
	};
}
