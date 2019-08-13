module neobc.string;

import neobc.array;

import core.stdc.stdlib;
import core.stdc.string;

String ToString(T)(T value)
  if (__traits(isIntegral, T)
   && !is(T == enum)
   && !is(T == bool)
  )
{
  import core.stdc.stdlib;
  import core.stdc.stdio;
  import core.stdc.math;

  T logValue = value < 0 ? -value : value;
  if (logValue < 0) return String("N/A");
  if (logValue == 0) logValue = 1;

  String s;
  s.Resize(cast(int)(floor(log10(logValue)+1)));
  snprintf(s.ptr, s.length, "%d", value);
  return s;
}

String ToString(T)(T value) if (is(T == U*, U)) {
  import core.stdc.stdio;

  String s;
  s.Resize(15);
  snprintf(s.ptr, s.length, "%p", value);
  return s;
}

String ToString(T)(T value) if (is(T == bool)) {
  return value ? String("true") : String("false");
}

String ToString(T)(T value) if (is(T == enum)) {
  immutable static string[] mem = [__traits(allMembers, T)];
  return String(mem[cast(size_t)(value)]);
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

  void opOpAssign(string op)(String rhs) if (op == "~") {
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

  inout(char)* ptr() inout { return cast(inout(char)*)data.ptr; }
  void Resize(size_t i) {
    data.Resize(i+1);
    data[$-1] = '\0';
  }

  size_t length() { return data.length; }

  private Array!(char) data;
}
