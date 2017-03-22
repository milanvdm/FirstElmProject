module Login.State exposing (..)

import Login.Types exposing (Model, Msg(..))
import Shared.Form.Validation as Validation exposing (Validator, getErrors, ifBlank, ifInvalidEmail)
import Login.Rest exposing (authenticateUser)
import Login.Config as Config
import Router.Helpers
import Router.Types

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


update : Msg -> Model -> ( Model, Cmd Msg )
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
            )

        UpdatePassword newPassword ->
            ( { model | 
                password = newPassword,
                passwordTouched = True,
                passwordError = errorMessage newPassword 
                                    [ Config.requiredPassword ]
                                    [ ifBlank ] } 
            , Cmd.none
            )

        ShowPassword toShow ->
            ( { model | showPassword = toShow }
            , Cmd.none
            )

        SubmitLoginForm -> 
            ( model
            , authenticateUser model.username model.password
            )

        Authentication (Ok jwt) ->
            let
              newModel = { model | 
                           loginSucces = True }
            in
              
            ( newModel
            , Navigation.modifyUrl (Router.Helpers.reverseRoute Router.Types.HomeRoute)
            )

        Authentication (Err _) ->
            ( { model | 
                loginSucces = False,
                loginAttempts = model.loginAttempts + 1 }
            , Cmd.none
            )

        Mdl message_ ->
            Material.update Mdl message_ model