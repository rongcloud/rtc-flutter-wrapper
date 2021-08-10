//
//  RCRTCViewWrapper.h
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/15.
//

#import <Flutter/Flutter.h>

#import "Macros.h"

NS_ASSUME_NONNULL_BEGIN

@class RCRTCIWFlutterView;

@interface RCRTCView : NSObject

- (RCRTCIWFlutterView *)view;

@end

@interface RCRTCViewWrapper : NSObject<FlutterPlugin>

SingleInstanceH(Instance);

- (RCRTCView *)getView:(NSInteger)tid;

@end

NS_ASSUME_NONNULL_END
