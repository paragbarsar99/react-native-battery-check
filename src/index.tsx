import { NativeModules, NativeEventEmitter } from 'react-native';

const BatteryInfo = NativeModules.BatteryCheck;

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

export async function getBatteryLevel(): Promise<number> {
  return await BatteryInfo.getBatteryLevel();
}

export async function getBatteryState(): Promise<TBatteryStatus> {
  return await BatteryInfo.getBatteryState();
}

export async function isLowPowerModeEnabled(): Promise<string> {
  return await BatteryInfo.isLowPowerModeEnabled();
}
export async function getThermalState(): Promise<TThermalStaus> {
  return await BatteryInfo.getThermalState();
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
