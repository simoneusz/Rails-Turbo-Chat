# frozen_string_literal: true

module Api
  module V1
    module Users
      module Show
        class Transaction
          include ::TransactionResponse

          def call(params, user, current_user)
            Authorizer.new.call(user, current_user)

            validator = Validator.new.call(params)
            return unless validator

            response(status: :ok, data: Serializer.new.call(user), message: 'Ok')
          end
        end
      end
    end
  end
end
