//
//  RCRTCEngineWrapper.m
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/11.
//

#import "RCRTCEngineWrapper.h"


#import "RCRTCViewWrapper.h"
#import "MainThreadPoster.h"
#import "ArgumentAdapter.h"

@protocol RCRTCIWViewDelegate;

@interface RCRTCIWEngine()
- (NSInteger)setLocalViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *)view;
- (NSInteger)setRemoteViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *)view userId:(NSString *)userId;
- (NSInteger)setLiveMixViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *)view;
- (NSInteger)setLocalCustomStreamViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *)view tag:(NSString *)tag;
- (NSInteger)setRemoteCustomStreamViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *)view userId:(NSString *)userId tag:(NSString *)tag;
- (NSInteger)setLiveMixInnerCdnStreamViewDelegate:(NSObject<RCRTCIWViewDelegate> *)view;
@end

@interface RCRTCEngineWrapper() <RCRTCIWEngineDelegate, RCRTCIWStatsDelegate, RCRTCIWNetworkProbeDelegate> {
    NSObject<FlutterPluginRegistrar> *registrar;
    FlutterMethodChannel *channel;
    RCRTCIWEngine *engine;
}

@end

@implementation RCRTCEngineWrapper

#pragma mark *************** [N] ***************

- (instancetype)init {
    self = [super init];
    if (self) {
        engine = nil;
    }
    return self;
}

SingleInstanceM(Instance);

- (NSInteger)setLocalAudioCapturedDelegate:(id<RCRTCIWAudioFrameDelegate>)delegate {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setLocalAudioCapturedDelegate:delegate];
    }
    return code;
}

- (NSInteger)setLocalAudioMixedDelegate:(id<RCRTCIWAudioFrameDelegate>)delegate {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setLocalAudioMixedDelegate:delegate];
    }
    return code;
}

- (NSInteger)setRemoteAudioReceivedDelegate:(id<RCRTCIWAudioFrameDelegate>)delegate
                                     userId:(NSString *)userId {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setRemoteAudioReceivedDelegate:delegate
                                               userId:userId];
    }
    return code;
}

- (NSInteger)setRemoteAudioMixedDelegate:(id<RCRTCIWAudioFrameDelegate>)delegate {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setRemoteAudioMixedDelegate:delegate];
    }
    return code;
}

- (NSInteger)setLocalVideoProcessedDelegate:(id<RCRTCIWSampleBufferVideoFrameDelegate>)delegate {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setLocalVideoProcessedDelegate:delegate];
    }
    return code;
}

- (NSInteger)setRemoteVideoProcessedDelegate:(id<RCRTCIWPixelBufferVideoFrameDelegate>)delegate
                                      userId:(NSString *)userId {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setRemoteVideoProcessedDelegate:delegate
                                                userId:userId];
    }
    return code;
}

- (NSInteger)setLocalCustomVideoProcessedDelegate:(id<RCRTCIWSampleBufferVideoFrameDelegate>)delegate
                                              tag:(NSString *)tag {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setLocalCustomVideoProcessedDelegate:delegate
                                                        tag:tag];
    }
    return code;
}

- (NSInteger)setRemoteCustomVideoProcessedDelegate:(id<RCRTCIWPixelBufferVideoFrameDelegate>)delegate
                                            userId:(NSString *)userId
                                               tag:(NSString *)tag {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine setRemoteCustomVideoProcessedDelegate:delegate
                                                      userId:userId
                                                         tag:tag];
    }
    return code;
}

- (void)initWithRegistrar:(NSObject<FlutterPluginRegistrar> * _Nullable)registrar {
    channel = [FlutterMethodChannel methodChannelWithName:@"cn.rongcloud.rtc.flutter/engine"
                                          binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
    self->registrar = registrar;
}

- (void)unInit {
    channel = nil;
    registrar = nil;
}

#pragma mark *************** [D] ***************

- (void)create:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (engine == nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        id setup = arguments[@"setup"];
        if (![setup isEqual:[NSNull null]]) {
            engine = [RCRTCIWEngine create:toEngineSetup(setup)];
        } else {
            engine = [RCRTCIWEngine create];
        }
        engine.engineDelegate = self;
    }
    dispatch_to_main_queue(^{
        result(nil);
    });
}

- (void)destroy:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        [engine destroy];
        engine = nil;
        code = 0;
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)joinRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *rid = arguments[@"id"];
        NSDictionary *setup = arguments[@"setup"];
        code = [engine joinRoom:rid setup:toRoomSetup(setup)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)leaveRoom:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine leaveRoom];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)publish:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int type = [arguments[@"type"] intValue];
        code = [engine publish:toMediaType(type)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)unpublish:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int type = [arguments[@"type"] intValue];
        code = [engine unpublish:toMediaType(type)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)subscribe:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        int type = [arguments[@"type"] intValue];
        bool tiny = [arguments[@"tiny"] boolValue];
        code = [engine subscribe:uid type:toMediaType(type) tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)subscribes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSArray<NSString *> *ids = arguments[@"ids"];
        int type = [arguments[@"type"] intValue];
        bool tiny = [arguments[@"tiny"] boolValue];
        code = [engine subscribeWithUserIds:ids type:toMediaType(type) tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)subscribeLiveMix:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int type = [arguments[@"type"] intValue];
        bool tiny = [arguments[@"tiny"] boolValue];
        code = [engine subscribeLiveMix:toMediaType(type) tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)unsubscribe:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        int type = [arguments[@"type"] intValue];
        code = [engine unsubscribe:uid type:toMediaType(type)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)unsubscribes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSArray<NSString *> *ids = arguments[@"ids"];
        int type = [arguments[@"type"] intValue];
        code = [engine unsubscribeWithUserIds:ids type:toMediaType(type)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)unsubscribeLiveMix:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int type = [arguments[@"type"] intValue];
        code = [engine unsubscribeLiveMix:toMediaType(type)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setAudioConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSDictionary *config = arguments[@"config"];
        code = [engine setAudioConfig:toAudioConfig(config)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setVideoConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        bool tiny = [arguments[@"tiny"] boolValue];
        NSDictionary *config = arguments[@"config"];
        code = [engine setVideoConfig:toVideoConfig(config) tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)enableMicrophone:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        bool enable = [call.arguments boolValue];
        code = [engine enableMicrophone:enable];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)enableSpeaker:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        bool enable = [call.arguments boolValue];
        code = [engine enableSpeaker:enable];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)adjustLocalVolume:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int volume = [call.arguments intValue];
        code = [engine adjustLocalVolume:volume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)enableCamera:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        bool enable = [arguments[@"enable"] boolValue];
        id camera = arguments[@"camera"];
        if (![camera isEqual:[NSNull null]]) {
            code = [engine enableCamera:enable camera:toCamera([camera intValue])];
        } else {
            code = [engine enableCamera:enable];
        }
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)switchCamera:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine switchCamera];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

//- (void)switchToCamera:(FlutterMethodCall *)call result:(FlutterResult)result {
//    NSInteger code = -1;
//    if (engine != nil) {
//        NSDictionary *arguments = (NSDictionary *)call.arguments;
//
//    }
//    dispatch_to_main_queue(^{
//        result(@(code));
//    });
//}

- (void)whichCamera:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        RCRTCIWCamera camera = [engine whichCamera];
        code = (NSInteger) camera;
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)isCameraFocusSupported:(FlutterResult)result {
    bool code = false;
    if (engine != nil) {
        code = [engine isCameraFocusSupported];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)isCameraExposurePositionSupported:(FlutterResult)result {
    bool code = false;
    if (engine != nil) {
        code = [engine isCameraExposurePositionSupported];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setCameraFocusPositionInPreview:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        double x = [arguments[@"x"] doubleValue];
        double y = [arguments[@"y"] doubleValue];
        code = [engine setCameraFocusPositionInPreview:CGPointMake(x, y)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setCameraExposurePositionInPreview:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        double x = [arguments[@"x"] doubleValue];
        double y = [arguments[@"y"] doubleValue];
        code = [engine setCameraExposurePositionInPreview:CGPointMake(x, y)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setCameraCaptureOrientation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int orientation = [arguments[@"orientation"] intValue];
        code = [engine setCameraCaptureOrientation:toCameraCaptureOrientation(orientation)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLocalView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSInteger view = [arguments[@"view"] integerValue];
        RCRTCView *origin = [[RCRTCViewWrapper sharedInstance] getView:view];
        code = [engine setLocalViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *) [origin view]];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeLocalView:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine removeLocalView];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setRemoteView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        NSInteger view = [arguments[@"view"] integerValue];
        RCRTCView *origin = [[RCRTCViewWrapper sharedInstance] getView:view];
        code = [engine setRemoteViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *) [origin view] userId:uid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeRemoteView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *uid = (NSString *)call.arguments;
        code = [engine removeRemoteView:uid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSInteger view = [arguments[@"view"] integerValue];
        RCRTCView *origin = [[RCRTCViewWrapper sharedInstance] getView:view];
        code = [engine setLiveMixViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *) [origin view]];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeLiveMixView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine removeLiveMixView];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)muteLocalStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int type = [arguments[@"type"] intValue];
        bool mute = [arguments[@"mute"] boolValue];
        code = [engine muteLocalStream:toMediaType(type) mute:mute];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)muteRemoteStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        int type = [arguments[@"type"] intValue];
        bool mute = [arguments[@"mute"] boolValue];
        code = [engine muteRemoteStream:uid type:toMediaType(type) mute:mute];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)muteLiveMixStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int type = [arguments[@"type"] intValue];
        bool mute = [arguments[@"mute"] boolValue];
        code = [engine muteLiveMixStream:toMediaType(type) mute:mute];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)addLiveCdn:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *url = (NSString *)call.arguments;
        code = [engine addLiveCdn:url];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeLiveCdn:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *url = (NSString *)call.arguments;
        code = [engine removeLiveCdn:url];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixLayoutMode:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int mode = [call.arguments intValue];
        code = [engine setLiveMixLayoutMode:toLiveMixLayoutMode(mode)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixRenderMode:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int mode = [call.arguments intValue];
        code = [engine setLiveMixRenderMode:toLiveMixRenderMode(mode)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixBackgroundColor:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int red = [arguments[@"red"] intValue];
        int green = [arguments[@"green"] intValue];
        int blue = [arguments[@"blue"] intValue];
        code = [engine setLiveMixBackgroundColorWithRed:red
                                                  green:green
                                                   blue:blue];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixCustomAudios:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSArray<NSString *> *ids = arguments[@"ids"];
        code = [engine setLiveMixCustomAudios:ids];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixCustomLayouts:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSArray<NSDictionary *> *layouts = arguments[@"layouts"];
        code = [engine setLiveMixCustomLayouts:toLiveMixCustomLayouts(layouts)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixAudioBitrate:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int bitrate = [call.arguments intValue];
        code = [engine setLiveMixAudioBitrate:bitrate];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixVideoBitrate:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int bitrate = [arguments[@"bitrate"] intValue];
        bool tiny = [arguments[@"tiny"] boolValue];
        code = [engine setLiveMixVideoBitrate:bitrate tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixVideoResolution:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int width = [arguments[@"width"] intValue];
        int height = [arguments[@"height"] intValue];
        bool tiny = [arguments[@"tiny"] boolValue];
        code = [engine setLiveMixVideoResolution:width height:height tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixVideoFps:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int fps = [arguments[@"fps"] intValue];
        bool tiny = [arguments[@"tiny"] boolValue];
        code = [engine setLiveMixVideoFps:toVideoFps(fps) tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setStatsListener:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        bool remove = [call.arguments boolValue];
        if (remove) {
            engine.statsDelegate = nil;
        } else {
            engine.statsDelegate = self;
        }
        // TODO code?
        code = 0;
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (NSString *)getAssetsPath:(NSString *)assets {
    return [[NSBundle mainBundle] pathForResource:[registrar lookupKeyForAsset:assets] ofType:nil];
}

- (void)createAudioEffect:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *path = arguments[@"path"];
        NSString *assets = arguments[@"assets"];
        NSString *file = !path ? [self getAssetsPath:assets] : path;
        int eid = [arguments[@"id"] intValue];
        code = [engine createAudioEffect:[NSURL URLWithString:file] effectId:eid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)releaseAudioEffect:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int eid = [call.arguments intValue];
        code = [engine releaseAudioEffect:eid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)playAudioEffect:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int eid = [arguments[@"id"] intValue];
        int volume = [arguments[@"volume"] intValue];
        int loop = [arguments[@"loop"] intValue];
        code = [engine playAudioEffect:eid volume:volume loop:loop];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)pauseAudioEffect:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int eid = [call.arguments intValue];
        code = [engine pauseAudioEffect:eid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)pauseAllAudioEffects:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine pauseAllAudioEffects];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)resumeAudioEffect:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int eid = [call.arguments intValue];
        code = [engine resumeAudioEffect:eid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)resumeAllAudioEffects:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine resumeAllAudioEffects];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)stopAudioEffect:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int eid = [call.arguments intValue];
        code = [engine stopAudioEffect:eid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)stopAllAudioEffects:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine stopAllAudioEffects];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)adjustAudioEffectVolume:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int eid = [arguments[@"id"] intValue];
        int volume = [arguments[@"volume"] intValue];
        code = [engine adjustAudioEffect:eid volume:volume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)getAudioEffectVolume:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int eid = [call.arguments intValue];
        code = [engine getAudioEffectVolume:eid];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)adjustAllAudioEffectsVolume:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int volume = [call.arguments intValue];
        code = [engine adjustAllAudioEffectsVolume:volume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)startAudioMixing:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *path = arguments[@"path"];
        NSString *assets = arguments[@"assets"];
        NSString *file = !path ? [self getAssetsPath:assets] : path;
        int mode = [arguments[@"mode"] intValue];
        bool playback = [arguments[@"playback"] boolValue];
        int loop = [arguments[@"loop"] intValue];
        CGFloat position = [arguments[@"position"] floatValue];
        code = [engine startAudioMixing:[NSURL URLWithString:file]
                                   mode:toAudioMixingMode(mode)
                               playback:playback
                                   loop:loop
                               position:position];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)stopAudioMixing:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine stopAudioMixing];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)pauseAudioMixing:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine pauseAudioMixing];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)resumeAudioMixing:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine resumeAudioMixing];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)adjustAudioMixingVolume:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int volume = [call.arguments intValue];
        code = [engine adjustAudioMixingVolume:volume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)adjustAudioMixingPlaybackVolume:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int volume = [call.arguments intValue];
        code = [engine adjustAudioMixingPlaybackVolume:volume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)getAudioMixingPlaybackVolume:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine getAudioMixingPlaybackVolume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)adjustAudioMixingPublishVolume:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int volume = [call.arguments intValue];
        code = [engine adjustAudioMixingPublishVolume:volume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)getAudioMixingPublishVolume:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine getAudioMixingPublishVolume];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setAudioMixingPosition:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        double position = [call.arguments doubleValue];
        code = [engine setAudioMixingPosition:position];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)getAudioMixingPosition:(FlutterResult)result {
    CGFloat code = -1;
    if (engine != nil) {
        code = [engine getAudioMixingPosition];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)getAudioMixingDuration:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine getAudioMixingDuration];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)getSessionId:(FlutterResult)result {
    NSString *code = nil;
    if (engine != nil) {
        code = [engine getSessionId];
    }
    dispatch_to_main_queue(^{
        result(code);
    });
}

- (void)createCustomStreamFromFile:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *path = arguments[@"path"];
        NSString *assets = arguments[@"assets"];
        NSString *file = !path ? [self getAssetsPath:assets] : path;
        NSString *tag = arguments[@"tag"];
        bool replace = [arguments[@"replace"] boolValue];
        bool playback = [arguments[@"playback"] boolValue];
        code = [engine createCustomStreamFromFile:[NSURL URLWithString:file]
                                              tag:tag
                                          replace:replace
                                         playback:playback];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setCustomStreamVideoConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *tag = arguments[@"tag"];
        NSDictionary *config = arguments[@"config"];
        code = [engine setCustomStreamVideoConfig:toVideoConfig(config)
                                              tag:tag];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)muteLocalCustomStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *tag = arguments[@"tag"];
        bool mute = [arguments[@"mute"] boolValue];
        code = [engine muteLocalCustomStream:tag
                                        mute:mute];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLocalCustomStreamView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *tag = arguments[@"tag"];
        NSInteger view = [arguments[@"view"] integerValue];
        RCRTCView *origin = [[RCRTCViewWrapper sharedInstance] getView:view];
        code = [engine setLocalCustomStreamViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *) [origin view]
                                                            tag:tag];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeLocalCustomStreamView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *tag = (NSString *)call.arguments;
        code = [engine removeLocalCustomStreamView:tag];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)publishCustomStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *tag = (NSString *)call.arguments;
        code = [engine publishCustomStream:tag];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)unpublishCustomStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *tag = (NSString *)call.arguments;
        code = [engine unpublishCustomStream:tag];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)muteRemoteCustomStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        NSString *tag = arguments[@"tag"];
        int type = [arguments[@"type"] intValue];
        bool mute = [arguments[@"mute"] boolValue];
        code = [engine muteRemoteCustomStream:uid
                                          tag:tag
                                         type:toMediaType(type)
                                         mute:mute];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setRemoteCustomStreamView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        NSString *tag = arguments[@"tag"];
        NSInteger view = [arguments[@"view"] integerValue];
        RCRTCView *origin = [[RCRTCViewWrapper sharedInstance] getView:view];
        code = [engine setRemoteCustomStreamViewWithViewDelegate:(NSObject<RCRTCIWViewDelegate> *) [origin view]
                                                          userId:uid
                                                             tag:tag];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeRemoteCustomStreamView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        NSString *tag = arguments[@"tag"];
        code = [engine removeRemoteCustomStreamView:uid
                                                tag:tag];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)subscribeCustomStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        NSString *tag = arguments[@"tag"];
        int type = [arguments[@"type"] intValue];
        bool tiny = [arguments[@"tiy"] boolValue];
        code = [engine subscribeCustomStream:uid
                                         tag:tag
                                        type:toMediaType(type)
                                        tiny:tiny];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)unsubscribeCustomStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *uid = arguments[@"id"];
        NSString *tag = arguments[@"tag"];
        int type = [arguments[@"type"] intValue];
        code = [engine unsubscribeCustomStream:uid
                                           tag:tag
                                          type:toMediaType(type)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)requestJoinSubRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *rid = arguments[@"rid"];
        NSString *uid = arguments[@"uid"];
        bool autoLayout = [arguments[@"auto"] boolValue];
        NSString *extra = arguments[@"extra"];
        code = [engine requestJoinSubRoom:rid
                                   userId:uid
                               autoLayout:autoLayout
                                    extra:extra];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)cancelJoinSubRoomRequest:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *rid = arguments[@"rid"];
        NSString *uid = arguments[@"uid"];
        NSString *extra = arguments[@"extra"];
        code = [engine cancelJoinSubRoomRequest:rid
                                         userId:uid
                                          extra:extra];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)responseJoinSubRoomRequest:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *rid = arguments[@"rid"];
        NSString *uid = arguments[@"uid"];
        bool agree = [arguments[@"agree"] boolValue];
        bool autoLayout = [arguments[@"auto"] boolValue];
        NSString *extra = arguments[@"extra"];
        code = [engine responseJoinSubRoomRequest:rid
                                           userId:uid
                                            agree:agree
                                       autoLayout:autoLayout
                                            extra:extra];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)joinSubRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *argument = (NSString *)call.arguments;
        code = [engine joinSubRoom:argument];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)leaveSubRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *rid = arguments[@"id"];
        bool disband = [arguments[@"disband"] boolValue];
        code = [engine leaveSubRoom:rid
                            disband:disband];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)switchLiveRole:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        int role = [call.arguments intValue];
        code = [engine switchLiveRole:toRole(role)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)enableSei:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        bool enable = [call.arguments boolValue];
        code = [engine enableSei:enable];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)sendSei:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSString *sei = (NSString *)call.arguments;
        code = [engine sendSei:sei];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

#pragma mark - 内置 cdn

- (void)enableLiveMixInnerCdnStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        BOOL enable = [arguments[@"enable"] boolValue];
        code = [engine enableLiveMixInnerCdnStream:enable];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)subscribeLiveMixInnerCdnStream:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine subscribeLiveMixInnerCdnStream];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)unsubscribeLiveMixInnerCdnStream:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine unsubscribeLiveMixInnerCdnStream];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)muteLiveMixInnerCdnStream:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        BOOL mute = [arguments[@"mute"] boolValue];
        code = [engine muteLiveMixInnerCdnStream:mute];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLiveMixInnerCdnStreamView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSInteger view = [arguments[@"view"] integerValue];
        RCRTCView *origin = [[RCRTCViewWrapper sharedInstance] getView:view];
        code = [engine setLiveMixInnerCdnStreamViewDelegate:(NSObject<RCRTCIWViewDelegate> *) [origin view]];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeLiveMixInnerCdnStreamView:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine removeLiveMixInnerCdnStreamView];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLocalLiveMixInnerCdnVideoResolution:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSInteger width = [arguments[@"width"] integerValue];
        NSInteger height = [arguments[@"height"] integerValue];
        code = [engine setLocalLiveMixInnerCdnVideoResolution:width height:height];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setLocalLiveMixInnerCdnVideoFps:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int fps = [arguments[@"fps"] intValue];
        code = [engine setLocalLiveMixInnerCdnVideoFps:toVideoFps(fps)];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)startNetworkProbe:(FlutterResult)result  {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine startNetworkProbe:self];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)stopNetworkProbe:(FlutterResult)result  {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine stopNetworkProbe];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

#pragma mark - 水印

- (void)setWatermark:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *imagePath = arguments[@"imagePath"];
        NSDictionary *position = arguments[@"position"];
        CGPoint point = toCGPoint(position);
        CGFloat zoom = [arguments[@"zoom"] floatValue];
        if ([imagePath containsString:@"file://"]) {
            imagePath = [imagePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        }
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        code = [engine setWatermark:image position:point zoom:zoom];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)removeWatermark:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine removeWatermark];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)startEchoTest:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        NSInteger timeInterval = [call.arguments integerValue];
        code = [engine startEchoTest:timeInterval];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)stopEchoTest:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine stopEchoTest];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)preconnectToMediaServer:(FlutterResult)result {
    NSInteger code = -1;
    if (engine != nil) {
        code = [engine preconnectToMediaServer];
    }
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

#pragma mark *************** [C] ***************

- (void)onError:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onError" arguments:arguments];
    });
}

- (void)onKicked:(NSString *)roomId message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    if (roomId) {
        [arguments setObject:roomId forKey:@"id"];
    }
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onKicked" arguments:arguments];
    });
}

- (void)onRoomJoined:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRoomJoined" arguments:arguments];
    });
}

- (void)onRoomLeft:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRoomLeft" arguments:arguments];
    });
}

- (void)onPublished:(RCRTCIWMediaType)type code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onPublished" arguments:arguments];
    });
}

- (void)onUnpublished:(RCRTCIWMediaType)type code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUnpublished" arguments:arguments];
    });
}

- (void)onSubscribed:(NSString *)userId
           mediaType:(RCRTCIWMediaType)type
                code:(NSInteger)code
             message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSubscribed" arguments:arguments];
    });
}

- (void)onUnsubscribed:(NSString *)userId
             mediaType:(RCRTCIWMediaType)type
                  code:(NSInteger)code
               message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUnsubscribed" arguments:arguments];
    });
}

- (void)onLiveMixSubscribed:(RCRTCIWMediaType)type code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixSubscribed" arguments:arguments];
    });
}

- (void)onLiveMixUnsubscribed:(RCRTCIWMediaType)type code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixUnsubscribed" arguments:arguments];
    });
}

- (void)onCameraEnabled:(BOOL)enable code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(enable) forKey:@"enable"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCameraEnabled" arguments:arguments];
    });
}

- (void)onCameraSwitched:(RCRTCIWCamera)camera code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@((int) camera + 1) forKey:@"camera"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCameraSwitched" arguments:arguments];
    });
}

- (void)onLiveCdnAdded:(NSString *)url code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:url forKey:@"url"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveCdnAdded" arguments:arguments];
    });
}

- (void)onLiveCdnRemoved:(NSString *)url code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:url forKey:@"url"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveCdnRemoved" arguments:arguments];
    });
}

- (void)onLiveMixLayoutModeSet:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixLayoutModeSet" arguments:arguments];
    });
}

- (void)onLiveMixRenderModeSet:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixRenderModeSet" arguments:arguments];
    });
}

- (void)onLiveMixBackgroundColorSet:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixBackgroundColorSet" arguments:arguments];
    });
}

- (void)onLiveMixCustomAudiosSet:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixCustomAudiosSet" arguments:arguments];
    });
}

- (void)onLiveMixCustomLayoutsSet:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixCustomLayoutsSet" arguments:arguments];
    });
}

- (void)onLiveMixAudioBitrateSet:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixAudioBitrateSet" arguments:arguments];
    });
}

- (void)onLiveMixVideoBitrateSet:(BOOL)tiny
                            code:(NSInteger)code
                         message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(tiny) forKey:@"tiny"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixVideoBitrateSet" arguments:arguments];
    });
}

- (void)onLiveMixVideoResolutionSet:(BOOL)tiny
                               code:(NSInteger)code
                            message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(tiny) forKey:@"tiny"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixVideoResolutionSet" arguments:arguments];
    });
}

- (void)onLiveMixVideoFpsSet:(BOOL)tiny
                        code:(NSInteger)code
                     message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(tiny) forKey:@"tiny"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixVideoFpsSet" arguments:arguments];
    });
}

- (void)onAudioEffectCreated:(NSInteger)effectId code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(effectId) forKey:@"id"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onAudioEffectCreated" arguments:arguments];
    });
}

- (void)onAudioEffectFinished:(NSInteger)effectId {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onAudioEffectFinished" arguments:@(effectId)];
    });
}

- (void)onAudioMixingStarted {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onAudioMixingStarted" arguments:nil];
    });
}

- (void)onAudioMixingPaused {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onAudioMixingPaused" arguments:nil];
    });
}

- (void)onAudioMixingResume {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onAudioMixingStarted" arguments:nil];
    });
}

- (void)onAudioMixingStopped {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onAudioMixingStopped" arguments:nil];
    });
}

- (void)onAudioMixingFinished {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onAudioMixingFinished" arguments:nil];
    });
}

- (void)onUserJoined:(NSString *)roomId
              userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUserJoined" arguments:arguments];
    });
}

- (void)onUserOffline:(NSString *)roomId
               userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUserOffline" arguments:arguments];
    });
}

- (void)onUserLeft:(NSString *)roomId
            userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUserLeft" arguments:arguments];
    });
}

- (void)onRemotePublished:(NSString *)roomId
                   userId:(NSString *)userId
                mediaType:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@((int) type) forKey:@"type"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemotePublished" arguments:arguments];
    });
}

- (void)onRemoteUnpublished:(NSString *)roomId
                     userId:(NSString *)userId
                  mediaType:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@((int) type) forKey:@"type"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteUnpublished" arguments:arguments];
    });
}

- (void)onRemoteLiveMixPublished:(RCRTCIWMediaType)type {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteLiveMixPublished" arguments:@((int) type)];
    });
}

- (void)onRemoteLiveMixUnpublished:(RCRTCIWMediaType)type {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteLiveMixUnpublished" arguments:@((int) type)];
    });
}

- (void)onRemoteStateChanged:(NSString *)roomId
                      userId:(NSString *)userId
                        type:(RCRTCIWMediaType)type
                    disabled:(BOOL)disabled {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(disabled) forKey:@"disabled"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteStateChanged" arguments:arguments];
    });
}

- (void)onRemoteFirstFrame:(NSString *)roomId
                    userId:(NSString *)userId
                      type:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@((int) type) forKey:@"type"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteFirstFrame" arguments:arguments];
    });
}

- (void)onRemoteLiveMixFirstFrame:(RCRTCIWMediaType)type {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteLiveMixFirstFrame" arguments:@((int) type)];
    });
}

// - (void)onMessageReceived:(NSString *)roomId
//                   message:(RCMessage *)message {
//     // NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
//     // [arguments setObject:roomId forKey:@"id"];
//     // [arguments setObject:[RCFlutterMessageFactory message2String:message] forKey:@"message"];
//     // __weak typeof (channel) weak = channel;
//     // dispatch_to_main_queue(^{
//     //    typeof (weak) strong = weak;
//     //    [strong invokeMethod:@"engine:onRemoteLiveMixFirstFrame" arguments:arguments];
//     // });
// }

- (void)onCustomStreamPublished:(NSString *)tag
                           code:(NSInteger)code
                        message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCustomStreamPublished" arguments:arguments];
    });
}

- (void)onCustomStreamUnpublished:(NSString *)tag
                             code:(NSInteger)code
                          message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCustomStreamUnpublished" arguments:arguments];
    });
}

- (void)onCustomStreamPublishFinished:(NSString *)tag {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCustomStreamPublishFinished" arguments:tag];
    });
}

- (void)onRemoteCustomStreamPublished:(NSString *)roomId
                               userId:(NSString *)userId
                                  tag:(NSString *)tag
                                 type:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@((int) type) forKey:@"type"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamPublished" arguments:arguments];
    });
}

- (void)onRemoteCustomStreamUnpublished:(NSString *)roomId
                                 userId:(NSString *)userId
                                    tag:(NSString *)tag
                                   type:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@((int) type) forKey:@"type"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamUnpublished" arguments:arguments];
    });
}

- (void)onRemoteCustomStreamStateChanged:(NSString *)roomId
                                  userId:(NSString *)userId
                                     tag:(NSString *)tag
                                    type:(RCRTCIWMediaType)type
                                disabled:(BOOL)disabled {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(disabled) forKey:@"disabled"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamStateChanged" arguments:arguments];
    });
}

- (void)onRemoteCustomStreamFirstFrame:(NSString *)roomId
                                userId:(NSString *)userId
                                   tag:(NSString *)tag
                                  type:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@((int) type) forKey:@"type"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamFirstFrame" arguments:arguments];
    });
}

- (void)onCustomStreamSubscribed:(NSString *)userId
                             tag:(NSString *)tag
                            type:(RCRTCIWMediaType)type
                            code:(NSInteger)code
                         message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCustomStreamSubscribed" arguments:arguments];
    });
}

- (void)onCustomStreamUnsubscribed:(NSString *)userId
                               tag:(NSString *)tag
                              type:(RCRTCIWMediaType)type
                              code:(NSInteger)code
                           message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCustomStreamUnsubscribed" arguments:arguments];
    });
}

- (void)onJoinSubRoomRequested:(NSString *)roomId
                        userId:(NSString *)userId
                          code:(NSInteger)code
                       message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onJoinSubRoomRequested" arguments:arguments];
    });
}

- (void)onJoinSubRoomRequestCanceled:(NSString *)roomId
                              userId:(NSString *)userId
                                code:(NSInteger)code
                             message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onJoinSubRoomRequestCanceled" arguments:arguments];
    });
}

- (void)onJoinSubRoomRequestResponded:(NSString *)roomId
                               userId:(NSString *)userId
                                agree:(BOOL)agree
                                 code:(NSInteger)code
                              message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@(agree) forKey:@"agree"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onJoinSubRoomRequestResponded" arguments:arguments];
    });
}

- (void)onJoinSubRoomRequestReceived:(NSString *)roomId
                              userId:(NSString *)userId
                               extra:(NSString *)extra {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    if (extra) {
        [arguments setObject:extra forKey:@"extra"];
    }
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onJoinSubRoomRequestReceived" arguments:arguments];
    });
}

- (void)onCancelJoinSubRoomRequestReceived:(NSString *)roomId
                                    userId:(NSString *)userId
                                     extra:(NSString *)extra {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    if (extra) {
        [arguments setObject:extra forKey:@"extra"];
    }
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCancelJoinSubRoomRequestReceived" arguments:arguments];
    });
}

- (void)onJoinSubRoomRequestResponseReceived:(NSString *)roomId
                                      userId:(NSString *)userId
                                       agree:(BOOL)agree
                                       extra:(NSString *)extra {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@(agree) forKey:@"agree"];
    if (extra) {
        [arguments setObject:extra forKey:@"extra"];
    }
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onJoinSubRoomRequestResponseReceived" arguments:arguments];
    });
}

- (void)onSubRoomJoined:(NSString *)roomId
                   code:(NSInteger)code
                message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"id"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSubRoomJoined" arguments:arguments];
    });
}

- (void)onSubRoomLeft:(NSString *)roomId
                 code:(NSInteger)code
              message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"id"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSubRoomLeft" arguments:arguments];
    });
}

- (void)onSubRoomBanded:(NSString *)roomId {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSubRoomBanded" arguments:roomId];
    });
}

- (void)onSubRoomDisband:(NSString *)roomId
                  userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSubRoomDisband" arguments:arguments];
    });
}

- (void)onLiveRoleSwitched:(RCRTCIWRole)current code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(current) forKey:@"role"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveRoleSwitched" arguments:arguments];
    });
}

- (void)onRemoteLiveRoleSwitched:(NSString *)roomId userId:(NSString *)userId role:(RCRTCIWRole)role {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:@(role) forKey:@"role"];
    __weak __typeof(channel) weak = channel;
    dispatch_to_main_queue(^{
        __strong __typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteLiveRoleSwitched" arguments:arguments];
    });
}

- (void)onLiveMixInnerCdnStreamEnabled:(BOOL)enable code:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(enable) forKey:@"enable"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixInnerCdnStreamEnabled" arguments:arguments];
    });
}

- (void)onRemoteLiveMixInnerCdnStreamPublished {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteLiveMixInnerCdnStreamPublished" arguments:nil];
    });
}

- (void)onRemoteLiveMixInnerCdnStreamUnpublished {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteLiveMixInnerCdnStreamUnpublished" arguments:nil];
    });
}

- (void)onLiveMixInnerCdnStreamSubscribed:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixInnerCdnStreamSubscribed" arguments:arguments];
    });
}

- (void)onLiveMixInnerCdnStreamUnsubscribed:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixInnerCdnStreamUnsubscribed" arguments:arguments];
    });
}

- (void)onLocalLiveMixInnerCdnVideoResolutionSet:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLocalLiveMixInnerCdnVideoResolutionSet" arguments:arguments];
    });
}

- (void)onLocalLiveMixInnerCdnVideoFpsSet:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLocalLiveMixInnerCdnVideoFpsSet" arguments:arguments];
    });
}

- (void)onWatermarkSet:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onWatermarkSet" arguments:arguments];
    });
}

- (void)onWatermarkRemoved:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onWatermarkRemoved" arguments:arguments];
    });
}

- (void)onNetworkProbeStarted:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onNetworkProbeStarted" arguments:arguments];
    });
}

- (void)onNetworkProbeStopped:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onNetworkProbeStopped" arguments:arguments];
    });
}

- (void)onSeiEnabled:(BOOL)enable code:(NSInteger)code errMsg:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(enable) forKey:@"enable"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSeiEnabled" arguments:arguments];
    });
}

- (void)onSeiReceived:(NSString *)roomId userId:(NSString *)userId sei:(NSString *)sei{
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:sei forKey:@"sei"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSeiReceived" arguments:arguments];
    });
}

- (void)onLiveMixSeiReceived:(NSString *)sei {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onLiveMixSeiReceived" arguments:sei];
    });
}

- (void)onNetworkStats:(RCRTCIWNetworkStats *)stats {
    NSDictionary *argument = fromNetworkStats(stats);
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onNetworkStats" arguments:argument];
    });
}

- (void)onLocalAudioStats:(RCRTCIWLocalAudioStats *)stats {
    NSDictionary *argument = fromLocalAudioStats(stats);
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLocalAudioStats" arguments:argument];
    });
}

- (void)onLocalVideoStats:(RCRTCIWLocalVideoStats *)stats {
    NSDictionary *argument = fromLocalVideoStats(stats);
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLocalVideoStats" arguments:argument];
    });
}

- (void)onRemoteAudioStats:(RCRTCIWRemoteAudioStats *)stats
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:fromRemoteAudioStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onRemoteAudioStats" arguments:arguments];
    });
}

- (void)onRemoteVideoStats:(RCRTCIWRemoteVideoStats *)stats
                    roomId:(NSString *)roomId
                    userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:fromRemoteVideoStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onRemoteVideoStats" arguments:arguments];
    });
}

- (void)onLiveMixAudioStats:(RCRTCIWRemoteAudioStats *)stats {
    NSDictionary *argument = fromRemoteAudioStats(stats);
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLiveMixAudioStats" arguments:argument];
    });
}

- (void)onLiveMixVideoStats:(RCRTCIWRemoteVideoStats *)stats {
    NSDictionary *argument = fromRemoteVideoStats(stats);
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLiveMixVideoStats" arguments:argument];
    });
}

- (void)onLiveMixMemberAudioStats:(NSString *)userId
                           volume:(NSInteger)volume {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:@(volume) forKey:@"volume"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLiveMixMemberAudioStats" arguments:arguments];
    });
}

- (void)onLiveMixMemberCustomAudioStats:(NSString *)userId
                                    tag:(NSString *)tag
                                 volume:(NSInteger)volume {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@(volume) forKey:@"volume"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLiveMixMemberCustomAudioStats" arguments:arguments];
    });
}

- (void)onLocalCustomAudioStats:(RCRTCIWLocalAudioStats *)stats
                            tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:fromLocalAudioStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLocalCustomAudioStats" arguments:arguments];
    });
}

- (void)onLocalCustomVideoStats:(RCRTCIWLocalVideoStats *)stats
                            tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:fromLocalVideoStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onLocalCustomVideoStats" arguments:arguments];
    });
}

- (void)onRemoteCustomAudioStats:(RCRTCIWRemoteAudioStats *)stats
                          roomId:(NSString *)roomId
                          userId:(NSString *)userId
                             tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:fromRemoteAudioStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onRemoteCustomAudioStats" arguments:arguments];
    });
}

- (void)onRemoteCustomVideoStats:(RCRTCIWRemoteVideoStats *)stats
                          roomId:(NSString *)roomId
                          userId:(NSString *)userId
                             tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:roomId forKey:@"rid"];
    [arguments setObject:userId forKey:@"uid"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:fromRemoteVideoStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onRemoteCustomVideoStats" arguments:arguments];
    });
}

- (void)onNetworkProbeFinished:(NSInteger)code errMsg:(nonnull NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onNetworkProbeFinished" arguments:arguments];
    });
}

- (void)onNetworkProbeDownLinkStats:(RCRTCIWNetworkProbeStats *)stats {
    NSDictionary *argument = fromNetworkProbeStats(stats);
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onNetworkProbeDownLinkStats" arguments:argument];
    });
}


- (void)onNetworkProbeUpLinkStats:(RCRTCIWNetworkProbeStats *)stats {
    NSDictionary *argument = fromNetworkProbeStats(stats);
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onNetworkProbeUpLinkStats" arguments:argument];
    });
}


#pragma mark *************** [F] ***************

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [[RCRTCEngineWrapper sharedInstance] initWithRegistrar:registrar];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [self unInit];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString* method = [call method];
    if ([method isEqualToString:@"create"]) {
        [self create:call result:result];
    } else if ([method isEqualToString:@"destroy"]) {
        [self destroy:result];
    } else if ([method isEqualToString:@"joinRoom"]) {
        [self joinRoom:call result:result];
    } else if ([method isEqualToString:@"leaveRoom"]) {
        [self leaveRoom:result];
    } else if ([method isEqualToString:@"publish"]) {
        [self publish:call result:result];
    } else if ([method isEqualToString:@"unpublish"]) {
        [self unpublish:call result:result];
    } else if ([method isEqualToString:@"subscribe"]) {
        [self subscribe:call result:result];
    } else if ([method isEqualToString:@"subscribes"]) {
        [self subscribes:call result:result];
    } else if ([method isEqualToString:@"subscribeLiveMix"]) {
        [self subscribeLiveMix:call result:result];
    } else if ([method isEqualToString:@"unsubscribe"]) {
        [self unsubscribe:call result:result];
    } else if ([method isEqualToString:@"unsubscribes"]) {
        [self unsubscribes:call result:result];
    } else if ([method isEqualToString:@"unsubscribeLiveMix"]) {
        [self unsubscribeLiveMix:call result:result];
    } else if ([method isEqualToString:@"setAudioConfig"]) {
        [self setAudioConfig:call result:result];
    } else if ([method isEqualToString:@"setVideoConfig"]) {
        [self setVideoConfig:call result:result];
    } else if ([method isEqualToString:@"enableMicrophone"]) {
        [self enableMicrophone:call result:result];
    } else if ([method isEqualToString:@"enableSpeaker"]) {
        [self enableSpeaker:call result:result];
    } else if ([method isEqualToString:@"adjustLocalVolume"]) {
        [self adjustLocalVolume:call result:result];
    } else if ([method isEqualToString:@"enableCamera"]) {
        [self enableCamera:call result:result];
    } else if ([method isEqualToString:@"switchCamera"]) {
        [self switchCamera:result];
    }
//    else if ([method isEqualToString:@"switchToCamera"]) {
//        [self switchToCamera:call result:result];
//    }
    else if ([method isEqualToString:@"whichCamera"]) {
        [self whichCamera:result];
    } else if ([method isEqualToString:@"isCameraFocusSupported"]) {
        [self isCameraFocusSupported:result];
    } else if ([method isEqualToString:@"isCameraExposurePositionSupported"]) {
        [self isCameraExposurePositionSupported:result];
    } else if ([method isEqualToString:@"setCameraFocusPositionInPreview"]) {
        [self setCameraFocusPositionInPreview:call result:result];
    } else if ([method isEqualToString:@"setCameraExposurePositionInPreview"]) {
        [self setCameraExposurePositionInPreview:call result:result];
    } else if ([method isEqualToString:@"setCameraCaptureOrientation"]) {
        [self setCameraCaptureOrientation:call result:result];
    } else if ([method isEqualToString:@"setLocalView"]) {
        [self setLocalView:call result:result];
    } else if ([method isEqualToString:@"removeLocalView"]) {
        [self removeLocalView:result];
    } else if ([method isEqualToString:@"setRemoteView"]) {
        [self setRemoteView:call result:result];
    } else if ([method isEqualToString:@"removeRemoteView"]) {
        [self removeRemoteView:call result:result];
    } else if ([method isEqualToString:@"setLiveMixView"]) {
        [self setLiveMixView:call result:result];
    } else if ([method isEqualToString:@"removeLiveMixView"]) {
        [self removeLiveMixView:call result:result];
    } else if ([method isEqualToString:@"muteLocalStream"]) {
        [self muteLocalStream:call result:result];
    } else if ([method isEqualToString:@"muteRemoteStream"]) {
        [self muteRemoteStream:call result:result];
    } else if ([method isEqualToString:@"muteLiveMixStream"]) {
        [self muteLiveMixStream:call result:result];
    } else if ([method isEqualToString:@"addLiveCdn"]) {
        [self addLiveCdn:call result:result];
    } else if ([method isEqualToString:@"removeLiveCdn"]) {
        [self removeLiveCdn:call result:result];
    } else if ([method isEqualToString:@"setLiveMixLayoutMode"]) {
        [self setLiveMixLayoutMode:call result:result];
    } else if ([method isEqualToString:@"setLiveMixRenderMode"]) {
        [self setLiveMixRenderMode:call result:result];
    } else if ([method isEqualToString:@"setLiveMixBackgroundColor"]) {
        [self setLiveMixBackgroundColor:call result:result];
    } else if ([method isEqualToString:@"setLiveMixCustomAudios"]) {
        [self setLiveMixCustomAudios:call result:result];
    } else if ([method isEqualToString:@"setLiveMixCustomLayouts"]) {
        [self setLiveMixCustomLayouts:call result:result];
    } else if ([method isEqualToString:@"setLiveMixAudioBitrate"]) {
        [self setLiveMixAudioBitrate:call result:result];
    } else if ([method isEqualToString:@"setLiveMixVideoBitrate"]) {
        [self setLiveMixVideoBitrate:call result:result];
    } else if ([method isEqualToString:@"setLiveMixVideoResolution"]) {
        [self setLiveMixVideoResolution:call result:result];
    } else if ([method isEqualToString:@"setLiveMixVideoFps"]) {
        [self setLiveMixVideoFps:call result:result];
    } else if ([method isEqualToString:@"setStatsListener"]) {
        [self setStatsListener:call result:result];
    } else if ([method isEqualToString:@"createAudioEffect"]) {
        [self createAudioEffect:call result:result];
    } else if ([method isEqualToString:@"releaseAudioEffect"]) {
        [self releaseAudioEffect:call result:result];
    } else if ([method isEqualToString:@"playAudioEffect"]) {
        [self playAudioEffect:call result:result];
    } else if ([method isEqualToString:@"pauseAudioEffect"]) {
        [self pauseAudioEffect:call result:result];
    } else if ([method isEqualToString:@"pauseAllAudioEffects"]) {
        [self pauseAllAudioEffects:result];
    } else if ([method isEqualToString:@"resumeAudioEffect"]) {
        [self resumeAudioEffect:call result:result];
    } else if ([method isEqualToString:@"resumeAllAudioEffects"]) {
        [self resumeAllAudioEffects:result];
    } else if ([method isEqualToString:@"stopAudioEffect"]) {
        [self stopAudioEffect:call result:result];
    } else if ([method isEqualToString:@"stopAllAudioEffects"]) {
        [self stopAllAudioEffects:result];
    } else if ([method isEqualToString:@"adjustAudioEffectVolume"]) {
        [self adjustAudioEffectVolume:call result:result];
    } else if ([method isEqualToString:@"getAudioEffectVolume"]) {
        [self getAudioEffectVolume:call result:result];
    } else if ([method isEqualToString:@"adjustAllAudioEffectsVolume"]) {
        [self adjustAllAudioEffectsVolume:call result:result];
    } else if ([method isEqualToString:@"startAudioMixing"]) {
        [self startAudioMixing:call result:result];
    } else if ([method isEqualToString:@"stopAudioMixing"]) {
        [self stopAudioMixing:result];
    } else if ([method isEqualToString:@"pauseAudioMixing"]) {
        [self pauseAudioMixing:result];
    } else if ([method isEqualToString:@"resumeAudioMixing"]) {
        [self resumeAudioMixing:result];
    } else if ([method isEqualToString:@"adjustAudioMixingVolume"]) {
        [self adjustAudioMixingVolume:call result:result];
    } else if ([method isEqualToString:@"adjustAudioMixingPlaybackVolume"]) {
        [self adjustAudioMixingPlaybackVolume:call result:result];
    } else if ([method isEqualToString:@"getAudioMixingPlaybackVolume"]) {
        [self getAudioMixingPlaybackVolume:result];
    } else if ([method isEqualToString:@"adjustAudioMixingPublishVolume"]) {
        [self adjustAudioMixingPublishVolume:call result:result];
    } else if ([method isEqualToString:@"getAudioMixingPublishVolume"]) {
        [self getAudioMixingPublishVolume:result];
    } else if ([method isEqualToString:@"setAudioMixingPosition"]) {
        [self setAudioMixingPosition:call result:result];
    } else if ([method isEqualToString:@"getAudioMixingPosition"]) {
        [self getAudioMixingPosition:result];
    } else if ([method isEqualToString:@"getAudioMixingDuration"]) {
        [self getAudioMixingDuration:result];
    } else if ([method isEqualToString:@"getSessionId"]) {
        [self getSessionId:result];
    } else if ([method isEqualToString:@"createCustomStreamFromFile"]) {
        [self createCustomStreamFromFile:call result:result];
    } else if ([method isEqualToString:@"setCustomStreamVideoConfig"]) {
        [self setCustomStreamVideoConfig:call result:result];
    } else if ([method isEqualToString:@"muteLocalCustomStream"]) {
        [self muteLocalCustomStream:call result:result];
    } else if ([method isEqualToString:@"setLocalCustomStreamView"]) {
        [self setLocalCustomStreamView:call result:result];
    } else if ([method isEqualToString:@"removeLocalCustomStreamView"]) {
        [self removeLocalCustomStreamView:call result:result];
    } else if ([method isEqualToString:@"publishCustomStream"]) {
        [self publishCustomStream:call result:result];
    } else if ([method isEqualToString:@"unpublishCustomStream"]) {
        [self unpublishCustomStream:call result:result];
    } else if ([method isEqualToString:@"muteRemoteCustomStream"]) {
        [self muteRemoteCustomStream:call result:result];
    } else if ([method isEqualToString:@"setRemoteCustomStreamView"]) {
        [self setRemoteCustomStreamView:call result:result];
    } else if ([method isEqualToString:@"removeRemoteCustomStreamView"]) {
        [self removeRemoteCustomStreamView:call result:result];
    } else if ([method isEqualToString:@"subscribeCustomStream"]) {
        [self subscribeCustomStream:call result:result];
    } else if ([method isEqualToString:@"unsubscribeCustomStream"]) {
        [self unsubscribeCustomStream:call result:result];
    } else if ([method isEqualToString:@"requestJoinSubRoom"]) {
        [self requestJoinSubRoom:call result:result];
    } else if ([method isEqualToString:@"cancelJoinSubRoomRequest"]) {
        [self cancelJoinSubRoomRequest:call result:result];
    } else if ([method isEqualToString:@"responseJoinSubRoomRequest"]) {
        [self responseJoinSubRoomRequest:call result:result];
    } else if ([method isEqualToString:@"joinSubRoom"]) {
        [self joinSubRoom:call result:result];
    } else if ([method isEqualToString:@"leaveSubRoom"]) {
        [self leaveSubRoom:call result:result];
    } else if ([method isEqualToString:@"switchLiveRole"]) {
        [self switchLiveRole:call result:result];
    } else if ([method isEqualToString:@"enableSei"]) {
        [self enableSei:call result:result];
    } else if ([method isEqualToString:@"sendSei"]) {
        [self sendSei:call result:result];
    } else if ([method isEqualToString:@"preconnectToMediaServer"]) {
        [self preconnectToMediaServer:result];
    } else if ([method isEqualToString:@"enableLiveMixInnerCdnStream"]) {
        [self enableLiveMixInnerCdnStream:call result:result];
    } else if ([method isEqualToString:@"subscribeLiveMixInnerCdnStream"]) {
        [self subscribeLiveMixInnerCdnStream:result];
    } else if ([method isEqualToString:@"unsubscribeLiveMixInnerCdnStream"]) {
        [self unsubscribeLiveMixInnerCdnStream:result];
    } else if ([method isEqualToString:@"muteLiveMixInnerCdnStream"]) {
        [self muteLiveMixInnerCdnStream:call result:result];
    } else if ([method isEqualToString:@"setLiveMixInnerCdnStreamView"]) {
        [self setLiveMixInnerCdnStreamView:call result:result];
    } else if ([method isEqualToString:@"removeLiveMixInnerCdnStreamView"]) {
        [self removeLiveMixInnerCdnStreamView:result];
    } else if ([method isEqualToString:@"setLocalLiveMixInnerCdnVideoResolution"]) {
        [self setLocalLiveMixInnerCdnVideoResolution:call result:result];
    } else if ([method isEqualToString:@"setLocalLiveMixInnerCdnVideoFps"]) {
        [self setLocalLiveMixInnerCdnVideoFps:call result:result];
    } else if ([method isEqualToString:@"startNetworkProbe"]) {
        [self startNetworkProbe:result];
    } else if ([method isEqualToString:@"stopNetworkProbe"]) {
        [self stopNetworkProbe:result];
    } else if ([method isEqualToString:@"setWatermark"]) {
        [self setWatermark:call result:result];
    } else if ([method isEqualToString:@"removeWatermark"]) {
        [self removeWatermark:result];
    } else if ([method isEqualToString:@"startEchoTest"]) {
        [self startEchoTest:call result:result];
    } else if ([method isEqualToString:@"stopEchoTest"]) {
        [self stopEchoTest:result];
    }  else {
        dispatch_to_main_queue(^{
            result(FlutterMethodNotImplemented);
        });
    }
}

@end
