FROM --platform=$BUILDPLATFORM golang AS builder

ARG BUILDPLATFORM
ARG FOCALBOARD_MAJOR
ARG FOCALBOARD_MINOR
ARG FOCALBOARD_INCREMENT
ARG GOARCH

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
