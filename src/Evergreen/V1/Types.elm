module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Lamdera
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , messages : List String
    , newMessage : String
    }


type alias BackendModel =
    { messages : List String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | NewMessageChanged String
    | NewMessageSubmit


type ToBackend
    = NoOpToBackend
    | SubmitNewMessage String


type BackendMsg
    = NoOpBackendMsg
    | UserConnected Lamdera.SessionId Lamdera.ClientId


type ToFrontend
    = NoOpToFrontend
    | MessagesOnJoin (List String)
    | NewMessage String
