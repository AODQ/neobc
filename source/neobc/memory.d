module neobc.memory;

T* Allocate(T)(size_t count = 1) {
  import core.stdc.stdlib;
  return cast(T*)calloc(count, T.sizeof * count);
}
