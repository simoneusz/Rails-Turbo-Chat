# frozen_string_literal: true

# Monkey patch Dry::Validation::Result to provide a better string representation of errors
module DryValidationResultExtensions
  # Override to_s to provide a formatted error message string
  # @return [String] Formatted error message
  def to_s
    return "Valid" if success?

    # Format errors as "field: message1, message2; another_field: message3"
    errors.to_h.map do |field, messages|
      "#{field} #{Array(messages).join(', ')}"
    end.join('; ')
  end

  # Format errors as a hash with arrays of messages
  # @return [Hash] Hash with field names as keys and arrays of error messages as values
  def errors_hash
    errors.to_h
  end

  # Format errors as a flat array of strings
  # @return [Array<String>] Array of error messages
  def errors_array
    errors.to_h.flat_map do |field, messages|
      Array(messages).map { |msg| "#{field}: #{msg}" }
    end
  end
end

# Apply the extension to Dry::Validation::Result
Dry::Validation::Result.include(DryValidationResultExtensions)