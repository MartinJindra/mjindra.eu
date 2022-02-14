# derchef.site

My personal [website](https://derchef.site) created with Hugo.
The theme that is being used is [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## Building

To build the website [Hugo](https://gohugo.io/getting-started/installing/#quick-install) has to be installed.

### Windows

Follow the instructions on the [Hugo website](https://gohugo.io/getting-started/installing#windows)

### MacOS

Install Hugo with `brew`.

```
brew install hugo
```

If `brew` is not installed run this command.

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

If you don't want to use `brew` follow these [instructions](https://gohugo.io/getting-started/installing#install-hugo-from-tarball).

### Archlinux-based linux distributions

```
sudo pacman -Sy hugo git
```

### Debian 10+ / Ubuntu 20.04+

```
sudo apt update
sudo apt install hugo git
```

### Fedora

```
sudo dnf update
sudo dnf install hugo git
```

Clone the repository recursively to use the theme as a submodule.
Change the working directory.

```
git clone https://git.derchef.site/derchef/derchef.site.git --recursive
cd derchef.site
```

Build the site.

```
hugo
```

In the newly created directory [public](public) you can see the html and js files.

Or serve the site so that you can visit the site on [localhost:1313](localhost:1313).

```
hugo server
```
