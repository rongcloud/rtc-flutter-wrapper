//
//  RCRTCIWLocalVideoStats.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWLocalVideoStats : NSObject

/*!
 是否小流
 */
@property (nonatomic, assign) BOOL tiny;

/*!
 视频编码
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
 发送到服务端往返时间
 */
@property (nonatomic, assign) NSInteger rtt;

@end

NS_ASSUME_NONNULL_END
