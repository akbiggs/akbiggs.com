module WorldTimer where

import Random
import Debug

import World
import Context

type alias TimerEffect =
    Context.UpdateContext -> World.World -> TimerModel -> (World.World, TimerModel)

type alias TimerModel =
    { currentTime : Int
    , startTime : Int
    , isFinished : Bool
    , repeat : Bool

    {-
    This is a bit of a hack...

    Random number generation in Elm requires keeping track
    of the nextSeed value that was produced after each number
    was generated, or else we will get back the same value each
    time. So we need somewhere to store this value. Most timers
    will want some degree of randomness in their effect, so I chose to store it
    here, but ideally we should cut out a Random wrapper module
    of our own that gets passed in with the update context and
    can be updated.
    -}
    , seed : Random.Seed
    }

type alias WorldTimer =
    { model : TimerModel
    , effect : TimerEffect }

type alias WorldTimerCreationArgs =
    { time : Int
    , repeat : Bool
    , effect : TimerEffect
    , seed : Random.Seed }

create : WorldTimerCreationArgs -> WorldTimer
create {time, repeat, effect, seed} =
    { model =
        { currentTime = time
        , startTime = time
        , isFinished = False
        , repeat = repeat
        , seed = seed
        }
    , effect = effect }

update : Context.UpdateContext -> World.World -> WorldTimer -> (World.World, WorldTimer)
update ctx currentWorld timer =
    let
        {model, effect} = timer
        newTime = model.currentTime - (floor ctx.dt)
        shouldExecuteEffect = not model.isFinished && newTime <= 0

        modelAfterTimeUpdates = if newTime <= 0
            then {model | isFinished <- not model.repeat,
                          currentTime <- model.startTime}
            else {model | currentTime <- newTime}

        (newWorld, newModel) = if shouldExecuteEffect
            then effect ctx currentWorld modelAfterTimeUpdates
            else (currentWorld, modelAfterTimeUpdates)

        newTimer = {timer | model <- newModel}
    in
        (newWorld, newTimer)

cancel : WorldTimer -> WorldTimer
cancel timer =
    let
        {model} = timer
        newModel = {model | isFinished <- True}
    in
        {timer | model <- newModel}