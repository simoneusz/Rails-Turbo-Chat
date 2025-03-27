# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin '@rails/actiontext', to: 'actiontext.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
pin 'trix'
pin '@picmo/popup-picker', to: '@picmo--popup-picker.js' # @5.8.5
pin 'picmo' # @5.8.5
pin 'stimulus-use' # @0.52.3
pin "bootstrap", to: 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js'# @5.3.3
pin "@popperjs/core", to: "popper.js" # @2.11.8
