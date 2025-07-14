{ self, lib, config, pkgs, ... }:
let
  inherit (self.lib.modules) mkOpt;
  inherit (lib.types) bool;
  inherit (lib) mkIf;

  cfg = config.sylveon.virtualization.libvirt;
in
{

  options.sylveon.virtualization.libvirt = {
    enable = mkOpt bool false "Enable libvirt support for that system";
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

     # Manage the virtualisation services
     virtualisation = {
       libvirtd = {
         enable = true;

         qemu = {
           package = pkgs.qemu_kvm;

           swtpm.enable = true;
           ovmf.enable = true;
           ovmf.packages = [ pkgs.OVMFFull.fd ];

           runAsRoot = false;
         };
       };
     };

     boot = {
       kernelParams = [
         "amd_iommu=on"
         "vfio-pci.ids=1002:7480" # IOMMU Group 16
       ];

       kernelModules = [
         "vfio_pci"
         "vfio"
         "vfio_iommu_typel"
       ];
     };

  };
}