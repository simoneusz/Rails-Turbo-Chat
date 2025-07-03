# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Index
        # Orchestrates room#all action
        class Transaction
          include ::TransactionResponse
          # Orchestrates room#all action
          #
          # @param rooms [Room::ActiveRecord_Relation] rooms to be filtered
          # @param params [ActionController::Parameters] params for filter rooms
          # @return [Hash] transaction response with status, data, message
          def call(rooms, params)
            Authorizer.new.call
            Validator.new.call

            query = Queries::RoomsQuery.new(rooms, params)
            pagy, rooms = query.call

            response(status: :ok,
                     data: Serializer.new.call(rooms),
                     message: 'Ok',
                     meta: { pagy: pagy, total_count: pagy.count, total_pages: pagy.pages })
          end
        end
      end
    end
  end
end
