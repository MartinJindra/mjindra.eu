# mjindra.eu

Everyone needs a personal website nowadays and I created mine with hugo. To visit it follow [www.mjindra.eu]](https://www.mjindra.eu).

## Credit

The theme that I am using is [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod).

## how to build the site

### dependencies

Install the following dependencies on your system.

1. [Hugo](https://gohugo.io/getting-started/installing/#quick-install)
2. [Docker](https://docs.docker.com/engine/install/)
3. [Docker Compose](https://docs.docker.com/compose/install/)
4. [make](https://www.gnu.org/software/make/)

### building

To build the needed files execute in the project directory.

```
make build
```

In the newly created directory [public](public) you can see the html and js files.

If you only want to preview the website.

```
make serve
```

### deployment

The deployment of the website is done by Docker. All the important configurations is done in [config.yaml](config.yaml).

To checkout how a sample website would look execute and visit [http://localhost](http://localhost).

```
make up
```

### shutting down

To shutdown all running services execute.

```
make down
```

