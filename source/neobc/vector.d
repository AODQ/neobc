module neobc.vector;

// Wrote this originally for Polyplex library, the two have grown very distant
// from each other though. This is a stripped down version for BC as well.

private bool ProperVectorBinaryOperation(string op) {
  return op == "/" || op == "*" || op == "+" || op == "-";
}

private bool ProperVectorUnaryOperation(string op) {
  return op == "-" || op == "+";
}

private size_t SwizzleIndex(char c) {
  switch (c) {
    default: return -1;
    case 'r': case 'x': return 0; case 'g': case 'y': return 1;
    case 'b': case 'z': return 2; case 'a': case 'w': return 3;
  }
}

private size_t[] GenerateSwizzleList(string swizzleList)() {
  size_t[] buffer;
  foreach (swizzle; swizzleList) buffer ~= SwizzleIndex(swizzle);
  return buffer;
}

struct Vector(size_t _Dim, _Type) {
  alias Type = _Type;
  static immutable size_t Dim = _Dim;

  Type[Dim] data;

  this(U)(U x) { data[] = cast(Type)x; }
  static if(Dim == 2) {
    this(U)(U x, U y) { data[0] = cast(Type)x; data[1] = cast(Type)y; }
  }
  static if(Dim == 3) {
    this(U)(U x, U y, U z) {
      data[0] = cast(Type)x; data[1] = cast(Type)y; data[2] = cast(Type)z;
    }
  }
  static if(_Dim == 4) {
    this(U)(U x, U y, U z, U w) {
        data[0] = x; data[1] = y; data[2] = z; data[3] = w;
    }
  }
  this(U)(Vector!(Dim, U) vec) {
      data[0] = vec.x; data[1] = vec.y; data[2] = vec.z; data[3] = vec.w;
  }

  /// Returns a pointer to the data container of this vector
  inout(Type)* ptr() pure inout nothrow { return data.ptr; }

  auto opDispatch(string swizzleList, U = void)() pure const nothrow
    if (swizzleList.length <= 4)
  {
    static if (swizzleList.length == 1) {
      size_t idx = (GenerateSwizzleList!swizzleList)[0];
      return data[idx];
    }
    // else {
    //   Vector!(T, swizzleList.length) retVec;
    //   static foreach (iter, idx; GenerateSwizzleList!swizzleList)
    //     retVec.data[iter] = data[index];
    //   return retVec;
    // }
  }

  auto opDispatch(string swizzleList, U)(U x) pure nothrow {
    static if (swizzleList.length == 1) {
      this.data[(GenerateSwizzleList!swizzleList)[0]] = x;
      return x;
    } else {
      Vector!(T, swizzleList.length) tvec = x; // scalar to vector
      static foreach (iter, idx; GenerateSwizzleList!swizzleList)
        data[idx] = tvec.data[iter];
      return tvec;
    }
  }
}

Type dot(size_t Length, Type)(
  Vector!(Length, Type) left,
  Vector!(Length, Type) right
) pure @nogc nothrow {
  Type temp = cast(Type)(0);
  static foreach (i; 0 .. Dim)
    temp += left.data[i] * right.data[i];
  return temp;
}

Type length(size_t Length, Type)(Vector!(Length, Type) vec) pure @nogc nothrow {
  Type accumulator = cast(Type)(0);
  static foreach (i; 0 .. Dim)
    accumulator += vec.data[i] * vec.data[i];
  return cast(Type) sqrt(cast(float)accumulator);
}

Type length(size_t Length, Type)(
  Vector!(Length, Type) left,
  Vector!(Length, Type) right
) pure @nogc nothrow {
  return length(left - right);
}

Vector!(Length, Type) normalize(size_t Length, Type)(Vector!(Length, Type) vec)
    pure @nogc nothrow {
  return vec.opBinary!"/"(vec.length);
}

enum IsVector(T) = is(T : Vector!U, U...);

alias float2 = Vector!(2, float);
alias int2   = Vector!(2, int);
alias float3 = Vector!(3, float);
alias int3   = Vector!(3, int);
alias float4 = Vector!(4, float);
alias int4   = Vector!(4, int);

auto cross(T)(Vector!(T, 3) a, Vector!(T, 3) b) pure nothrow {
  return Vector!(T, 3)(
    a.y*b.z - a.z*b.y,
    a.z*b.x - a.x * b.z,
    a.x*b.y - a.y * b.x
  );
}
