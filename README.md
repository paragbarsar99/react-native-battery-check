# React Native Battery Module

A **React Native Turbo Module** for monitoring battery status, power mode, and thermal conditions on both **iOS and Android**. This module is compatible with both **New (Fabric) and Old Architecture**, ensuring seamless integration across different versions of React Native.

## Features

- Get real-time battery level
- Check battery charging state
- Detect low power mode activation
- Monitor device thermal conditions
- Listen for battery state and level changes

## Installation

```sh
npm install react-native-battery-module
# or
yarn add react-native-battery-module
```

## API Reference

### 1. `getBatteryLevel(): number`

Retrieves the current battery level as a percentage (0-100).

#### Example:

```js
import BatteryModule from 'react-native-battery-module';

const level = BatteryModule.getBatteryLevel();
console.log(`Battery Level: ${level}%`);
```

### 2. `getBatteryState(): string`

Returns the battery charging state.

#### Possible Values:

- `Charging`
- `Unplugged`
- `Full`
- `Unknown`

#### Example:

```js
const state = BatteryModule.getBatteryState();
console.log(`Battery State: ${state}`);
```

### 3. `isLowPowerModeEnabled(): boolean`

Checks if Low Power Mode is enabled.

#### Example:

```js
const isEnabled = BatteryModule.isLowPowerModeEnabled();
console.log(`Low Power Mode: ${isEnabled ? 'Enabled' : 'Disabled'}`);
```

### 4. `getThermalState(): string`

Returns the current thermal state of the device.

#### Possible Values:

- `Nominal`
- `Fair`
- `Serious`
- `Critical`
- `Unknown`

#### Example:

```js
const state = BatteryModule.getThermalState();
console.log(`Thermal State: ${state}`);
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

A complete usage example can be found in the [`example` folder](./example) of this repository.

```js
import BatteryModule from 'react-native-battery-module';

const checkBattery = () => {
  const level = BatteryModule.getBatteryLevel();
  const state = BatteryModule.getBatteryState();
  console.log(`Battery: ${level}% - State: ${state}`);
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

