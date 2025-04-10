import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bs-init-component"
export default class extends Controller {
  connect() {
    let toggle_type = this.element.attributes['data-bs-toggle'].value;
    switch (toggle_type) {
      case 'tooltip':
        new bootstrap.Tooltip(this.element, {});
        break;
      case 'popover':
        new bootstrap.Popover(this.element, {});
        break;
    }
  }
}
