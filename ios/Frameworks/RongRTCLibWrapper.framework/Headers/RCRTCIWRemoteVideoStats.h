//
//  RCRTCIWRemoteVideoStats.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWRemoteVideoStats : NSObject

/*!
 音频编码
 */
@property (nonatomic, assign) RCRTCIWVideoCodecType codec;

/*!
 码率
 */
@property (nonatomic, assign) NSInteger bitrate;

/*!
 帧率
 */
@property (nonatomic, assign) NSInteger fps;

/*!
 宽度
 */
@property (nonatomic, assign) NSInteger width;

/*!
 高度
 */
@property (nonatomic, assign) NSInteger height;

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




