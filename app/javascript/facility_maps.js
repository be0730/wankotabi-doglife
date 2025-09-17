// app/javascript/facility_maps.js
// index＝全体表示（fitBounds） / show＝対象施設にズーム の両方に対応
// HTML側で data-map-mode="index" | "show" を付けるのが確実（未指定なら markers 数で自動判定）

(() => {
  const TOKYO_ST = { lat: 35.681236, lng: 139.767125 }; // 東京駅（デフォルト中心）

  function initIndexFacilityMap() {
    const el = document.getElementById("index-map");
    if (!el || el.dataset.initialized) return;

    // --- data-* 読み込み ---
    const initialZoom = Number(el.dataset.zoom) || 8;
    const minZoom     = Number(el.dataset.minZoom) || initialZoom;
    const zoomSingle  = Number(el.dataset.zoomSingle) || 16;

    // --- markers 取得 ---
    let markers = [];
    try {
      markers = JSON.parse(el.dataset.markers || "[]");
    } catch (e) {
      console.error("markers JSON parse error", e);
      markers = [];
    }

    // モード指定（明示があれば優先、なければ自動判定）
    const mode = el.dataset.mapMode || (markers.length === 1 ? "show" : "index");

    el.dataset.initialized = "1";

    // --- 地図生成 ---
    const map = new google.maps.Map(el, {
      zoom: initialZoom,
      center: TOKYO_ST,
      mapTypeControl: false,
      streetViewControl: false,
      minZoom: minZoom,
    });

    // --- ピン立て ---
    const iw = new google.maps.InfoWindow();
    const bounds = new google.maps.LatLngBounds();

    markers.forEach((m) => {
      const pos = { lat: Number(m.lat), lng: Number(m.lng) };
      const marker = new google.maps.Marker({ position: pos, map, title: m.title });

      const html = `
        <div style="min-width:200px">
          <div style="font-weight:600;margin-bottom:4px">${m.title ?? ""}</div>
          <div style="font-size:12px;color:#555">${m.address ?? ""}</div>
          <div style="margin-top:6px"><a href="${m.url}" class="text-indigo-600 underline">詳細を見る</a></div>
        </div>`;
      marker.addListener("click", () => { iw.setContent(html); iw.open(map, marker); });

      bounds.extend(pos);
    });

    // --- 表示制御 ---
    if (mode === "show") {
      // 単一施設を詳細ズーム（マーカーが無い場合は東京駅デフォルト）
      if (markers.length >= 1) {
        const m0 = markers[0];
        map.setCenter({ lat: Number(m0.lat), lng: Number(m0.lng) });
        map.setZoom(Math.max(minZoom, zoomSingle));
      } else {
        map.setCenter(TOKYO_ST);
        map.setZoom(initialZoom);
      }
    } else {
      // index: 全件が入るようにフィット（最小ズームは保証）
      if (markers.length >= 1) {
        map.fitBounds(bounds);
        google.maps.event.addListenerOnce(map, "idle", () => {
          if (map.getZoom() < minZoom) map.setZoom(minZoom);
        });
      } else {
        map.setCenter(TOKYO_ST);
        map.setZoom(initialZoom);
      }
    }
  }

  // カード内の個別地図（data-lat / data-lng を持つ要素用）
  function initAllFacilityMaps() {
    document.querySelectorAll('[data-lat][data-lng]').forEach((el) => {
      if (el.dataset.initialized) return;
      el.dataset.initialized = "1";

      const pos = { lat: parseFloat(el.dataset.lat), lng: parseFloat(el.dataset.lng) };
      const map = new google.maps.Map(el, {
        zoom: Number(el.dataset.zoom) || 15,
        center: pos,
      });
      const marker = new google.maps.Marker({ position: pos, map });

      if (el.dataset.address) {
        const iw = new google.maps.InfoWindow({ content: `【住所】${el.dataset.address}` });
        marker.addListener("click", () => iw.open(map, marker));
      }
    });
  }

  // google の callback と Turbo 遷移の両方から安全に呼ぶ
  function initMaps() {
    if (!(window.google && google.maps)) return;
    initIndexFacilityMap();
    initAllFacilityMaps();
  }

  window.initMaps = initMaps; // Google callback 用にグローバルへ公開
  document.addEventListener("turbo:load", initMaps);
  document.addEventListener("DOMContentLoaded", initMaps);

  // Turboキャッシュから戻るときに再初期化できるようフラグを解除
  document.addEventListener("turbo:before-cache", () => {
    const el = document.getElementById("index-map");
    if (el) delete el.dataset.initialized;
    document.querySelectorAll('[data-lat][data-lng]').forEach((n) => {
      delete n.dataset.initialized;
    });
  });
})();
