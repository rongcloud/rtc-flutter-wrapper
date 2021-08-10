//
//  RCRTCIWStatsDelegate.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import "RCRTCIWNetworkStats.h"
#import "RCRTCIWLocalAudioStats.h"
#import "RCRTCIWLocalVideoStats.h"
#import "RCRTCIWRemoteAudioStats.h"
#import "RCRTCIWRemoteVideoStats.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWStatsDelegate <NSObject>

@optional

/*!
 上报网络状态统计信息
 @param stats 网络状态统计信息
 @discussion
 上报网络状态统计信息
 */
- (void)onNetworkStats:(RCRTCIWNetworkStats *)stats;

/*!
 上报本地音频统计信息
 @param stats 音频统计信息
 @discussion
 上报音频统计信息
 */
- (void)onLocalAudioStats:(RCRTCIWLocalAudioStats *)stats;

/*!
 上报本地视频统计信息
 @param stats 视频统计信息
 @discussion
 上报视频统计信息
 */
- (void)onLocalVideoStats:(RCRTCIWLocalVideoStats *)stats;

/*!
 上报远端音频统计信息
 @param stats 音频统计信息
 @discussion
 上报远端音频统计信息
 */
- (void)onRemoteAudioStats:(RCRTCIWRemoteAudioStats *)stats;

/*!
 上报远端视频统计信息
 @param stats 视频统计信息
 @discussion
 上报远端视频统计信息
 */
- (void)onRemoteVideoStats:(RCRTCIWRemoteVideoStats *)stats;

@end

NS_ASSUME_NONNULL_END
