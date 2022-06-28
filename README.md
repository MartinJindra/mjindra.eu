# mjindra.eu

Everyone needs a personal website nowadays and I created mine with hugo. To visit it follow [www.mjindra.eu](https://www.mjindra.eu).

## Credit

The theme that I am using is [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod).

## how to build the site

### dependencies

Install the following dependencies on your system.

1. [docker](https://docs.docker.com/engine/install/) and [docker-compose](https://docs.docker.com/compose/install/)
2. [hugo](https://gohugo.io/getting-started/installing/) (not needed for building)
3. [make](https://www.gnu.org/software/make/)

### building

To build the needed files execute in the project directory.

```
make build
```

In the newly created directory [public](public) you can see the HTML and JavaScript files.

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

