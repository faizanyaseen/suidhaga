import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]
  
  connect() {
    if (this.hasInputTarget && this.hasPreviewTarget) {
      this.inputTarget.addEventListener('change', this.preview.bind(this))
      this.files = new DataTransfer()
      
      // Add existing images to our list when connecting
      if (this.previewTarget.querySelectorAll('img').length > 0) {
        // This ensures the preview images are already there but no actual files
        // are in the input, which is what we want for existing images
        console.log("Found existing images in preview")
      }
    }
  }

  preview(event) {
    // Add new files to our DataTransfer object
    Array.from(this.inputTarget.files).forEach(file => {
      this.files.items.add(file)
      
      const wrapper = document.createElement('div')
      wrapper.classList.add('relative', 'group', 'w-1/2')
      
      const img = document.createElement('img')
      img.src = URL.createObjectURL(file)
      img.classList.add('w-full', 'object-cover', 'rounded-lg')
      
      // Add remove button
      const removeButton = document.createElement('button')
      removeButton.type = 'button'
      removeButton.classList.add(
        'absolute', 'top-2', 'right-2',
        'p-1', 'bg-white', 'rounded-full', 'shadow',
        'opacity-0', 'group-hover:opacity-100', 'transition-opacity',
        'text-gray-500', 'hover:text-gray-700'
      )
      removeButton.innerHTML = `
        <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      `
      
      // When removing an image, also remove it from our files list
      removeButton.addEventListener('click', () => {
        const newFiles = new DataTransfer()
        Array.from(this.files.files)
          .filter(f => f !== file)
          .forEach(f => newFiles.items.add(f))
        this.files = newFiles
        this.inputTarget.files = this.files.files
        wrapper.remove()
      })
      
      wrapper.appendChild(img)
      wrapper.appendChild(removeButton)
      this.previewTarget.appendChild(wrapper)
    })
    
    // Update the input's files with our maintained list
    this.inputTarget.files = this.files.files
  }

  removeExisting(event) {
    const imageId = event.currentTarget.dataset.imageId;
    const hiddenField = document.querySelector(`input[value="${imageId}"]`);
    
    if (hiddenField) {
      // Remove the hidden field that tells the server to keep this image
      hiddenField.remove();
      
      // Remove the image preview
      event.currentTarget.closest('.relative').remove();
    }
  }
} 