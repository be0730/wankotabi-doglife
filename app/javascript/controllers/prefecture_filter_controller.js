import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box", "count"]

  connect() { this.updateCount() }

  selectAll() {
    this.boxTargets.forEach(cb => cb.checked = true)
    this.updateCount()
  }
  clearAll() {
    this.boxTargets.forEach(cb => cb.checked = false)
    this.updateCount()
  }
  updateCount() {
    if (!this.hasCountTarget) return
    const n = this.boxTargets.filter(cb => cb.checked).length
    this.countTarget.textContent = n
  }
}
