module Router.Types exposing (..)

import Navigation exposing (Location)

import Home.Types
import Login.Types

type alias Model =
    { homeModel : Home.Types.Model
    , loginModel : Login.Types.Model
    , route : Route
    }

type Route
    = HomeRoute
    | LoginRoute
    | NotFoundRoute


type Msg
    = UrlChange Location
    | HomeMsg Home.Types.Msg
    | LoginMsg Login.Types.Msg
    | NoOp

type Redirect
    = Redirected Route
    | Stay Route
