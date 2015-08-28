module Point where

import Basics

type alias Point = (Float, Float)

applyBinaryOp : (Float -> Float -> Float) -> Point -> Point -> Point
applyBinaryOp op (x1, y1) (x2, y2) = (op x1 x2, op y1 y2)

changeX : Float -> Point -> Point
changeX newX (_, y) = (newX, y)

changeY : Float -> Point -> Point
changeY newY (x, _) = (x, newY)

add : Point -> Point -> Point
add = applyBinaryOp (+)

sub : Point -> Point -> Point
sub = applyBinaryOp (-)

mul : Point -> Point -> Point
mul = applyBinaryOp (*)

div : Point -> Point -> Point
div = applyBinaryOp (/)

clamp : Point -> Point -> Point -> Point
clamp (minX, minY) (maxX, maxY) (x, y) =
    (Basics.clamp minX maxX x, Basics.clamp minY maxY y)

mulScalar : Float -> Point -> Point
mulScalar s (x, y) = (x * s, y * s)

toIntPair : Point -> (Int, Int)
toIntPair (x, y) = (floor x, floor y)

fromIntPair : (Int, Int) -> Point
fromIntPair (x, y) = (toFloat x, toFloat y)