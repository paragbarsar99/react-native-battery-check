package com.batterycheck

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager

class BatteryInfoBatteryStatusReceiver(private val onBatteryStatusChanged: (Int) -> Unit) :
        BroadcastReceiver() {
  override fun onReceive(p0: Context?, intent: Intent?) {
    val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
    onBatteryStatusChanged(status)
  }
}

fun registerBatteryStatusReceiver(
        context: Context,
        listener: (Int) -> Unit
): BatteryInfoBatteryStatusReceiver {
  val receiver = BatteryInfoBatteryStatusReceiver(listener)
  val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
  context.registerReceiver(receiver, filter)
  return receiver
}

// Unregister when no longer needed
fun unregisterBatteryStatusReceiver(context: Context, receiver: BatteryInfoBatteryStatusReceiver) {
  context.unregisterReceiver(receiver)
}
