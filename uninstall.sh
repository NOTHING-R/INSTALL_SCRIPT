#!/bin/bash

echo "⚠️ WARNING: This will remove almost everything except core system packages!"
read -p "Are you sure you want to proceed? (yes/no): " confirm

if [[ "$confirm" == "yes" ]]; then
    echo "🔧 Starting system cleanup..."
    sudo pacman -Rns $(pacman -Qq | grep -v -E "^(linux|linux-firmware|systemd|bash|coreutils|pacman|filesystem)$")
    echo "✅ Uninstallation complete. System is now minimal (TTY only)."
else
    echo "❌ Operation cancelled."
fi
