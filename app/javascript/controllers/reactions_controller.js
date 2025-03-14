import { Controller } from "@hotwired/stimulus";
import { createPopup } from "@picmo/popup-picker";

export default class extends Controller {
  static targets = ["pickerContainer"];

  connect() {
    console.log("Reactions controller connected");
  }

  open(event) {
    const button = event.currentTarget;
    const messageId = button.dataset.messageId;

    const picker = createPopup(
      {
        rootElement: this.pickerContainerTarget,
      },
      {
        triggerElement: button,
        referenceElement: button,
        position: "bottom-start",
      }
    );

    picker.addEventListener("emoji:select", (event) => {
      this.addReaction(messageId, event.emoji);
    });

    picker.open();
  }

  addReaction(messageId, emoji) {
    fetch(`/messages/${messageId}/reactions`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({emoji: emoji}),
    }).then(r => console.log(r));
  }
}