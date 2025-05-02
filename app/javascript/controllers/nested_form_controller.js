import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]
  static values = { wrapperClass: String }

  connect() {
    // Set default wrapper class if not provided
    if (!this.hasWrapperClassValue) {
      this.wrapperClassValue = "nested-fields"
    }
  }

  add(event) {
    event.preventDefault()

    // Generate a unique timestamp-based ID for the new record
    const timestamp = new Date().getTime()

    // Clone the template content and replace NEW_RECORD with the timestamp
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, timestamp)
    
    // Insert the new content at the end of the container
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  remove(event) {
    event.preventDefault()

    // Find the closest wrapper element using the button's parent elements
    const button = event.currentTarget
    let item = button

    // Get the wrapper class from the controller's data attribute
    const wrapperClass = this.wrapperClassValue
    // Traverse up the DOM until we find the wrapper element with the specified class
    while (item && !item.classList.contains(wrapperClass)) {
      item = item.parentElement
    }

    if (!item) {
      console.error(`Could not find wrapper element with class '${wrapperClass}'`)
      return
    }

    // Check if this is a persisted record (has an ID)
    const idInput = item.querySelector("input[name*='[id]']")
    
    if (idInput) {
      // For existing records, hide the item and mark for destruction
      item.style.display = 'none'
      const destroyInput = item.querySelector("input[name*='[_destroy]']")
      if (destroyInput) {
        destroyInput.value = "1"
      }
    } else {
      // For new records, simply remove from the DOM
      item.remove()
    }
  }
} 