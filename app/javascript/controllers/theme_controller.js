// app/javascript/controllers/theme_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static targets = ["lightIcon", "darkIcon"]
  
  connect() {
    this.updateThemeIcons()
    
    // Set initial theme based on localStorage or system preference
    if (!this.hasStoredTheme()) {
      this.setTheme(this.getSystemTheme())
    } else {
      this.setTheme(this.getStoredTheme())
    }
  }
  
  toggle() {
    const currentTheme = document.documentElement.getAttribute('data-theme')
    const newTheme = currentTheme === 'light' ? 'dark' : 'light'
    
    this.setTheme(newTheme)
    localStorage.setItem('theme', newTheme)
    this.updateThemeIcons()
  }
  
  setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme)
    this.updateThemeIcons()
  }
  
  updateThemeIcons() {
    const currentTheme = document.documentElement.getAttribute('data-theme')
    
    if (currentTheme === 'dark') {
      document.querySelector('.theme-light-icon').classList.add('hidden')
      document.querySelector('.theme-dark-icon').classList.remove('hidden')
    } else {
      document.querySelector('.theme-light-icon').classList.remove('hidden')
      document.querySelector('.theme-dark-icon').classList.add('hidden')
    }
  }
  
  hasStoredTheme() {
    return localStorage.getItem('theme') !== null
  }
  
  getStoredTheme() {
    return localStorage.getItem('theme')
  }
  
  getSystemTheme() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }
}