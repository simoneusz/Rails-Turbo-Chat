// app/javascript/controllers/avatar_preview_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "message", "preview"]

  connect() {
    this.messageTarget.style.display = "none"
  }

  preview() {
    const file = this.inputTarget.files[0];
    if (file) {
      this.messageTarget.style.display = "block";
      this.messageTarget.textContent = "New image selected!";

      const reader = new FileReader();
      reader.onload = e => {
        this.previewTarget.src = e.target.result;
      };
      reader.readAsDataURL(file);
    } else {
      this.messageTarget.style.display = "none";
    }
  }
}