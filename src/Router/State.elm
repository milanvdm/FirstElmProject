module Router.State exposing (..)

import Navigation exposing (Location)

import Router.Helpers exposing (parseLocation, reverseRoute, loginGuard)
import Router.Types exposing (Model, Msg(..), Redirect(..))
import Login.State
import Home.State
import Home.Types
import Login.Types
import App.Types exposing (GlobalUpdate(..), Global)


init : Global -> Location -> ( Model, Cmd Msg )
init global location =
    let
        ( homeModel, homeCmd ) =
            Home.State.init

        ( loginModel, _ ) =
            Login.State.init

        redirect = loginGuard global (parseLocation location)
    in
        case redirect of
            Redirected newRoute ->
                ( { 
                    homeModel = homeModel,
                    loginModel = loginModel,
                    route = newRoute
                }
                , Navigation.modifyUrl (reverseRoute newRoute)
                )

            Stay oldRoute ->
                ( { 
                    homeModel = homeModel,
                    loginModel = loginModel,
                    route = oldRoute
                }
                , Cmd.map HomeMsg homeCmd
                )
    


update : Global -> Msg -> Model -> ( Model, Cmd Msg, GlobalUpdate)
update global msg model =
    case msg of
        UrlChange location ->
            let 
                redirect = loginGuard global (parseLocation location)
            in
                case redirect of
                    Redirected newRoute ->
                        ( { model | route = newRoute }
                        , Navigation.modifyUrl (reverseRoute newRoute)
                        , NoUpdate
                        )

                    Stay oldRoute ->
                        ( { model | route = oldRoute }
                        , Cmd.none
                        , NoUpdate
                        )

        HomeMsg homeMsg ->
            updateHome model homeMsg

        LoginMsg loginMsg ->
            updateLogin model loginMsg

        NoOp -> ( model, Cmd.none, NoUpdate )
    

updateHome : Model -> Home.Types.Msg -> ( Model, Cmd Msg, GlobalUpdate )
updateHome model homeMsg =
    let
        ( nextHomeModel, homeCmd ) =
            Home.State.update homeMsg model.homeModel
    in
        ( { model | homeModel = nextHomeModel }
        , Cmd.map HomeMsg homeCmd
        , NoUpdate
        )


updateLogin : Model -> Login.Types.Msg -> ( Model, Cmd Msg, GlobalUpdate )
updateLogin model loginMsg =
    let
        ( nextLoginModel, loginCmd, globalUpdate ) =
            Login.State.update loginMsg model.loginModel
    in
        ( { model | loginModel = nextLoginModel }
        , Cmd.map LoginMsg loginCmd
        , globalUpdate
        )