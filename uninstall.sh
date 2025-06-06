#!/bin/bash

echo "⚠️ WARNING: This will remove almost all packages except core system components."
read -p "Are you sure you want to proceed? (yes/no): " confirm

if [[ "$confirm" == "yes" ]]; then
    echo "🔍 Collecting packages to remove..."

    keep="linux|linux-firmware|linux-firmware-whence|systemd|bash|coreutils|pacman|filesystem|glibc|attr|acl|gmp|libcap|openssl|mkinitcpio|kmod"

    packages=$(pacman -Qq | grep -v -E "^($keep)$")

    echo "📦 Packages to be removed:"
    echo "$packages"

    if [ -z "$packages" ]; then
        echo "✅ Nothing to remove. You're already minimal."
        exit 0
    fi

    echo "🚀 Removing packages..."
    sudo pacman -Rns $packages

    echo "✅ Done. The system is now minimal (TTY only)."
else
    echo "❌ Operation cancelled by user."
    exit 1
fi
