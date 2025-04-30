# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Create
        class Transaction
          include ::TransactionResponse

          def call(room_params, current_user)
            authorize = Api::V1::Rooms::Create::Authorizer.new.call(room_params, current_user)
            validator = Api::V1::Rooms::Create::Validator.new.call(room_params, current_user)
            return unless authorize && validator

            result = ::Rooms::CreateRoomService.new(room_params, current_user).call

            return error_response(:forbidden, [result.data, result.error_code], 'Forbidden') unless result.success?

            success_response(:ok, result.data, Api::V1::Serializers::RoomSerializer, 'Success')
          end
        end
      end
    end
  end
end
