# frozen_string_literal: true

module TransactionResponse
  extend ActiveSupport::Concern
  # Builds transaction response
  #
  # @param status [Symbol] HTTP status code
  # @param data [Hash] data to be returned
  # @param message [String] message to be returned
  # @param errors [Hash] errors to be returned
  # @param meta [Hash] metadata including pagination to be returned
  # @return [Hash] transaction response with status, data, message
  def response(status:, data: nil, message: nil, errors: nil, meta: nil)
    base_response = build_base_response(status, message, meta)
    if errors
      error_response(base_response, errors)
    elsif data
      success_response(base_response, data)
    else
      base_response
    end
  end

  private

  def build_base_response(status, message, meta)
    response = { status: }
    response[:message] = message if message
    response[:meta] = meta unless meta.nil?
    response
  end

  def error_response(base, errors)
    base.merge(
      success: false,
      errors: {
        title: 'Error',
        data: errors
      }
    )
  end

  def success_response(base, data)
    base.merge(
      success: true,
      data: data[:data]
    )
  end
end
