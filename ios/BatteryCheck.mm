#import "BatteryCheck.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <UIKit/UIKit.h>

@interface BatteryCheck ()
@property (nonatomic, assign) BOOL hasListeners;
@end

@implementation BatteryCheck

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelDidChange) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateDidChange) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Supported events
- (NSArray<NSString *> *)supportedEvents {
    return @[@"onBatteryLevelChange", @"onBatteryStateChange"];
}

// Listener tracking
RCT_EXPORT_METHOD(addListener:(NSString *)eventName) {
    self.hasListeners = YES;
}

RCT_EXPORT_METHOD(removeListeners:(NSInteger)count) {
    self.hasListeners = NO;
}

// Get battery level
RCT_EXPORT_METHOD(getBatteryLevel:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    float batteryLevel = [UIDevice currentDevice].batteryLevel * 100;
    resolve(@(batteryLevel));
}

// Get battery state
RCT_EXPORT_METHOD(getBatteryState:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *state;
    switch ([UIDevice currentDevice].batteryState) {
        case UIDeviceBatteryStateUnknown:
            state = @"Unknown";
            break;
        case UIDeviceBatteryStateUnplugged:
            state = @"Unplugged";
            break;
        case UIDeviceBatteryStateCharging:
            state = @"Charging";
            break;
        case UIDeviceBatteryStateFull:
            state = @"Full";
            break;
        default:
            state = @"Unknown";
            break;
    }
    resolve(state);
}

// Check low power mode
RCT_EXPORT_METHOD(isLowPowerModeEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    BOOL lowPowerMode = [[NSProcessInfo processInfo] isLowPowerModeEnabled];
    resolve(@(lowPowerMode));
}

// Get thermal state
RCT_EXPORT_METHOD(getThermalState:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *state;
    switch ([NSProcessInfo processInfo].thermalState) {
        case NSProcessInfoThermalStateNominal:
            state = @"Nominal";
            break;
        case NSProcessInfoThermalStateFair:
            state = @"Fair";
            break;
        case NSProcessInfoThermalStateSerious:
            state = @"Serious";
            break;
        case NSProcessInfoThermalStateCritical:
            state = @"Critical";
            break;
        default:
            state = @"Unknown";
            break;
    }
    resolve(state);
}

// Battery level change event
- (void)batteryLevelDidChange {
    if (self.hasListeners) {
        float batteryLevel = [UIDevice currentDevice].batteryLevel * 100;
        [self sendEventWithName:@"onBatteryLevelChange" body:@(batteryLevel)];
    }
}

// Battery state change event
- (void)batteryStateDidChange {
    if (self.hasListeners) {
        NSString *state;
        switch ([UIDevice currentDevice].batteryState) {
            case UIDeviceBatteryStateUnknown:
                state = @"Unknown";
                break;
            case UIDeviceBatteryStateUnplugged:
                state = @"Unplugged";
                break;
            case UIDeviceBatteryStateCharging:
                state = @"Charging";
                break;
            case UIDeviceBatteryStateFull:
                state = @"Full";
                break;
            default:
                state = @"Unknown";
                break;
        }
        [self sendEventWithName:@"onBatteryStateChange" body:state];
    }
}

// Start event listener
RCT_EXPORT_METHOD(startListener:(NSString *)event) {
    if ([event isEqualToString:@"onBatteryLevelChange"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelDidChange) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    } else if ([event isEqualToString:@"onBatteryStateChange"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateDidChange) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    }
}

// Stop event listener
RCT_EXPORT_METHOD(stopListener:(NSString *)event) {
    if ([event isEqualToString:@"onBatteryLevelChange"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    } else if ([event isEqualToString:@"onBatteryStateChange"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:nil];
    }
}

@end
