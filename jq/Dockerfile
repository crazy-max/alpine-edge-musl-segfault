# syntax=docker/dockerfile:1

FROM scratch AS alpine-musl
FROM --platform=$BUILDPLATFORM alpine:3.18 AS build-riscv64
RUN apk add --no-cache file bash clang lld musl-dev pkgconfig git make go
COPY --link --from=tonistiigi/xx:1.2.1 / /
ARG TARGETPLATFORM
COPY --from=alpine-musl / /root/packages
RUN xx-apk add --allow-untrusted /root/packages/main/riscv64/*.apk
RUN xx-apk add gcc jq-dev oniguruma-dev
WORKDIR /src
RUN --mount=type=bind,source=.,rw \
  CGO_ENABLED=1 xx-go build -ldflags '-v -extldflags -static' -o ./jq && \
  file ./jq

FROM --platform=$BUILDPLATFORM alpine:3.18 AS build-musl-r1
COPY --from=alpine-musl / /root/packages
RUN apk add --allow-untrusted /root/packages/main/x86_64/*.apk
RUN apk add --no-cache file bash clang lld pkgconfig git make go
COPY --link --from=tonistiigi/xx:1.2.1 / /
ARG TARGETPLATFORM
RUN xx-apk add --allow-untrusted /root/packages/main/riscv64/*.apk
RUN xx-apk add gcc jq-dev oniguruma-dev
WORKDIR /src
RUN --mount=type=bind,source=.,rw \
  CGO_ENABLED=1 xx-go build -ldflags '-v -extldflags -static' -o ./jq && \
  file ./jq

FROM --platform=$BUILDPLATFORM alpine:3.18
RUN apk add --no-cache file bash clang lld musl-dev pkgconfig git make go
COPY --link --from=tonistiigi/xx:1.2.1 / /
ARG TARGETPLATFORM
RUN xx-apk add musl-dev gcc jq-dev oniguruma-dev
WORKDIR /src
RUN --mount=type=bind,source=.,rw \
  CGO_ENABLED=1 xx-go build -ldflags '-extldflags -static' -o ./jq && \
  file ./jq
