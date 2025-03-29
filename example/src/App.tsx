import { useCallback, useEffect, useState } from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import {
  addEventListenerWithEventType,
  getBatteryLevel,
  getBatteryState,
  getThermalState,
  isLowPowerModeEnabled,
  removeEventListenerWithEventType,
} from '../../src/index';

export default function App() {
  const [state, setState] = useState({
    level: '',
    isLowPowerMode: '',
    thermalStates: '',
    status: '',
  });
  const getAll = useCallback(async () => {
    const level = await getBatteryLevel();
    const isLowPowerMode = await isLowPowerModeEnabled();
    const thermalStates = await getThermalState();
    const status = await getBatteryState();
    setState({
      level: level.toString(),
      isLowPowerMode: isLowPowerMode,
      thermalStates: thermalStates,
      status: status,
    });
  }, []);

  useEffect(() => {
    getAll();
    addEventListenerWithEventType('onBatteryStateChange', (status) => {
      setState((prev) => ({
        ...prev,
        status: status,
      }));
    });
    return () => {
      removeEventListenerWithEventType('onBatteryStateChange');
    };
  }, [getAll]);

  return (
    <View style={styles.container}>
      <Text>Battery level: {state.level}</Text>
      <Text>Status: {state.status}</Text>
      <Text>isLowPowerMode: {state.isLowPowerMode}</Text>
      <Text>thermalStates: {state.thermalStates}</Text>
      <View style={styles.box}>
        <Text style={styles.heading}>Battery State Change Listeners</Text>

        <Button
          title="addBatteryStateChange"
          onPress={() => {
            addEventListenerWithEventType('onBatteryStateChange', (status) => {
              setState((prev) => ({
                ...prev,
                status: status,
              }));
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
              setState((prev) => ({
                ...prev,
                level: status,
              }));
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
    backgroundColor: '#000',
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
