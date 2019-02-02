module neobc.range;

alias AliasSeq(TList...) = TList;

// Pretty much a stupid library until we can get BetterC Exceptions so phobos
// doesn't break. But a lot of these also rely on D runtime.

// This is pretty much useless because the returned 'Tuple' can't be iterated
// over with multiple values
auto enumerate(Enumerator = size_t, Range)(Range range, Enumerator start = 0) {
  static struct Tuple {
    AliasSeq!(Enumerator, typeof(Range.init.front.init)) values;
    alias values this;
  }

  static struct Result {
    Range range;
    Enumerator index;

    Tuple front() { return Tuple(index, range.front); }
    bool empty() { return range.empty; }
    void popFront() { range.popFront; ++ index; }
  }

  return Result(range, start);
}
