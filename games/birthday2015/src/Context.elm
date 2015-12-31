module Context where

import Input

type alias GameDimensions = (Int, Int)

-- UPDATE CONTEXT

type alias UpdateContext =
  { dt : Float
  , keys : Input.ArrowKeys
  , dimensions : GameDimensions
  }

-- VIEW CONTEXT

type alias ViewContext =
  { dimensions : GameDimensions
  }
