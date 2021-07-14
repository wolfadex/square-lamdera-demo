module Evergreen.Migrate.V2 exposing (..)

import Evergreen.V1.Types as Old
import Evergreen.V2.Types as New
import Lamdera.Migrations exposing (..)


frontendModel : Old.FrontendModel -> ModelMigration New.FrontendModel New.FrontendMsg
frontendModel old =
    ModelMigrated
        ( { key = old.key
          , messages = List.map New.UserMessageV1 old.messages
          , newMessage = old.newMessage
          }
        , Cmd.none
        )


backendModel : Old.BackendModel -> ModelMigration New.BackendModel New.BackendMsg
backendModel old =
    ModelMigrated
        ( { messages = List.map New.UserMessageV1 old.messages
          }
        , Cmd.none
        )


frontendMsg : Old.FrontendMsg -> MsgMigration New.FrontendMsg New.FrontendMsg
frontendMsg old =
    MsgUnchanged


toBackend : Old.ToBackend -> MsgMigration New.ToBackend New.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Old.BackendMsg -> MsgMigration New.BackendMsg New.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Old.ToFrontend -> MsgMigration New.ToFrontend New.FrontendMsg
toFrontend old =
    case old of
        Old.NoOpToFrontend ->
            MsgUnchanged

        Old.NewMessage content ->
            MsgMigrated ( New.NewMessage (New.UserMessageV1 content), Cmd.none )

        Old.MessagesOnJoin oldMessages ->
            MsgMigrated ( New.MessagesOnJoin (List.map New.UserMessageV1 oldMessages), Cmd.none )
