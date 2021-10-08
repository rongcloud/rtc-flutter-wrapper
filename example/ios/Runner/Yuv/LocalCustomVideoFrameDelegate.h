//
//  LocalCustomVideoFrameDelegate.h
//  Runner
//
//  Created by 潘铭达 on 2021/9/23.
//

#import <Foundation/Foundation.h>
#import <rongcloud_rtc_wrapper_plugin/RCRTCEngineWrapper.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalCustomVideoFrameDelegate : NSObject <RCRTCIWSampleBufferVideoFrameDelegate>

@property (nonatomic, strong, readonly) NSString *roomId;
@property (nonatomic, strong, readonly) NSString *hostId;
@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSString *tag;

- (instancetype)initWithRoomId:(NSString *)roomId
                        hostId:(NSString *)hostId
                        userId:(NSString *)userId
                           tag:(NSString *)tag;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
