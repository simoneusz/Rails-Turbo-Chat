import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-modal"
export default class extends Controller {
  connect() {
    document.addEventListener("turbo:frame-load", () => {
      console.log('frame loaded')
      let modal = document.getElementById("user-modal");
      if (modal) {
        modal.style.display = "block";
      }
    }, {once: true});

  }
  closeModal() {
    let modal = document.getElementById("user-modal");
    let turbo = document.getElementById("modal_frame")
    if (modal) {
      modal.style.opacity = "0";
      setTimeout(() => modal.remove(), 300);
    }
    turbo.innerHTML = ""
    turbo.removeAttribute("src")
    turbo.removeAttribute("complete")
    console.log("closing modal")
  }
}
