module neobc.memory;

T* Allocate(T)(size_t count = 1) {
  import core.stdc.stdlib;
  return cast(T*)calloc(count, T.sizeof * count);
}

void Swap(T)(ref T left, ref T right) if (__traits(isIntegral, T)) {
  left  ^= right;
  right ^= left;
  left  ^= right;
}

void Swap(T)(ref T* left, ref T* right) if (!__traits(isIntegral, T)) {
  T* tmp = left;
  left   = right;
  right  = tmp;
}
