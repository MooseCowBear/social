import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["change"]
  static targets = ["content", "menu"]

  toggle() {
    this.contentTargets.forEach(elem => {
      console.log("the button was pressed", elem, this.changeClass);
      elem.classList.toggle(this.changeClass);
    });
  }

  remove() {
    this.contentTargets.forEach(elem => {
      console.log("the remove button was pressed", elem, this.changeClass);
      elem.classList.remove(this.changeClass);
    });
  }

  add() {
    this.contentTargets.forEach(elem => {
      console.log("the add button was pressed", elem, this.changeClass);
      elem.classList.add(this.changeClass);
    });
  }
}