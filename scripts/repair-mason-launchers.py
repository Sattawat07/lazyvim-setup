#!/usr/bin/env python3
"""Repair npm launchers that can be broken when Mason runs across WSL mounts."""

from __future__ import annotations

import json
import os
from pathlib import Path
import platform
import subprocess


MASON = Path.home() / ".local" / "share" / "nvim" / "mason"
BIN = MASON / "bin"
PACKAGES = MASON / "packages"

LAUNCHERS = {
    "ansible-language-server": "ansible-language-server/node_modules/@ansible/ansible-language-server/dist/cli.cjs",
    "docker-compose-langserver": "docker-compose-language-service/node_modules/@microsoft/compose-language-service/bin/docker-compose-langserver",
    "docker-langserver": "dockerfile-language-server/node_modules/dockerfile-language-server-nodejs/bin/docker-langserver",
    "eslint_d": "eslint_d/node_modules/eslint_d/bin/eslint_d.js",
    "markdown-toc": "markdown-toc/node_modules/markdown-toc/cli.js",
    "markdownlint-cli2": "markdownlint-cli2/node_modules/markdownlint-cli2/markdownlint-cli2-bin.mjs",
    "oxlint": "oxlint/node_modules/oxlint/bin/oxlint",
    "vscode-eslint-language-server": "eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server",
    "vscode-json-language-server": "json-lsp/node_modules/vscode-langservers-extracted/bin/vscode-json-language-server",
}


def repair_oxlint_binding() -> None:
    if platform.machine() not in {"x86_64", "AMD64"}:
        return
    oxlint_bin = BIN / "oxlint"
    if not oxlint_bin.exists() and not oxlint_bin.is_symlink():
        return
    check = subprocess.run(
        [str(oxlint_bin), "--version"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    if check.returncode == 0:
        return

    package_dir = PACKAGES / "oxlint"
    package_json = package_dir / "node_modules" / "oxlint" / "package.json"
    if not package_json.exists():
        return
    version = json.loads(package_json.read_text(encoding="utf-8"))["version"]
    subprocess.run(
        [
            "npm",
            "install",
            "--no-save",
            "--ignore-scripts",
            "--os=linux",
            "--cpu=x64",
            f"@oxlint/binding-linux-x64-gnu@{version}",
        ],
        cwd=package_dir / "node_modules" / "oxlint",
        check=True,
    )


def repair_launchers() -> None:
    for command, relative_target in LAUNCHERS.items():
        launcher = BIN / command
        target = PACKAGES / relative_target
        if not target.exists() or (not launcher.exists() and not launcher.is_symlink()):
            continue

        try:
            resolved = launcher.resolve(strict=True)
            content = resolved.read_text(encoding="utf-8", errors="ignore")
        except (OSError, UnicodeError):
            continue

        is_npm_shim = content.startswith("#!/bin/sh") and "basedir" in content
        is_our_wrapper = "LazyVim setup Mason wrapper" in content
        if not is_npm_shim and not is_our_wrapper:
            continue

        if launcher.is_symlink():
            launcher.unlink()
        launcher.write_text(
            "#!/bin/sh\n"
            "# LazyVim setup Mason wrapper\n"
            f"exec node {json.dumps(str(target))} \"$@\"\n",
            encoding="utf-8",
        )
        os.chmod(launcher, 0o755)
        print(f"repaired {command}")


if __name__ == "__main__":
    repair_oxlint_binding()
    repair_launchers()
    print("Mason launcher check complete")
