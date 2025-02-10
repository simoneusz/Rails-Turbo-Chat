import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trix"
export default class extends Controller {
  connect() {
    addEventListener("trix-initialize", function (event) {
      
    }, true);

    addEventListener("trix-file-accept", function (event) {
      event.preventDefault();
    }, true);

  }
}
