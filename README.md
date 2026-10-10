# Sattawat07 LazyVim Setup

A portable Neovim configuration for Ubuntu on WSL, built with LazyVim and Mason. It supports C, C++, Python, Java, JavaScript, TypeScript, HTML, CSS, Tailwind CSS, PHP, Go, Bash, SQL, Markdown, Vue, Svelte, and more.

## Features

- TokyoNight Moon theme with transparent backgrounds
- Language servers, formatters, linters, and debuggers managed through Mason
- Run individual source files with `F5`
- Automatically save changes when leaving Insert mode or switching buffers
- Add or update a 42 Header with `F1`
- Share the Windows clipboard from inside WSL
- Open the current HTML file in a Windows browser with `F5`
- Safer HTML and JavaScript language server settings to prevent freezes

## Installation

Open Ubuntu or another WSL distribution and run:

```bash
git clone https://github.com/Sattawat07/lazyvim-setup.git ~/.config/nvim
cd ~/.config/nvim
chmod +x install.sh
./install.sh
```

The installer sets up the required system packages, Node.js, Neovim, Lazy plugins, and Mason tools. After it finishes, open a new shell and run:

```bash
nvim
```

## Icons and terminal font

LazyVim uses Nerd Font icons for file types, folders, the dashboard, diagnostics, and the status line. The installer installs **JetBrainsMono Nerd Font** and configures Windows Terminal automatically. Windows may display a UAC prompt during this step.

Close every Windows Terminal window and open it again after installation. If the icons still appear as squares or diamonds, run this from WSL:

```bash
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w ~/.config/nvim/scripts/setup-windows-terminal.ps1)"
```

## Key bindings

| Key | Action |
| --- | --- |
| `F5` | Run the current file |
| `F1` | Add or update the 42 Header |
| `Ctrl+/` | Toggle the terminal |
| `Space e` | Open the file explorer |
| `Space ff` | Find files |
| `:Mason` | View and manage language tools |
| `:Lazy` | View and manage plugins |

## 42 Header configuration

The default identity is configured in `lua/plugins/42header.lua`:

- Username: `sbontem`
- Email: `sboontem@student.42bangkok.com`

Update these values to match your own 42 account before using the configuration.

## Wallpaper

The moon wallpaper is included at `assets/moonlit-lake.png`. Set it as the Windows Terminal background image and adjust the opacity to your preference.

## Updating

```bash
cd ~/.config/nvim
git pull
nvim --headless "+Lazy! sync" +qa
```

This setup is designed for Ubuntu on WSL. Most features also work on native Linux, but clipboard integration and opening HTML files depend on the operating system.

## Credits

This configuration was originally cloned from [Golden-Husky](https://github.com/Golden-Husky) and then customized and expanded for this setup. Thank you to Golden-Husky for the original foundation.
