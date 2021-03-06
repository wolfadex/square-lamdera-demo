module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId, SessionId)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , messages : List UserMessage
    , newMessage : String
    }


type alias BackendModel =
    { messages : List UserMessage
    }


type UserMessage
    = UserMessageV1 String
    | UserMessageV2
        { content : String
        , clientId : ClientId
        }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | NewMessageChanged String
    | NewMessageSubmit


type ToBackend
    = NoOpToBackend
    | SubmitNewMessage String


type BackendMsg
    = NoOpBackendMsg
    | UserConnected SessionId ClientId


type ToFrontend
    = NoOpToFrontend
    | MessagesOnJoin (List UserMessage)
    | NewMessage UserMessage
