import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "status"]
  static values = { orderId: Number }

  connect() {
    console.log("Order complete controller connected")
  }

  markComplete(event) {
    event.preventDefault()

    this.buttonTarget.disabled = true
    this.buttonTarget.innerHTML = `
      <span class="loading loading-spinner loading-sm"></span>
      Marking Complete...
    `

    fetch(`/orders/${this.orderIdValue}/mark_complete`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'success') {
        this.updateStatusDisplay()
        this.showSuccessMessage(data.message)

        this.buttonTarget.style.display = 'none'
      } else {
        this.showErrorMessage(data.message)
        this.resetButton()
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.showErrorMessage('An error occurred while marking the order as complete.')
      this.resetButton()
    })
  }

  updateStatusDisplay() {
    if (this.hasStatusTarget) {
      this.statusTarget.className = "badge badge-success"
      this.statusTarget.textContent = "Completed"
    }

    const lineItemBadges = document.querySelectorAll('[data-line-item-status]')
    lineItemBadges.forEach(badge => {
      badge.className = "badge badge-success badge-sm"
      badge.textContent = "Completed"
    })
  }

  showSuccessMessage(message) {
    this.showToast(message, 'success')
  }

  showErrorMessage(message) {
    this.showToast(message, 'error')
  }

  showToast(message, type) {
    const toast = document.createElement('div')
    toast.className = `alert alert-${type} shadow-lg max-w-md mx-auto mt-4 fixed top-4 right-4 z-50`
    toast.innerHTML = `
      <div>
        <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current flex-shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
          ${type === 'success'
            ? '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />'
            : '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />'
          }
        </svg>
        <span>${message}</span>
      </div>
    `

    document.body.appendChild(toast)

    setTimeout(() => {
      toast.remove()
    }, 3000)
  }

  resetButton() {
    this.buttonTarget.disabled = false
    this.buttonTarget.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      Mark as Complete
    `
  }
}
