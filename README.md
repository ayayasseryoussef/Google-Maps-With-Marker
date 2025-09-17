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


🔑 Google Maps API Key Setup

Go to Google Cloud.

Create or select a project.

Enable the following APIs:

Maps SDK for Android

Maps JavaScript API

Directions API

Create an API Key.

Add the API Key to the platform files:

Android

In android/app/src/main/AndroidManifest.xml:

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ANDROID_API_KEY"/>

Web

In web/index.html:

<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_WEB_API_KEY&libraries=places"></script>

🧩 How it Works

On app start:

Displays user’s current location.

On tap:

Adds a destination marker.

Draws a polyline route between the user’s current location and the tapped destination.

The user’s marker updates in real-time as the device location changes.

▶️ Run the Project
flutter pub get
flutter run


To run on Web:

flutter run -d chrome