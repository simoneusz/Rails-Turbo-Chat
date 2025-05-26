# frozen_string_literal: true

module Api
  class ErrorsController < ApiController
    def not_found
      render json: { errors: { status: 404, title: 'Not found', message: 'Route not found' } }, status: :not_found
    end
  end
end
