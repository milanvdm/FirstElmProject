module Main exposing (main)

import Navigation

import App.State exposing (init, update, subscriptions)
import App.View exposing (view)
import App.Types exposing (Model, Msg(..))


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
