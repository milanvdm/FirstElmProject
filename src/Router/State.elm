module Router.State exposing (..)

import Navigation exposing (Location)

import Router.Helpers exposing (parseLocation, reverseRoute, loginGuard)
import Router.Types exposing (Model, Msg(..), Redirect(..))
import Login.State
import Home.State
import Home.Types
import Login.Types


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( homeModel, homeCmd ) =
            Home.State.init

        ( loginModel, _ ) =
            Login.State.init

        redirect = loginGuard loginModel (parseLocation location)
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
    


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        UrlChange location ->
            let 
                redirect = loginGuard model.loginModel (parseLocation location)
            in
                case redirect of
                    Redirected newRoute ->
                        ( { model | route = newRoute }
                        , Navigation.modifyUrl (reverseRoute newRoute)
                        )

                    Stay oldRoute ->
                        ( { model | route = oldRoute }
                        , Cmd.none
                        )

        HomeMsg homeMsg ->
            updateHome model homeMsg

        LoginMsg loginMsg ->
            updateLogin model loginMsg
    

updateHome : Model -> Home.Types.Msg -> ( Model, Cmd Msg )
updateHome model homeMsg =
    let
        ( nextHomeModel, homeCmd ) =
            Home.State.update homeMsg model.homeModel
    in
        ( { model | homeModel = nextHomeModel }
        , Cmd.map HomeMsg homeCmd
        )


updateLogin : Model -> Login.Types.Msg -> ( Model, Cmd Msg )
updateLogin model loginMsg =
    let
        ( nextLoginModel, loginCmd ) =
            Login.State.update loginMsg model.loginModel
    in
        ( { model | loginModel = nextLoginModel }
        , Cmd.map LoginMsg loginCmd
        )