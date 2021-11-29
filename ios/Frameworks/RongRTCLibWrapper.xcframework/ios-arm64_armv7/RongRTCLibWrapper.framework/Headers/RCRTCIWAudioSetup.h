//
//  RCRTCIWAudioSetup.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWAudioSetup : NSObject

/*!
 音频编译类型, 默认: RCRTCIWAudioCodecTypeOPUS
 */
@property (nonatomic, assign) RCRTCIWAudioCodecType type;

/*!
  默认 YES：是否可以和其它后台 App 进行混音
  特别注意：如果该属性设置为 NO，切换到其它 App 操作麦克风或者扬声器时，会导致自己 App 麦克风采集和播放被打断。
 */
@property (nonatomic, assign) BOOL mixOtherAppsAudio;

@end

NS_ASSUME_NONNULL_END
