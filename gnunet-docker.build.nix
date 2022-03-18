{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2022-03-19";
  url = "https://github.com/nixos/nixpkgs/archive/73ad5f9e147c0d2a2061f1d4bd91e05078dc0b58.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "01j7nhxbb2kjw38yk4hkjkkbmz50g3br7fgvad6b1cjpdvfsllds";
}) { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildImage {
  name = "gnunet";
  tag = "0.16";

  fromImage = null;
  fromImageName = null;
  fromImageTag = "latest";

  contents = (with pkgsLinux; [
    gnunet
    miniupnpc
    # CA certs bundle
    cacert
    # aux tools
    bashInteractive
    coreutils
    iproute
    iputils
    bind # dig tool
    ps
    curl
  ]);
  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir -p /data
    cd /etc/ssl/certs && ln -s ca-bundle.crt ca-certificates.crt
  '';

  config = {
    Cmd = [ "/bin/gnunet-arm" "-c" "/config/gnunet.conf" "-s" "-m" ];
#    Cmd = [ "${pkgsLinux.gnunet}/bin/gnunet-arm" "-s" "-m" ];
    WorkingDir = "/data";
    Volumes = {
      "/data" = { };
      "/config" = { };
    };
    ExposedPorts = {
      "2087/tcp" = { }; # arm
      "2095/tcp" = { }; # dht
      "2098/tcp" = { }; # ats
      "7776/tcp" = { }; # REST
    };
  };
}
