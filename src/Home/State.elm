
module Home.State exposing (..)

import Home.Types exposing (Model, Msg)


init : ( Model, Cmd Msg )
init = (emptyModel, Cmd.none)

emptyModel : Model 
emptyModel =
    { 
        message = "Hello Milan"
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = init

