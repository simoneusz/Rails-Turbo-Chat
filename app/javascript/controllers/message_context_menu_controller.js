import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-context-menu"
export default class extends Controller {
  // static targets = ["menu", "editLink", "deleteLink", "showLink"];
  static targets = ["menu", "deleteLink"];

  connect() {
    this.hideMenu = this.hideMenu.bind(this);
    document.addEventListener("click", this.hideMenu);
  }
  disconnect() {
    document.removeEventListener("click", this.hideMenu);
    document.removeEventListener("scroll", this.hideMenu);
  }

  open(event) {
    event.preventDefault();
    event.stopPropagation();

    let clickedElement = event.target;
    let messageId = this.getMessageId(clickedElement);
    let roomId = this.getRoomId(clickedElement);
    if (messageId && roomId) {
      this.prepareMenuForTodoItem(messageId, roomId);
    } else {
      this.hideMenuOptions();
    }

    this.positionMenu(event);
    this.menuTarget.classList.remove("d-none");
  }

  prepareMenuForTodoItem(messageId, roomId) {
    this.updateLinkTargets(messageId, roomId);
    this.showMenuOptions();
  }

  hideMenuOptions() {
    this.toggleMenuOptions(true);
  }

  showMenuOptions() {
    this.toggleMenuOptions(false);
  }

  updateLinkTargets(messageId, roomId) {
    const messagePath = `/rooms/${roomId}/messages/${messageId}`;
    this.deleteLinkTarget.href = messagePath;
  }

  getMessageId(clickedElement) {
    const container = clickedElement.closest(".message-content");
    if (!container) return null;

    const messageElement = container.querySelector("[data-message-id]");
    return messageElement ? messageElement.dataset.messageId : null;
  }

  getRoomId(clickedElement) {
    const container = clickedElement.closest(".message-content");
    if (!container) return null;

    const messageElement = container.querySelector("[data-room-id]");
    return messageElement ? messageElement.dataset.roomId : null;
  }

  toggleMenuOptions(hide) {
    this.deleteLinkTarget.classList.toggle("d-none", hide);
  }

  positionMenu(event) {
    let menuDimensions = this.getDimensions(this.menuTarget);
    this.menuTarget.style.left = `${this.clampValue(
        event.clientX,
        window.innerWidth,
        menuDimensions.width
    )}px`;
    this.menuTarget.style.top = `${this.clampValue(
        event.clientY,
        window.innerHeight,
        menuDimensions.height
    )}px`;
  }

  clampValue(value, maxValue, elementDimension) {
    let viewportDimension = maxValue - elementDimension;
    return value > viewportDimension ? viewportDimension : value;
  }

  getDimensions(element) {
    let dimensions = {};
    element.classList.remove("d-none");
    dimensions.width = element.offsetWidth;
    dimensions.height = element.offsetHeight;
    element.classList.add("d-none");
    return dimensions;
  }

  hideMenu(event) {
    if (this.shouldHideMenu(event)) {
      this.menuTarget.classList.add("d-none");
    }
  }

  shouldHideMenu(event) {
    return (
        !this.menuTarget.contains(event.target) ||
        event.target === this.menuTarget ||
        event.target.closest("a")
    );
  }
}
