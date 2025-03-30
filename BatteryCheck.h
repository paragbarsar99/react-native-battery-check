#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

// Declare the delegate protocol inside the header.
@protocol BatteryCheckDelegate <NSObject>
@required
- (void)sendEventWithName:(NSString *)name result:(id)result;
@end

// Declare the BatteryCheck interface, conforming to RCTEventEmitter, RCTBridgeModule, and the delegate protocol.
@interface BatteryCheck : RCTEventEmitter <RCTBridgeModule, BatteryCheckDelegate>

- (NSNumber *)getBatteryLevel;
- (NSString *)isLowPowerModeEnabled;
- (NSString *)getThermalState;
- (NSString *)getBatteryState;
- (void)startListener:(NSString *)event;
- (void)stopListener:(NSString *)event;

+ (NSArray<NSString *> *)supportedEvents;

@end

NS_ASSUME_NONNULL_END
