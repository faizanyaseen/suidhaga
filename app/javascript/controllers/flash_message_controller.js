import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alert"]

  connect() {
    console.log("Flash message controller connected")
  }

  close() {
    console.log("Closing flash message")
    // Add fade out animation
    this.element.style.transition = "opacity 0.3s ease-out"
    this.element.style.opacity = "0"
    
    // Remove element after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
