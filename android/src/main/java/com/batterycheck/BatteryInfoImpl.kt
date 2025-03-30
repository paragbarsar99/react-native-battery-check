package com.batterycheck

import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import androidx.annotation.RequiresApi
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.modules.core.DeviceEventManagerModule

class BatteryInfoImpl(private val reactContext: ReactApplicationContext) {
    private val batteryManager =
            reactContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    private val powerManager = reactContext.getSystemService(Context.POWER_SERVICE) as PowerManager
    private var batteryLevelReceiver: BatteryInfoBroadCastReceiver? = null
    private var batteryStatusReceiver: BatteryInfoBatteryStatusReceiver? = null

    fun getBatteryLevel(): Double {
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY).toDouble()
    }

    fun getBatteryStatusString(status: Int): String {
        return when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "Charging"
            BatteryManager.BATTERY_STATUS_FULL -> "Full"
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "UnPlugged"
            BatteryManager.BATTERY_STATUS_UNKNOWN -> "Unknown"
            else -> "Unknown"
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun getBatteryState(): String {
        val status = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS)
        return getBatteryStatusString(status)
    }

    @RequiresApi(Build.VERSION_CODES.VANILLA_ICE_CREAM)
    fun isLowPowerModeEnabled(): String {
        val status = powerManager.isPowerSaveMode
        if (status) {
            return "true"
        }
        return "false"
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    fun getThermalState(): String {
        val status = powerManager.currentThermalStatus
        return when (status) {
            PowerManager.THERMAL_STATUS_LIGHT -> "Nominal"
            PowerManager.THERMAL_STATUS_CRITICAL -> "Critical"
            PowerManager.THERMAL_STATUS_SEVERE -> "Serious"
            PowerManager.THERMAL_STATUS_MODERATE -> "Fair"
            else -> "Unknown"
        }
    }

    private fun sendEventInt(event: String, data: Int) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit(event, data)
    }

    private fun sendEventString(event: String, data: String) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit(event, data)
    }

    fun stopListenerWithEvent(eventType: String?) {
        if (eventType == "onBatteryLevelChange" && batteryLevelReceiver != null) {
            unregisterBatteryReceiver(reactContext, batteryLevelReceiver!!)
            batteryLevelReceiver = null
        }

        if (eventType == "onBatteryStateChange" && batteryStatusReceiver != null) {
            unregisterBatteryStatusReceiver(reactContext, batteryStatusReceiver!!)
            batteryStatusReceiver = null
        }
    }

    fun startListenerWithEvent(eventType: String?) {
        if (eventType == "onBatteryLevelChange" && batteryLevelReceiver == null) {
            batteryLevelReceiver =
                    registerBatteryReceiver(reactContext) { level ->
                        sendEventInt(eventType, level)
                    }
        }
        if (eventType == "onBatteryStateChange" && batteryStatusReceiver == null) {
            batteryStatusReceiver =
                    registerBatteryStatusReceiver(reactContext) { status ->
                        sendEventString(eventType, getBatteryStatusString(status))
                    }
        }
    }

    companion object {
        const val NAME = "BatteryCheck"
    }
}
