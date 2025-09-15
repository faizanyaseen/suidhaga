import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["eyeOpen", "eyeClosed", "passwordField"]

  connect() {
    if (!this.hasPasswordFieldTarget) {
      const passwordInput = this.element.querySelector('input[type="password"]')
      if (passwordInput) {
        passwordInput.dataset.passwordToggleTarget = "passwordField"
      }
    }
  }

  toggle(event) {
    event.preventDefault()

    const passwordField = this.passwordFieldTarget || this.element.querySelector('input[type="password"]')
    const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password'
    passwordField.setAttribute('type', type)

    if (this.hasEyeOpenTarget && this.hasEyeClosedTarget) {
      this.eyeOpenTarget.classList.toggle('hidden')
      this.eyeClosedTarget.classList.toggle('hidden')
    }
  }
}
