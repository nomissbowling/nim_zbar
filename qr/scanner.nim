# scanner.nim

import qrutils, ./private/[qrcommon, nimstdvector]

proc scan*(gr: QRimage): Vector[QRdetect]=
  # expects gr is a 1ch grayscale
  discard gr.scanQR(result)

proc scan*(fpath: string): Vector[QRdetect]=
  var qri: QRimage
  discard qri.load(fpath)
  result = scan(qri.toGray)
