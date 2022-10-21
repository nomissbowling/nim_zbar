# tQR.nim
#
# nim cpp -d:release -r nim_zbar/tests/tQR

{.push warning[ProveInit]: off .}

import qr/[tgenerator, tscanner]

{. pop .}
