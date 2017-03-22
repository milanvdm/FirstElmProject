module Login.View exposing (..)

import Login.Types exposing (Model, Msg(..))
import Login.Config exposing (failedLogin)

import Html exposing (..)
import Html.Attributes exposing (style)
import String exposing (isEmpty)

import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options exposing (Property)
import Material.Grid exposing (grid, cell, align, Align(..))
import Material.Card as Card
import Material.Color exposing (Color, color)
import Material.Icon as Icon
import Material.Tooltip as Tooltip


view : Model -> Html Msg
view model =
    centered model

centerVertically : Attribute Msg
centerVertically =
  style
    [ ("flex", "0 0 auto")
    , ("height", "100vh")
    , ("display", "flex")
    , ("justify-content", "center")
    , ("align-items", "center")
    ]

centerHorizontally : Attribute Msg
centerHorizontally =
  style
    [ ("display", "flex")
    , ("height", "auto")
    , ("width", "50vw")
    ]

centered : Model -> Html Msg
centered model =
    div [ centerVertically ]
        [ div [centerHorizontally]
            [ grid []
                [ cell [ align Middle ]
                    [card model ]
                ]
            ]
        ]

red : Options.Property c m
red =
  Material.Color.text (color Material.Color.Red Material.Color.A200)

loginFeedback : Card.Block msg
loginFeedback =
    Card.text 
        [ red  ]
        [ text failedLogin ]

card : Model -> Html Msg
card model = 
    Card.view 
        [ Options.cs "mdl-shadow--6dp" ]
        (
            let errorMessage = 
                if not model.loginSucces && model.loginAttempts > 0 then [ loginFeedback ] else []
            in
                errorMessage
                ++
                [ Card.text [ ]
                    [ loginForm model ]
                , Card.actions [ ]
                    [ loginButton model ]
                ]
        )

loginForm : Model -> Html Msg
loginForm model = 
    div []
        [ emailField model
        , passwordField model
        ]

emailField : Model -> Html Msg
emailField model =
    Textfield.render Mdl [0] model.mdl
            [ Textfield.label "Email"
            , Textfield.floatingLabel
            , Textfield.value model.username
            , Textfield.email
            , Textfield.error model.usernameError
                |> Options.when (not <| isEmpty model.usernameError)
            , Options.onInput UpdateUsername
            ]
            []

passwordIconStyle : List (Property c m)
passwordIconStyle =
    [ Options.css "position" "absolute"
    , Options.css "top" "18px"
    , Options.css "right" "5px"
    , Options.css "cursor" "pointer"
    ]

passwordField : Model -> Html Msg
passwordField model =
    div [ style [ ("position", "relative") ] ]
        [ Textfield.render Mdl [1] model.mdl
            [ Textfield.label "Password"
            , Textfield.floatingLabel
            , if model.showPassword then Textfield.text_ else Textfield.password
            , Textfield.value model.password
            , Textfield.error model.passwordError
                |> Options.when (not <| isEmpty model.passwordError)
            , Options.onInput UpdatePassword
            , Options.css "padding-right" "40px"
            ]
            [ ]
        , Options.span 
            passwordIconStyle
            [ Icon.view (if model.showPassword then "visibility" else "visibility_off")
                [ Tooltip.attach Mdl [2] 
                , Options.onClick (ShowPassword (not model.showPassword))]
            , Tooltip.render Mdl [2] model.mdl
                [ Tooltip.right]
                [ text (if model.showPassword then "Hide password" else "Show password") ]
            ]
        ]


loginButton : Model -> Html Msg
loginButton model =
    Button.render Mdl [3] model.mdl
            [ Button.raised
            , Button.ripple
            , Button.colored
            , Button.disabled
                |> Options.when (not <| (model.usernameTouched && 
                                        isEmpty model.usernameError && 
                                        model.passwordTouched &&
                                        isEmpty model.passwordError))
            , Options.onClick SubmitLoginForm
            ]
            [ text "Login" ]

        
        