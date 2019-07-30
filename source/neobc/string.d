module neobc.string;

// Have to create your own ToString function, and import
// all modules associated with the project, at least
// those you want string enums build for
string ToStringMixin(T)() {
  import std.format;
  import std.conv : to;

  string caseMixer;
  foreach (i; T.min .. T.max) {
    caseMixer ~=
      `case %s: return "%s";`.format(i.to!string, i.to!string);
  }
  return
    `switch(value) with(%s) {
        default: return "N/A";
        %s
    }`.format(T.stringof, caseMixer);
}
