//
//  LocalCustomVideoFrameDelegate.h
//  Runner
//
//  Created by 潘铭达 on 2021/9/23.
//

#import <Foundation/Foundation.h>
#import <rongcloud_rtc_wrapper_plugin/RCRTCEngineWrapper.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoteCustomVideoFrameDelegate : NSObject <RCRTCIWPixelBufferVideoFrameDelegate>

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *hostId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *tag;

- (instancetype)initWithRoomId:(NSString *)roomId
                        hostId:(NSString *)hostId
                        userId:(NSString *)userId
                           tag:(NSString *)tag;

- (void)writeFps:(NSString *)fps;

- (void)writeBitrate:(NSString *)bitrate;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
