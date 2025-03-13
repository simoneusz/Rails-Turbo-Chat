import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    parentMessageId: Number
  }

  connect() {
    console.log("message-scroll connected")
    this.room = document.getElementById("single_room")
  }

  scrollToMessage(retryCount = 5) {
    if (retryCount === 0) {
      return
    }

    const parentMessage = document.querySelector(`[data-message-id='${this.parentMessageIdValue}']`)

    if (parentMessage) {
      const rect = parentMessage.getBoundingClientRect()
      const offset = parentMessage.offsetHeight + 100
      console.log(`Scrolling to message ID: ${this.parentMessageIdValue}`)

      this.room.scrollTo({
        top: this.room.scrollTop + rect.top - offset,
        behavior: "smooth"
      })

      let messageContent = parentMessage.closest(".message-content")
      if (messageContent && !messageContent.classList.contains("message_highlight")) {
        messageContent.classList.add("message_highlight")
        setTimeout(() => messageContent.classList.remove("message_highlight"), 2000)
      }
    } else {
      console.log("cant find message, scrolling..")

      this.room.scrollTo({ top: 0, behavior: "smooth" })

      setTimeout(() => this.scrollToMessage(retryCount - 1), 1000)
    }
  }
}