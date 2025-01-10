# mpllib
Grab-bag library for the [MaPLe](https://github.com/mpllang/mpl) compiler.
MPL extends Standard ML with support for (nested) fork-join
parallelism, and has excellent multicore performance. This library contains
a variety of parallel algorithms, data structures, and utilities, including:
  * sequences, sets, dictionaries, matrices, concurrent collections
  * sorting, searching, shuffling
  * text processing (tokenization, string search)
  * images (`.ppm`, `.gif` formats)
  * graph processing (CSR and edge list formats)
  * audio (signal processing and `.wav` format)
  * computational geometry (nearest neighbors, meshes, triangulation, convex hull)
  * command-line arguments
  * benchmarking
  * and more...

To see these in action, check out the
[Parallel ML benchmark suite](https://github.com/mpllang/parallel-ml-bench).

This library is compatible with the
[`smlpkg`](https://github.com/diku-dk/smlpkg) package manager.

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

Primitives for parallelism and concurrency
* structure [`ForkJoin`](doc/ForkJoin.md)
* structure [`Concurrency`](doc/Concurrency.md)

Files and Command-line Arguments
* structure [`ReadFile`](doc/ReadFile.md)
* structure [`CommandLineArgs`](doc/CommandLineArgs.md)

Sequences
* structure [`Seq`](doc/Seq.md)
* structure [`ArraySequence = Seq`](doc/Seq.md)
* structure [`DelayedSeq`](doc/DelayedSeq.md)
* structure [`SeqBasis`](doc/SeqBasis.md)

Sorting and Permutations
* structure [`Merge`](doc/Merge.md)
* structure [`StableMerge`](doc/StableMerge.md)
* structure [`StableSort`](doc/StableSort.md)
* structure [`Mergesort`](doc/Mergesort.md)
* structure [`SampleSort`](doc/SampleSort.md)
* structure [`CountingSort`](doc/CountingSort.md)
* structure [`Quicksort`](doc/Quicksort.md)
* structure `RadixSort`
* structure [`Shuffle`](doc/Shuffle.md)

Searching
* structure [`BinarySearch`](doc/BinarySearch.md)
* structure [`FindFirst`](doc/FindFirst.md)

Graphs
* functor [`AdjacencyGraph`](doc/AdjacencyGraph.md)

Geometry
* structure [`Geometry2D`](doc/Geometry2D.md)
* structure `Geometry3D`
* structure [`Topology2D`](doc/Topology2D.md)
* structure `MeshToImage`
* structure `NearestNeighbors`

Images
* structure [`Color`](doc/Color.md)
* structure [`GIF`](doc/GIF.md)
* structure [`PPM`](doc/PPM.md)

Audio
* structure `NewWaveIO`
* structure `Signal`

Text
* structure `Tokenize`
* functor `MkGrep`

Matrices
* functor `MatCOO`
* structure `TreeMatrix`

Augmented Maps
* functor `PAM`

Collections
* structure `Hashset`
* structure `Hashtable`
* functor `ChunkedTreap`
* structure `ParFuncArray`