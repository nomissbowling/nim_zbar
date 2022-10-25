# tscanner.nim

import unittest
import nim_zbar
import stdnim
import strformat, strutils

proc toStr(locs: seq[seq[QRpoint]]): string=
  var r = @[fmt"locs: {locs.len}"]
  for loc in locs:
    r.add(fmt" loc: {loc.len}")
    for pt in loc:
      r.add($pt)
  result = r.join("\n")

proc toSeq(loc: StdVector[QRpoint]): seq[QRpoint]=
  for it in loc.begin..<loc.end:
    result.add(it[])

proc inQR(fpath: string, expectmsg: string): bool=
  let qrd = scan(fpath)
  var
    typs = newSeq[string](qrd.size)
    msgs = newSeq[string](qrd.size)
    locs = newSeq[seq[QRpoint]](qrd.size)
    k = 0
  for it in qrd.begin..<qrd.end:
    let detect: QRdetect = it[] # assign to accessing type
    typs[k] = $detect.typ.cStr
    check(typs[k] == "QR-Code")
    msgs[k] = $detect.msg.cStr
    locs[k] = detect.loc.toSeq
    k += 1
  if expectmsg.len > 0: check(msgs[0] == expectmsg)
  else: echo fmt"test {fpath}:{'\n'}{typs}{'\n'}{msgs}{'\n'}{locs.toStr}"
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
