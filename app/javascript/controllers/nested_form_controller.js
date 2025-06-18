import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]
  static values = { wrapperClass: String }

  connect() {
    console.log("Nested form controller connected")
    if (!this.hasWrapperClassValue) {
      this.wrapperClassValue = "nested-fields"
    }
  }

  add(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML

    const timestamp = new Date().getTime()

    const newContent = content.replace(/NEW_RECORD/g, timestamp)

    this.containerTarget.insertAdjacentHTML('beforeend', newContent)
  }

  remove(event) {
    event.preventDefault()
    
    const wrapper = event.target.closest(`.${this.wrapperClass}`)

    if (wrapper.querySelector("input[name*='_destroy']")) {
      wrapper.querySelector("input[name*='_destroy']").value = 1
      wrapper.style.display = 'none'
    } else {
      wrapper.remove()
    }
  }

  get wrapperClass() {
    return this.data.get("wrapperClassValue") || "nested-fields"
  }
}
