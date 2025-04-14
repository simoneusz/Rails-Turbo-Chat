import { Controller } from "@hotwired/stimulus"
import Split from "split.js"

export default class extends Controller {
  connect() {
    const gutter = document.querySelector(".gutter")
    if (gutter) gutter.remove()

    const main = document.querySelector("main")
    const elements = [...main.children]

    const savedSizes = localStorage.getItem("split-sizes")
    const sizes = savedSizes ? JSON.parse(savedSizes) : [33, 66]

    this.split = Split(elements, {
      sizes: sizes,
      minSize: [250, 500],
      onDragEnd: (newSizes) => {
        localStorage.setItem("split-sizes", JSON.stringify(newSizes))
      },
    })
  }
}