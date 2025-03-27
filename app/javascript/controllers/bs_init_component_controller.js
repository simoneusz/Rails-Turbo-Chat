import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bs-init-component"
export default class extends Controller {
  connect() {
    // TODO: logic for different tooltips, not only popovers
    let targets = document.querySelectorAll('[data-bs-toggle="popover"]')
    targets.forEach(target => {
      new bootstrap.Popover(target)
    })
  }
}
