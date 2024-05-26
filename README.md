# nixos-config
My NixOS configs
## Installation
1. Get and boot the minimal ISO image from [nixos.org/download/](https://nixos.org/download/)
2. [Connect to the network](https://wiki.archlinux.org/title/Wpa_supplicant#Connecting_with_wpa_passphrase)
3. Clone this repo
4. Use disko to setup storage
   ``` shell
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /path/to/disk-config.nix
   ```
5. Add `disk-config.nix` to the flake
6. Generate hardware configuration and add to flake
   ``` shell
   # Generates config at /mnt/etc/nixos
   # Copy /mnt/etc/nixos/hardware-configuration.nix to the cloned flake, then remove /mnt/etc/nixos
   nixos-generate-config --no-filesystems --root /mnt
   ```
6. Generate password file
   1. [hashedPasswordFile](https://search.nixos.org/options?&show=users.users.%3Cname%3E.hashedPasswordFile) should refrence this file
   2. Replace `user` with the user's name
   ``` shell
   mkdir /mnt/persist/secrets
   mkpasswd >> /mnt/persist/secrets/user-passwd
   ```
8. Install
   ``` shell
   # May need --impure? Really shouldn't though
   nixos-install --root /mnt --flake /path/to/this/repo#hostname
   ```
7. Reboot
## Post install
### Yubikey
1. Import GPG key: `gpg --recv <key-id>`
2. Import resident ssh key stubs
   ``` shell
   cd ~/.ssh
   ssh-keygen -K
   # Generated key stubs will be postfixed with _rk (resident key)
   # This needs to be removed,
   mv id_ed25519_sk_rk id_ed25519_sk
   mv id_ed25519_sk_rk.pub id_ed25519_sk.pub
   ```
3. Generate local keys for pam-u2f. See the [Arch Wiki](https://wiki.archlinux.org/title/Universal_2nd_Factor#Adding_a_key)

## Credits/Resources
Those hosted on github can be found in my [nix stars list](https://github.com/stars/Cowboylaserkittenjetshark/lists/nix).
