# qrcommon.nim
#
# TODO: const zbardll and const zbarlib only for windows

# git submodule add https://github.com/mchehab/zbar.git qr/private/zbar
# git submodule add https://github.com/nayuki/QR-Code-generator.git qr/private/qrcodegenerator

import repos
import ../qrutils
import stdnim
import strformat

const reposdir = getReposDir # here
const zbardll = fmt"{reposdir}/bin/libzbar-64.dll" # for windows
const zbarlib = fmt"{reposdir}/lib/libzbar-64.lib" # for windows
const zbardir = fmt"{reposdir}/zbar/include" # zbar.h
const qrcodegendir = fmt"{reposdir}/qrcodegenerator/cpp" # qrcodegen.hpp
const qrcodegensrc = fmt"{qrcodegendir}/qrcodegen.cpp"

{.push stackTrace: off.}
{.passL: fmt"{zbarlib}"} # or --passL:.../lib/libzbar-64.lib at compile
{.passC: fmt"-I{zbardir}"}
{.passC: fmt"-I{qrcodegendir}"}
{.emit: staticRead(qrcodegensrc) .}
{.emit: """
#define UNICODE
#define _UNICODE
#include <wchar.h>

#include <iomanip>
#include <iostream>
#include <sstream>
#include <map>
#include <vector>
#include <string>

#include <stdexcept>
#include <exception>

#include <ctime>

#include <qrcodegen.hpp>
#include <zbar.h>

#define DISP_INFO_ZBAR 0

using namespace std;
using namespace qrcodegen;
using SymbolIterator = zbar::Image::SymbolIterator;

int CgenQR(char *buf, char *msg)
{
  QrCode qr = QrCode::encodeText(msg, QrCode::Ecc::MEDIUM);
  int sz = qr.getSize();
  if(buf){ // buf >= char[sz * sz]
    for(int y = 0; y < sz; ++y)
      for(int x = 0; x < sz; ++x)
        buf[y * sz + x] = qr.getModule(x, y) ? '*' : ' ';
  }
  return sz;
}

typedef struct {int x; int y;} CQRPOINT;
typedef struct {string typ; string msg; vector<CQRPOINT> loc;} CQRDETECT;

int CscanQR(vector<CQRDETECT> *pvdetect,
  int ch, int w, int h, unsigned char *px)
{
  zbar::Image q(w, h, "Y800", (unsigned char *)px, w * h);
  zbar::ImageScanner scanner;
  scanner.set_config(zbar::ZBAR_NONE, zbar::ZBAR_CFG_ENABLE, 1);
  int n = scanner.scan(q); // must scan at least once even if not use n
#if DISP_INFO_ZBAR > 0
  fprintf(stdout, "found: %d\n", n);
#endif
  for(SymbolIterator it = q.symbol_begin(); it != q.symbol_end(); ++it){
    string typ = it->get_type_name(); // can not use char *typ = *.c_str();
    string msg = it->get_data(); // can not use char *msg = *.c_str();
    int m = it->get_location_size();
#if DISP_INFO_ZBAR > 0
    fprintf(stdout, "decoded [%s]\n symbol [%s]\n", typ.c_str(), msg.c_str());
    fprintf(stdout, "location_size: %d\n", m);
#endif
    pvdetect->push_back(CQRDETECT{typ, msg, vector<CQRPOINT>(m)});
    CQRDETECT &detect = pvdetect->at(pvdetect->size() - 1);
    vector<CQRPOINT> &vp = detect.loc;
    for(int i = 0; i < m; ++i)
      vp[i] = CQRPOINT{it->get_location_x(i), it->get_location_y(i)};
  }
  return 0;
}
""".}
{.pop.}

proc cgenQR(p: ptr char; msg: cstring): cint {.importcpp: "CgenQR(@)", nodecl.}
# proc cgenQR(p: ptr char; msg: cstring): cint {.importcpp: "CgenQR(@)".} # OK

proc cscanQR(pvdetect: pointer,
  ch, w, h: cint; px: ptr uint8): cint
  {.importcpp: "CscanQR(@)", nodecl.}
# proc cscanQR(pvdetect: pointer
#   ch, w, h: cint; px: ptr uint8): cint
#   {.importcpp: "CscanQR(@)".} # OK

proc genQR*(qr: var QRmap; msg: cstring): int=
  qr.sz = cgenQR(if qr.p.len == 0: nil else: qr.p[0].unsafeAddr, msg)
  result = qr.sz

proc scanQR*(gr: QRimage; vdetect: var StdVector[QRdetect]): int=
  # expects gr is a 1ch grayscale
  assert gr.ch == 1
  result = cscanQR(vdetect.addr,
    gr.ch.cint, gr.w.cint, gr.h.cint, gr.px[0].unsafeAddr)
