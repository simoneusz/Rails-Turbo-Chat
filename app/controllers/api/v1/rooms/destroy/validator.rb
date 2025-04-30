# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Destroy
        class Validator
          def call(room, current_user)
            room.creator_id = current_user.id
          end
        end
      end
    end
  end
end
