module neobc.arrayview;

struct ArrayView {
  size_t length;
  immutable(void)* ptr;

  static ArrayView Construct(size_t length_, inout (void)* ptr_) {
    ArrayView self;
    self.length = length_;
    self.ptr = cast(immutable(void)*)ptr_;
    return self;
  }
};
