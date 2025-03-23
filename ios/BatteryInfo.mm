#import "BatteryInfo.h"
#include <Foundation/Foundation.h>
#import "BatteryInfo-Swift.h"

// Conform to the BatteryinfoManagerDelegate protocol
@interface BatteryInfo () <BatteryinfoManagerDelegate>
@property (nonatomic, strong) BatteryinfoManager *batteryManager;
@end

@implementation BatteryInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _batteryManager = [[BatteryinfoManager alloc] init];
        _batteryManager.delegate = self; // Set the delegate
    }
    return self;
}

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

// Supported events
- (NSArray<NSString *> *)supportedEvents {
    return [BatteryinfoManager supportedEvents];
}

// Implement the BatteryinfoManagerDelegate protocol
- (void)sendEventWithName:(NSString *)name result:(id)result {
    NSLog(@"Battery Info: %@", name);
    [self sendEventWithName:name body:result];
}



#ifdef RCT_NEW_ARCH_ENABLED

// TurboModule implementation for New Architecture
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeBatteryInfoSpecJSI>(params);
}

- (nonnull NSNumber *)getBatteryLevel {
    return [self.batteryManager getBatteryLevel];
}

- (nonnull NSString *)getBatteryState {
    return [self.batteryManager getBatteryState];
}

- (nonnull NSString *)getThermalState {
    return [self.batteryManager getThermalState];
}

- (nonnull NSNumber *)isLowPowerModeEnabled {
    return [self.batteryManager isLowPowerModeEnabled];
}
- (void)stopListenerWithEvent:(NSString *)eventName {
    [self.batteryManager stopListenerWithEvent:eventName];
}
- (void)startListenerWithEvent:(NSString *)eventName {
    [self.batteryManager startListenerWithEvent:eventName];
}
-(void)addListener:(NSString *)eventName{
     
}
-(void)removeListeners:(NSNumber *)eventName { 

}
#else
// Exported methods
RCT_EXPORT_METHOD(getBatteryLevel:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSNumber *level = [self.batteryManager getBatteryLevel];
    resolve(level);
}

RCT_EXPORT_METHOD(getBatteryState:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *state = [self.batteryManager getBatteryState];
    resolve(state);
}

RCT_EXPORT_METHOD(isLowPowerModeEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSNumber *isLowPowerMode = [self.batteryManager isLowPowerModeEnabled];
    resolve(isLowPowerMode);
}

RCT_EXPORT_METHOD(getThermalState:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *state = [self.batteryManager getThermalState];
    resolve(state);
}

RCT_EXPORT_METHOD(stopListenerWithEvent:(NSString *)eventName)
{
    [self.batteryManager stopListenerWithEvent:eventName];
}

RCT_EXPORT_METHOD(startListenerWithEvent:(NSString *)eventName)
{
    [self.batteryManager startListenerWithEvent:eventName];
}

RCT_EXPORT_METHOD(addListener:(NSString *)eventName)
{
    
}

RCT_EXPORT_METHOD(removeListeners:(NSNumber *)eventName)
{

}
#endif



@end
