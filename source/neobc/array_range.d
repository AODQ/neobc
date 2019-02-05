module neobc.array_range;

struct ArrayRange(T, Imm=T) {
  private T * dataFront, dataEnd;

  this(T * dataFront_, T * dataEnd_) {
    dataFront = dataFront_;
    dataEnd = dataEnd_;
  }

  ref inout(T) front() inout { return dataFront[0]; }
  void popFront() { ++ dataFront; };
  bool empty() inout { return dataFront == dataEnd; }
}
