# frozen_string_literal: true

module TransactionResponse
  extend ActiveSupport::Concern

  def success_response(status, data, serializer, message = nil)
    {
      status:,
      message:,
      data: serializer.new(data).serializable_hash[:data]
    }
  end

  def error_response(status, data, message = nil)
    {
      errors: {
        status:,
        title: 'Error',
        message:,
        data:
      }
    }
  end
end
