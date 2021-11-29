//
//  RCRTCAudioBufferDelegate.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/21.
//

#import "RCRTCIWAudioFrame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWAudioFrameDelegate <NSObject>

/*!
音频数据回调
@param frame 音频数据
@discussion
音频数据回调
*/
- (void)onAudioFrame:(RCRTCIWAudioFrame * _Nonnull)frame;

@end

NS_ASSUME_NONNULL_END
