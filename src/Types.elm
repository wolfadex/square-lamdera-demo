module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId, SessionId)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , messages : List String
    , newMessage : String
    }


type alias BackendModel =
    { messages : List String
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
    | MessagesOnJoin (List String)
    | NewMessage String
