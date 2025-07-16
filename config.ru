# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require 'rack/attack'
use Rack::Attack

require_relative 'config/environment'

run Rails.application
Rails.application.load_server
