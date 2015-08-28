module BalloonSpawner where

import Random

import WorldTimer
import Balloon
import World

balloonMargin : Float
balloonMargin = 10

balloonSeed : Random.Seed
balloonSeed = Random.initialSeed 343

create : WorldTimer.WorldTimer
create =
    WorldTimer.create
    { time = 2
    , repeat = True
    , effect = spawnBalloon
    , seed = balloonSeed
    }

spawnBalloon : WorldTimer.TimerEffect
spawnBalloon ctx world timerModel =
    let
        (w, h) = ctx.dimensions

        minSpawnX = (toFloat -w) + balloonMargin
        maxSpawnX = (toFloat w) - balloonMargin - 150
        spawnXGenerator = Random.float minSpawnX maxSpawnX
        (spawnX, seedAfterSpawn) = Random.generate spawnXGenerator timerModel.seed

        (balloonModel, nextSeed) = Balloon.floatUp spawnX (w, h) seedAfterSpawn
        balloon = Balloon.actor balloonModel

        newWorld = World.addActor balloon world
        newTimerModel = { timerModel | seed <- nextSeed }
    in
        (newWorld, newTimerModel)
