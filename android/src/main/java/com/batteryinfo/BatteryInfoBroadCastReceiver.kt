package com.batteryinfo
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager

class BatteryInfoBroadCastReceiver(private val onBatteryLevelChanged:(Int) -> Unit):BroadcastReceiver() {
  override fun onReceive(p0: Context?, intent: Intent?) {
    val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
    val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
    val batteryPct = (level * 100) / scale
    onBatteryLevelChanged(batteryPct)
  }
}

fun registerBatteryReceiver(context: Context, listener: (Int) -> Unit): BatteryInfoBroadCastReceiver {
  val receiver = BatteryInfoBroadCastReceiver(listener)
  val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
  context.registerReceiver(receiver, filter)
  return receiver
}

// Unregister when no longer needed
fun unregisterBatteryReceiver(context: Context, receiver: BatteryInfoBroadCastReceiver) {
  context.unregisterReceiver(receiver)
}

