//
//  RCRTCAudioBufferDelegate.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/21.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWAudioFrameDelegate <NSObject>

/*!
 发遂前上报麦克风采集的音频数据的回调
 
 @param inNumberFrames 帧个数
 @param ioData 音频 pcm 数据
 @param inTimeStamp 音频时间戳
 @param asbd 音频数据格式
 @discussion
 发遂前上报麦克风采集的音频数据的回调
 */
- (void)onAudioSendBuffer:(UInt32)inNumberFrames
              audioBuffer:(AudioBufferList *_Nonnull)ioData
                timeStamp:(const AudioTimeStamp *_Nonnull)inTimeStamp
              description:(const AudioStreamBasicDescription)asbd;

@end

NS_ASSUME_NONNULL_END
