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

    CODE_REACTION_INVALID = :invalid_reaction
    CODE_FAVORITE_DOES_NOT_EXIST = :favorite_doesnt_exist
  end
end
