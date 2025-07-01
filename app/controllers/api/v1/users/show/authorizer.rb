# frozen_string_literal: true

module Api
  module V1
    module Users
      module Show
        # Authorizes a user to be shown
        class Authorizer
          # Authorizes a user to be shown
          #
          # @param user [User] user instance
          # @param current_user [User] current logged user
          # @return [User] user record if authorized, raises Pundit::NotAuthorizedError otherwise
          def call(user, current_user)
            Pundit.authorize current_user, user, :show?
          end
        end
      end
    end
  end
end
