package com.batteryinfo

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

// @ReactModule(name = BatteryInfoImpl.NAME)
class BatteryInfoModule(reactContext: ReactApplicationContext) :
        ReactContextBaseJavaModule(reactContext) {

    private var implementation: BatteryInfoImpl = BatteryInfoImpl(reactContext)

    override fun getName(): String {
        return BatteryInfoImpl.NAME
    }

    @ReactMethod
    fun getBatteryLevel(promise: Promise) {
        promise.resolve(implementation.getBatteryLevel())
    }

    // for internal use only
    // fun getBatteryStatusString(status: Int): String {
    //   return implementation.getBatteryStatusString()
    // }

    @ReactMethod
    fun addListener(eventName: String) {
        // Keep: Required for RN built in Event Emitter Calls
    }

    @ReactMethod
    fun removeListeners(count: Double) {
        // Keep: Required for RN built in Event Emitter Calls
    }

    @ReactMethod
    fun getBatteryState(promise: Promise) {
        promise.resolve(implementation.getBatteryState())
    }

    @ReactMethod
    fun isLowPowerModeEnabled(promise: Promise) {
        promise.resolve(implementation.isLowPowerModeEnabled())
    }

    @ReactMethod
    fun getThermalState(promise: Promise) {
        promise.resolve(implementation.getThermalState())
    }

    @ReactMethod
    fun stopListenerWithEvent(eventType: String) {
        implementation.stopListenerWithEvent(eventType)
    }

    @ReactMethod
    fun startListenerWithEvent(eventType: String) {
        implementation.startListenerWithEvent(eventType)
    }
}
