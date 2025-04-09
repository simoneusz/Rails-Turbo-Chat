// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import * as bootstrap from "bootstrap"
import "./channels"
import * as trix from "trix"
import "@rails/actiontext"
import "trix"
import "@rails/actiontext"

function searchHotkey(e) {
    e.preventDefault()
    if (e.ctrlKey && e.code === 'KeyM') {
      let modal = document.querySelector("#searchModal");
      if (!modal.classList.contains("show")) {
        let b_modal = new bootstrap.Modal(modal)
        b_modal.show()
      }
    }
}

document.addEventListener('keyup', searchHotkey, false);