# scanner.nim

import qrutils, ./private/qrcommon

proc scan*(gr: QRimage): QRdetect=
  # expects gr is a 1ch grayscale
  discard gr.scanQR(result)

proc scan*(fpath: string): QRdetect=
  var qri: QRimage
  discard qri.load(fpath)
  result = scan(qri.toGray)
