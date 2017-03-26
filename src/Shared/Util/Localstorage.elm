port module Shared.Util.Localstorage exposing (..)

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
port loadLocalstorage : (String -> msg) -> Sub msg





