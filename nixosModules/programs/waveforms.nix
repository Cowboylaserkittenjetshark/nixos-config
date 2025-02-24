{inputs, ...}: {
  imports = [
    inputs.waveforms.nixosModule
  ];
  users.groups.plugdev = {};
}
