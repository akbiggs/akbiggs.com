import Graphics.Element exposing (..)
import Keyboard
import Time exposing (..)
import Window
import List
import Debug

import World
import WorldTimer
import BalloonSpawner
import Context

-- MODEL

type alias GameModel =
  { world : World.World
  , timers : List WorldTimer.WorldTimer
  }

game : GameModel
game =
  { world = World.create
  , timers = [BalloonSpawner.create]
  }

-- UPDATE

update : Context.UpdateContext -> GameModel -> GameModel
update ctx game =
  let
    worldAfterSelfUpdate = World.update ctx game.world
    (newTimers, newWorld) = applyTimerUpdates ctx game.timers worldAfterSelfUpdate
  in
    { game | world <- newWorld, timers <- newTimers }

-- update all the timers
-- timers can fire events that change the world, so we pass the world
-- through each timer's update method, getting back a new world
-- each time
applyTimerUpdates : Context.UpdateContext -> List WorldTimer.WorldTimer -> World.World -> (List WorldTimer.WorldTimer, World.World)
applyTimerUpdates ctx timers world =
  let
    applySingleTimerUpdate = \timer (timers, world) ->
      let
        (updatedWorld, updatedTimer) = WorldTimer.update ctx world timer
      in
        (timers ++ [updatedTimer], updatedWorld)
  in
    List.foldl applySingleTimerUpdate ([], world) timers

-- VIEW

view : Context.ViewContext -> GameModel -> Element
view ctx {world} = World.view ctx world

-- SIGNALS

main : Signal Element
main =
  let
    viewContext = Signal.map Context.ViewContext Window.dimensions
  in
    -- update and render the game after every tick
    Signal.map2 view viewContext (Signal.foldp update game tick)

-- This signal is fired whenever a new frame should be rendered,
-- aiming for 60 FPS. Whether or not it will get 60 FPS, well...
-- that depends on how well the game performs on your computer
-- :)
tick : Signal Context.UpdateContext
tick =
  let
    delta = Signal.map (\t -> t/20) (fps 60)
  in
    -- Every frame(e.g. every time the fps signal receives a new value),
    -- pull in the new values for all the context that we're using to update
    -- our game
    Signal.sampleOn delta (Signal.map3 Context.UpdateContext delta Keyboard.arrows Window.dimensions)
