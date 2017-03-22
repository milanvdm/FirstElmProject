module App.Types exposing (..)

import Login.Types
import Router.Types

import Navigation exposing (Location)

type Msg
  = UrlChange Location
  | RouterMsg Router.Types.Msg
  | NoOp


type Route
  = Home
  | Login


type alias Global =
  { login : Login.Types.Model
  }


type alias Model =
    { appState : AppState
    , location : Location
    }

type AppState
    = NotReady
    | Ready Router.Types.Model
