module Login.Types exposing (..)

import Material
import Http


type alias Model =
    { 
        mdl: Material.Model,
        username: String,
        password: String,
        showPassword : Bool,
        usernameTouched: Bool,
        usernameError: String,
        passwordTouched: Bool,
        passwordError: String,
        loginSucces: Bool,
        loginAttempts: Int
    }


type Msg
    = UpdateUsername String
    | UpdatePassword String
    | ShowPassword Bool
    | SubmitLoginForm
    | Authentication (Result Http.Error String)
    | Mdl (Material.Msg Msg)