module App.View exposing (..)

import App.Types exposing (Model, Msg(..), AppState(..))
import Router.View

import Html exposing (..)

view : Model -> Html Msg
view model =
    case model.appState of
        Ready _ routerModel ->
            Router.View.view routerModel
                |> Html.map RouterMsg

        NotReady _ ->
            text "Loading"