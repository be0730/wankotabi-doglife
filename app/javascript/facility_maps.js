// app/javascript/facility_maps.js

(() => {
  const TOKYO_ST = { lat: 35.681236, lng: 139.767125 };

  const CATEGORY_COLORS = {
    accommodation: "#22c55e", // green
    restaurant:    "#ef4444", // red
    leisure:       "#3b82f6", // blue
    shop:          "#a855f7", // purple
    default:       "#f59e0b", // amber
  };

  function colorByCategory(cat) {
    return CATEGORY_COLORS[cat] || CATEGORY_COLORS.default;
  }

  function markerIcon(color = "#3b82f6") {
    const path =
      "M12 2C7.58 2 4 5.58 4 10c0 5.25 5.9 11.39 7.53 13.03.27.27.71.27.98 0C14.1 21.39 20 15.25 20 10 20 5.58 16.42 2 12 2zm0 11.2a3.2 3.2 0 1 1 0-6.4 3.2 3.2 0 0 1 0 6.4z";

    return {
      path,
      fillColor: color,
      fillOpacity: 1,
      strokeColor: "#1f2937",
      strokeOpacity: 0.8,
      strokeWeight: 1,
      scale: 1.6,
      anchor: new google.maps.Point(12, 24),
    };
  }

  // 一覧・詳細の大きい地図（#index-map）
  function initIndexFacilityMap(targetEl) {
    const el = targetEl || document.getElementById("index-map");
    if (!el || el.dataset.initialized) return;

    el.dataset.initialized = "1";

    const initialZoom = Number(el.dataset.zoom) || 8;
    const minZoom     = Number(el.dataset.minZoom) || initialZoom;
    const zoomSingle  = Number(el.dataset.zoomSingle) || 16;

    let markers = [];
    try {
      markers = JSON.parse(el.dataset.markers || "[]");
    } catch (e) {
      console.error("markers JSON parse error", e);
      markers = [];
    }

    const mode = el.dataset.mapMode || (markers.length === 1 ? "show" : "index");

    const map = new google.maps.Map(el, {
      zoom: initialZoom,
      center: TOKYO_ST,
      mapTypeControl: false,
      streetViewControl: false,
      minZoom,
    });

    function escapeHtml(s) {
      return String(s ?? "").replace(/[&<>"']/g, (c) => ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        "\"": "&quot;",
        "'": "&#39;"
      }[c]));
    }

    const iw = new google.maps.InfoWindow();
    const bounds = new google.maps.LatLngBounds();

    markers.forEach((m) => {
      const pos = { lat: Number(m.lat), lng: Number(m.lng) };
      const color = colorByCategory(m.category);
      const marker = new google.maps.Marker({
        position: pos,
        map,
        title: m.title,
        icon: markerIcon(color),
      });

      const html = `
        <div style="min-width:200px">
          <div style="font-weight:600;margin-bottom:4px">${m.title ?? ""}</div>
          <div style="font-size:12px;color:#555">${m.address ?? ""}</div>
          <div style="margin-top:6px"><a href="${m.url}" class="text-indigo-600 underline">詳細を見る</a></div>
        </div>`;

      marker.addListener("click", () => { iw.setContent(html); iw.open(map, marker); });

      bounds.extend(pos);
    });

    if (mode === "show") {
      if (markers.length >= 1) {
        const m0 = markers[0];
        map.setCenter({ lat: Number(m0.lat), lng: Number(m0.lng) });
        map.setZoom(Math.max(minZoom, zoomSingle));
      } else {
        map.setCenter(TOKYO_ST);
        map.setZoom(initialZoom);
      }
    } else {
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

  // カードのミニ地図（data-lat / data-lng）
  function initAllFacilityMaps() {
    document.querySelectorAll("[data-lat][data-lng]").forEach((el) => {
      if (el.dataset.initialized || el.id === "picker-map") return; // picker-map は別関数で

      el.dataset.initialized = "1";

      const pos = {
        lat: parseFloat(el.dataset.lat),
        lng: parseFloat(el.dataset.lng),
      };

      const map = new google.maps.Map(el, {
        zoom: Number(el.dataset.zoom) || 15,
        center: pos,
        mapTypeControl: false,
        streetViewControl: false,
      });

      const color = colorByCategory(el.dataset.category);
      const marker = new google.maps.Marker({
        position: pos,
        map,
        icon: markerIcon(color),
      });

      if (el.dataset.address) {
        const iw = new google.maps.InfoWindow({ content: `【住所】${el.dataset.address}` });
        marker.addListener("click", () => iw.open(map, marker));
      }
    });
  }

  // フォーム用：ドラッグ可能なピン (#picker-map)
  function initPickerMap() {
    const el = document.getElementById("picker-map");
    if (!el || el.dataset.initialized) return;

    el.dataset.initialized = "1";

    const latField = document.getElementById("facility_latitude");
    const lngField = document.getElementById("facility_longitude");

    // hidden に値があれば優先、なければ data-* / デフォルト
    const lat =
      parseFloat(latField?.value) ||
      parseFloat(el.dataset.lat) ||
      TOKYO_ST.lat;
    const lng =
      parseFloat(lngField?.value) ||
      parseFloat(el.dataset.lng) ||
      TOKYO_ST.lng;

    const pos = { lat, lng };

    const map = new google.maps.Map(el, {
      zoom: Number(el.dataset.zoom) || 15,
      center: pos,
      mapTypeControl: false,
      streetViewControl: false,
    });

    const marker = new google.maps.Marker({
      position: pos,
      map,
      draggable: true,
    });

    // hidden に初期値を反映
    if (latField) latField.value = lat.toFixed(6);
    if (lngField) lngField.value = lng.toFixed(6);

    function updateFields(latLng) {
      if (!latField || !lngField) return;
      latField.value = latLng.lat().toFixed(6);
      lngField.value = latLng.lng().toFixed(6);
    }

    marker.addListener("dragend", (e) => {
      updateFields(e.latLng);
    });

    // クリックした場所にピンを移動できるように（お好み）
    map.addListener("click", (e) => {
      marker.setPosition(e.latLng);
      updateFields(e.latLng);
    });
  }

  // Google Maps の callback ＋ Turbo のイベントから共通で呼ぶ
  function initMaps() {
    if (!(window.google && google.maps)) return;

    initIndexFacilityMap();
    initAllFacilityMaps();
    initPickerMap();
  }

  // Google Maps の callback 用にグローバルへ公開
  window.initMaps = initMaps;

  // Turbo / 通常ロードでも呼んでおく（戻る時など）
  document.addEventListener("turbo:load", initMaps);
  document.addEventListener("DOMContentLoaded", initMaps);

  // Turbo フレーム内用
  document.addEventListener("turbo:frame-load", (e) => {
    const frame = e.target;
    const mapEl = frame.querySelector("#index-map");
    if (mapEl) {
      delete mapEl.dataset.initialized;
      initIndexFacilityMap(mapEl);
    }

    const picker = frame.querySelector("#picker-map");
    if (picker) {
      delete picker.dataset.initialized;
      initPickerMap();
    }
  });

  // Turbo キャッシュに入る前にフラグを解除
  document.addEventListener("turbo:before-cache", () => {
    const index = document.getElementById("index-map");
    if (index) delete index.dataset.initialized;

    const picker = document.getElementById("picker-map");
    if (picker) delete picker.dataset.initialized;

    document.querySelectorAll("[data-lat][data-lng]").forEach((n) => {
      delete n.dataset.initialized;
    });
  });
})();
