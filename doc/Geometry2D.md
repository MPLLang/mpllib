# structure Geometry2D

Basic operations for 2-dimensional geometric data. Contains two substructures,
`Geometry.Vector` and `Geometry.Point`.

## Interface

```sml
type point = real * real
```

A point is a tuple `(x,y)`.

```sml
val toString: point -> string
```

Conversion to a string. For example `toString (1.0, 2.0) = "(1.0,2.0)"`.

```sml
val distance: point * point -> real
```

Standard euclidean distance between two points.

## structure Geometry2D.Vector

```sml
type t = real * real
```

A vector is a tuple `(x,y)`.

```sml
val toString: t -> string
```

Convert to a string.

```sml
val add: t * t -> t
val sub: t * t -> t
val dot: t * t -> t
val cross: t * t -> t
```

Some basic operations on vectors.

```sml
val length: t -> real
```

Euclidean length (magnitude) of a vector.

```sml
val angle: t * t -> real
```

`angle (u, v)` is the rotation (in radians) of
`v` with respect to `u`. This is a value between `-π` and `π`.
Positive rotation is counter-clockwise, negative is clockwise.

For example, `angle ((1.0,0.0),(0.0,1.0))` is approximately `π/2`,
and `angle ((1.0,0.0),(~1.0,~1.0))` is approximately `-3π/4`

```sml
val scaleBy: real -> t -> t
```

Multiply the length (magnitude) of a vector by some scalar.

## structure Geometry2D.Point

```sml
type t = point
```

A point is a tuple `(x,y)`.

```sml
val add: t * t -> t
val sub: t * t -> t
```

Basic operations on points.

```sml
val minCoords: t * t -> t
val maxCoords: t * t -> t
```

`minCoords` computes the lower-left point of the bounding box of two points.
Similarly, `maxCoords` computes the upper-right point of the bounding box.

```sml
val triArea: t * t * t -> t
```

The (signed) area of a triangle between three points. The orientation of the
triangle determines the sign: from left to right, if the points are in
counter-clockwise order, the area is positive. If they are in clockwise order,
the area is negative.

```sml
val counterClockwise: t * t * t -> bool
```

Test if the three points are in counter-clockwise order, from left to right.

```sml
val triAngle: t * t * t -> real
```

`triAngle (a,b,c)` is the angle (in radians) of the triangle inside vertex `b`.

```sml
val inCircle: t * t * t -> t -> bool
```

`inCircle (a,b,c) x` tests whether or not the point `x` is within the
circumcircle of the triangle `(a,b,c)`.
