import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="favorite-animation"
export default class extends Controller {
  static targets = ["favorite"]
  connect() {
    this.handleAnimation()
  }

  handleAnimation(){
    let star = this.favoriteTarget;
    let button = star.closest(".btn")
    button.addEventListener("click", function(e) {
      if (star.classList.contains("starred")) {
        star.classList.remove("starred");
        star.classList.add("unstarred");
      } else if (star.classList.contains("unstarred")) {
        star.classList.remove("unstarred");
        star.classList.add("starred");
      } else {
        star.classList.add("starred");
      }
    });

  }
}
