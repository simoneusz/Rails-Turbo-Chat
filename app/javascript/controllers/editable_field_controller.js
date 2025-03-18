import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["display", "form"];

  connect() {
    this.originalContent = this.displayTarget.innerHTML;
  }

  edit() {
    this.displayTarget.classList.add("d-none");
    this.formTarget.classList.remove("d-none");
    this.formTarget.querySelector("input").focus();
  }

  cancel(event) {
    event.preventDefault();
    this.displayTarget.classList.remove("d-none");
    this.formTarget.classList.add("d-none");
  }
}
