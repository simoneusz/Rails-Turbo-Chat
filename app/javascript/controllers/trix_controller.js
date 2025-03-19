import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trix"
export default class TrixController extends Controller {
  static UNUSED_TOOLBAR_CLASSES = [
    // ".trix-button--icon-strike",
    // ".trix-button--icon-link",
    // ".trix-button-group--block-tools",
    // ".trix-button-group--file-tools",
    // ".trix-button-group--history-tools"
      ".trix-button--icon-bullet-list",
      ".trix-button--icon-number-list",
      ".trix-button--icon-decrease-nesting-level",
      ".trix-button--icon-increase-nesting-level",
  ];

  connect() {
    this.editor = this.data.element
    this.editor.addEventListener("keydown", this.handleKeydown.bind(this.editor))

    addEventListener("trix-initialize", function (event) {
      TrixController.removeToolbarIcons()
    }, true);
  }

  handleKeydown(event) {
    if (event.key === "Enter") {
      if (event.shiftKey) {
        return
      }

      event.preventDefault()

      const form = event.target.closest("form")
      if (form) {
        form.submit();
        form.reset();
      }
    }
  }

  static removeToolbarIcons() {
    TrixController.UNUSED_TOOLBAR_CLASSES.forEach((cls) => {
      if(document.querySelector(cls)) document.querySelector(cls).remove();
    });
  }
}
