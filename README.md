# 🚀 Flutter Google Maps (Android & Web)

This project is a Flutter example that integrates **Google Maps API** with:
- Current user location tracking.
- Displaying a marker at the current position.
- Selecting a destination by tapping on the map.
- Drawing a polyline between the current location and the selected destination using **Google Directions API**.
- Real-time marker movement as the user changes location.

---

## 📦 Requirements

- Flutter (>=3.0.0)
- Google Cloud Project with enabled APIs:
  - Maps SDK for Android
  - Maps JavaScript API
  - Directions API

---

## ⚙️ Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.6.1
  google_maps_flutter_web: ^0.5.4+2
  location: ^5.0.0
  dio: ^5.4.0
