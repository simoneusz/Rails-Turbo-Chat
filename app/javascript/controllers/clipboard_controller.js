import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  copy(event) {
    const element = event.currentTarget;
    const content = element.querySelector(".copyable")?.innerText.trim();

    if (content) {
      navigator.clipboard.writeText(content).then(() => {
        this.showCopiedMessage(element);
      });
    }
  }

  showCopiedMessage(element) {
    const originalText = element.innerHTML;

    element.dataset.originalText = originalText;
    element.innerHTML = `<span class="text-success">Copied!</span>`;

    setTimeout(() => {
      element.innerHTML = element.dataset.originalText;
    }, 1500);
  }
}