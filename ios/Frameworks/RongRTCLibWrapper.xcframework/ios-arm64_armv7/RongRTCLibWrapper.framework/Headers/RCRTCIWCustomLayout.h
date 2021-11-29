//
//  RCRTCIWCustomLayout.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWCustomLayout : NSObject

/*!
 流类型, 默认: RCRTCIWStreamTypeNormal
 */
@property (nonatomic, assign, readonly) RCRTCIWStreamType type;

/*!
 用户Id
 */
@property (nonatomic, strong, readonly) NSString *userId;

/*!
 流tag
 */
@property (nonatomic, strong, readonly) NSString *tag;

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

- (instancetype)init __attribute__((unavailable("use initWithUserId or initWithStreamType instead.")));

- (instancetype)initWithUserId:(NSString *)userId;

- (instancetype)initWithStreamType:(RCRTCIWStreamType)type
                            userId:(NSString *)userId
                               tag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
