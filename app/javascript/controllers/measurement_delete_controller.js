import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "keyDisplay",
    "usageInfo",
    "lineItemsUsage",
    "customersUsage",
    "lineItemsCount",
    "customersCount",
    "deleteForm"
  ]

  confirmDelete(event) {
    const button = event.currentTarget
    const id = button.dataset.measurementDeleteId
    const keyEn = button.dataset.modalKeyEn
    const keyUr = button.dataset.modalKeyUr

    const locale = document.documentElement.lang
    this.keyDisplayTarget.textContent = locale === 'ur' ? keyUr : keyEn

    this.deleteFormTarget.action = `/measurement_types/${id}`

    fetch(`/measurement_types/${id}/usage_info`)
      .then(response => response.json())
      .then(data => {
        this.updateUsageInfo(data)
        delete_confirmation_modal.showModal()
      })
      .catch(error => {
        console.error("Error fetching usage info:", error)
        delete_confirmation_modal.showModal()
      })
  }

  updateUsageInfo(data) {
    const hasUsage = data.total_count > 0

    if (hasUsage) {
      this.usageInfoTarget.classList.remove("hidden")

      if (data.line_items_count > 0) {
        this.lineItemsUsageTarget.classList.remove("hidden")
        this.lineItemsUsageTarget.innerHTML = this.lineItemsUsageTarget.innerHTML.replace('0', data.line_items_count)
      } else {
        this.lineItemsUsageTarget.classList.add("hidden")
      }

      if (data.customers_count > 0) {
        this.customersUsageTarget.classList.remove("hidden")
        this.customersUsageTarget.innerHTML = this.customersUsageTarget.innerHTML.replace('0', data.customers_count)
      } else {
        this.customersUsageTarget.classList.add("hidden")
      }
    } else {
      this.usageInfoTarget.classList.add("hidden")
    }
  }
}
