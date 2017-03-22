module Login.Rest exposing (..)

import Login.Types exposing (Msg(..))
import Shared.Util.Mock as Mock

import Result
import Http

authenticateUser : String -> String -> Cmd Msg
authenticateUser username password =
  Mock.send (Authentication (Result.Ok "jwt-test-token"))


{-
(Result.Err Http.Timeout ))
(Result.Ok "jwt-test-token"))
-}
{-
loginFormToJson : String -> String -> String
loginFormToJson username password =
    object
        [ ("username", string username)
        , ("password", string password)
        ]

authenticateUser : String -> String -> Cmd msg
authenticateUser username password =
     Http.send AuthenticationResult
       <| Http.request
            { method = "GET"
            , headers = []
            , url = url
            , body = jsonBody (loginFormToJson username password)
            , expect = expectJson 
            , timeout = Nothing
            , withCredentials = False
            }
-}





