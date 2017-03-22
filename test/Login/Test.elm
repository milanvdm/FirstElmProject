module Login.Test exposing (..)

import Login.Model exposing (Model, model)
import Login.Update exposing (update)
import Login.View exposing (view)
import Login.Messages exposing (Msg)

import Shared.Util.Localstorage as Localstorage

import Html

main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = Localstorage.subscriptions
        , update = update
        }