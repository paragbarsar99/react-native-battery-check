import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  getBatteryLevel: () => number;
  getBatteryState: () => string;
  isLowPowerModeEnabled: () => string;
  getThermalState: () => string;
  stopListenerWithEvent: (eventType: string) => void;
  startListenerWithEvent: (eventType: string) => void;
  addListener: (event: string) => void;
  removeListeners: (count: number) => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('BatteryInfo');
