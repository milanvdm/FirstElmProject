module App.State exposing (..)

import Navigation exposing (Location)

import App.Types exposing (Model, Msg(..), AppState(..))
import Router.Types
import Router.State

init : Location -> ( Model, Cmd Msg )
init location =
    let 
        (initRouterModel, _) = Router.State.init location
    in
        ( { appState = Ready initRouterModel
        , location = location
        }
        , Cmd.none
        )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            updateRouter { model | location = location } (Router.Types.UrlChange location)

        RouterMsg routerMsg ->
            updateRouter model routerMsg

        NoOp -> (model, Cmd.none)


updateRouter : Model -> Router.Types.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    case model.appState of
        Ready routerModel ->
            let
                ( nextRouterModel, routerCmd ) =
                    Router.State.update routerMsg routerModel
            in
                ( { model | appState = Ready nextRouterModel }
                , Cmd.map RouterMsg routerCmd
                )

        NotReady ->
            Debug.crash "Ooops. We got a sub-component message even though it wasn't supposed to be initialized?!?!?"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none