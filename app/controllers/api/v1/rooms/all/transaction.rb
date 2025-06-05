# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module All
        class Transaction
          include ::TransactionResponse

          def call
            Authorizer.new.call
            Validator.new.call

            rooms = Room.public_rooms
            # TODO: add sorting from params?
            response(status: :ok, data: Serializer.new.call(rooms), message: 'Ok')
          end
        end
      end
    end
  end
end
