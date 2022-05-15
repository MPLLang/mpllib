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
      w
      | \ --> c
a <-- |  v
      | / --> b
      u
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

Walk through a mesh to find where a point lies. The resulting triangle
will either have that point on its boundary, or within its center. In the
case of `find`, we search for a vertex in the mesh. For `findPoint`, we search
for any arbitrary point within the convex boundary of the mesh.

```sml
val across: mesh -> simplex -> simplex option
```

`across mesh s` returns the simplex across the distinguished edge of `s`.
The distinguished edge of the resulting simplex is the one shared with `s`.

If there is no such simplex, it returns `NONE`.

```sml
val rotateClockwise: simplex -> simplex
```

Rotate the simplex to choose the next distinguished edge. For example,
in the following, if `a` is the distinguished edge, then after rotation,
the new distinguished edge is `b`:
```
        w                                         u
        | \ --> c      rotateClockwise            | \ --> a
*a* <-- |  v           ==============>    *b* <-- |  w
        | / --> b                                 | / --> c
        u                                         v
```


```sml
val outside: mesh -> simplex -> vertex -> bool
val pointOutside: mesh -> simplex -> Geometry2D.point -> bool
```

Test if a vertex or arbitrary point is outside a simplex, across its
distinguished edge. (I.e., on the other side of the line defined by
the distinguished edge).

```sml
val inCircle: mesh -> simplex -> vertex -> bool
val pointInCircle: mesh -> simplex -> Geometry2D.point -> bool
```

Test if a vertex or arbitrary point is within the circumcircle of a simplex.

```sml
val firstVertex: mesh -> simplex -> vertex
```

When viewing a simplex with its distinguished edge on the left, return the
"bottom" vertex. For example, in the picture below, `u` is the first vertex.

```
      w
      | \ --> c
a <-- |  v
      | / --> b
      u
```

## Mesh Updates

```sml
val split: mesh -> triangle -> Geometry2D.point -> mesh
```

`split mesh t p` splits the triangle `t` by putting a new vertex at point
`p`, creating two new triangles. **Requires** the point `p` must be within
the triangle `t`.

For example below, the new vertex is labeled `v` and the two new triangles
created are labeled `ta0` and `ta1`.

```
  BEFORE:                    AFTER:
    v1                         v1
    |\                         |\\
    |   \    t1                | \ \    t1
    |      \                   |  \   \
    |         \                |   \  t  \
t2  |    t     v3          t2  |ta0 v --- v3
    |         /                |   / ta1 /
    |      /                   |  /   /
    |   /    t3                | / /    t3
    |/                         |//
    v2                         v2
```


(TODO... more functions from the interface)
