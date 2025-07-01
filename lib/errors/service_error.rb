# frozen_string_literal: true

module Errors
  class ServiceError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super
    end
  end
end
