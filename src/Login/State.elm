module Login.State exposing (..)

import Login.Types exposing (Model, Msg(..))
import Shared.Form.Validation as Validation exposing (Validator, getErrors, ifBlank, ifInvalidEmail)
import Login.Rest exposing (authenticateUser)
import Login.Config as Config
import Router.Helpers
import Router.Types
import App.Types exposing (GlobalUpdate(..))
import Shared.Util.Localstorage as Localstorage

import Navigation
import Material

init : ( Model, Cmd Msg )
init = (emptyModel, Cmd.none)

emptyModel : Model 
emptyModel =
    { 
        mdl = Material.model,
        username = "",
        password = "",
        showPassword = False,
        usernameTouched = False,
        usernameError = "",
        passwordTouched = False,
        passwordError = "",
        loginAttempts = 0,
        loginSucces = False
    }

errorMessage : String -> List String -> List Validator -> String
errorMessage field messages validators = 
    let 
        error = getErrors field messages validators
    in 
        case error of
            Nothing -> ""
            Just message -> message


update : Msg -> Model -> ( Model, Cmd Msg, GlobalUpdate )
update msg model =
    case msg of
        UpdateUsername newUsername ->
            ( { model | 
                username = newUsername,
                usernameTouched = True,
                usernameError = errorMessage newUsername 
                                    [ Config.requiredEmail, Config.validEmail ]
                                    [ ifBlank, ifInvalidEmail ] }
            , Cmd.none
            , NoUpdate
            )

        UpdatePassword newPassword ->
            ( { model | 
                password = newPassword,
                passwordTouched = True,
                passwordError = errorMessage newPassword 
                                    [ Config.requiredPassword ]
                                    [ ifBlank ] } 
            , Cmd.none
            , NoUpdate
            )

        ShowPassword toShow ->
            ( { model | showPassword = toShow }
            , Cmd.none
            , NoUpdate
            )

        SubmitLoginForm -> 
            ( model
            , authenticateUser model.username model.password
            , NoUpdate
            )

        Authentication (Ok jwt) ->
            let
              newModel = { model | 
                           loginSucces = True }
            in
              
            ( newModel
            , Cmd.batch
              [ Localstorage.store (Localstorage.createStorageData "jwtToken" jwt)
              , Navigation.modifyUrl (Router.Helpers.reverseRoute Router.Types.HomeRoute)
              ]
            , UpdateJwt jwt
            )

        Authentication (Err _) ->
            ( { model | 
                loginSucces = False,
                loginAttempts = model.loginAttempts + 1 }
            , Localstorage.store (Localstorage.createStorageData "jwtToken" "")
            , UpdateJwt ""
            )

        Mdl message_ ->
            let
              (nextModel, nextCmd) = Material.update Mdl message_ model
            in 
              (nextModel, nextCmd, NoUpdate)