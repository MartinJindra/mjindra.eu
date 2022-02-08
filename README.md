# derchef.site

My personal [website](https://derchef.site) created with Hugo.
The theme that is being used is [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## Building

To build the website [hugo](https://gohugo.io/getting-started/installing/#quick-install) has to be installed.

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

Clone the repository with the theme as a submodule.
Change the current directory it.

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
