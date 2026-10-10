#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
local_bin="$HOME/.local/bin"
local_opt="$HOME/.local/opt"
timestamp="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$local_bin" "$local_opt" "$(dirname -- "$config_dir")"

sudo apt-get update
sudo apt-get install -y \
  build-essential ca-certificates curl fd-find git golang-go \
  openjdk-21-jdk php-cli python3 python3-pip python3-venv \
  ripgrep unzip xz-utils

case "$(uname -m)" in
  x86_64) node_arch="x64"; nvim_archive="nvim-linux-x86_64.tar.gz" ;;
  aarch64|arm64) node_arch="arm64"; nvim_archive="nvim-linux-arm64.tar.gz" ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

node_major=0
if command -v node >/dev/null 2>&1; then
  node_major="$(node --version | sed -E 's/^v([0-9]+).*/\1/')"
fi

if (( node_major < 20 )); then
  node_version="$(curl -fsSL https://nodejs.org/dist/latest-v24.x/SHASUMS256.txt | sed -nE 's/.*node-(v[0-9.]+)-linux-.*$/\1/p' | head -n1)"
  node_tmp="$(mktemp -d)"
  node_file="node-${node_version}-linux-${node_arch}.tar.xz"
  curl -fL "https://nodejs.org/dist/latest-v24.x/${node_file}" -o "$node_tmp/$node_file"
  tar -xJf "$node_tmp/$node_file" -C "$node_tmp"
  node_target="$local_opt/node-${node_version}"
  rm -rf -- "$node_target"
  mv "$node_tmp/node-${node_version}-linux-${node_arch}" "$node_target"
  rm -rf -- "$node_tmp"
  ln -sfn "$node_target/bin/node" "$local_bin/node"
  ln -sfn "$node_target/bin/npm" "$local_bin/npm"
  ln -sfn "$node_target/bin/npx" "$local_bin/npx"
fi

export PATH="$local_bin:$PATH"
if ! grep -Fq '.local/bin' "$HOME/.profile" 2>/dev/null; then
  printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.profile"
fi

if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  ln -sfn "$(command -v fdfind)" "$local_bin/fd"
fi

npm config set prefix "$HOME/.local"
npm install --global tsx

need_nvim=true
if command -v nvim >/dev/null 2>&1; then
  nvim_version="$(nvim --version | sed -nE '1s/^NVIM v([0-9]+\.[0-9]+).*/\1/p')"
  if printf '%s\n%s\n' '0.11' "$nvim_version" | sort -V -C; then
    need_nvim=false
  fi
fi

if [[ "$need_nvim" == true ]]; then
  nvim_tmp="$(mktemp -d)"
  curl -fL "https://github.com/neovim/neovim/releases/latest/download/${nvim_archive}" -o "$nvim_tmp/$nvim_archive"
  tar -xzf "$nvim_tmp/$nvim_archive" -C "$nvim_tmp"
  nvim_source="$(find "$nvim_tmp" -mindepth 1 -maxdepth 1 -type d -name 'nvim-linux-*' -print -quit)"
  nvim_target="$local_opt/neovim"
  rm -rf -- "$nvim_target"
  mv "$nvim_source" "$nvim_target"
  rm -rf -- "$nvim_tmp"
  ln -sfn "$nvim_target/bin/nvim" "$local_bin/nvim"
fi

if [[ "$(readlink -f -- "$repo_dir")" != "$(readlink -m -- "$config_dir")" ]]; then
  if [[ -e "$config_dir" || -L "$config_dir" ]]; then
    mv "$config_dir" "${config_dir}.backup-${timestamp}"
  fi
  ln -s "$repo_dir" "$config_dir"
fi

nvim --headless "+Lazy! sync" +qa
nvim --headless -c "lua require('mason').setup()" -l "$repo_dir/scripts/mason-install.lua"
python3 "$repo_dir/scripts/repair-mason-launchers.py"

if command -v powershell.exe >/dev/null 2>&1 && command -v wslpath >/dev/null 2>&1; then
  windows_setup="$(wslpath -w "$repo_dir/scripts/setup-windows-terminal.ps1")"
  powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "$windows_setup" || \
    echo "Windows Terminal font setup did not complete. Run scripts/setup-windows-terminal.ps1 manually."
fi

echo
echo "ติดตั้งเสร็จแล้ว เปิด shell ใหม่แล้วรัน: nvim"
