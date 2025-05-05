# frozen_string_literal: true

module TransactionResponse
  extend ActiveSupport::Concern

  def response(status:, data: nil, message: nil, errors: nil)
    body = { status: }
    body[:message] = message if message

    if errors
      body[:success] = false
      body[:errors] = { title: 'Error', data: errors }
    elsif data
      body[:success] = true
      body[:data] = data[:data]
    end

    body
  end
end
