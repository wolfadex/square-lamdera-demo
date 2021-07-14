module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes as Attr
import Lamdera
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , messages = []
      , newMessage = ""
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Cmd.batch [ Nav.pushUrl model.key (Url.toString url) ]
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        NewMessageChanged newMessage ->
            ( { model | newMessage = newMessage }, Cmd.none )

        NewMessageSubmit ->
            ( { model | newMessage = "" }, Lamdera.sendToBackend (SubmitNewMessage model.newMessage) )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        MessagesOnJoin messages ->
            ( { model | messages = messages }, Cmd.none )

        NewMessage message ->
            ( { model | messages = List.take 100 (message :: model.messages) }, Cmd.none )


view : Model -> Lamdera.Document FrontendMsg
view model =
    { title = ""
    , body =
        [ layout [ width fill, height fill, padding 16 ] (viewBody model) ]
    }


viewBody : Model -> Element FrontendMsg
viewBody model =
    column
        [ width fill, height fill ]
        [ model.messages
            |> groupByClient
            |> List.map viewMessageGroup
            |> column [ height fill, width fill ]
        , viewNewMessage model.newMessage
        ]


groupByClient : List UserMessage -> List (List UserMessage)
groupByClient messages =
    List.foldl
        (\message groups ->
            case message of
                UserMessageV1 _ ->
                    [ message ] :: groups

                UserMessageV2 newMessage ->
                    case groups of
                        [] ->
                            [ [ message ] ]

                        first :: rest ->
                            case first of
                                [] ->
                                    [ message ] :: rest

                                (UserMessageV2 { clientId }) :: _ ->
                                    if clientId == newMessage.clientId then
                                        (message :: first) :: rest

                                    else
                                        [ message ] :: groups

                                _ ->
                                    [ message ] :: groups
        )
        []
        messages


viewNewMessage : String -> Element FrontendMsg
viewNewMessage newMessage =
    row
        [ width fill, spacing 16 ]
        [ Input.text
            [ width fill ]
            { onChange = NewMessageChanged
            , text = newMessage
            , placeholder = Nothing
            , label = Input.labelHidden "new message"
            }
        , Input.button
            []
            { onPress =
                if String.isEmpty newMessage then
                    Nothing

                else
                    Just NewMessageSubmit
            , label = text "Send"
            }
        ]


viewMessageGroup : List UserMessage -> Element FrontendMsg
viewMessageGroup messageGroups =
    column
        [ width fill
        , padding 8
        , Border.solid
        , Border.widthEach
            { top = 0
            , bottom = 1
            , left = 0
            , right = 0
            }
        ]
        [ messageGroups
            |> List.head
            |> Maybe.map
                (\message ->
                    text ("[" ++ viewClientId message ++ "]")
                        |> el
                            [ Font.bold
                            , paddingEach
                                { top = 0
                                , bottom = 0
                                , left = 0
                                , right = 8
                                }
                            , alignTop
                            ]
                )
            |> Maybe.withDefault none
        , messageGroups
            |> List.map viewMessage
            |> column
                [ width fill ]
        ]


viewClientId : UserMessage -> String
viewClientId message =
    case message of
        UserMessageV1 _ ->
            "Anonymous"

        UserMessageV2 { clientId } ->
            clientId


viewMessage : UserMessage -> Element FrontendMsg
viewMessage message =
    paragraph
        [ width fill ]
        [ text (viewContent message)
        ]


viewContent : UserMessage -> String
viewContent message =
    case message of
        UserMessageV1 content ->
            content

        UserMessageV2 { content } ->
            content
