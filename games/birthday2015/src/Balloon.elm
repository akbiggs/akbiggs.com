module Balloon where

import Graphics.Collage as Collage
import Random
import List
import Maybe

import Context
import Actor
import Point

type alias BalloonModel = Actor.ActorModel

balloonColors : List String
balloonColors = ["red", "blue", "green"]

width : Float
width = 88

height : Float
height = 152

floatSpeedGenerator : Random.Generator Float
floatSpeedGenerator = Random.float 4 8

create : Point.Point -> Random.Seed -> (BalloonModel, Random.Seed)
create pos seed =
    let
        colorIndexGenerator = Random.int 0 ((List.length balloonColors) - 1)
        (colorIndex, seed2) = Random.generate colorIndexGenerator seed

        colorName = List.drop colorIndex balloonColors
            |> List.head
            |> Maybe.withDefault "red"

        (floatSpeed, seed3) = Random.generate floatSpeedGenerator seed2

        result =
            { pos = pos
            , vel = (0, floatSpeed)
            , dir = Actor.None
            , size = (width, height)
            , image = "images/balloon_" ++ colorName ++ ".png"
            , isFinished = False
            }
    in
        (result, seed3)

floatUp : Float -> Context.GameDimensions -> Random.Seed -> (BalloonModel, Random.Seed)
floatUp x (w, h) seed = create (x, toFloat -h) seed

update : Context.UpdateContext -> BalloonModel -> BalloonModel
update ctx model =
    let
        withPhysicsApplied = Actor.applyPhysicsModel ctx model
        (x, y) = withPhysicsApplied.pos
        (w, h) = ctx.dimensions
    in
        { withPhysicsApplied | isFinished <- y > (toFloat h) + height }

view : Context.ViewContext -> BalloonModel -> Collage.Form
view ctx model = Actor.basicView ctx model

actor : BalloonModel -> Actor.Actor
actor model =
    { model = model
    , update = update
    , view = view
    }
