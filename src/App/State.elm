module App.State exposing (..)

import Navigation exposing (Location)

import App.Types exposing (Model, Msg(..), AppState(..), Flags, Global, GlobalUpdate(..))
import Router.Types
import Router.State
import Shared.Util.Localstorage as Localstorage

init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let 
        initModel = 
            { appState = NotReady flags.jwtToken
            , location = location
            }
    in 
        update (RouterMsg Router.Types.NoOp) initModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            updateRouter { model | location = location } (Router.Types.UrlChange location)

        RouterMsg routerMsg ->
            updateRouter model routerMsg

        LoadLocalstorage ls ->
            updateRouter { model | appState = NotReady ls } Router.Types.NoOp

        NoOp -> (model, Cmd.none)


updateRouter : Model -> Router.Types.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    case model.appState of
        Ready global routerModel ->
            let

                ( nextRouterModel, routerCmd, globalUpdate ) =
                    Router.State.update global routerMsg routerModel

                nextGlobal =
                    updateGlobal global globalUpdate

            in
                ( { model | appState = Ready nextGlobal nextRouterModel }
                , Cmd.map RouterMsg routerCmd
                )

        NotReady jwtToken ->
            let
                initGlobal =
                    { jwtToken = jwtToken
                    }

                ( initRouterModel, routerCmd ) =
                    Router.State.init initGlobal model.location
            in
                ( { model | appState = Ready initGlobal initRouterModel }
                , Cmd.map RouterMsg routerCmd
                )


updateGlobal : Global -> GlobalUpdate -> Global
updateGlobal global globalUpdate =
    case globalUpdate of
        UpdateJwt jwt ->
            { global | jwtToken = jwt }

        NoUpdate ->
            global


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch 
    [
        Localstorage.loadLocalstorage LoadLocalstorage
    ]