#FROM arm32v7/golang
FROM golang

ARG VERSION=2.7.0

WORKDIR ${GOPATH}/src/k8s.io/helm

RUN git clone --branch v${VERSION} --depth 1 https://github.com/kubernetes/helm.git . \
&& make clean bootstrap build-cross dist APP=tiller VERSION=${VERSION} TARGETS=linux/arm

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:jessie-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*
ENV HOME /tmp

#COPY --from=0 ${GOPATH}/src/github.com/kubernetes/helm/_dist/helm-${VERSION}-linux-arm.tar.gz /
#RUN tar xvzf helm-${VERSION}-linux-arm.tar.gz --strip-components 1 linux-arm/tiller \
ADD tiller /

EXPOSE 44134

CMD ["/tiller"]

    