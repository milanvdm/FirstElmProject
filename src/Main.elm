module Main exposing (main)

import Navigation exposing (Location)

import App.State exposing (init, update, subscriptions)
import App.View exposing (view)
import App.Types exposing (Model, Msg(..), Flags)


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
