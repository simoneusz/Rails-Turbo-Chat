import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
// Controller for 'on-demand modal' that loads after calling it via link or button
// with attribute data: { turbo_frame: 'modal_frame'}

export default class extends Controller {
  connect() {
    document.addEventListener("turbo:frame-load", () => {
      let modal = new bootstrap.Modal(this.element);
      if (modal) {
        modal.show()
        this.element.addEventListener("hidden.bs.modal", (e) => {
          this.onCloseModal()
        })
      }
    }, {once: true});

  }

  onCloseModal() {
    console.log('onclosemodal')
    let turbo = document.getElementById("modal_frame")
    turbo.innerHTML = ""
    turbo.removeAttribute("src")
    turbo.removeAttribute("complete")
  }
}
