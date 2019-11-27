module neobc.array;

import core.stdc.stdio;
import core.stdc.stdlib;
import core.stdc.string;
import neobc.array_range;
static import neobc.arrayview;

// Idiom from Randy Schutt
mixin template RvalueRef() {
    @nogc @safe ref const(typeof(this)) byRef() const pure nothrow return {
        return this;
    }
}

struct Array(T) {
  private T* data = null; // Must be T[] so default state is an empty array
  private size_t dataLength = 0;

  private static T* AllocateMemory(size_t length) {
    T* ptr = cast(T*)calloc(length, T.sizeof);
    return ptr;
  }

  private static void FreeMemory(void* ptr) {
    if (ptr == null) { printf("Trying to free nullptr!\n"); return; }
    free(ptr);
  }

  private void Construct(size_t _dataLength) {
    dataLength = _dataLength;

    data = AllocateMemory(dataLength);
  }

  static Array!T Create(U...)(U args) {
    Array!T array;
    array.Construct(args.length);
    foreach (it, i; args)
      array.data[it] = cast(T)i;
    return array;
  }

  this(size_t _dataLength) {
    if (_dataLength == 0) return;
    Construct(_dataLength);
  }

  this (size_t _dataLength, inout(T)* srcData) {
    if (_dataLength == 0) return;
    Construct(_dataLength);
    memcpy(cast(void*)data, cast(void*)srcData, byteLength);
  }

  ~this() {
    FreeMemory(cast(void*)data);
  }

  this(ref return scope inout(Array!T) other) {
    Construct(other.dataLength);
    memcpy(cast(void*)data, cast(void*)other.data, other.byteLength);
  }

  void Clear() {
    if (data != null)
      FreeMemory(cast(void*)data);
    data = null;
    dataLength = 0;
  }

  T * ptr() { return data; }
  inout(T) * ptr() inout { return data; }

  size_t byteLength() inout {
    return T.sizeof * dataLength;
  }
  size_t length() inout { return dataLength; }
  void length(size_t length) { Resize(length); }

  size_t opDollar() inout { return dataLength; }
  ref T opIndex(size_t idx) {
    debug {
      if (idx < 0 || idx >= dataLength) {
        import core.stdc.stdio;
        import core.stdc.signal;
        printf("Index out of range (%lu) for [0 .. %lu]\n", idx, dataLength-1);
        raise(SIGABRT);
        exit(-1);
      }
    }
    return data[idx];
  }

  void Resize(size_t newLength) {
    // TODO make realloc work
    //      if data.ptr is null this won't work
    // T* dataPtr = cast(T*)realloc(cast(void*)data.ptr, T.sizeof * newLength);
    // until then just do this

    // allocate data
    T * newData = AllocateMemory(newLength);

    // copy old contents & free if appropiate
    if (data != null) {
      size_t copyLength = dataLength > newLength ? newLength : dataLength;
      memcpy(cast(void*)newData, cast(void*)data, copyLength * T.sizeof);

      FreeMemory(cast(void*)data);
    }

    // store
    data = AllocateMemory(newLength);
    memcpy(cast(void*)data, cast(void*)newData, newLength * T.sizeof);
    dataLength = newLength;
  }

  /* Appends T(), then assigns T.Construct to it, which allows an append w/o a
   * destructor call on actual useful information */
  T* ConstructAppend()() if (__traits(hasMember, T, "Construct")) {
    this ~= T();
    this[$-1] = T.Construct;
    return &this[$-1];
  }

  void opOpAssign(string op : "~")(T rhs) {
    Resize(dataLength + 1);
    data[dataLength-1] = rhs;
  }

  void opOpAssign(string op : "~")(ref T rhs) {
    Resize(dataLength + 1);
    data[dataLength-1] = rhs;
  }

  void opOpAssign(string op)(ref Array!T rhs) if ( op == "~" ) {
    Resize(dataLength + rhs.dataLength);
    foreach ( size_t i; 0 .. rhs.dataLength ) {
      data[originDataLength + i] = rhs[i];
    }
  }

  neobc.ArrayView AsView() {
    return neobc.ArrayView.Construct(dataLength, cast(void*)data);
  }

  ArrayRange!T AsRange() {
    return ArrayRange!T.Create(data, data + dataLength);
  }

  ArrayRange!(immutable T) AsRange() immutable {
    return ArrayRange!(immutable T).Create(data, data + dataLength);
  }

  mixin RvalueRef;
}
