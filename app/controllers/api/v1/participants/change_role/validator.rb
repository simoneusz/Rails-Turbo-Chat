# frozen_string_literal: true

module Api
  module V1
    module Participants
      module ChangeRole
        # Validates participant#change_role action
        class Validator
          # Validates participant#change_role action
          #
          # @param params [ActionController::Parameters] params for changing participant role
          # @return [nil] nil if valid, raises Errors::ValidationError otherwise
          def call(params)
            schema = Api::V1::RequestSchemas::ParticipantChangeRoleSchema.new.call(params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
