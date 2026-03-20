# Privacy Policy — NET Speed Test

**Effective Date:** March 20, 2026  
**Developer:** AY Digital Centre  
**App Name:** NET Speed Test  
**Package:** com.aydigitalcentre.speedest  
**Contact:** [aydigitalcentre.com](https://aydigitalcentre.com)

---

## 1. Overview

NET Speed Test ("the App") is a network speed testing utility. This Privacy Policy explains what information the App accesses, how it is used, and confirms that no personal data is collected, stored, or shared.

---

## 2. Data We Do NOT Collect

The App does **not** collect, store, transmit, or share:

- Your name, email address, or any account information
- Your device identifier, advertising ID, or IMEI
- Your precise or approximate GPS location coordinates
- Your browsing history or activity outside the App
- Any analytics or crash reporting data sent to us or third parties

---

## 3. Data Accessed at Runtime

The following data is accessed **only on your device** during a speed test and is **never transmitted to the developer or any third party**:

| Data | Purpose | Stored remotely? |
|------|---------|-----------------|
| **Wi-Fi network name (SSID)** | Displayed in the Network tile so you know which network was tested | No |
| **Mobile operator name** | Displayed in the Network tile when on cellular | No |
| **Connection type** (Wi-Fi / Mobile) | Used to show the correct icon | No |
| **Public IP address** | Fetched from `api.ipify.org` and displayed on screen only | No |
| **Speed test results** (download, upload, ping) | Saved locally on your device in Shared Preferences for the History tab | No |

All speed test results stored in History are stored **locally on your device only** and can be deleted at any time from the Settings screen.

---

## 4. Permissions Explained

| Android Permission | Why It Is Needed |
|-------------------|-----------------|
| `INTERNET` | To connect to Cloudflare speed test servers and fetch your public IP |
| `ACCESS_NETWORK_STATE` | To detect whether you are on Wi-Fi or mobile data |
| `ACCESS_WIFI_STATE` | To read Wi-Fi connection information |
| `ACCESS_COARSE_LOCATION` | Required by Android OS to read Wi-Fi network name |
| `ACCESS_FINE_LOCATION` | Required on Android 8.0+ to read the Wi-Fi SSID |
| `READ_PHONE_STATE` | To read the name of your mobile carrier when on cellular |

> **Important:** Location permissions are used **solely** to display the name of the connected Wi-Fi network on screen. The App never reads your GPS coordinates, never tracks your physical location, and never shares location data with anyone.

---

## 5. Third-Party Services

The App communicates with the following external services **only during a speed test**:

| Service | URL | Data Sent | Purpose |
|---------|-----|-----------|---------|
| Cloudflare Speed Test | `speed.cloudflare.com` | HTTP download/upload traffic | Measure download/upload speed and ping |
| ipify | `api.ipify.org` | Your IP address (inherent to any HTTP request) | Display your public IP address |

These services are operated by their respective owners. The App does not send any personal identifiers to them. Please review their privacy policies:
- [Cloudflare Privacy Policy](https://www.cloudflare.com/privacypolicy/)
- [ipify Privacy Policy](https://www.ipify.org/)

---

## 6. Children's Privacy

The App does not knowingly collect any information from children under the age of 13. The App contains no user accounts, registration, or social features.

---

## 7. Data Security

Because the App does not transmit or store personal data on any remote server, there is no risk of a data breach involving your personal information. Speed test results stored locally are protected by your device's built-in security.

---

## 8. Changes to This Policy

We may update this Privacy Policy from time to time. Any changes will be reflected by updating the **Effective Date** at the top of this document. Continued use of the App after changes constitutes acceptance of the updated policy.

---

## 9. Contact Us

If you have any questions about this Privacy Policy, please contact us:

**AY Digital Centre**  
Website: [https://aydigitalcentre.com](https://aydigitalcentre.com)

---

*This privacy policy applies to NET Speed Test on Android.*
