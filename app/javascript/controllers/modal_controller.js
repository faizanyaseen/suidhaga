import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "title", "form", "method", "keyInput", "idInput", "errors"]

  connect() {
    // Initialize controller
  }

  setupForCreate(event) {
    // Set up the modal for creating a new measurement type
    this.titleTarget.textContent = "New Measurement Type"

    // Clear previous form data and errors
    this.formTarget.reset()
    this.errorsTarget.textContent = ""
    this.errorsTarget.classList.add("hidden")

    // Set form for creating a new record
    this.methodTarget.value = "post"
    this.idInputTarget.value = ""
  }

  setupForEdit(event) {
    // Set up the modal for editing an existing measurement type
    const button = event.currentTarget

    this.titleTarget.textContent = "Edit Measurement Type"

    // Clear previous errors
    this.errorsTarget.textContent = ""
    this.errorsTarget.classList.add("hidden")

    // Set form for editing an existing record
    this.methodTarget.value = "patch"
    this.keyInputTarget.value = button.dataset.modalKey
    this.idInputTarget.value = button.dataset.modalId
  }

  submit(event) {
    event.preventDefault()

    // Determine the URL based on whether we're creating or editing
    const isEdit = this.methodTarget.value === "patch"
    const url = isEdit
      ? `/measurement_types/${this.idInputTarget.value}`
      : "/measurement_types"

    // Prepare form data
    const formData = new FormData()
    formData.append("measurement_type[key]", this.keyInputTarget.value)

    if (isEdit) {
      formData.append("_method", "patch")
    }

    // Send the request
    fetch(url, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      credentials: "same-origin"
    })
    .then(response => {
      if (response.ok) {
        // Close the modal and reload the page to show the updated list
        document.getElementById('measurement_modal').close()
        window.location.reload()
      } else {
        return response.json().then(data => {
          throw new Error(data.errors || "An error occurred")
        })
      }
    })
    .catch(error => {
      // Display error messages
      this.errorsTarget.textContent = error.message
      this.errorsTarget.classList.remove("hidden")
    })
  }
}
