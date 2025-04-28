# frozen_string_literal: true

module Api
  module V1
    module Users
      module Update
        class Authorizer
          def call(_params)
            true
          end
        end
      end
    end
  end
end
