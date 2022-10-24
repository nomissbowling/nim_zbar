# tscanner.nim

import unittest
import nim_zbar
import ../../qr/private/[nimstdvector, nimstdstring]
import strformat, strutils

proc expand(vvpts: Vector[Vector[QRpoint]]): string=
  var r = @[fmt"vvpts: {vvpts.size}"]
  for it in vvpts.begin..<vvpts.end:
    let vpts: Vector[QRpoint] = it[] # must assgin to accessing type
    r.add(fmt" vpts: {vpts.size}")
    for pt in vpts.begin..<vpts.end:
      r.add(fmt"{$pt[]}")
  result = r.join("\n")

proc inQR(fpath: string, expectmsg: string): bool=
  let qrd = scan(fpath)
  var
    typs = newSeq[string](qrd.vtyps.size)
    msgs = newSeq[string](qrd.vmsgs.size)
    k = 0
  for it in qrd.vtyps.begin..<qrd.vtyps.end:
    typs[k] = $it[].cStr
    check(typs[k] == "QR-Code")
    k += 1
  k = 0
  for it in qrd.vmsgs.begin..<qrd.vmsgs.end:
    msgs[k] = $it[].cStr
    k += 1
  if expectmsg.len > 0: check(msgs[0] == expectmsg)
  else: echo fmt"test {fpath}:{'\n'}{typs}{'\n'}{msgs}{'\n'}{qrd.vvpts.expand}"
  result = true

proc run() =
  suite "test QR scanner":
    let
      fnShort = "res/_test_zbar_nim_short_.png"
      fnLong = "res/_test_zbar_nim_long_.png"
      fnBGC = "res/_test_zbar_nim_bgc_.png"
      fnMul = "res/_test_zbar_nim_mul_.png"

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
