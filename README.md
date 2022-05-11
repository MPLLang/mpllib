# mpllib
Standard library for the MPL compiler (https://github.com/mpllang/mpl).
Compatible with the [smlpkg](https://github.com/diku-dk/smlpkg) package manager.

## Usage

```
$ smlpkg add github.com/mpllang/mpllib
$ smlpkg sync
```

And then add one of the following `.mlb` source files to your project.

## Library sources

Two source files:

* `lib/github.com/mpllang/mpllib/sources.mpl.mlb`
* `lib/github.com/mpllang/mpllib/sources.mlton.mlb`

The former is for use with MPL, the latter with MLton.

## Documentation

Sequences
* `structure `[`Seq`](doc/Seq.md)
* `structure ArraySequence = `[`Seq`](doc/Seq.md)
* `structure `[`DelayedSeq`](doc/DelayedSeq.md)

TODO...
