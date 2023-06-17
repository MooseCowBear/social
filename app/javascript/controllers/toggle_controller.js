import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["change"]
  static targets = ["content", "menu"]

  toggle() {
    this.contentTargets.forEach(elem => {
      elem.classList.toggle(this.changeClass);
    });
  }

  remove() {
    this.contentTargets.forEach(elem => {
      elem.classList.remove(this.changeClass);
    });
  }

  add() {
    this.contentTargets.forEach(elem => {
      elem.classList.add(this.changeClass);
    });
  }

  disconnect() {
    //so menu will not remain open if navigating with the back button
    const menu = document.getElementById("menu");
    menu.classList.add("hidden");
  }
}