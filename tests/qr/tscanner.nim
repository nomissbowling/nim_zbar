# tscanner.nim

import unittest
import nim_zbar
import strformat, strutils

proc inQR(fpath: string, expectmsg: string): bool=
  let msgs = scan(fpath)
  if expectmsg.len > 0: check(msgs[0] == expectmsg)
  else: echo fmt"test {fpath}:{'\n'}{msgs}"
  result = true

proc run() =
  suite "test QR scanner":
    let
      fnShort = "_test_zbar_nim_short_.png"
      fnLong = "_test_zbar_nim_long_.png"
      fnBGC = "_test_zbar_nim_bgc_.png"
      fnMul = "_test_zbar_nim_mul_.png"

    test fmt"scan QR short: {fnShort}":
      const s = "testQR"
      check(inQR(fnShort, s))

    test fmt"scan QR long: {fnLong}":
      var s = "big".repeat(106) # seq[string] will be auto joined
      # echo $s.typeof # string
      check(s.len == 318)
      s = fmt"QR{s}QR"
      check(inQR(fnLong, s))

    test fmt"scan QR BGC: {fnBGC}":
      const s = "black"
      check(inQR(fnBGC, s))

    test fmt"scan QR Mul: {fnMul}":
      const s = ""
      check(inQR(fnMul, s))

run()
