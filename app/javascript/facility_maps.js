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
window.initAllFacilityMaps = initAllFacilityMaps;
document.addEventListener("turbo:load", initAllFacilityMaps);
document.addEventListener("DOMContentLoaded", initAllFacilityMaps);
