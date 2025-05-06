# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Destroy
        class Validator
          def call(_room, _current_user)
            true
          end
        end
      end
    end
  end
end
