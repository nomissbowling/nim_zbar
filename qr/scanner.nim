# scanner.nim

import qrutils, ./private/qrcommon
import stdnim

proc scan*(gr: QRimage): StdVector[QRdetect]=
  # expects gr is a 1ch grayscale
  discard gr.scanQR(result)

proc scan*(fpath: string): StdVector[QRdetect]=
  var qri: QRimage
  discard qri.load(fpath)
  result = scan(qri.toGray)
