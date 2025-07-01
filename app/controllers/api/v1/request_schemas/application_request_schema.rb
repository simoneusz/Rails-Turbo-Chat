# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class ApplicationRequestSchema < Dry::Validation::Contract
        # @return Dry::Validation::Result
        def self.call(options)
          new.call(options)
        end
      end
    end
  end
end
