module HaskellGame.Interaction where

import HaskellGame.Datatypes
import HaskellGame.Utils

{-
  Check if the player's new position would collide with something.
  Return True if there would be a collision.
  Return False if there would be no collision.

  Lab 2: Implement this function for 20 marks
-}
detectCollision :: Scene -> Point -> Bool
detectCollision (Scene map _ objects monsters) (x,y) = 
                if getTile map (x,y) == "#" 
                then True 
                else if monsterCollision monsters (x,y) 
                then True
                else if chestCollision objects (x,y)
                then True
                else False

{- Returns the string representation of a given tile -}
getTile :: Map -> Point -> [Char]
getTile (Map _ _ tiles) (x,y) = theTile
  where theTile = show ((tiles !! y) !! x)

{- Checks each Monster in the scene to see if it would collide with the player -}
monsterCollision :: [Monster] -> Point -> Bool
monsterCollision [] _ = False
monsterCollision (m:ms) (x,y) = if position m == (x,y) then True else monsterCollision ms (x,y)

{- Checks each Object in the scene, including the chest, to see if it would collide with the player -}
chestCollision :: [Object] -> Point -> Bool
chestCollision [] _ = False
chestCollision (o:os) (x,y) = if position o == (x,y) then True else chestCollision os (x,y)


{- Handle a key press from the player -}
handleInput :: Char -> Scene -> Scene
handleInput c theScene@(Scene map player objects monsters) =
  let newPosition = move player c
  in
    if detectCollision theScene newPosition then
      -- if there would be a collision, we'll just give back the old scene
      theScene
    else
      -- if there would be NO collision, we move the player
      (Scene map (Player newPosition) objects monsters)
  where
    move (Player (x, y)) chr =
      case c of
        'i' -> (x, (y-1))
        'j' -> ((x-1), y)
        'k' -> (x, (y+1))
        'l' -> ((x+1), y)
        _   -> (x, y)
