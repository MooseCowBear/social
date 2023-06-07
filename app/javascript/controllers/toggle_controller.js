import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["change"]
  static targets = ["content"]

  toggle() {
    this.contentTargets.forEach(elem => {
      elem.classList.toggle(this.changeClass);
    });
  }
}