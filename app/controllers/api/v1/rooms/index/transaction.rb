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
          # @return [Hash] transaction response with status, data, message
          def call(rooms, params)
            Authorizer.new.call
            Validator.new.call

            query = Api::V1::Queries::RoomsQuery.new(rooms, params)
            _pagy, rooms = query.call
            Rails.logger.info(rooms)
            Rails.logger.info(rooms.count)

            # TODO: add pagy meta information
            # pagy: pagy,
            # total_count: rooms.count,
            # total_pages: pagy.pages

            response(status: :ok, data: Serializer.new.call(rooms), message: 'Ok')
          end
        end
      end
    end
  end
end
