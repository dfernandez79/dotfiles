# Diego's dotfiles

These are my personal dotfiles. To learn more about dotfiles see the [awesome dotfiles list](https://github.com/webpro/awesome-dotfiles).

**⚠️ Before using this project:**

- Use and remix at your own risk.
- Check the script sources, understand what they do, and see if it applies to your system and tastes.
- These scripts are intended for macOS

## Installation

1. You'll need to have `git` and the Xcode Command Line Tools installed (macOS will prompt to install the tools the first time you use `git`)
2. Clone this repo
3. Run `./install-tools.sh` to install Homebrew and other tools
4. Run `./install-dotfiles.sh` to write the configuration in your home (the old files are stored in `./backup` using git, so you can rollback to previous versions)

## Personal preferences in these files

- I tried to keep it small and simple. There are many tools to handle dotfiles, but at the moment I don't need the extra functionality (and complexity).
- I use the popular [oh-my-zsh](https://ohmyz.sh/) framework.
- I use [starship](https://starship.rs/) prompt, because is faster than [spaceship zsh](https://github.com/spaceship-prompt/spaceship-prompt).
- I use [nvm](https://github.com/nvm-sh/nvm) to manage Node versions.
- I prefer to manually install Yarn 1.x because the Homebrew formula usually tries to install Node (clashing with nvm)
- I don't do much Python development, but I found that [pyenv](https://github.com/pyenv/pyenv) saves me from the madness of Python versions in macOS.
- I don't symlink configuration files to this repo: I prefer to manually run `./install-dotfiles`
