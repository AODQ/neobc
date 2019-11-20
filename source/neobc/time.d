module neobc.time;

import core.stdc.stdint;

uint64_t GetNsTime() {
  version(Posix) {
    import core.sys.posix.time;
    return clock() / (CLOCKS_PER_SEC / 1_000_000);
  }
}

void Sleep(size_t nanoseconds = 5) {
  import core.sys.posix.time;

  timespec requested, remainder;
  requested.tv_nsec = nanoseconds;
  requested.tv_sec = 0;

  nanosleep(&requested, &remainder);
}
