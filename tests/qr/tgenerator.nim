# tgenerator.nim

import unittest
import nim_zbar
import strformat, strutils

proc dumps*(qr: QRmap): string=
  var r = @[""]
  for y in 0..<qr.sz:
    for x in 0..<qr.sz:
      r.add(if qr.p[y * qr.sz + x] == '*': "  " else: "■") # reverse B/W
    r.add("\n")
  result = r.join

proc outQR(msg: string, expectsz: int,
  fn: string, border: int, scale: int, fgc: RGBA, bgc: RGBA=newRGBA()): bool=
  let qr = gen(msg)
  check(qr.sz == expectsz)
  check(qr.deco(border, scale, fgc, bgc).save(fn))
  # echo fmt"QR size: {qr.sz:06d}"
  # echo qr.dumps
  result = true

proc run() =
  suite "test QR generator":
    let
      bgc = newRGBA(0xff99cc33'u32) # ABGR
      fnShort = "res/_test_zbar_nim_short_.png"
      fnLong = "res/_test_zbar_nim_long_.png"
      fnBGC = "res/_test_zbar_nim_bgc_.png"

    test fmt"generate QR short: {fnShort}":
      const s = "testQR"
      check(outQR(s, 21, fnShort, 2, 16, newRGBA(0xcc, 0x99, 0x33, 0xff)))

    test fmt"generate QR long: {fnLong}":
      var s = "big".repeat(106) # seq[string] will be auto joined
      # echo $s.typeof # string
      check(s.len == 318)
      s = fmt"QR{s}QR"
      check(outQR(s, 69, fnLong, 1, 5, newRGBA(0x66, 0x33, 0xcc, 0xff)))

    test fmt"generate QR BGC: {fnBGC}":
      const s = "black"
      check(outQR(s, 21, fnBGC, 2, 16, newRGBA(0x00, 0x00, 0x00, 0xff), bgc))

run()
