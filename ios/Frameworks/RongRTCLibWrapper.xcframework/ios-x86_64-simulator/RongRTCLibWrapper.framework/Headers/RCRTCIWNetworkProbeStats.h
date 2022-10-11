//
//  RCRTCIWNetworkProbeStats.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 7/25/22.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWNetworkProbeStats : NSObject

/**
 网络质量等级
 */
@property (nonatomic, assign, readonly) RCRTCIWNetworkQualityLevel qualityLevel;

/*!
 往返时间
 */
@property (nonatomic, assign, readonly) NSInteger rtt;

/*!
 丢包率
 */
@property (nonatomic, assign, readonly) float packetLostRate;

@end

NS_ASSUME_NONNULL_END
