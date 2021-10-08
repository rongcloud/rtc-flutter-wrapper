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

- (NSInteger)setLocalAudioCapturedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate;

- (NSInteger)setLocalAudioMixedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate;

- (NSInteger)setRemoteAudioReceivedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate
                                     userId:(NSString *)userId;

- (NSInteger)setRemoteAudioMixedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate;

- (NSInteger)setLocalVideoProcessedDelegate:(id<RCRTCIWSampleBufferVideoFrameDelegate> _Nullable)delegate;

- (NSInteger)setRemoteVideoProcessedDelegate:(id<RCRTCIWPixelBufferVideoFrameDelegate> _Nullable)delegate
                                      userId:(NSString *)userId;

- (NSInteger)setLocalCustomVideoProcessedDelegate:(id<RCRTCIWSampleBufferVideoFrameDelegate> _Nullable)delegate
                                              tag:(NSString *)tag;

- (NSInteger)setRemoteCustomVideoProcessedDelegate:(id<RCRTCIWPixelBufferVideoFrameDelegate> _Nullable)delegate
                                            userId:(NSString *)userId
                                               tag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
