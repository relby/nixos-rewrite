bootstrap destination username publickey:
    ssh \
    -o PubkeyAuthentication=no \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    {{destination}} " \
        parted --script /dev/nvme0n1 -- mklabel gpt; \
        parted --script /dev/nvme0n1 -- mkpart root ext4 512MB -8GB; \
        parted --script /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100\%; \
        parted --script /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB; \
        parted --script /dev/nvme0n1 -- set 3 esp on; \
        sleep 1; \
        mkfs.ext4 -L nixos /dev/nvme0n1p1; \
        mkswap -L swap /dev/nvme0n1p2; \
        mkfs.fat -F 32 -n boot /dev/nvme0n1p3; \
        sleep 1; \
        mount /dev/disk/by-label/nixos /mnt; \
        swapon /dev/disk/by-label/swap; \
        mkdir -p /mnt/boot; \
        mount /dev/disk/by-label/boot /mnt/boot; \
        nixos-generate-config --root /mnt; \
        sed --in-place '/system\.stateVersion = .*/a \
            nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
            security.sudo.wheelNeedsPassword = false;\n \
            services.openssh.enable = true;\n \
            services.openssh.settings.PasswordAuthentication = false;\n \
            services.openssh.settings.PermitRootLogin = \"no\";\n \
            users.mutableUsers = false;\n \
            users.users.{{username}}.extraGroups = [ \"wheel\" ];\n \
            users.users.{{username}}.initialPassword = \"{{username}}\";\n \
            users.users.{{username}}.isNormalUser = true;\n \
            users.users.{{username}}.openssh.authorizedKeys.keys = [ \"{{publickey}}\" ];\n \
        ' /mnt/etc/nixos/configuration.nix; \
        nixos-install --no-root-passwd; \
        reboot;"

# WARNING: Wipes ALL data
partition-and-mount: && partition (sleep "1.01") make-fs (sleep "1.02") mount
    #!/bin/sh
    set -euo pipefail
    read -p "This is going to wipe all data on the disk and partition it. Do you want to continue? [y/N]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit

[private]
@sleep seconds:
    sleep {{seconds}}

[private]
partition:
    parted --script /dev/nvme0n1 -- mklabel gpt
    parted --script /dev/nvme0n1 -- mkpart root ext4 512MB -8GB
    parted --script /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100\%
    parted --script /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
    parted --script /dev/nvme0n1 -- set 3 esp on

[private]
make-fs:
    mkfs.ext4 -L nixos /dev/nvme0n1p1
    mkswap -L swap /dev/nvme0n1p2
    mkfs.fat -F 32 -n boot /dev/nvme0n1p3

[private]
mount:
    mount /dev/disk/by-label/nixos /mnt
    swapon /dev/disk/by-label/swap
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
