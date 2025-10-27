import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu","content"]

  connect() {
    // 初期状態の整合性を取る（無くても動くが安全）
    const activeIndex = Math.max(
      0,
      this.menuTargets.findIndex(el => el.classList.contains("is-active"))
    )
    this.showIndex(activeIndex)
  }

  menuClick(event) {
    event.preventDefault()
    const i = this.menuTargets.indexOf(event.currentTarget)
    this.showIndex(i)

    // 「選択中」トーストを表示
    const label = event.currentTarget.textContent.trim()
    this.flash(`「${label}」を選択中`)
  }

  showIndex(i) {
    // メニューの active 切替
    this.menuTargets.forEach((el, idx) => {
      el.classList.toggle("is-active", idx === i)
      el.classList.toggle("not-active", idx !== i)
    })
    // コンテンツの表示切替
    this.contentTargets.forEach((panel, idx) => {
      panel.classList.toggle("hidden", idx !== i)
    })
  }
  flash(message) {
    // 既存トーストがあれば再利用、なければ生成
    if (!this.toastEl) {
      const el = document.createElement("div")
      el.setAttribute("aria-live", "polite")
      el.className = [
        "fixed inset-x-0 top-4 z-[9999] flex justify-center pointer-events-none"
      ].join(" ")
      el.innerHTML = `
        <div class="hidden pointer-events-auto rounded-md bg-gray-900 text-white text-sm sm:text-base px-4 py-2 shadow-lg ring-1 ring-black/10 transition-opacity duration-200"
             data-navbar-target="toastInner"></div>
      `
      document.body.appendChild(el)
      this.toastEl = el
      this.toastInner = el.querySelector('[data-navbar-target="toastInner"]')
    }
    // 表示
    this.toastInner.textContent = message
    this.toastInner.classList.remove("hidden", "opacity-0")
    // 一旦透明にしてからフェードインしたい場合は次の行のコメントを外す
    // this.toastInner.classList.add("opacity-0"); requestAnimationFrame(() => this.toastInner.classList.remove("opacity-0"))

    clearTimeout(this._toastTimer)
    this._toastTimer = setTimeout(() => {
      this.toastInner.classList.add("opacity-0")
      setTimeout(() => this.toastInner.classList.add("hidden"), 200) // フェード後に非表示
    }, 1500) // 1.5秒で自動クローズ
  }
}