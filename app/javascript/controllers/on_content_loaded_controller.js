import { Controller } from "@hotwired/stimulus"
import "bootstrap";

// Connects to data-controller="on-content-loaded"
export default class extends Controller {
  connect() {
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
  }
}
