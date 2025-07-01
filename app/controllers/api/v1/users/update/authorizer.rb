# frozen_string_literal: true

module Api
  module V1
    module Users
      module Update
        # Authorizes a user to be updated
        class Authorizer
          # Authorizes a user to be updated
          #
          # @param user [User] user instance
          # @param current_user [User] current logged user
          # @return [Boolean] true if authorized, raises Pundit::NotAuthorizedError otherwise
          def call(user, current_user)
            Pundit.authorize current_user, user, :update?
          end
        end
      end
    end
  end
end
