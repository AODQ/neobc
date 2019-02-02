# neobc

This is a BetterC standard library. It only exists because many portions of
Phobos relies on D runtime and/or garbage collection. When BetterC gets
exception support, and Phobos gets better @nogc support, then this library will
be defunct. While some portions of Phobos can still be used, it's rather
annoying to have to guess if a function is usable or not (it's pretty
arbitrary), and the useability of a function could change with any update.

Until then, we're forced to roll our own stuff.
