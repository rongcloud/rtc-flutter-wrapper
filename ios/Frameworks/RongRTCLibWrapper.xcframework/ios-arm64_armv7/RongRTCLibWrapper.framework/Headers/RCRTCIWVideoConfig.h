//
//  RCRTCIWVideoConfig.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWVideoConfig : NSObject

/*!
 视频最小码率, 默认值: 0
 */
@property (nonatomic, assign) NSUInteger minBitrate;

/*!
 视频最大码率, 默认值: 0
 */
@property (nonatomic, assign) NSUInteger maxBitrate;

/*!
 视频帧率, 默认值: RCRTCIWVideoFPS15
 */
@property (nonatomic, assign) RCRTCIWVideoFps fps;

/*!
 视频分辨率, 默认值: RCRTCIWVideoResolution640x480
 */
@property (nonatomic, assign) RCRTCIWVideoResolution resolution;

/*!
 流镜像, 默认值: NO
 */
@property (nonatomic, assign) BOOL mirror;

@end

NS_ASSUME_NONNULL_END
