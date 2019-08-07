module neobc.time;

import core.stdc.stdint;

uint64_t GetNsTime() {
  version(Posix) {
    import core.sys.posix.time;
    return clock() / (CLOCKS_PER_SEC / 1_000_000);
  }
}
