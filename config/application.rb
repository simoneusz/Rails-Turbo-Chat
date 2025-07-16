# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require "rack/attack"

Bundler.require(*Rails.groups)

module TurboChat
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w[assets tasks])
    config.eager_load_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/app/services]
    config.generators do |generator|
      generator.test_framework :rspec
    end
  end
end
