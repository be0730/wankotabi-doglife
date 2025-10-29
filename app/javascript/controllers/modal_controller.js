import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel"]

  open() {
    this.element.classList.remove("hidden")
    this.element.setAttribute("aria-hidden", "false")
  }

  close() {
    this.element.classList.add("hidden")
    this.element.setAttribute("aria-hidden", "true")
  }

  backdropClick(e) {
    if (e.target === this.backdropTarget) this.close()
  }

  // Escで閉じる
  keydown(e) {
    if (e.key === "Escape") this.close()
  }

  // 適用＝フォーム送信して閉じる
  apply(e) {
    e.preventDefault()
    const form = this.element.closest("form")
    if (form) form.requestSubmit()
    this.close()
  }
}
