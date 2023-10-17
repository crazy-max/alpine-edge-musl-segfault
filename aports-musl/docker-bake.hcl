group "default" {
  targets = ["build"]
}

target "build" {
  output = ["./packages"]
}
