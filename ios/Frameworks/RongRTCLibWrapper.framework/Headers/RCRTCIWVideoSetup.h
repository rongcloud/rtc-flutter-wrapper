//
//  RCRTCIWVideoSetup.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWVideoSetup : NSObject

/*!
 是否开启视频小流, 默认: YES 开启
 */
@property (nonatomic, assign) BOOL enableTinyStream;

@end

NS_ASSUME_NONNULL_END
