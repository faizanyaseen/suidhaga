import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customerSelect", "lineItemsSection", "addLineItemButton"]

  connect() {
    this.toggleLineItems()
  }

  toggleLineItems() {
    const customerSelected = this.customerSelectTarget.value !== ""

    if (customerSelected) {
      this.lineItemsSectionTarget.classList.remove("opacity-50", "pointer-events-none")
      this.addLineItemButtonTarget.disabled = false
    } else {
      this.lineItemsSectionTarget.classList.add("opacity-50", "pointer-events-none")
      this.addLineItemButtonTarget.disabled = true
    }
  }
}
