# Diego's dotfiles

These are my dotfiles. To learn more about dotfiles, see the
[awesome dotfiles list](https://github.com/webpro/awesome-dotfiles).

**⚠️ Before using this project:**

- These scripts are intended for **macOS** and will not work on Linux or Windows WSL.
- Use and remix at your own risk.
- Check the script sources, understand what they do, and see if it applies to
  your system and tastes.

## Installation

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dfernandez79/dotfiles/main/setup.sh)"
```

It will use [Homebrew bundle](https://github.com/Homebrew/homebrew-bundle)
to install Homebrew packages, macOS applications, and VSCode plugins.

The script will ask for your admin password multiple times during the installation.
Before running it, please check the script source, and **never run the bash+curl mindlessly**.

Some applications in the Apple Store bundle are paid and may only be installed if you
purchased them. If an installation fails, ignore it, and the script will continue.

## [Chezmoi](https://www.chezmoi.io/) Quick Reference

Edit the source state:

```shell
chezmoi edit ~/.zshrc
```

See what changes chezmoi would make:

```shell
chezmoi diff
```

Apply the changes:

```shell
chezmoi -v apply
```

Change to the chezmoi directory:

```shell
chezmoi cd
```
