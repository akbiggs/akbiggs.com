module Actor where

import Graphics.Collage as Collage
import Graphics.Element as Element

import Context
import Point
import Debug

type alias ActorModel =
  { pos : Point.Point
  , vel : Point.Point
  , size : Point.Point

  , dir : FacingDirection
  , image : String
  , isFinished : Bool
  }

type FacingDirection = Left | Right | None

type alias Actor =
  { model : ActorModel
  , update : Context.UpdateContext -> ActorModel -> ActorModel
  , view : Context.ViewContext -> ActorModel -> Collage.Form
  }

update : Context.UpdateContext -> Actor -> Actor
update ctx actor =
  { model = actor.update ctx actor.model
  , update = actor.update
  , view = actor.view
  }

applyPhysicsModel : Context.UpdateContext -> ActorModel -> ActorModel
applyPhysicsModel {dt} model =
  let
    timeAdjustedVel = Point.mulScalar dt model.vel
  in
    { model | pos <- Point.add model.pos timeAdjustedVel }

isAlive : Actor -> Bool
isAlive actor = not actor.model.isFinished

view : Context.ViewContext -> Actor -> Collage.Form
view ctx actor = actor.view ctx actor.model

basicView : Context.ViewContext -> ActorModel -> Collage.Form
basicView ctx {pos, size, image} =
  let
    (w, h) = Point.toIntPair size
    rendered = Collage.toForm (Element.image w h image  )
  in
    rendered
      |> Collage.move pos