# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      # Validates params for changing participant role
      class ParticipantChangeRoleSchema < ApplicationRequestSchema
        params do
          required(:role).filled(:string, included_in?: Participant.roles.keys.excluding('owner', 'peer'))
        end
      end
    end
  end
end
