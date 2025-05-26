import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customerSelect", "lineItemsSection", "addLineItemButton", "dependentField"]

  connect() {
    console.log("Order form controller connected")
    this.toggleFieldsState()
    this.toggleLineItems()
  }

  toggleFieldsState() {
    const customerSelected = this.customerSelectTarget.value !== ""

    this.dependentFieldTargets.forEach(field => {
      field.disabled = !customerSelected
    })
  }

  customerChanged() {
    this.toggleFieldsState()
    this.toggleLineItems()
  }

  toggleLineItems() {
    const customerSelected = this.customerSelectTarget.value !== ""

    if (customerSelected) {
      this.lineItemsSectionTarget.classList.remove("opacity-50", "pointer-events-none")
      if (this.hasAddLineItemButtonTarget) {
        this.addLineItemButtonTarget.disabled = false
      }
    } else {
      this.lineItemsSectionTarget.classList.add("opacity-50", "pointer-events-none")
      if (this.hasAddLineItemButtonTarget) {
        this.addLineItemButtonTarget.disabled = true
      }
    }
  }
}
