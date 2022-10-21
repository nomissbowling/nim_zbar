# scanner.nim

import qrutils, ./private/nimstdvector, ./private/qrcommon
import strutils

proc scan*(gr: QRimage): seq[string]=
  # expects gr is a 1ch grayscale
  var detect: QRdetect
  detect.vecmsgs = newVector[ptr char]()
  detect.num = gr.scanQR(detect) # pass 1
  detect.lens = newSeq[cint](detect.num)
  discard gr.scanQR(detect) # pass 2
  detect.msgs = newSeq[seq[char]](detect.num)
  for i in 0..<detect.num:
    detect.msgs[i] = newSeq[char](detect.lens[i]) # without '\0' terminator
    detect.vecmsgs.pushBack(detect.msgs[i][0].addr)
  discard gr.scanQR(detect) # pass 3
  result = newSeq[string](detect.num)
  for i in 0..<detect.num:
    result[i] = detect.msgs[i].join

proc scan*(fpath: string): seq[string]=
  var qri: QRimage
  discard qri.load(fpath)
  result = scan(qri.toGray)
