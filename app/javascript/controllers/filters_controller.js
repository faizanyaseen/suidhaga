import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "customDateRange", "activeCount"]

  connect() {
    this.updateActiveCount()
    this.checkCustomDateRange()
  }

  toggle() {
    const panel = this.panelTarget
    if (panel.classList.contains("collapse-open")) {
      panel.classList.remove("collapse-open")
    } else {
      panel.classList.add("collapse-open")
    }
  }

  toggleCustomDate(event) {
    const value = event.target.value
    if (value === 'custom') {
      this.customDateRangeTarget.classList.remove("hidden")
    } else {
      this.customDateRangeTarget.classList.add("hidden")
    }
    this.updateActiveCount()
  }

  checkCustomDateRange() {
    const dateRangeSelect = this.element.querySelector('select[name="date_range"]')
    if (dateRangeSelect && dateRangeSelect.value === 'custom') {
      this.customDateRangeTarget.classList.remove("hidden")
    }
  }

  updateCount() {
    this.updateActiveCount()
  }

  updateActiveCount() {
    const form = this.element.querySelector('form')
    const formData = new FormData(form)
    let activeCount = 0

    const filterFields = ['status', 'date_range', 'customer_id', 'start_date', 'end_date', 'tailor_id']
    
    filterFields.forEach(field => {
      const value = formData.get(field)
      if (value && value !== '') {
        activeCount++
      }
    })
    
    // Special handling for active filter - only count if not default (active)
    const activeValue = formData.get('active')
    if (activeValue && activeValue !== '' && activeValue !== 'active') {
      activeCount++
    }

    const countBadge = this.activeCountTarget
    if (activeCount > 0) {
      countBadge.textContent = activeCount
      countBadge.classList.remove("hidden")
    } else {
      countBadge.classList.add("hidden")
    }
  }

  clearAll() {
    const form = this.element.querySelector('form')

    const searchField = form.querySelector('input[name="search"]')
    if (searchField) {
      searchField.value = ''
    }

    // Reset all selects except active filter
    form.querySelectorAll('select:not([name="active"])').forEach(select => {
      select.selectedIndex = 0
    })
    
    // Set active filter to default (active)
    const activeSelect = form.querySelector('select[name="active"]')
    if (activeSelect) {
      // Find the option with value 'active' and select it
      for (let i = 0; i < activeSelect.options.length; i++) {
        if (activeSelect.options[i].value === 'active') {
          activeSelect.selectedIndex = i
          break
        }
      }
    }

    form.querySelectorAll('input[type="date"]').forEach(input => {
      input.value = ''
    })

    this.customDateRangeTarget.classList.add("hidden")

    this.updateActiveCount()

    form.submit()
  }
} 