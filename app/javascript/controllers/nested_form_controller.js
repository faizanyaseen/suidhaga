import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "target"]

  add(event) {
    event.preventDefault()
    
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.targetTarget.insertAdjacentHTML('beforeend', content)
  }

  remove(event) {
    event.preventDefault()
    
    const wrapper = event.target.closest('.line-item-fields, .measurement-type-fields')
    
    // If there's a hidden _destroy field, set it to 1, otherwise remove the field
    const destroyField = wrapper.querySelector('input[name*="_destroy"]')
    if (destroyField) {
      destroyField.value = 1
      wrapper.style.display = 'none'
    } else {
      wrapper.remove()
    }
  }
} 