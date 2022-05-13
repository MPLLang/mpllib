# structure CommandLineArgs

A simple command-line arguments library. It handles three kinds of arguments:
  * key-value pairs with keys prefixed by `-`
  * flags, with keys prefixed by `--`
  * positional arguments (all others)

## Interface

```sml
val parseString: string -> string -> string
val parseInt: string -> int -> int
val parseReal: string -> real -> real
val parseBool: string -> bool -> bool
```

The functions `parseXXX key default` look for `-<key> <value>` in the
command-line arguments and return `<value>` if it is found, or
`default` otherwise.

For integers, the values parsed as string should be compatible with
`Int.fromString`.

For reals, this uses `Real.fromString`.

For bools, the value must be either `true` or `false`.

```sml
val parseFlag: string -> bool
```

`parseFlag key` returns `true` if `--<key>` was passed at the command-line.

```sml
val positional: unit -> string list
```

`positional ()` returns a list of "positional" arguments: those that do
not begin with either `-` or `--`.

## Example

Consider the following program:
```sml
structure CLA = CommandLineArgs

val a = CLA.parseInt "a" 100
val b = CLA.parseString "b" "hello"
val c = CLA.parseFlag "c"
val d = CLA.positional ()

val _ = print ("a=" ^ Int.toString a ^ "\n")
val _ = print ("b=" ^ b ^ "\n")
val _ = print ("c=" ^ (case c of true => "true" | _ => "false") ^ "\n")
val _ = print ("d=[" ^ String.concatWith "," d ^ "]\n")
```

Here are a few invocations of it:
```
$ ./test
a=100
b=hello
c=false
d=[]

$ ./test -a 42 --c
a=42
b=hello
c=true
d=[]

$ ./test -a 42 yo --c whats up -b dude
a=42
b=dude
c=true
d=[yo,whats,up]
```
