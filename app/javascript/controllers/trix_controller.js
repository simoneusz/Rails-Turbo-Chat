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
    addEventListener("trix-initialize", function (event) {
      console.log("im inititalized!");

      TrixController.removeToolbarIcons()

    }, true);
  }

  static removeToolbarIcons() {
    TrixController.UNUSED_TOOLBAR_CLASSES.forEach((cls) => {
      document.querySelector(cls).remove();
    });
  }
}
