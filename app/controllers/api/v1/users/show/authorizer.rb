# frozen_string_literal: true

module Api
  module V1
    module Users
      module Show
        class Authorizer
          def call(_params, user, current_user)
            Pundit.authorize current_user, user, :show?
          end
        end
      end
    end
  end
end
