# frozen_string_literal: true

module Api
  module V1
    module Favorites
      module Toggle
        # Orchestrates favorite#toggle action
        class Transaction
          include ::TransactionResponse
          # Orchestrates favorite#toggle action
          #
          # @param params [ActionController::Parameters] params for toggle favorite
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(params, room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call(params)

            result = toggle_favorite_service(room, current_user)

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: response_status(result.data), data: Serializer.new.call(result.data), message: 'Created')
          end

          private

          def toggle_favorite_service(room, current_user)
            favorite = current_user.favorite_rooms.find_by(room:)
            ::Favorites::ToggleService.new(favorite, room, current_user).toggle_favorite
          end

          def response_status(favorite)
            favorite ? :created : :no_content
          end
        end
      end
    end
  end
end
