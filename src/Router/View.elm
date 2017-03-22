module Router.View exposing (..)

import Html exposing (..)

import Router.Types exposing (Model, Msg(..), Route(..))
import Home.View
import Login.View

view : Model -> Html Msg
view model =
    div [ ]
        [ pageView model ]


pageView : Model -> Html Msg
pageView model =
    div [ ]
        [ (case model.route of
            HomeRoute ->
                Home.View.view model.homeModel
                    |> Html.map HomeMsg

            LoginRoute ->
                Login.View.view model.loginModel
                    |> Html.map LoginMsg

            NotFoundRoute ->
                h1 [] [ text "404 :(" ]
          )
        ]