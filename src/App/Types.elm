module App.Types exposing (..)

import Router.Types

import Navigation exposing (Location)

type Msg
  = UrlChange Location
  | RouterMsg Router.Types.Msg
  | LoadLocalstorage String
  | NoOp


type Route
  = Home
  | Login


type alias Model =
    { appState : AppState
    , location : Location
    }


type AppState
    = NotReady String
    | Ready Global Router.Types.Model


type alias Global
  = { jwtToken: String }

type GlobalUpdate
    = NoUpdate
    | UpdateJwt String

type alias Flags 
    = { jwtToken : String }
