module Home.View exposing (..)

import Home.Types exposing (Model, Msg)

import Html exposing (..)


view : Model -> Html Msg
view model = div [] [ text model.message ]