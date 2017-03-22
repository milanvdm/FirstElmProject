port module Shared.Util.Localstorage exposing (..)

import Shared.Globals as Globals

type alias StorageData = 
    { 
        key: String,
        value: String
    }

createStorageData : String -> String -> StorageData
createStorageData key value =
    {
        key = key,
        value = value
    }

-- port for sending data out to JavaScript localstorage
port store : StorageData -> Cmd msg

port retrieve : String -> Cmd msg


-- port for listening for results from JavaScript
port value : (String -> msg) -> Sub msg


subscriptions : Globals.Variables -> Sub Msg
subscriptions variables =
    suggestions Suggest




