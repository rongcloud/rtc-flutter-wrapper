#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import <rongcloud_rtc_wrapper_plugin/RCRTCEngineWrapper.h>
#import <RongIMLibCore/RongIMLibCore.h>

#import "GPUImage/GPUImageHandle.h"
#import "LocalCustomVideoFrameDelegate.h"
#import "RemoteCustomVideoFrameDelegate.h"

@interface AppDelegate () <RCRTCIWAudioFrameDelegate, RCRTCIWSampleBufferVideoFrameDelegate>

@property (nonatomic, strong, nullable) GPUImageHandle *handle;
@property (nonatomic, strong, nullable) LocalCustomVideoFrameDelegate *localCustomVideoFrameDelegate;
@property (nonatomic, strong) NSMutableDictionary *remoteCustomVideoFrameDelegates;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RCCoreClient sharedCoreClient] setLogLevel:RC_Log_Level_Verbose];
    
    FlutterViewController *controller = (FlutterViewController *) self.window.rootViewController;
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"cn.rongcloud.rtc.flutter.demo"
                                                                binaryMessenger:controller.binaryMessenger];
    
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"openBeauty"]) {
            [self openBeauty];
            result(nil);
        } else if ([call.method isEqualToString:@"closeBeauty"]) {
            [self closeBeauty];
            result(nil);
        } else if ([call.method isEqualToString:@"enableLocalCustomYuv"]) {
            [self enableLocalCustomYuv:call];
            result(nil);
        } else if ([call.method isEqualToString:@"disableLocalCustomYuv"]) {
            [self disableLocalCustomYuv:call];
            result(nil);
        } else if ([call.method isEqualToString:@"enableRemoteCustomYuv"]) {
            [self enableRemoteCustomYuv:call];
            result(nil);
        } else if ([call.method isEqualToString:@"disableRemoteCustomYuv"]) {
            [self disableRemoteCustomYuv:call];
            result(nil);
        } else if ([call.method isEqualToString:@"disableAllRemoteCustomYuv"]) {
            [self disableAllRemoteCustomYuv:call];
            result(nil);
        } else if ([call.method isEqualToString:@"writeReceiveVideoFps"]) {
            [self writeReceiveVideoFps:call];
            result(nil);
        } else if ([call.method isEqualToString:@"writeReceiveVideoBitrate"]) {
            [self writeReceiveVideoBitrate:call];
            result(nil);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    self.handle = [[GPUImageHandle alloc] init];
    [self.handle onlyBeauty];
    
    self.remoteCustomVideoFrameDelegates = [NSMutableDictionary dictionary];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)openBeauty {
    [[RCRTCEngineWrapper sharedInstance] setLocalVideoProcessedDelegate:self];
}

- (void)closeBeauty {
    [[RCRTCEngineWrapper sharedInstance] setLocalVideoProcessedDelegate:nil];
}

- (void)enableLocalCustomYuv:(FlutterMethodCall *)call {
    if (!self.localCustomVideoFrameDelegate) {
        NSString *roomId = call.arguments[@"rid"];
        NSString *hostId = call.arguments[@"hid"];
        NSString *userId = call.arguments[@"uid"];
        NSString *tag = call.arguments[@"tag"];
        self.localCustomVideoFrameDelegate = [[LocalCustomVideoFrameDelegate alloc] initWithRoomId:roomId
                                                                                            hostId:hostId
                                                                                            userId:userId
                                                                                               tag:tag];
        [[RCRTCEngineWrapper sharedInstance] setLocalCustomVideoProcessedDelegate:self.localCustomVideoFrameDelegate
                                                                              tag:tag];
    }
}

- (void)disableLocalCustomYuv:(FlutterMethodCall *)call {
    if (self.localCustomVideoFrameDelegate) {
        [[RCRTCEngineWrapper sharedInstance] setLocalCustomVideoProcessedDelegate:nil
                                                                              tag:self.localCustomVideoFrameDelegate.tag];
        [self.localCustomVideoFrameDelegate destroy];
        self.localCustomVideoFrameDelegate = nil;
    }
}

- (void)enableRemoteCustomYuv:(FlutterMethodCall *)call {
    NSString *roomId = call.arguments[@"rid"];
    NSString *hostId = call.arguments[@"hid"];
    NSString *userId = call.arguments[@"uid"];
    NSString *tag = call.arguments[@"tag"];
    NSString *key = [NSString stringWithFormat:@"%@@%@", userId, tag];
    id remoteCustomVideoFrameDelegate = [self.remoteCustomVideoFrameDelegates objectForKey:key];
    if (!remoteCustomVideoFrameDelegate) {
        remoteCustomVideoFrameDelegate = [[RemoteCustomVideoFrameDelegate alloc] initWithRoomId:roomId
                                                                                         hostId:hostId
                                                                                         userId:userId
                                                                                            tag:tag];
        [self.remoteCustomVideoFrameDelegates setObject:remoteCustomVideoFrameDelegate
                                                 forKey:key];
        [[RCRTCEngineWrapper sharedInstance] setRemoteCustomVideoProcessedDelegate:remoteCustomVideoFrameDelegate
                                                                            userId:userId
                                                                               tag:tag];
    }
}

- (void)disableRemoteCustomYuv:(FlutterMethodCall *)call {
    NSString *userId = call.arguments[@"id"];
    NSString *tag = call.arguments[@"tag"];
    NSString *key = [NSString stringWithFormat:@"%@@%@", userId, tag];
    id remoteCustomVideoFrameDelegate = [self.remoteCustomVideoFrameDelegates objectForKey:key];
    if (remoteCustomVideoFrameDelegate) {
        [[RCRTCEngineWrapper sharedInstance] setRemoteCustomVideoProcessedDelegate:nil
                                                                            userId:userId
                                                                               tag:tag];
        [remoteCustomVideoFrameDelegate destroy];
        [self.remoteCustomVideoFrameDelegates removeObjectForKey:key];
    }
}

- (void)disableAllRemoteCustomYuv:(FlutterMethodCall *)call {
    for (RemoteCustomVideoFrameDelegate *delegate in self.remoteCustomVideoFrameDelegates.allValues) {
        [delegate destroy];
    }
    [self.remoteCustomVideoFrameDelegates removeAllObjects];
}

- (void)writeReceiveVideoFps:(FlutterMethodCall *)call {
    NSString *userId = call.arguments[@"id"];
    NSString *tag = call.arguments[@"tag"];
    NSString *fps = call.arguments[@"fps"];
    NSString *key = [NSString stringWithFormat:@"%@@%@", userId, tag];
    id remoteCustomVideoFrameDelegate = [self.remoteCustomVideoFrameDelegates objectForKey:key];
    if (remoteCustomVideoFrameDelegate) {
        [remoteCustomVideoFrameDelegate writeFps:fps];
    }
}

- (void)writeReceiveVideoBitrate:(FlutterMethodCall *)call {
    NSString *userId = call.arguments[@"id"];
    NSString *tag = call.arguments[@"tag"];
    NSString *bitrate = call.arguments[@"bitrate"];
    NSString *key = [NSString stringWithFormat:@"%@@%@", userId, tag];
    id remoteCustomVideoFrameDelegate = [self.remoteCustomVideoFrameDelegates objectForKey:key];
    if (remoteCustomVideoFrameDelegate) {
        [remoteCustomVideoFrameDelegate writeBitrate:bitrate];
    }
}

- (void)onAudioFrame:(RCRTCIWAudioFrame *)frame {
    // 音频处理
}

- (CMSampleBufferRef)onSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CMSampleBufferRef processedSampleBuffer = [self.handle onGPUFilterSource:sampleBuffer];
    return processedSampleBuffer ?: sampleBuffer;
}

@end
