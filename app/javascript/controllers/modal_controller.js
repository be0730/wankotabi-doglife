// モーダル開閉用コントローラー
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["root", "backdrop", "panel"]

  open()  { this.rootTarget.classList.remove("hidden") }
  close() { this.rootTarget.classList.add("hidden") }

  backdropClick(e) {
    if (e.target === this.backdropTarget) this.close()
  }

  keydown(e) {
    if (e.key === "Escape") this.close()
  }

  apply() {
    // そのままフォーム送信
    this.element.closest("form")?.requestSubmit()
  }
}
