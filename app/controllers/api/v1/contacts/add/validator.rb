# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Add
        class Validator
          def call(user, other_user)
            user != other_user
          end
        end
      end
    end
  end
end
