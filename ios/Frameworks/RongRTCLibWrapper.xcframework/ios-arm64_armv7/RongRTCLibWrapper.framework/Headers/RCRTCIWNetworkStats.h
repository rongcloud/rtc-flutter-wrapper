//
//  RCRTCIWNetworkStats.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWNetworkStats : NSObject

/*!
 网络类型, WLAN 4G
 */
@property (nonatomic, assign) RCRTCIWNetworkType type;

/*!
 网络地址
 */
@property (nonatomic, strong) NSString *ip;

/*!
 发送码率
 */
@property (nonatomic, assign) NSInteger sendBitrate;

/*!
 接收码率
 */
@property (nonatomic, assign) NSInteger receiveBitrate;

/*!
 发送到服务端往返时间
 */
@property (nonatomic, assign) NSInteger rtt;


@end

NS_ASSUME_NONNULL_END
