bootstrap destination username publickey:
    ssh \
    -o PubkeyAuthentication=no \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    {{destination}} " \
        yes | parted /dev/nvme0n1 -- mklabel gpt; \
        parted /dev/nvme0n1 -- mkpart root ext4 512MB -8GB; \
        parted /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100\%; \
        parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB; \
        parted /dev/nvme0n1 -- set 3 esp on; \
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

# WARNING: This wipes ALL data
partition-and-mount:
    #!/bin/sh
    set -euxo pipefail
    read -p "This is going to wipe all data on the disk and partition it. Do you wish to continue? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        just partition
        sleep 1
        just make-fs
        sleep 1
        mount
    fi


[private]
partition:
    yes | parted /dev/nvme0n1 -- mklabel gpt
    parted /dev/nvme0n1 -- mkpart root ext4 512MB -8GB
    parted /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100\%
    parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
    parted /dev/nvme0n1 -- set 3 esp on

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
