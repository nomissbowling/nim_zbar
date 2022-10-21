mode = ScriptMode.Verbose

packageName   = "nim_zbar"
version       = "0.0.1"
author        = "nomissbowling"
description   = "QR code generator scanner"
license       = "MIT"
skipDirs      = @["tests", "benchmarks", "htmldocs"]
skipFiles     = @["_config.yml"]

requires "nim >= 1.0.0",
  "stb_image"

proc configForTests() =
  --hints: off
  --linedir: on
  --stacktrace: on
  --linetrace: on
  --debuginfo
  --path: "."
  --run

proc configForBenchmarks() =
  --define: release
  --path: "."
  --run

task test, "run tests":
  configForTests()
  setCommand "c", "tests/tQR.nim"

task testQR, "run QR tests":
  configForTests()
  setCommand "c", "tests/tQR.nim"

task benchmark, "run benchmarks":
  configForBenchmarks()
  setCommand "c", "benchmarks/bQR.nim"

task docs, "generate documentation":
  exec("mkdir -p htmldocs/nim_zbar")
  --project
  --git.url: "https://github.com/nomissbowling/nim_zbar"
  --git.commit: master
  setCommand "doc", "nim_zbar.nim"
