import { Controller } from "@hotwired/stimulus"
import Split from "split.js";

// Connects to data-controller="room-resizer"
export default class extends Controller {
  connect() {
    let main = document.querySelector("main")
    let elements = main.childNodes;
    Split([...main.children], {
      sizes: [25, 75],
      minSize: [250, 500],
    })
    let gutter = document.querySelector(".gutter")
  }
}
