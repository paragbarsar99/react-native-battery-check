import Foundation
import UIKit

// Define a protocol for the BatteryinfoManager Delegate
@objc protocol BatteryinfoManagerDelegate {
    func sendEvent(name: String, result: Any)
}

@objc class BatteryinfoManager: NSObject {
    @objc weak var delegate: BatteryinfoManagerDelegate? = nil

    override init() {
        super.init()
        UIDevice.current.isBatteryMonitoringEnabled = true
       
      
    }

    @objc func getBatteryLevel() -> NSNumber {
        return NSNumber(value: UIDevice.current.batteryLevel * 100)
    }

    @objc func isLowPowerModeEnabled() -> NSString {
        return ProcessInfo.processInfo.isLowPowerModeEnabled ? "true" : "false"
    }

    @objc func getThermalState() -> String {
        let thermalState = ProcessInfo.processInfo.thermalState
        switch thermalState {
        case .nominal:
            return "Nominal"
        case .fair:
            return "Fair"
        case .serious:
            return "Serious"
        case .critical:
            return "Critical"
        @unknown default:
            return "Unknown"
        }
    }

    @objc func getBatteryState() -> String {
        switch UIDevice.current.batteryState {
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "Unplugged"
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        @unknown default:
            return "Unknown"
        }
    }

    @objc private func batteryLevelDidChange() {
        let batteryLevel = getBatteryLevel()
        delegate?.sendEvent(name: "onBatteryLevelChange", result: batteryLevel)
    }

    @objc private func batteryStateDidChange() {
        let state = getBatteryState()
        delegate?.sendEvent(name: "onBatteryStateChange", result: state)
    }
    
    @objc func stopListener(event:String){
        if(event == "onBatteryLevelChange"){
            NotificationCenter.default.removeObserver(self, name:UIDevice.batteryLevelDidChangeNotification ,object: nil)
        }
        if(event == "onBatteryStateChange"){
            NotificationCenter.default.removeObserver(self, name:UIDevice.batteryStateDidChangeNotification ,object: nil)
        }
    }
    
    @objc func startListener(event:String){
        if(event == "onBatteryLevelChange"){
            NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        }
        if(event == "onBatteryStateChange"){
            NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        }
    }
}

extension BatteryinfoManager {
    // List of emittable events
    enum Event: String, CaseIterable {
        case onBatteryLevelChange
        case onBatteryStateChange
    }

    @objc
    static var supportedEvents: [String] {
        return Event.allCases.map(\.rawValue)
    }
}
