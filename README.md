# React Native Battery Check

A React Native Modul**e** for monitoring battery status, power mode, and thermal conditions on both iOS and Android.\
compatible with both New (Fabric) and Old Architecture.

## Features

- Get real-time battery level
- Check battery charging state
- Detect low power mode activation
- Monitor device thermal conditions
- Listen for battery state and level changes

## Installation

# yarn add react-native-battery-check
               
# npm install react-native-battery-check

### React Native Architecture Support Version

| Architecture                  | Version Range      |
| ----------------------------- | ------------------ |
| **New Architecture (Fabric)** | `>=2.0.0` (Latest) |
| **Old Architecture**          | `>=1.0.0 <2.0.0`   |

## API Reference

### 1. `getBatteryLevel(): Promise<number>`

Retrieves the current battery level as a percentage (0-100).

#### Example:

```js
import BatteryModule from 'react-native-battery-check';

BatteryModule.getBatteryLevel().then((level) => {
  console.log(`Battery Level: ${level}%`);
});
```

### 2. `getBatteryState(): Promise<string>`

Returns the battery charging state.

#### Possible Values:

- `Charging`
- `Unplugged`
- `Full`
- `Unknown`

#### Example:

```js
BatteryModule.getBatteryState().then((state) => {
  console.log(`Battery State: ${state}`);
});
```

### 3. `isLowPowerModeEnabled(): Promise<boolean>`

Checks if Low Power Mode is enabled.

#### Example:

```js
BatteryModule.isLowPowerModeEnabled().then((isEnabled) => {
  console.log(`Low Power Mode: ${isEnabled ? 'Enabled' : 'Disabled'}`);
});
```

### 4. `getThermalState(): Promise<string>`

Returns the current thermal state of the device.

#### Possible Values:

- `Nominal`
- `Fair`
- `Serious`
- `Critical`
- `Unknown`

#### Example:

```js
BatteryModule.getThermalState().then((state) => {
  console.log(`Thermal State: ${state}`);
});
```

### 5. `startListenerWithEvent(eventType: string): void`

Starts listening to battery-related events.

#### Possible Event Types:

- `onBatteryLevelChange`
- `onBatteryStateChange`

#### Example:

```js
BatteryModule.startListenerWithEvent('onBatteryLevelChange');
```

### 6. `stopListenerWithEvent(eventType: string): void`

Stops listening to the specified event.

#### Example:

```js
BatteryModule.stopListenerWithEvent('onBatteryLevelChange');
```

## Usage Example

A complete usage example can be found in the [`example`](./example)[ folder](./example) of this repository.

```js
import BatteryModule from 'react-native-battery-check';

const checkBattery = () => {
  BatteryModule.getBatteryLevel().then((level) => {
    BatteryModule.getBatteryState().then((state) => {
      console.log(`Battery: ${level}% - State: ${state}`);
    });
  });
};

BatteryModule.startListenerWithEvent('onBatteryLevelChange');

// Cleanup on unmount
return () => BatteryModule.stopListenerWithEvent('onBatteryLevelChange');
```

## Compatibility

- **React Native New & Old Architecture** (TurboModule Compatible)
- **iOS & Android** support

## License

MIT
