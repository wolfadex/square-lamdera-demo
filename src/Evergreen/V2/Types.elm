module Evergreen.V2.Types exposing (..)

import Browser
import Browser.Navigation
import Lamdera
import Url


type UserMessage
    = UserMessageV1 String
    | UserMessageV2
        { content : String
        , clientId : Lamdera.ClientId
        }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , messages : List UserMessage
    , newMessage : String
    }


type alias BackendModel =
    { messages : List UserMessage
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
    | MessagesOnJoin (List UserMessage)
    | NewMessage UserMessage
