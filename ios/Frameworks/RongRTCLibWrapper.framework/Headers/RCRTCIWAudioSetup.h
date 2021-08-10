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

@end

NS_ASSUME_NONNULL_END
