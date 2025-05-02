import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["measurementTypeSelect", "valueField"]
  static values = { customerId: Number }

  connect() {
    // Initialize controller
  }

  fetchCustomerValue() {
    const measurementTypeId = this.measurementTypeSelectTarget.value
    const customerId = this.customerIdValue

    if (!measurementTypeId || measurementTypeId === "" || !customerId) {
      return
    }

    fetch(`/customers/${customerId}/measurement_value?measurement_type_id=${measurementTypeId}`)
      .then(response => response.json())
      .then(data => {
        if (data.value) {
          this.valueFieldTarget.value = data.value
        }
      })
      .catch(error => console.error("Error fetching measurement value:", error))
  }
}
