module neobc.uniqueptr;

import neobc.assertion;

import core.stdc.stdlib;

struct UniquePtr(T) {
  private T* data = null;

  static UniquePtr!T Create() {
    UniquePtr!T uniquePtr;
    EnforceAssert(
      uniquePtr.data == null
    , "Trying to create unique ptr, but unique ptr's data already exists"
    );

    uniquePtr.data = cast(T*)malloc(T.sizeof);
    return uniquePtr;
  }

  T*            ptr() { return data; }
  immutable(T)* ptr() { return cast(immutable)data; }

  bool Valid() { return data != null; }

  void Free() {
    if (data != null)
      free(data);
    data = null;
  }
  ~this() { Free(); }
}
