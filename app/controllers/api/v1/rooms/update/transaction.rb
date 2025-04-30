# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Update
        class Transaction
          def call(room, room_params, current_user)
            authorize = Api::V1::Rooms::Update::Authorizer.new.call(room_params, current_user)
            validator = Api::V1::Rooms::Update::Validator.new.call(room_params, current_user)
            return unless authorize && validator

            room.update(room_params)

            { status: 'success', message: 'Room successfully updated' }
          end
        end
      end
    end
  end
end
