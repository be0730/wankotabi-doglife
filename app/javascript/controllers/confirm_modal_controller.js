import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["root", "panel", "message", "confirmBtn", "cancelBtn"]
  static values = { message: String }

  connect() {
    // 動的にモーダル要素を生成（フォームごとに1つ）
    if (!this.hasRootTarget) {
      this.element.insertAdjacentHTML("beforeend", this.modalHTML(this.messageValue || "削除してもよろしいですか？"))
      this.rootTarget = this.element.querySelector("[data-confirm-modal-target='root']")
      this.panelTarget = this.element.querySelector("[data-confirm-modal-target='panel']")
      this.messageTarget = this.element.querySelector("[data-confirm-modal-target='message']")
      this.confirmBtnTarget = this.element.querySelector("[data-confirm-modal-target='confirmBtn']")
      this.cancelBtnTarget = this.element.querySelector("[data-confirm-modal-target='cancelBtn']")
      this.confirmBtnTarget.addEventListener("click", () => this.confirm())
      this.cancelBtnTarget.addEventListener("click", () => this.close())
      this.rootTarget.addEventListener("click", (e) => { if (e.target === this.rootTarget) this.close() })
      document.addEventListener("keydown", (e) => { if (this.isOpen() && e.key === "Escape") this.close() })
    }
  }

  ask(event) {
    // 送信を一旦止めてモーダル表示
    event.preventDefault()
    this._submitter = event.submitter // どのボタンで送られたか（CSRF等は form に付与済なのでOK）
    if (this.messageValue) this.messageTarget.textContent = this.messageValue
    this.open()
  }

  confirm() {
    // モーダルOK → 本来のsubmitを実行
    this.close()
    // Turboの正しい送信を維持するには requestSubmit を使う
    if (this._submitter) {
      this.element.requestSubmit(this._submitter)
    } else {
      this.element.requestSubmit()
    }
  }

  open()  { this.rootTarget.classList.remove("hidden") }
  close() { this.rootTarget.classList.add("hidden") }
  isOpen(){ return !this.rootTarget.classList.contains("hidden") }

  modalHTML(msg) {
    return `
<div class="hidden fixed inset-0 z-50" data-confirm-modal-target="root" aria-modal="true" role="dialog">
  <div class="absolute inset-0 bg-black/40"></div>
  <div class="absolute inset-0 flex items-end sm:items-center justify-center p-4">
    <div class="w-full sm:max-w-md rounded-2xl bg-white shadow-lg overflow-hidden" data-confirm-modal-target="panel">
      <div class="px-5 py-4">
        <h2 class="text-base font-semibold text-gray-900">確認</h2>
        <p class="mt-2 text-sm text-gray-700" data-confirm-modal-target="message">${msg}</p>
      </div>
      <div class="px-5 py-3 bg-gray-50 flex flex-col sm:flex-row gap-2 sm:justify-end">
        <button type="button" class="btn-primary" data-confirm-modal-target="cancelBtn">キャンセル</button>
        <button type="button" class="btn-primary bg-red-600 !text-white hover:bg-red-700" data-confirm-modal-target="confirmBtn">削除する</button>
      </div>
    </div>
  </div>
</div>`
  }
}
