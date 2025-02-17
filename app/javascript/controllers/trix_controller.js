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

    // wait for the trix editor is attached to the DOM to do stuff
    addEventListener("trix-initialize", function (event) {
      console.log("im inititalized!");

      TrixController.removeToolbarIcons()

    }, true);

    // remove file upload handling
    // addEventListener("trix-file-accept", function (event) {
    //   event.preventDefault();
    // }, true);

  }

  static removeToolbarIcons() {
    TrixController.UNUSED_TOOLBAR_CLASSES.forEach((cls) => {
      document.querySelector(cls).remove();
    });
  }
}
