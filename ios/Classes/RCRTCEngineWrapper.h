//
//  RCRTCEngineWrapper.h
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/11.
//

#import <Flutter/Flutter.h>

#import <RongRTCLibWrapper/RCRTCIWEngine.h>

#import "Macros.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCEngineWrapper : NSObject<FlutterPlugin>

SingleInstanceH(Instance);

- (int)setAudioFrameDelegate:(NSObject<RCRTCIWAudioFrameDelegate> * _Nullable)delegate;

- (int)setVideoFrameDelegate:(NSObject<RCRTCIWVideoFrameDelegate> * _Nullable)delegate;

@end

NS_ASSUME_NONNULL_END
