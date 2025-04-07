import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name"]

  submit(event) {
    const name = this.nameTarget.value.trim()
    console.log("name ", name)
    if (name === "") {
      event.preventDefault()
      alert("Room name is required.")
    }
  }
}