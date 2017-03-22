module Router.Helpers exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))
import Router.Types exposing (Route(..), Redirect(..))
import Login.Types



reverseRoute : Route -> String
reverseRoute route =
    case route of
        LoginRoute ->
            "#/login"

        _ ->
            "#/"


routeParser : Url.Parser (Route -> a) a
routeParser =
    Url.oneOf
        [ Url.map HomeRoute Url.top
        , Url.map LoginRoute (Url.s "login")
        ]


parseLocation : Location -> Route
parseLocation location =
    location
        |> Url.parseHash routeParser
        |> Maybe.withDefault NotFoundRoute



loginGuard : Login.Types.Model -> Route -> Redirect
loginGuard model route = 
    case route of
        LoginRoute -> Stay route

        _ -> if not model.loginSucces then
                Redirected LoginRoute
             else 
                Stay route
    
    