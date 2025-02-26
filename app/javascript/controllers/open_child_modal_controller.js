import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="open-child-modal"
// Stimulus controller for opening child modals without closing the parent modal
//
// Usage:
// 1. Add data-controller="open-child-modal" to the parent modal container.
// 2. Add data-open-child-modal-target="trigger" to buttons that should open a child modal.
// 3. Ensure each button has data-bs-target="#modalId" pointing to the target modal.
// 4. Ensure each child modal has id="modalId" the same as data-bs-target.
//
export default class extends Controller {
    static targets = ["trigger"];

    connect() {
        this.triggerTargets.forEach(button => {
            button.addEventListener("click", (event) => this.openTargetModal(event));
        });
    }

    openTargetModal(event) {
        event.preventDefault();

        const targetModalId = event.currentTarget.getAttribute("data-bs-target")?.replace("#", "");
        if (!targetModalId) {
            console.warn("No target modal ID found.");
            return;
        }

        const targetModal = document.getElementById(targetModalId);
        if (!targetModal) {
            console.warn(`Modal with ID '${targetModalId}' not found.`);
            return;
        }

        const bootstrapModal = new bootstrap.Modal(targetModal);
        bootstrapModal.show();
    }
}