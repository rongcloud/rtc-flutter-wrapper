#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import <rongcloud_rtc_wrapper_plugin/RCRTCEngineWrapper.h>
//#import <RongIMLib/RongIMLib.h>

#import "GPUImage/GPUImageHandle.h"

@interface AppDelegate () <RCRTCIWAudioFrameDelegate, RCRTCIWVideoFrameDelegate>

@property (nonatomic, strong, nullable) GPUImageHandle *handle;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[RCIMClient sharedRCIMClient] setLogLevel:RC_Log_Level_Verbose];
    
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
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    self.handle = [[GPUImageHandle alloc] init];
    [self.handle onlyBeauty];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)openBeauty {
    [[RCRTCEngineWrapper sharedInstance] setVideoFrameDelegate:self];
}

- (void)closeBeauty {
    [[RCRTCEngineWrapper sharedInstance] setVideoFrameDelegate:nil];
}

- (void)onAudioSendBuffer:(UInt32)inNumberFrames
              audioBuffer:(AudioBufferList *)ioData
                timeStamp:(const AudioTimeStamp *)inTimeStamp
              description:(const AudioStreamBasicDescription)asbd {
    // 音频处理
}

- (CMSampleBufferRef)onVideoFrame:(CMSampleBufferRef)sampleBuffer {
    CMSampleBufferRef processedSampleBuffer = [self.handle onGPUFilterSource:sampleBuffer];
    return processedSampleBuffer ?: sampleBuffer;
}

@end
