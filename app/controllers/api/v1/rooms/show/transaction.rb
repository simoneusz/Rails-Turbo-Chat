# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Show
        class Transaction
          include ::TransactionResponse

          def call(room, current_user)
            authorize = Authorizer.new.call(room, current_user)
            return unless authorize

            Validator.new.call

            response(status: :ok, data: Serializer.new.call(room), message: 'Ok')
          end
        end
      end
    end
  end
end
