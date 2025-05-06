# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Dms
        class Authorizer
          def call(_current_user)
            true
          end
        end
      end
    end
  end
end
