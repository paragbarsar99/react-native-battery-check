
#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>
#ifdef RCT_NEW_ARCH_ENABLED
#import "generated/RNBatteryInfoSpec/RNBatteryInfoSpec.h"

#endif

NS_ASSUME_NONNULL_BEGIN


#ifdef RCT_NEW_ARCH_ENABLED
@interface BatteryInfo: RCTEventEmitter<NativeBatteryInfoSpec>
#else
#import <React/RCTBridgeModule.h>
@interface BatteryInfo:RCTEventEmitter<RCTBridgeModule>
#endif
@end
NS_ASSUME_NONNULL_END



