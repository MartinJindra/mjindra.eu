# derchef.site

My personal [website](https://derchef.site) created with Hugo.
The theme that is being used is [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## how to build the site

### dependencies

Install the following dependencies on your system.

1. [Hugo](https://gohugo.io/getting-started/installing/#quick-install)
2. [Docker](https://docs.docker.com/engine/install/)

### building

Clone the repository recursively to also download the hugo theme.

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
