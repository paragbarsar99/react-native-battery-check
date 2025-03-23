import { useEffect, useState } from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import {
  getBatteryLevel,
  isLowPowerModeEnabled,
  getThermalState,
  addEventListenerWithEventType,
  removeEventListenerWithEventType,
} from 'react-native-battery-info';

const result = getBatteryLevel();
const isLowPowerMode = isLowPowerModeEnabled();
const thermalStatus = getThermalState();
export default function App() {
  const [batteryStatus, setBatteryStatus] = useState('');

  useEffect(() => {
    addEventListenerWithEventType('onBatteryStateChange', (status) => {
      setBatteryStatus(status);
    });
    return () => {
      removeEventListenerWithEventType('onBatteryStateChange');
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text>Battery level: {result}</Text>
      <Text>Status: {batteryStatus}</Text>
      <Text>isLowPowerMode: {isLowPowerMode}</Text>
      <Text>getThermalState: {thermalStatus}</Text>
      <View style={styles.box}>
        <Text style={styles.heading}>Battery State Change Listeners</Text>

        <Button
          title="addBatteryStateChange"
          onPress={() => {
            addEventListenerWithEventType('onBatteryStateChange', (status) => {
              setBatteryStatus(status);
            });
          }}
        />
        <Button
          title="removeBatteryStateListener"
          onPress={() => {
            removeEventListenerWithEventType('onBatteryStateChange');
          }}
        />
      </View>
      <View style={styles.box}>
        <Text style={styles.heading}>Battery Level Change Listeners</Text>

        <Button
          title="startBatteryLevelChangeListener"
          onPress={() => {
            addEventListenerWithEventType('onBatteryLevelChange', (status) => {
              setBatteryStatus(status);
            });
          }}
        />
        <Button
          title="remvoeBatteryLevelChange"
          onPress={() => {
            removeEventListenerWithEventType('onBatteryLevelChange');
          }}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  heading: {
    fontSize: 22,
    color: '#000',
  },
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'white',
    gap: 10,
  },
  box: {
    borderWidth: 1,
    borderColor: '#000',
    padding: 10,
    gap: 20,
    borderRadius: 10,
  },
});
