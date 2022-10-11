//
//  RCRTCIWNetworkProbeDelegate.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 7/27/22.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWNetworkProbeStats.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWNetworkProbeDelegate <NSObject>

/**
 汇报网络探测上行数据
 */
- (void)onNetworkProbeUpLinkStats:(RCRTCIWNetworkProbeStats *)stats;

/**
 汇报网络探测下行数据
 */
- (void)onNetworkProbeDownLinkStats:(RCRTCIWNetworkProbeStats *)stats;

/**
 网络探测完成
 @param code  为 0 时是正常结束，非 0 为探测中断
 */
- (void)onNetworkProbeFinished:(NSInteger)code errMsg:(NSString *)errMsg;

@end

NS_ASSUME_NONNULL_END
