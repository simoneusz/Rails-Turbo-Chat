# frozen_string_literal: true

module TransactionResponse
  extend ActiveSupport::Concern

  # Builds a response hash for a transaction, depending on the status, data, message and errors provided.
  # if errors are provided, the response will have a success: false and the errors will be returned in the response
  # otherwise, if data is provided, the response will have a success: true and the data will be returned in the response
  #
  # @param status [Symbol] status of the transaction
  # @param data [Hash] data to be returned in the response
  # @param message [String] message to be returned in the response
  # @param errors [Hash] errors to be returned in the response
  # @return [Hash] response hash
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
