import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["viewMode", "editMode", "form", "shopNameDisplay", "logoDisplay"]

  toggleEdit(event) {
    event.preventDefault()
    this.viewModeTarget.classList.toggle("hidden")
    this.editModeTarget.classList.toggle("hidden")
  }

  submitForm(event) {
    event.preventDefault()
    
    const formData = new FormData(this.formTarget)
    
    fetch(this.formTarget.action, {
      method: 'PATCH',
      body: formData,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'ok') {
        this.updateDisplay(data)
        this.toggleEdit({ preventDefault: () => {} })
        this.showToast(data.message, 'success')
      } else {
        this.showToast(data.message, 'error')
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.showToast('An error occurred', 'error')
    })
  }

  updateDisplay(data) {
    if (data.html.name) {
      this.shopNameDisplayTarget.textContent = data.html.name
      // Update shop name in sidebar and navbar
      document.querySelectorAll('.shop-name').forEach(el => {
        el.textContent = data.html.name
      })
    }
    if (data.html.logo_url) {
      this.logoDisplayTarget.src = data.html.logo_url
      // Update logo everywhere
      document.querySelectorAll('.sidebar-logo, .navbar-avatar').forEach(el => {
        el.src = data.html.logo_url
      })
    }
  }

  showToast(message, type) {
    // Create a proper toast notification
    const toast = document.createElement('div')
    const alertClass = type === 'success' ? 'alert-success' : 'alert-error'

    toast.className = `alert ${alertClass} shadow-lg mb-4 mx-4 fixed top-20 right-4 z-50 max-w-md toast-notification`
    toast.innerHTML = `
      <div class="flex items-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          ${type === 'success'
            ? '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />'
            : '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />'
          }
        </svg>
        <span>${message}</span>
        <button class="btn btn-sm btn-circle btn-ghost ml-auto" onclick="this.parentElement.parentElement.remove()">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    `

    document.body.appendChild(toast)

    // Auto-remove after 5 seconds
    setTimeout(() => {
      if (toast.parentElement) {
        toast.remove()
      }
    }, 5000)
  }
}
