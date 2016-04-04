import Http.Extra as Http
import Task exposing (Task)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (Signal, Mailbox)
import StartApp
import Effects exposing (Never, Effects)
import Json.Decode as Decode exposing (Value, (:=))

import Native.AsIs


type alias Model = Int

type alias ExampleAdder =
    { add : Int
    }

type ServerCommand
    = ConsoleLog
    | Add Int
    | Sub Int
    | RecordAdd ExampleAdder

type Action
    = SendCommand ServerCommand
    | UpdateModel Model
    | Noop


asIs : a -> Value
asIs =
    Native.AsIs.asIs

init : (Model, Effects.Effects Action)
init = (0, Effects.none)

decodeModel : Decode.Decoder Model
decodeModel =
    "model" := Decode.int

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
    case action of
        Noop ->
            (model, Effects.none)
        SendCommand command ->
            let
                task =
                    Http.post "/api"
                        |> Http.withHeader "Content-Type" "application/json"
                        |> Http.withJsonBody (asIs command)
                        |> Http.send (Http.jsonReader decodeModel) Http.stringReader
                        |> Task.toMaybe
                        |> Task.map (\x ->
                            case x of
                                Just model ->
                                    UpdateModel model.data
                                Nothing ->
                                    Noop
                            )


            in
                (model, Effects.task task)

        UpdateModel model ->
            (model, Effects.none)


view : Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ div [ onClick address (SendCommand ConsoleLog) ] [ text "log" ]
        , div [ onClick address (SendCommand (Add 1)) ] [ text "Add 1" ]
        , div [ onClick address (SendCommand (Sub 1)) ] [ text "Sub 1" ]
        , div [ onClick address (SendCommand (RecordAdd { add =  5 })) ] [ text "Sub 1" ]
        , text ("current model: " ++ toString model)
        ]

app : StartApp.App Model
app =
    StartApp.start
        { init = init
        , update = update
        , inputs = []
        , view = view
        }



main : Signal Html
main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

