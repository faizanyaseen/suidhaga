import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "target"]

  add(event) {
    event.preventDefault()
    
    // Get current timestamp for unique ID
    const timestamp = new Date().getTime()
    
    // Replace NEW_RECORD with timestamp for line items
    let content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, timestamp)
    
    // Make sure measurement type indices are unique by counting existing fields
    // and adding the count to each new field
    const existingFields = this.targetTarget.querySelectorAll('.measurement-type-fields').length
    
    // Replace measurement type indices with incremented values
    content = content.replace(/\[line_items_measurement_types_attributes\]\[(\d+|\w+)\]/g, 
                         (match, p1) => `[line_items_measurement_types_attributes][${existingFields}]`)
    
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