module neobc.array_range;

struct ArrayRange(T) {
  private T* dataFront, dataEnd;

  static ArrayRange!T Create(T* dataFront, T* dataEnd) {
    return ArrayRange!T(dataFront, dataEnd);
  }
  private this(T* dataFront_, T* dataEnd_) {
    dataFront = dataFront_;
    dataEnd = dataEnd_;
  }

  size_t opDollar() inout {
    return cast(size_t)(cast(ubyte*)(dataEnd - dataFront)) / T.sizeof ;
  }
  ref T opIndex(size_t idx) { return dataFront[idx]; }

  T* ptr() { return dataFront; }
  T* frontPtr() { return dataFront; }
  T* backPtr() { return dataEnd; }

  ref inout(T) front() inout { return *dataFront; }
  ref inout(T) back () inout { return *dataEnd; }
  void popFront() { ++ dataFront; };
  bool empty() inout { return dataFront == dataEnd; }
}
