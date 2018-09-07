## Containerization

In this paragraph you will find guidelines on how to build and run an `Electra` with [Docker](https://www.docker.com/).

### Building an Electra docker image

In order to build an `Electra` docker image you can issue the following command:

```bash
docker build -t electracoin/electra:1.2.0-headless .
```  

### Running Electra with docker

> In this paragraph is assumed you have a docker up and running on the host you want to run `Electra` on. If you don't please follow: [get-docker](https://www.docker.com/get-docker).

The `Electra` team will periodically release `Electra` docker images on the [Electra docker hub](https://hub.docker.com/r/electracoin/electra/).

You can download and run a docker `Electra` image with the following commands:

```bash
docker pull electracoin/electra:1.2.0-headless
docker run -d -v ~/.Electra:/root/.Electra -p 5788:5788 -p 5817:5817 electracoin/electra:1.2.0-headless
```  

Please note that in order to run the example above you will require an `Electra.conf` in the folder `~/.Electra`. You can copy the `Electra.conf` available in this
repository.

If you want to run the latest and greatest `Electra` you will have to build the docker image following instructions as per previous paragraph and then run the image. E.g.

```bash
docker build -t electracoin/electra:1.2.0-headless .
docker run -d -v ~/.Electra:/root/.Electra -p 5788:5788 -p 5817:5817 electracoin/electra:1.2.0-headless
```
