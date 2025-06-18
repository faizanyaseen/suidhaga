import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "title", "form", "method", "keyInput", "idInput", "errors", "keyInputEn", "keyInputUr"]

  connect() {
    // Initialize controller
  }

  setupForCreate() {
    this.methodTarget.value = "post"
    this.idInputTarget.value = ""
    this.keyInputEnTarget.value = ""
    this.keyInputUrTarget.value = ""
    this.errorsTarget.classList.add("hidden")
    this.errorsTarget.textContent = ""
    this.titleTarget.textContent = this.titleTarget.dataset.titleNew
  }

  setupForEdit(event) {
    const button = event.currentTarget
    const id = button.dataset.modalId
    const keyEn = button.dataset.modalKeyEn
    const keyUr = button.dataset.modalKeyUr

    this.methodTarget.value = "patch"
    this.idInputTarget.value = id
    this.keyInputEnTarget.value = keyEn
    this.keyInputUrTarget.value = keyUr
    this.errorsTarget.classList.add("hidden")
    this.errorsTarget.textContent = ""
    this.titleTarget.textContent = this.titleTarget.dataset.titleEdit
  }

  submit(event) {
    event.preventDefault()
    const form = this.formTarget
    const formData = new FormData(form)
    const url = this.methodTarget.value === "post" ? "/measurement_types" : `/measurement_types/${this.idInputTarget.value}`

    fetch(url, {
      method: this.methodTarget.value === "post" ? "POST" : "PATCH",
      body: formData,
      headers: {
        "Accept": "application/json"
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        window.location.reload()
      } else {
        this.errorsTarget.classList.remove("hidden")
        this.errorsTarget.textContent = data.errors.join(", ")
      }
    })
  }
}
