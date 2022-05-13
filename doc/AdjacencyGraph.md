# functor AdjacencyGraph(Vertex: INTEGER)

Implements a graph in compressed-sparse-row (CSR) format. The vertex type
is specified by the functor argument `Vertex`, ascribing to
[`INTEGER`](https://smlfamily.github.io/Basis/integer.html).

A graph abstractly is a collection of directed edges between vertices.
Vertices are labeled `0` to `n-1`, and each edge is an ordered pair `(u,v)`.
Multi-edges (i.e., duplicates) are allowed if desired.

This representation is for directed graphs. Undirected graphs can be
represented by replacing each undirected edge with two directed edges, one in
each direction. This is called a *symmetrized* graph.

## Basic Interface

```sml
type vertex = Vertex.int
type graph
```

Vertices, and the graph type defined by this module.

```sml
val numVertices: graph -> int
```

The number of vertices in the graph. Vertices are labeled from `0` to `n-1`.
Cost: constant work and span.

```sml
val numEdges: graph -> int
```

The number of edges in the graph (including duplicates, if any).
Cost: constant work and span.

```sml
val degree: graph -> vertex -> int
```

`degree g u` is the number of edges in graph `g` of the form `(u,v)`. In other
words, the number of out-neighbors of `u` (including duplicates, if any). This
is also equal to the length of `neighbors g u`.

Cost: constant work and span.

```sml
val neighbors: graph -> vertex -> vertex Seq.t
```

`neighbors g u` returns the neighbors of `u`. In other words, the collection
of vertices `v` such that there exists an edge `(u,v)`. This includes
duplicates if there are multi-edges. Note that
`Seq.length (neighbors g u) = degree g u`.

Cost: constant work and span.

## Utilities

```sml
val fromSortedEdges: (vertex * vertex) Seq.t -> graph
```

Construct a graph from a sequence of edges `(u,v)` sorted by `u`s. E.g.
input `[(0,2),(0,1),(1,0)]` is valid but `[(1,0),(0,2),(0,1)]` is not. The
resulting graph has `n+1` vertices, where `n` is the largest vertex label
appearing in the input.

**Work**: `O(n+m)` where `n` is the larget input vertex label
and `m` is the number of input edges.

**Span**: `polylog(n+m)`

```sml
val dedupEdges: (vertex * vertex) Seq.t -> (vertex * vertex) Seq.t
```

Deduplicates a collection of edges.

**Work**: `O(m log m)` for `m` edges.

**Span**: `polylog(m)`

```sml
val randSymmGraph: int -> int -> graph
```

`randSymmGraph n d` constructs a pseudorandom symmetrized graph of `n`
vertices with average degree approximately equal to `d`.

**Work**: `O(nd log(nd))`

**Span**: `polylog(nd)`


```sml
val parityCheck: graph -> bool
```

A quick sanity check for symmetrized graphs. If `g` is symmetrized, then
`parityCheck g` returns `true`. Otherwise, on non-symmetrized graphs,
false positives are possible but unlikely.

**Work**: `O(n+m)` for `n` vertices and `m` edges.

**Span**: `polylog(n+m)`

## Graph File I/O

```sml
val parseFile: string -> graph
```

`parseFile path` parses a graph from the file at `path`
(relative to the current directory). The graph should be in either
`AdjacencyGraph` or `AdjacencyGraphBin` format, described below.

```sml
val writeAsBinaryFormat: graph -> string -> unit
```

`writeAsBinaryFormat g path` writes graph `g` to a file at `path` in
the `AdjacencyGraphBin` format, described below.

## Graph File Formats

The above functions consider graphs written in files. There are two formats: a
human-readable format, and a binary format. The binary format is typically
not significantly smaller in size, but can be as much as 10x faster to read
into memory.

**Human-readable format**. A graph file in this format should begin with three
lines. The first line should be just the string `AdjacencyGraph`. The second
line should be the number of vertices. The third line should be the number of
edges. The file then has `n+m` additional lines for the contents of the graph,
where `n` is the number of vertices, and `m` is the number of edges.
The first `n` of these are the neighbor offsets of the corresponding vertex.
Then the final `m` lines are the neighbors.

For example, the graph `[(0,1),(0,2),(1,0),(2,1)]` could be represented by the
following file.

```
AdjacencyGraph
3
4
0
2
3
1
2
0
1
```

And an annotated explanation (annotations should not be included in the actual
file).

```
AdjacencyGraph
3    # 3 vertices
4    # 4 edges
0    # neighbors of v0 start at offset 0
2    # neighbors of v1 start at offset 2
3    # neighbors of v2 start at offset 3
1    # beginning of v0's neighbors (offset 0)
2
0    # beginning of v1's neighbors (offset 2)
1    # beginning of v2's neighbors (offset 3)
```

**Binary format**. A graph in this format should begin with the ASCII bytes
`AdjacencyGraphBin` followed by a newline (i.e. hex byte `0a`). The rest of
the file is a sequence of 64-bit unsigned words, written in big-endian byte
order. The data itself is exactly the same data as the human-readable format:
we first write the number of vertices (as a 64-bit word), next the number of
edges (as a 64-bit word), next the offset of the 0th vertex's neighbors (as
a 64-bit word), etc.

Here is a hexdump of the binary form of the above example:
```
$ hexdump -C sample-bin
00000000  41 64 6a 61 63 65 6e 63  79 47 72 61 70 68 42 69  |AdjacencyGraphBi|
00000010  6e 0a 00 00 00 00 00 00  00 03 00 00 00 00 00 00  |n...............|
00000020  00 04 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000030  00 02 00 00 00 00 00 00  00 03 00 00 00 00 00 00  |................|
00000040  00 01 00 00 00 00 00 00  00 02 00 00 00 00 00 00  |................|
00000050  00 00 00 00 00 00 00 00  00 01                    |..........|
0000005a
```
