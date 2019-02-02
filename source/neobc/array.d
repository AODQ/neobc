module neobc.array;

import core.stdc.stdio;
import core.stdc.stdlib;
import core.stdc.string;
import neobc.array_range;

// Idiom from Randy Schutt
mixin template RvalueRef() {
    @nogc @safe ref const(typeof(this)) byRef() const pure nothrow return {
        return this;
    }
}


struct Array(T) {
  private T[] data; // Must be T[] so default state is an empty array
  private size_t dataLength;

  private void Construct(size_t _dataLength) {
    dataLength = _dataLength;

    T * dataPtr = cast(T *)malloc(dataLength * T.sizeof);
    data = dataPtr[0 .. dataLength];
  }

  @disable this(this);

  this(U...)(U args) {
    Construct(args.length);
    foreach ( it, i; args )
      data[it] = cast(T)i;
  }

  this ( size_t _dataLength ) {
    if ( _dataLength == 0 ) return;
    Construct(_dataLength);
  }

  ~this () {
    free(cast(void*)data.ptr);
  }

  T * ptr ( ) { return data.ptr; }

  size_t length ( ) { return dataLength; }
  void length(size_t length) { Resize(length); }
  // TODO : void length ( size_t length )

  size_t opDollar() { return dataLength; }
  ref T opIndex(size_t idx) { return data[idx]; }

  void Resize(size_t newLength) {
    // TODO make realloc work
    //      if data.ptr is null this won't work
    // T* dataPtr = cast(T*)realloc(cast(void*)data.ptr, T.sizeof * newLength);
    // until then just do this

    T * newData = cast(T *)malloc(newLength * T.sizeof);
    memcpy(newData, data.ptr, dataLength * T.sizeof);

    free(data.ptr);

    data = newData[0 .. newLength];
    dataLength = newLength;
  }

  void opOpAssign(string op : "~")(T rhs) {
    Resize(dataLength + 1);
    data[$-1] = rhs;
  }

  void opOpAssign(string op : "~")(ref T rhs) {
    Resize(dataLength + 1);
    data[$-1] = rhs;
  }

  void opOpAssign(string op)(ref Array!T rhs) if ( op == "~" ) {
    Resize(dataLength + rhs.dataLength);
    foreach ( size_t i; 0 .. rhs.dataLength ) {
      data[originDataLength + i] = rhs[i];
    }
  }

  ArrayRange!T AsRange() {
    return ArrayRange!T(data.ptr, data.ptr + dataLength);
  }

  mixin RvalueRef;
}
