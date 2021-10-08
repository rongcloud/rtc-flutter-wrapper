//
//  RCRTCIWRemoteAudioStats.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWRemoteAudioStats : NSObject

/*!
 音频编码
 */
@property (nonatomic, assign) RCRTCIWAudioCodecType codec;

/*!
 码率
 */
@property (nonatomic, assign) NSInteger bitrate;

/*!
 音量, 0 ~ 9 表示音量高低
 */
@property (nonatomic, assign) NSInteger volume;

/*!
 丢包率
 */
@property (nonatomic, assign) CGFloat packageLostRate;

/*!
 往返时间
 */
@property (nonatomic, assign) NSInteger rtt;

@end

NS_ASSUME_NONNULL_END
