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
    // Implement your preferred toast notification here
    alert(message)
  }
}