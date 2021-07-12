module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { messages = [ "Welcome to the chat!" ] }
    , Cmd.none
    )


subscriptions : Model -> Sub BackendMsg
subscriptions _ =
    Lamdera.onConnect UserConnected


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        UserConnected sessionId clientId ->
            ( model, Lamdera.sendToFrontend clientId (MessagesOnJoin model.messages) )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        SubmitNewMessage newMessage ->
            let
                messages =
                    List.take 100 (newMessage :: model.messages)
            in
            ( { model | messages = messages }
            , Lamdera.broadcast (NewMessage newMessage)
            )
