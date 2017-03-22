module Shared.Form.Validation exposing (..)

{-| Convenience functions for validating data.
-}


import Maybe
import Regex

type alias Validator = String -> String -> Maybe String


{-| Run each of the given validators, in order, and return the first
    found error message
-}
getErrors : String -> List String -> List Validator -> Maybe String
getErrors input messages validators =
    case (messages, validators) of
        (_, []) -> Nothing

        (message :: otherMessages, validator :: otherValidators) ->
            let 
                error = validator input message
            in 
                case error of 
                    Nothing -> getErrors input otherMessages otherValidators
                    Just _ -> Just message

        (_, _) -> Nothing



{-| Return an error if the given `String` is empty, or if it contains only
whitespace characters.
-}
ifBlank : Validator
ifBlank input message =
    ifInvalid input (Regex.contains lacksNonWhitespaceChars) message


lacksNonWhitespaceChars : Regex.Regex
lacksNonWhitespaceChars =
    Regex.regex "^\\s*$"


isValidEmail : String -> Bool
isValidEmail =
    let
        validEmail =
            Regex.regex "\\S+@\\S+\\.\\S+"
                |> Regex.caseInsensitive
    in
        Regex.contains validEmail


{-| Return an error if the given email string is malformed.
-}
ifInvalidEmail : Validator
ifInvalidEmail input message =
    ifInvalid input (not << isValidEmail) message


{-| Return an error if the given predicate returns `True` for the given
subject.
-}
ifInvalid : String -> (String -> Bool) -> String  -> Maybe String
ifInvalid input test message  =
    let
        passed = test input
    in
        if passed then
            Just input
        else
            Nothing