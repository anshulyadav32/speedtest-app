package com.aydigitalcentre.speedest

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.aydigitalcentre.speedest/network_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getNetworkInfo") {
                    result.success(getNetworkInfo())
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getNetworkInfo(): Map<String, String?> {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = cm.activeNetwork
        val caps = cm.getNetworkCapabilities(activeNetwork)

        val isWifi = caps?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true
        val isMobile = caps?.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) == true

        val connectionType = when {
            isWifi -> "wifi"
            isMobile -> "mobile"
            else -> "none"
        }

        // WiFi SSID – use modern API on Android 10+, deprecated fallback for older
        val wifiSsid: String? = if (isWifi) {
            try {
                val ssid: String? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    // Android 10+: WifiInfo from NetworkCapabilities (no deprecated API needed)
                    (caps?.transportInfo as? WifiInfo)?.ssid
                        ?.removeSurrounding("\"")
                        ?.takeIf { it.isNotBlank() && it != "<unknown ssid>" }
                } else {
                    @Suppress("DEPRECATION")
                    val wm = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                    @Suppress("DEPRECATION")
                    wm.connectionInfo.ssid
                        ?.removeSurrounding("\"")
                        ?.takeIf { it.isNotBlank() && it != "<unknown ssid>" }
                }
                ssid
            } catch (_: Exception) {
                null
            }
        } else null

        // Mobile operator name – networkOperatorName first, simOperatorName as fallback
        val operatorName: String? = try {
            val tm = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            tm.networkOperatorName.takeIf { it.isNotBlank() }
                ?: tm.simOperatorName.takeIf { it.isNotBlank() }
        } catch (_: Exception) {
            null
        }

        return mapOf(
            "connectionType" to connectionType,
            "wifiSsid" to wifiSsid,
            "operatorName" to operatorName,
        )
    }
}
