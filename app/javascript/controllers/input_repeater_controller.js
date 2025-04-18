import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="input-repeater"
export default class extends Controller {
  static targets = ["inputRepeater", "outputRepeater"]

  repeat(){
    let value = this.inputRepeaterTarget.value;
    if (value === "") {
      this.outputRepeaterTarget.innerHTML = "room name"
    } else{
      this.outputRepeaterTarget.innerHTML = value;
    }
  }
}
