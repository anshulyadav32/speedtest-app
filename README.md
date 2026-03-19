# NET Speed Test

A real-time internet speed test app built with Flutter. Measures your actual **download speed**, **upload speed**, and **ping** using Cloudflare's public speed test servers. Shows your public IP address and automatically detects Wi-Fi SSID or mobile operator name.

<img src="assets/readme/speedtest_light.gif" width="150"> <img src="assets/readme/speedtest_dark.gif" width="150">

---

## Features

- **Real speed measurement** — streams 25 MB from Cloudflare for live Mbps download; POSTs 5 MB for upload; 1 KB round-trip for ping latency
- **Public IP detection** — fetches real public IP from `api.ipify.org`
- **Network info** — shows Wi-Fi SSID (Android 8+ with location permission) or mobile operator name, with dynamic icon
- **Animated radial gauge** — live SyncFusion gauge updates in real time as the test runs
- **Test history** — every result saved locally on-device; view and review from the History tab
- **Dark / Light theme** — persistent theme preference saved with Shared Preferences
- **Privacy first** — no data is stored remotely or shared with any third party

---

## Screenshots

| Speed Test | History | Settings |
|---|---|---|
| <img src="assets/readme/speedtest_light.gif" width="150"> | *(History tab)* | *(Settings tab)* |

---

## How It Works

| Phase | Endpoint | Size |
|-------|----------|------|
| Ping | `speed.cloudflare.com/__down?bytes=1024` | 1 KB round-trip |
| Download | `speed.cloudflare.com/__down?bytes=25000000` | 25 MB streamed |
| Upload | `speed.cloudflare.com/__up` | 5 MB POST |
| Public IP | `api.ipify.org` | Plain text |

---

## Android Permissions

| Permission | Purpose |
|------------|---------|
| `INTERNET` | Run speed test & fetch public IP |
| `ACCESS_NETWORK_STATE` | Detect connection type |
| `ACCESS_WIFI_STATE` | Read Wi-Fi connection info |
| `ACCESS_COARSE_LOCATION` | Required by Android for Wi-Fi SSID |
| `ACCESS_FINE_LOCATION` | Required on Android 8+ for Wi-Fi SSID |
| `READ_PHONE_STATE` | Read mobile operator name |

> **Note:** Location permission is used **only** to read the name of the connected Wi-Fi network. No location data is ever stored or transmitted.

---

## Packages Used

| Package | Purpose |
|---------|---------|
| [provider](https://pub.dev/packages/provider) | State management |
| [http](https://pub.dev/packages/http) | Speed test HTTP requests |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Persist theme & history |
| [syncfusion_flutter_gauges](https://pub.dev/packages/syncfusion_flutter_gauges) | Animated radial speed gauge |
| [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) | Icons |
| [animations](https://pub.dev/packages/animations) | Page transition animations |
| [url_launcher](https://pub.dev/packages/url_launcher) | Open links from Settings |
| [permission_handler](https://pub.dev/packages/permission_handler) | Runtime location permission |

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0` — [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android device / emulator (API 21+)

### Run from source

```bash
git clone https://github.com/anshulyadav32/speedtest-app.git
cd speedtest-app
flutter pub get
flutter run
```

### Build release AAB (for Play Store)

1. Create a keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Copy and fill in `android/key.properties.template` → `android/key.properties`

3. Get a free [SyncFusion Community License](https://www.syncfusion.com/products/communitylicense) and add it to `lib/confidential.dart`

4. Build:
   ```bash
   flutter build appbundle --release
   ```
   Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Privacy Policy

See [PRIVACY_POLICY.md](PRIVACY_POLICY.md) for the full privacy policy.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

### Prerequisites
- Download IDE either [Android Studio](https://developer.android.com/studio) or [VSC](https://code.visualstudio.com/)
- Install Flutter SDK and Dart plugin
- Emulator or physical device

### Steps
- Clone this repo to your machine: `https://github.com/KhalidWar/banking_app.git`
- Obtain a [free community lincense](https://www.syncfusion.com/products/communitylicense) from SyncFusion to use with gauge
- Create 'syncFusionLicenseKey' const String in /lib/confidential.dart
- Run on Emulator or physical device
- All set!

## License
This project is licensed under [MIT Licnese](https://github.com/KhalidWar/speedtest_app/blob/master/LICENSE).
