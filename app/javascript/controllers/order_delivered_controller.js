import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { orderId: Number }

  connect() {
    console.log("OrderDelivered controller connected")
  }

  markDelivered(event) {
    event.preventDefault()
    console.log("markDelivered called")

    if (!confirm(this.element.dataset.confirmMessage)) return

    fetch(`/orders/${this.orderIdValue}/mark_delivered`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'ok') {
        window.location.reload()
      } else {
        alert(data.message)
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('An error occurred while marking the order as delivered')
    })
  }
}
