_: {
  # Enables options to fix legacy amd gpus
  # I use this for a FirePro W5100 (Bonaire), but it should work for any Southern/Sea Islands gpus
  boot.extraModprobeConfig = ''
    # Enable Southern/Sea Islands support in amdgpu
    options amdgpu si_support=1
    options amdgpu cik_support=1

    # Disable radeon module entirely
    blacklist radeon
    options radeon si_support=0
    options radeon cik_support=0
  '';

  boot.kernelModules = [ "amdgpu" ];
}
