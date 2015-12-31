module Hero where

import Graphics.Collage as Collage

import Actor
import Context
import Point

type alias HeroModel = Actor.ActorModel

speed : Float
speed = 5

create : Point.Point -> HeroModel
create pos =
    { pos = pos
    , vel = (0, 0)
    , size = (400, 400)
    , dir = Actor.Right
    , image = "images/google-bike.gif"
    , isFinished = False
    }

update : Context.UpdateContext -> HeroModel -> HeroModel
update ctx hero =
    let
        {x, y} = ctx.keys
        newVel = Point.fromIntPair (x, 0)
            |> Point.mulScalar speed
            |> Point.mulScalar ctx.dt

        (posX, posY) = hero.pos
        (w, h) = ctx.dimensions
        newPos = (posX, toFloat (-h + 690))

        withVelocityChanged = { hero | vel <- newVel, pos <- newPos }

        newHero = Actor.applyPhysicsModel ctx withVelocityChanged
    in
        newHero

view : Context.ViewContext -> HeroModel -> Collage.Form
view ctx model = Actor.basicView ctx model

actor : HeroModel -> Actor.Actor
actor model =
    { model = model
    , update = update
    , view = view
    }