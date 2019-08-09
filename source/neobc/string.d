module neobc.string;

import neobc.array;

import core.stdc.stdlib;
import core.stdc.string;

string ToStringEnum(T)(T value) {
  immutable static string[] mem = [__traits(allMembers, T)];
  return mem[cast(size_t)(value)];
}

String ToString(T)(T value) if (__traits(isIntegral, T)) {
  import core.stdc.stdlib;
  import core.stdc.stdio;
  import core.stdc.math;

  T logValue = value < 0 ? -value : value;
  if (logValue == 0) logValue = 1;

  String s;
  s.Resize(cast(int)(floor(log10(logValue)+1)));
  snprintf(s.ptr, s.length, "%d", value);
  return s;
}

String ToString(T)(T value) if (__traits(isFloating, T)) {
  import core.stdc.stdlib;
  import core.stdc.math;

  int integral = cast(int)value;
  int floating = cast(int)((value - cast(float)integral) * 100.0f);

  String s;
  s ~= ToString(integral);
  s ~= ".";
  s ~= ToString(floating);
  return s;
}

struct String {
  this(string s) {
    data = Array!(char)(s.length, s.ptr);
    MakeCString;
  }

  private void MakeCString() {
    if (data[$-1] != '\0')
      data ~= '\0';
  }

  void opOpAssign(string op)(ref String rhs) if (op == "~") {
    size_t actualLength = data.ptr == null ? 0 : data.length-1;
    data.Resize(actualLength + rhs.length);
    memcpy(cast(void*)(data.ptr + actualLength), rhs.ptr, rhs.length);
  }

  void opOpAssign(string op)(string rhs) if (op == "~") {
    size_t actualLength = data.ptr == null ? 0 : data.length-1;
    data.Resize(data.length + rhs.length);
    memcpy(cast(void*)(data.ptr + actualLength), rhs.ptr, rhs.length);
    MakeCString();
  }

  immutable(char)* ptr() { return cast(immutable(char)*)data.ptr; }

  private Array!(char) data;
}
