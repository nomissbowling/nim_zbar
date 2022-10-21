# repos.nim

import os

template getReposDir*(): auto =
  # let (fPath, lineno, columnno) = instantiationInfo(-1, true) # fullPath=true
  let fPath = currentSourcePath
  # fPath.splitFile().dir # must 'import os' on the caller to use this style
  os.splitFile(fPath).dir

# echo instantiationInfo(-1, true) # not get filename (must be in the template)
