group "default" {
  targets = ["build"]
}

target "build" {
  output = ["type=cacheonly"]
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
  contexts = {
    alpine-musl = "../aports-musl/packages"
  }
}
