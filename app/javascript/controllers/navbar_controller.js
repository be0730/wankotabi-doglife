import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "content"] // 必要なら "toastInner" を追加

  connect() {
    const activeIndex = Math.max(
      0,
      this.menuTargets.findIndex(el => el.classList.contains("is-active"))
    )
    this.showIndex(activeIndex)
  }

  disconnect() {
    clearTimeout(this._toastTimer)
    // body直下のトーストをこのコントローラ専用で使うなら、残したい/消したいの方針で調整
    // const el = document.getElementById("navbar-toast")
    // if (el) el.remove()
  }

  menuClick(event) {
    // event.preventDefault() // button なら不要。<a> なら必要。
    const i = this.menuTargets.indexOf(event.currentTarget)
    if (i < 0) return
    this.showIndex(i)

    const label = event.currentTarget.textContent.trim()
    this.flash(`「${label}」を選択中`)
  }

  showIndex(i) {
    this.menuTargets.forEach((el, idx) => {
      el.classList.toggle("is-active", idx === i)
      el.classList.toggle("not-active", idx !== i)
    })
    this.contentTargets.forEach((panel, idx) => {
      panel.classList.toggle("hidden", idx !== i)
    })
  }

  flash(message) {
    // 既存を id で検索して再利用（重複生成防止）
    let wrapper = document.getElementById("navbar-toast")
    if (!wrapper) {
      wrapper = document.createElement("div")
      wrapper.id = "navbar-toast"
      wrapper.setAttribute("aria-live", "polite")
      wrapper.className = "fixed inset-x-0 top-4 z-[9999] flex justify-center pointer-events-none"
      wrapper.innerHTML = `
        <div class="hidden pointer-events-auto rounded-md bg-gray-900 text-white text-sm sm:text-base px-4 py-2 shadow-lg ring-1 ring-black/10 transition-opacity duration-200"
             id="navbar-toast-inner"></div>
      `
      document.body.appendChild(wrapper)
    }
    const inner = wrapper.querySelector("#navbar-toast-inner")

    inner.textContent = message
    inner.classList.remove("hidden", "opacity-0")

    clearTimeout(this._toastTimer)
    this._toastTimer = setTimeout(() => {
      inner.classList.add("opacity-0")
      setTimeout(() => inner.classList.add("hidden"), 200)
    }, 1500)
  }
}
