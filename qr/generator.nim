# generator.nim

import qrutils, ./private/qrcommon

proc gen*(msg: string): QRmap=
  let sz = result.genQR(msg)
  when false:
    result.p = array[sz, array[sz, char]] # cannot evaluate at compile time
  else:
    result.p = newSeq[char](sz * sz)
  discard result.genQR(msg)
