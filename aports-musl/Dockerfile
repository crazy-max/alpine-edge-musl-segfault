FROM alpine:edge AS build
RUN apk add bash alpine-sdk sudo su-exec git tree file
RUN adduser -D packager
RUN addgroup packager abuild
RUN echo "packager ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER packager
RUN abuild-keygen -a -i -n
WORKDIR /home/packager/aports
RUN git init . && git remote add origin https://github.com/alpinelinux/aports.git
# https://github.com/alpinelinux/aports/commit/79b42d15d9185e13d55e1738699094e9263f6fc0
RUN git fetch -q --depth 1 origin 79b42d15d9185e13d55e1738699094e9263f6fc0 && git checkout -q FETCH_HEAD
WORKDIR /home/packager/aports/main/musl
RUN abuild -r
RUN tree /home/packager/packages

FROM scratch
COPY --from=build /home/packager/packages /
