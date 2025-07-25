# frozen_string_literal: true

module Constants
  module ErrorCodes
    CODE_ROOM_NOT_VALID = :new_room_invalid
    CODE_CANT_JOIN_PRIVATE_ROOM = :cant_join_private_room
    CODE_CANT_LEAVE_PEER_ROOM = :cant_leave_peer_room

    CODE_ADD_SELF_TO_CONTACTS = :contact_add_self
    CODE_NO_PENDING_CONTACTS = :no_pending_contacts
    CODE_CONTACT_INVALID = :contact_invalid
    CODE_CONTACT_ALREADY_EXISTS = :contact_already_exists
    CODE_CONTACT_DOESNT_EXISTS = :contact_doesnt_exists

    CODE_NOT_A_PARTICIPANT = :not_a_participant
    CODE_PARTICIPANT_DOESNT_EXIST = :participant_doesnt_exist
    CODE_PARTICIPANT_INVALID = :new_participant_invalid
    CODE_PARTICIPANT_ALREADY_EXISTS = :participant_already_exists
    CODE_UNKNOWN_ROLE = :unknown_role
    CODE_CANT_KICK_SELF = :cant_kick_self_from_room
    CODE_CANT_KICK_OWNER = :cant_kick_owner
    CODE_CANT_CHANGE_ROLE = :cant_change_role

    CODE_REACTION_INVALID = :invalid_reaction
    CODE_NO_REACTION_BY_USER = :no_reaction_by_user
    CODE_FAVORITE_DOES_NOT_EXIST = :favorite_doesnt_exist

    CODE_USER_UPDATE_FAILED = :user_update_failed
    CODE_USER_NOT_FOUND = :user_not_found
    CODE_STATUS_INVALID = :user_status_invalid
    CODE_USER_CANT_DESTROY_MESSAGE = :user_cant_destroy_message

    CODE_UNAUTHORIZED_NOTIFICATION_ACCESS = :unauthorized_notify
  end
end
