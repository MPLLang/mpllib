# structure Topology2D

Implements 2-dimensional meshes of triangles. Abstractly, a mesh is a
connected set of triangles with convex boundary.

## Basic Interface

```sml
type vertex = int
type vertex_data = Geometry2D.point
```

The vertices within a mesh are identified by integer labels. Each vertex
corresponds to a 2D point.

```sml
type triangle = int
datatype triangle_data =
  Tri of
    { vertices: vertex * vertex * vertex
    , neighbors: triangle * triangle * triangle
    }
```

The triangles within a mesh are identified by integer labels. Each triangle
has three vertices, and up to three neighboring triangles. The label `~1` is
used to indicate that no neighbor exists.

The vertices of a triangle must always appear in counter-clockwise order.
Any rotation is equivalent, but CCW order must be preserved.

The neighbors of a triangle must respect the rotation of the vertices.
For vertices `(u,v,w)` and neighbors `(a,b,c)`, the neighbor `a` must be
across the face `(w,u)`, neighbor `b` must be across face `(u,v)`, and neighbor
`c` must be across face `(v,w)`, as shown below:
```
      u
      | \ --> a
b <-- |  w
      | / --> c
      v
```

```sml
type mesh
```

The abstract mesh type.

```sml
val numVertices: mesh -> int
val numTriangles: mesh -> int
```

The number of vertices and triangles in a mesh. Vertices are labeled between
`0` and `n-1` where `n` is the number of vertices. Similarly, triangles are
labeled between `0` and `m-1` where `m` is the number of triangles.

```sml
val vdata: mesh -> vertex -> vertex_data
val tdata: mesh -> triangle -> triangle_data
```

Look up info about the position and neighbors of vertices and triangles
in a mesh.

```sml
val verticesOfTriangle: mesh -> triangle -> vertex * vertex * vertex
val neighborsOfTriangle: mesh -> triangle -> triangle * triangle * triangle
```

Convenience functions, often preferable to using `tdata` directly.

```sml
val triangleOfVertex: mesh -> vertex -> triangle
```

Returns one of the triangles that a vertex participates in. (No guarantees
on which one.)

```sml
val getPoints: mesh -> Geometry2D.point Seq.t
```

The collection of points for the vertices.
Note that `Seq.nth (getPoints mesh i) = vdata mesh i`.


## Simplices

```sml
type simplex
```

A simplex is an oriented triangle. It has a distinguished edge.

```sml
val find: mesh -> vertex -> simplex -> simplex
val findPoint: mesh -> Geometry2D.point -> simplex -> simplex
```

TODO...

