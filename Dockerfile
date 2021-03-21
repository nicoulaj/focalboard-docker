FROM golang AS builder-base

FROM builder-base AS builder-amd64
ENV GOARCH "amd64"

FROM builder-base AS builder-arm64
ENV GOARCH "arm64"

ARG TARGETARCH
ARG FOCALBOARD_MAJOR
ARG FOCALBOARD_MINOR
ARG FOCALBOARD_INCREMENT

FROM builder-$TARGETARCH AS builder

RUN apt-get update
RUN apt-get install -y npm
RUN git clone -b "v${FOCALBOARD_MAJOR}.${FOCALBOARD_MINOR}.${FOCALBOARD_INCREMENT}" --depth 1 https://github.com/mattermost/focalboard.git /focalboard
WORKDIR /focalboard
RUN sed -i "s/GOARCH=amd64/GOARCH=${GOARCH}/g" Makefile
RUN cat Makefile
RUN make prebuild
RUN make
RUN make server-linux-package
RUN tar xvzf dist/focalboard-server-*.tar.gz

FROM debian:stable-slim
COPY --from=builder /focalboard/focalboard/ /opt/focalboard/
WORKDIR /opt/focalboard
EXPOSE 8000
CMD /opt/focalboard/bin/focalboard-server
