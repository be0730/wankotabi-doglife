// app/javascript/facility_maps.js

function initIndexFacilityMap() {
  const el = document.getElementById("index-map");
  if (!el || el.dataset.initialized) return;
  const initialZoom = Number(el.dataset.zoom) || 5;
  const minZoom = Number(el.dataset.minZoom) || initialZoom;

  let markers = [];
  try {
    markers = JSON.parse(el.dataset.markers || "[]");
  } catch (e) {
    console.error("markers JSON parse error", e);
    return;
  }
  if (!markers.length) return;

  el.dataset.initialized = "1";

  const map = new google.maps.Map(el, {
    zoom: initialZoom,
    center: {
      lat: parseFloat(el.dataset.centerLat) || 35.6895,
      lng: parseFloat(el.dataset.centerLng) || 139.6917
    },
    mapTypeControl: false,
    streetViewControl: false,
    minZoom: minZoom,
  });

  const bounds = new google.maps.LatLngBounds();
  const iw = new google.maps.InfoWindow();
  const TOKYO = new google.maps.LatLng(35.6895, 139.6917);

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

  if (markers.length === 1) {
    // 常に東京を中心
    map.setCenter(TOKYO);
    map.setZoom(Number(el.dataset.zoomSingle) || initialZoom);
  } else {
    // 東京も bounds に含めると、fitBounds の中心が東京寄りになります
    bounds.extend(TOKYO);
    map.fitBounds(bounds);
    google.maps.event.addListenerOnce(map, "idle", () => {
      // 最終的に“東京を中心”に固定
      map.setCenter(TOKYO);
      if (map.getZoom() < minZoom) map.setZoom(minZoom);
    });
  }
}

// （必要ページだけで使う想定）カード内の個別地図
function initAllFacilityMaps() {
  document.querySelectorAll('[data-lat][data-lng]').forEach((el) => {
    if (el.dataset.initialized) return;
    el.dataset.initialized = "1";

    const pos = { lat: parseFloat(el.dataset.lat), lng: parseFloat(el.dataset.lng) };
    const map = new google.maps.Map(el, { zoom: 15, center: pos });
    const marker = new google.maps.Marker({ position: pos, map });
    const iw = new google.maps.InfoWindow({ content: `【住所】${el.dataset.address || ""}` });
    marker.addListener("click", () => iw.open(map, marker));
  });
}

// google の callback と Turbo 遷移の両方から安全に呼ぶ
function initMaps() {
  if (!(window.google && google.maps)) return;
  initIndexFacilityMap();
  // indexでは show_card_map:false にしているので、この呼び出しで何も起きません
  initAllFacilityMaps();
}

window.initMaps = initMaps;                  // ← Google callback 用にグローバルへ公開
document.addEventListener("turbo:load", initMaps);
document.addEventListener("DOMContentLoaded", initMaps);
