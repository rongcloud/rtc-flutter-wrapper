//
//  RCRTCIWCustomLayout.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWCustomLayout : NSObject

/*!
 用户Id
 */
@property (nonatomic, strong) NSString *userId;

/*!
 混流图层坐标的 x 值
 */
@property (nonatomic, assign) NSInteger x;

/*!
 混流图层坐标的 y 值
 */
@property (nonatomic, assign) NSInteger y;

/*!
 视频流的宽度
 */
@property (nonatomic, assign) NSInteger width;

/*!
 视频流的高度
 */
@property (nonatomic, assign) NSInteger height;

@end

NS_ASSUME_NONNULL_END
