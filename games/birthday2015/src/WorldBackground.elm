module WorldBackground where

import Graphics.Collage as Collage
import Color

import Context
import Actor

type alias Background =
    { clouds : List Actor.Actor }

create : Background
create =
    { clouds = []
    }

skyTopColor : Color.Color
skyTopColor = Color.rgb 245 79 41

skyBottomColor : Color.Color
skyBottomColor = Color.rgb 255 151 79

groundHeight : Float
groundHeight = 100

views : Context.ViewContext -> Background -> List Collage.Form
views {dimensions} background =
    let
        (w, h) = dimensions

        gradientStops = [(0, skyTopColor), (1, skyBottomColor)]
        gradient = Color.linear (0, (toFloat h)) (0, (toFloat -h)) gradientStops

        backgroundRect = Collage.rect (toFloat w) (toFloat h)
            |> Collage.gradient gradient

        ground = Collage.rect (toFloat w) groundHeight
            |> Collage.filled (Color.rgb 0 0 0)
            |> Collage.moveY ((toFloat -h) / 2)
    in
        [backgroundRect, ground]
