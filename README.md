# rpi-helm

Couldn't find a recent arm build of tiller :)

Dockerfile contains an attempt to build native arm, but pulling glide dependencies crashes fails and even crashes the pi on most attempts

## Workaround macOS

```bash
brew install go
PATH=$PATH:$HOME/go/bin/
mkdir -p $HOME/go/src/k8s.io/helm
cd $HOME/go/src/k8s.io/helm
git clone --branch v${VERSION} --depth 1 https://github.com/kubernetes/helm.git 
make clean bootstrap build-cross dist APP=tiller VERSION=${VERSION} TARGETS=linux/arm
cd _dist/linux-arm/

cat <<EOF > Dockerfile
FROM debian:jessie-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*
ENV HOME /tmp

ADD tiller /

EXPOSE 44134

CMD ["/tiller"]
EOF
export DOCKER_HOST=tcp://raspberrypi.lan:2376 DOCKER_TLS_VERIFY=1
docker build .
```