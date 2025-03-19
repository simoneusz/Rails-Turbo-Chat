import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reply"

export default class extends Controller {
  static targets = ["replyBox", "replyText", "parentMessageId"]

  connect() {}

  setReply(event) {
    console.log("set reply")
    const messageId = event.currentTarget.dataset.messageId
    const messageText = event.currentTarget.dataset.messageText
    console.log(this)
    this.replyTextTarget.innerText = `${messageText}`
    this.parentMessageIdTarget.value = messageId
    this.replyBoxTarget.style.display = "flex"
  }

  clearReply() {
    console.log("clear reply")
    this.replyBoxTarget.style = "display: none !important;"
    this.replyTextTarget.innerText = ""
    this.parentMessageIdTarget.value = ""
  }
}
