//
//  RCRTCIWAudioConfig.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWAudioConfig : NSObject

/*!
 音频通话质量类型, 默认: RCRTCIWAudioQualitySpeech
 */
@property (nonatomic, assign) RCRTCIWAudioQuality quality;

/*!
 音频通话模式, 默认: RCRTCIWAudioScenarioDefault
 */
@property (nonatomic, assign) RCRTCIWAudioScenario scenario;

@property (nonatomic, assign) NSUInteger recordingVolume;

@end

NS_ASSUME_NONNULL_END
