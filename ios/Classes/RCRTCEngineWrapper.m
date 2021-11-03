//
//  RCRTCEngineWrapper.m
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/11.
//

#import "RCRTCEngineWrapper.h"

#import <RongIMLib/RongIMLib.h>

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
@end

@interface RCFlutterMessageFactory
+ (NSString *)message2String:(RCMessage *)message;
@end

@interface RCRTCEngineWrapper() <RCRTCIWEngineDelegate, RCRTCIWStatsDelegate> {
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
        if (call.arguments != nil) {
            NSDictionary *arguments = (NSDictionary *)call.arguments;
            NSDictionary *setup = arguments[@"setup"];
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
        code = [engine startAudioMixing:[NSURL fileURLWithPath:file]
                                   mode:toAudioMixingMode(mode)
                               playback:playback
                                   loop:loop];
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
        bool mute = [arguments[@"mute"] boolValue];
        code = [engine muteRemoteCustomStream:uid
                                          tag:tag
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
        code = [engine subscribeCustomStream:uid
                                         tag:tag];
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
        code = [engine unsubscribeCustomStream:uid
                                           tag:tag];
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

- (void)onEnableCamera:(BOOL)enable code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@(enable) forKey:@"enable"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onEnableCamera" arguments:arguments];
    });
}

- (void)onSwitchCamera:(RCRTCIWCamera)camera code:(NSInteger)code message:(NSString *)errMsg {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:@((int) camera + 1) forKey:@"camera"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:errMsg forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onSwitchCamera" arguments:arguments];
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

- (void)onUserJoined:(NSString *)userId {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUserJoined" arguments:userId];
    });
}

- (void)onUserOffline:(NSString *)userId {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUserOffline" arguments:userId];
    });
}

- (void)onUserLeft:(NSString *)userId {
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onUserLeft" arguments:userId];
    });
}

- (void)onRemotePublished:(NSString *)userId mediaType:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:@((int) type) forKey:@"type"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemotePublished" arguments:arguments];
    });
}

- (void)onRemoteUnpublished:(NSString *)userId mediaType:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
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

- (void)onRemoteStateChanged:(NSString *)userId type:(RCRTCIWMediaType)type disabled:(BOOL)disabled {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:@((int) type) forKey:@"type"];
    [arguments setObject:@(disabled) forKey:@"disabled"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteStateChanged" arguments:arguments];
    });
}

- (void)onRemoteFirstFrame:(NSString *)userId type:(RCRTCIWMediaType)type {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
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

- (void)onMessageReceived:(RCMessage *)message {
    NSString *argument = [RCFlutterMessageFactory message2String:message];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteLiveMixFirstFrame" arguments:argument];
    });
}

- (void)onCustomStreamPublished:(NSString *)tag
                           code:(int)code
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
                             code:(int)code
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

- (void)onRemoteCustomStreamPublished:(NSString *)userId
                                  tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamPublished" arguments:arguments];
    });
}

- (void)onRemoteCustomStreamUnpublished:(NSString *)userId
                                    tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamUnpublished" arguments:arguments];
    });
}

- (void)onRemoteCustomStreamStateChanged:(NSString *)userId
                                     tag:(NSString *)tag
                                disabled:(BOOL)disabled {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@(disabled) forKey:@"disabled"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamStateChanged" arguments:arguments];
    });
}

- (void)onRemoteCustomStreamFirstFrame:(NSString *)userId
                                   tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onRemoteCustomStreamFirstFrame" arguments:arguments];
    });
}

- (void)onCustomStreamSubscribed:(NSString *)userId
                             tag:(NSString *)tag
                            code:(int)code
                         message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
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
                              code:(int)code
                           message:(NSString *)message {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:@(code) forKey:@"code"];
    [arguments setObject:message forKey:@"message"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"engine:onCustomStreamUnsubscribed" arguments:arguments];
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
                    userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:fromRemoteAudioStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onRemoteAudioStats" arguments:arguments];
    });
}

- (void)onRemoteVideoStats:(RCRTCIWRemoteVideoStats *)stats
                    userId:(NSString *)userId {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
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
                          userId:(NSString *)userId
                             tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:fromRemoteAudioStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onRemoteCustomAudioStats" arguments:arguments];
    });
}

- (void)onRemoteCustomVideoStats:(RCRTCIWRemoteVideoStats *)stats
                          userId:(NSString *)userId
                             tag:(NSString *)tag {
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:userId forKey:@"id"];
    [arguments setObject:tag forKey:@"tag"];
    [arguments setObject:fromRemoteVideoStats(stats) forKey:@"stats"];
    __weak typeof (channel) weak = channel;
    dispatch_to_main_queue(^{
        typeof (weak) strong = weak;
        [strong invokeMethod:@"stats:onRemoteCustomVideoStats" arguments:arguments];
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
    } else if ([method isEqualToString:@"addLiveCdn"]) {
        [self addLiveCdn:call result:result];
    } else if ([method isEqualToString:@"removeLiveCdn"]) {
        [self removeLiveCdn:call result:result];
    } else if ([method isEqualToString:@"setLiveMixLayoutMode"]) {
        [self setLiveMixLayoutMode:call result:result];
    } else if ([method isEqualToString:@"setLiveMixRenderMode"]) {
        [self setLiveMixRenderMode:call result:result];
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
    } else {
        dispatch_to_main_queue(^{
            result(FlutterMethodNotImplemented);
        });
    }
}

@end
