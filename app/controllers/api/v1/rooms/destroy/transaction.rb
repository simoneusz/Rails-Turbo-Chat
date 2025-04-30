# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Destroy
        class Transaction
          def call(room, current_user)
            authorize = Api::V1::Rooms::Destroy::Authorizer.new.call(room, current_user)
            validator = Api::V1::Rooms::Destroy::Validator.new.call(room, current_user)
            return unless authorize && validator

            room.destroy

            { status: 'success', message: 'Room successfully destroyed' }
          end
        end
      end
    end
  end
end
