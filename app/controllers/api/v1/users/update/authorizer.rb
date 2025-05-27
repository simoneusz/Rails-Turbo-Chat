# frozen_string_literal: true

module Api
  module V1
    module Users
      module Update
        class Authorizer
          def call(user, current_user)
            Pundit.authorize current_user, user, :update?
          end
        end
      end
    end
  end
end
