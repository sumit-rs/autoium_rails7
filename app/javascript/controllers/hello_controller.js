import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    //this.element.textContent = "Hello World!"
    console.log("home controller has been connected");
  }
}
