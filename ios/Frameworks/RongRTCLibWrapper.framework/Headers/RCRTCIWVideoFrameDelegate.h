//
//  RCRTCVideoBufferDelegate.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/21.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWVideoFrameDelegate <NSObject>

/*!
 发送前上报摄像头采集的视频数据
 @param sampleBuffer 视频数据
 @discussion
 发送前上报摄像头采集的视频数据
 */
- (CMSampleBufferRef)onVideoFrame:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
