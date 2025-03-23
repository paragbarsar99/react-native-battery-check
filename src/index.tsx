import { NativeEventEmitter } from 'react-native';
import BatteryInfo from './NativeBatteryInfo';

export type EventType = 'onBatteryLevelChange' | 'onBatteryStateChange';

export type TBatteryStatus =
  | 'Charging'
  | 'Unknown'
  | 'Unplugged'
  | 'Full'
  | string;

export type TThermalStaus =
  | 'Nominal'
  | 'Fair'
  | 'Serious'
  | 'Critical'
  | 'Unknown'
  | string;

const eventEmitter = new NativeEventEmitter(BatteryInfo);

export function getBatteryLevel(): number {
  return BatteryInfo.getBatteryLevel();
}

export function getBatteryState(): TBatteryStatus {
  return BatteryInfo.getBatteryState();
}

export function isLowPowerModeEnabled(): string {
  return BatteryInfo.isLowPowerModeEnabled();
}
export function getThermalState(): TThermalStaus {
  return BatteryInfo.getThermalState();
}

export function addEventListenerWithEventType(
  event: EventType,
  callback: (t: string) => void
) {
  BatteryInfo?.startListenerWithEvent(event);
  const remove = eventEmitter.addListener(event, callback);
  return { remove };
}

export function removeEventListenerWithEventType(event: EventType) {
  BatteryInfo?.stopListenerWithEvent(event);
  eventEmitter.removeAllListeners(event);
}
