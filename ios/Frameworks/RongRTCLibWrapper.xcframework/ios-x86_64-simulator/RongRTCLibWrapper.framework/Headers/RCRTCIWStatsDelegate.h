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
 @param roomId 房间ID
 @param userId 远端用户ID
 @discussion
 上报远端音频统计信息
 */
- (void)onRemoteAudioStats:(RCRTCIWRemoteAudioStats *)stats
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId;

/*!
 上报远端视频统计信息
 @param stats 视频统计信息
 @param roomId 房间ID
 @param userId 远端用户ID
 @discussion
 上报远端视频统计信息
 */
- (void)onRemoteVideoStats:(RCRTCIWRemoteVideoStats *)stats
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId;

/*!
 上报远端合流音频统计信息
 @param stats 音频统计信息
 @discussion
 上报远端合流音频统计信息
 */
- (void)onLiveMixAudioStats:(RCRTCIWRemoteAudioStats *)stats;

/*!
 上报远端合流视频统计信息
 @param stats 视频统计信息
 @discussion
 上报远端合流视频统计信息
 */
- (void)onLiveMixVideoStats:(RCRTCIWRemoteVideoStats *)stats;

/*!
 上报远端分流音频统计信息
 @param userId 用户id
 @param volume 音量
 @discussion
 上报远端分流音频统计信息
 */
- (void)onLiveMixMemberAudioStats:(NSString *)userId
                           volume:(NSInteger)volume;

/*!
 上报远端分流自定义音频统计信息
 @param userId 用户id
 @param tag 自定义音频流标签
 @param volume 音量
 @discussion
 上报远端分流自定义音频统计信息
 */
- (void)onLiveMixMemberCustomAudioStats:(NSString *)userId
                                    tag:(NSString *)tag
                                 volume:(NSInteger)volume;

/*!
 上报本地自定义音频统计信息
 @param stats 音频统计信息
 @param tag 自定义音频tag
 @discussion
 上报本地自定义音频统计信息
 */
- (void)onLocalCustomAudioStats:(RCRTCIWLocalAudioStats *)stats
                            tag:(NSString *)tag;

/*!
 上报本地自定义视频统计信息
 @param stats 视频统计信息
 @param tag 自定义视频tag
 @discussion
 上报本地自定义视频统计信息
 */
- (void)onLocalCustomVideoStats:(RCRTCIWLocalVideoStats *)stats
                            tag:(NSString *)tag;

/*!
 上报远端自定义音频统计信息
 @param stats 音频统计信息
 @param roomId 房间ID
 @param userId 远端用户ID
 @param tag 自定义音频tag
 @discussion
 上报远端自定义音频统计信息
 */
- (void)onRemoteCustomAudioStats:(RCRTCIWRemoteAudioStats *)stats
                          roomId:(NSString *)roomId
                          userId:(NSString *)userId
                             tag:(NSString *)tag;

/*!
 上报远端自定义视频统计信息
 @param stats 视频统计信息
 @param roomId 房间ID
 @param userId 远端用户ID
 @param tag 自定义视频tag
 @discussion
 上报远端自定义视频统计信息
 */
- (void)onRemoteCustomVideoStats:(RCRTCIWRemoteVideoStats *)stats
                          roomId:(NSString *)roomId
                          userId:(NSString *)userId
                             tag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
