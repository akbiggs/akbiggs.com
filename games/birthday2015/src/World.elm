module World where

import Graphics.Collage as Collage
import Graphics.Element as Element
import Debug

import Actor
import Hero
import Context
import WorldBackground

type alias World =
  { actors : List Actor.Actor
  , background : WorldBackground.Background
  }

create : World
create =
  { actors = [Hero.actor (Hero.create (0, 0))]
  , background = WorldBackground.create
  }

addActor : Actor.Actor -> World -> World
addActor actor world = { world | actors <- world.actors ++ [actor] }

update : Context.UpdateContext -> World -> World
update ctx world =
  let
    updatedActors = List.map (Actor.update ctx) world.actors
    onlyAliveActors = List.filter Actor.isAlive updatedActors
  in
    { world | actors <- onlyAliveActors }

view : Context.ViewContext -> World -> Element.Element
view ctx {actors, background} =
  let
    (w, h) = ctx.dimensions
    actorViews = List.map (Actor.view ctx) actors
    backgroundViews = WorldBackground.views ctx background
  in
    Collage.collage w h (backgroundViews ++ actorViews)