package com.batteryinfo

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = BatteryInfoImpl.NAME)
class BatteryInfoModule(reactContext: ReactApplicationContext) :
        NativeBatteryInfoSpec(reactContext) {

    private var implementation: BatteryInfoImpl = BatteryInfoImpl(reactContext)

    override fun getName(): String {
        return BatteryInfoImpl.NAME
    }

    override fun getBatteryLevel(): Double {
        return implementation.getBatteryLevel()
    }

    // fun getBatteryStatusString(status: Int): String {
    //   return implementation.getBatteryStatusString()
    // }

    override fun addListener(event: String) {}
    override fun removeListeners(count: Double) {}

    override fun getBatteryState(): String {
        return implementation.getBatteryState()
    }

    override fun isLowPowerModeEnabled(): String {
        return implementation.isLowPowerModeEnabled()
    }

    override fun getThermalState(): String {
        return implementation.getThermalState()
    }

    override fun stopListenerWithEvent(eventType: String?) {
        implementation.stopListenerWithEvent(eventType)
    }

    override fun startListenerWithEvent(eventType: String?) {
        implementation.startListenerWithEvent(eventType)
    }
}
