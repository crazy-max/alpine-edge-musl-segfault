group "default" {
  targets = ["build"]
}

target "build" {
  output = ["type=cacheonly"]
  contexts = {
    alpine-musl = "../aports-musl/packages"
  }
}

target "build-cross" {
  inherits = ["build"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
    "linux/ppc64le",
    "linux/riscv64",
    "linux/s390x"
  ]
}

target "build-riscv64" {
  inherits = ["build"]
  target = "build-riscv64"
  platforms = ["linux/riscv64"]
}

target "build-musl-r1" {
  inherits = ["build"]
  target = "build-musl-r1"
  platforms = ["linux/riscv64"]
}
