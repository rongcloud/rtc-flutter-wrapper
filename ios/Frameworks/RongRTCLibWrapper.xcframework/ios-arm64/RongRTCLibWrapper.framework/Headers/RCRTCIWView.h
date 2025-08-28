//
//  RCRTCIWVideoView.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWView : UIView

/*!
 视频镜像
 */
@property (nonatomic, assign) BOOL mirror;

/*!
 视频填充模式
 */
@property (nonatomic, assign) RCRTCIWViewFitType fitType;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (RCRTCIWView *)create;

+ (RCRTCIWView *)create:(CGRect)frame;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
