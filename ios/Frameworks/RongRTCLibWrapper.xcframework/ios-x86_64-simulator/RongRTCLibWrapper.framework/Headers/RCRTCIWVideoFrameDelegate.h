//
//  RCRTCVideoBufferDelegate.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/21.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWPixelBufferVideoFrameDelegate <NSObject>

- (void)onPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

@protocol RCRTCIWSampleBufferVideoFrameDelegate <NSObject>

- (CMSampleBufferRef)onSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
