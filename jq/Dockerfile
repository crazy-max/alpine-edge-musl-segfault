# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM alpine:edge
RUN apk add --no-cache file bash clang lld musl-dev pkgconfig git make go
COPY --link --from=tonistiigi/xx:1.2.1 / /
ARG TARGETPLATFORM
RUN xx-apk add musl-dev gcc jq-dev oniguruma-dev
WORKDIR /src
RUN --mount=type=bind,source=.,rw \
  CGO_ENABLED=1 xx-go build -ldflags '-extldflags -static' -o ./jq && \
  file ./jq
