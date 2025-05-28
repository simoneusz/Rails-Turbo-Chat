# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Add
        class Transaction
          def call(user, other_user)
            authorize = Api::V1::Contacts::Add::Authorizer.new.call(user)
            validator = Api::V1::Contacts::Add::Validator.new.call(user, other_user)
            return unless authorize && validator

            result = ::Contacts::ContactService.new(user, other_user).request_contact

            if result.success?
              { status: 'success', message: 'Requested contact successfully' }
            else
              { errors: [{ status: '403', title: 'Forbidden' }] }
            end
          end
        end
      end
    end
  end
end
