module neobc.allocator;

import neobc.array;
import neobc.array_range;
import neobc.assertion;
import neobc.uniqueptr;

struct LinearAllocator {
  private Array!ubyte data;
  size_t itr = 0;

  static LinearAllocator Create(size_t len) { return LinearAllocator(len); }
  private this(size_t byteLength) {
    data = Array!ubyte.Create(byteLength);
  }

  ArrayRange!T Allocate(T)(size_t length = 1) {
    T* front = cast(T*)(data.ptr) + itr;
    T* end   = cast(T*)(data.ptr) + itr + length;
    itr += length * T.sizeof;
    EnforceAssert(itr <= data.length, "Attemping to allocate too much data");
    return ArrayRange!T.Create(front, end);
  }

  size_t BytesLeft() { return data.length - itr; }

  /*
    Sets itr to 0, but does NOT actually free any memory.
    Thus a very very fast deallocation
  */
  void Clear() {
    itr = 0;
  }

  ~this() {}
}
