module neobc.assertion;

import core.stdc.stdint;
import core.stdc.stdio;

void EnforceAssert(
  T
, string PF = __PRETTY_FUNCTION__
, string FP = __FILE_FULL_PATH__
, int LC = __LINE__
)(
  T status, string err = ""
) {
  if (cast(bool)status) return;
  import core.stdc.stdlib;
  import core.stdc.signal;

  printf(
    "%s assert failed: %s: %s ; %d: %s\n", "\033[0;31m".ptr
  , FP.ptr, PF.ptr, LC, err.ptr
  );

  raise(SIGABRT);
  exit(-1);
}
