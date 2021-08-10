//
//  RCRTCViewWrapper.m
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/15.
//

#import "RCRTCViewWrapper.h"

#import <RongRTCLib/RongRTCLib.h>

#import "MainThreadPoster.h"

@interface RCRTCIWFlutterView

+ (RCRTCIWFlutterView *)create;

- (void)destroy;

@end

#pragma mark *************** [RCRTCView] ***************

@interface RCRTCView() <FlutterTexture, FlutterStreamHandler, RCRTCVideoTextureViewDelegate> {
    NSObject<FlutterTextureRegistry> *registry;
    NSInteger tid;
    FlutterEventChannel *channel;
    RCRTCIWFlutterView *view;
    FlutterEventSink sink;
    
    int rotation;
    int width;
    int height;
}

@end

@implementation RCRTCView

- (instancetype)initWithTextureRegistry:(NSObject<FlutterTextureRegistry> *)registry
                              messenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        self->registry = registry;
        tid = [registry registerTexture:self];
        channel = [FlutterEventChannel eventChannelWithName:[NSString stringWithFormat:@"cn.rongcloud.rtc.flutter/view:%ld", tid]
                                            binaryMessenger:messenger];
        [channel setStreamHandler:self];
        view = [RCRTCIWFlutterView create];
        RCRTCVideoTextureView *view = (RCRTCVideoTextureView *) self.view;
        view.delegate = self;
        
        rotation = -1;
        width = 0;
        height = 0;
    }
    return self;
}

- (NSInteger)textureId {
    return tid;
}

- (RCRTCIWFlutterView *)view {
    return self->view;
}

- (void)destroy {
    RCRTCVideoTextureView *view = (RCRTCVideoTextureView *) self->view;
    view.delegate = nil;
    [self->view destroy];
    [channel setStreamHandler:nil];
    [registry unregisterTexture:tid];
    registry = nil;
}

- (CVPixelBufferRef)copyPixelBuffer {
    RCRTCVideoTextureView *view = (RCRTCVideoTextureView *) self.view;
    CVPixelBufferRef pixelBufferRef = [view pixelBufferRef];
    if (pixelBufferRef != nil) {
        CVBufferRetain(pixelBufferRef);
    }
    return pixelBufferRef;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    sink = nil;
    return nil;
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    sink = events;
    return nil;
}

- (void)firstFrameRendered {
    if (sink != nil) {
        __weak typeof (sink) weak = sink;
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        [arguments setObject:@"onFirstFrame" forKey:@"event"];
        dispatch_to_main_queue(^{
            typeof (weak) strong = weak;
            if (strong != nil) {
                strong(arguments);
            }
        });
    }
}

- (void)changeRotation:(int)rotation {
    if (self->rotation != rotation && sink != nil) {
        __weak typeof (sink) weak = sink;
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        [arguments setObject:@"onRotationChanged" forKey:@"event"];
        [arguments setObject:@(rotation) forKey:@"rotation"];
        self->rotation = rotation;
        dispatch_to_main_queue(^{
            typeof (weak) strong = weak;
            if (strong != nil) {
                strong(arguments);
            }
        });
    }
}

- (void)changeSize:(int)width height:(int)height {
    if ((self->width != width || self->height != height) && sink != nil) {
        __weak typeof (sink) weak = sink;
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        [arguments setObject:@"onSizeChanged" forKey:@"event"];
        [arguments setObject:@(width) forKey:@"width"];
        [arguments setObject:@(height) forKey:@"height"];
        [arguments setObject:@(rotation) forKey:@"rotation"];
        self->width = width;
        self->height = height;
        dispatch_to_main_queue(^{
            typeof (weak) strong = weak;
            if (strong != nil) {
                strong(arguments);
            }
        });
    }
}

- (void)frameRendered {
    [registry textureFrameAvailable:tid];
}

@end

#pragma mark *************** [RCRTCViewWrapper] ***************

@interface RCRTCViewWrapper() {
    NSObject<FlutterTextureRegistry> *registry;
    NSObject<FlutterBinaryMessenger> *messenger;
    FlutterMethodChannel *channel;
    NSMutableDictionary<NSNumber *, RCRTCView *> *views;
}

@end

@implementation RCRTCViewWrapper

#pragma mark *************** [N] ***************

- (instancetype)init {
    self = [super init];
    if (self) {
        views = [NSMutableDictionary dictionary];
    }
    return self;
}

SingleInstanceM(Instance);

- (RCRTCView *)getView:(NSInteger)tid {
    return [views objectForKey:[NSNumber numberWithInteger:tid]];
}

- (void)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    registry = [registrar textures];
    messenger = [registrar messenger];
    channel = [FlutterMethodChannel methodChannelWithName:@"cn.rongcloud.rtc.flutter/view"
                                          binaryMessenger:messenger];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)unInit {
    registry = nil;
    messenger = nil;
    for (NSNumber *key in views) {
        RCRTCView *view = views[key];
        [view destroy];
    }
    [views removeAllObjects];
}

#pragma mark *************** [D] ***************

- (void)create:(FlutterResult)result {
    NSInteger code = -1;
    RCRTCView *view = [[RCRTCView alloc] initWithTextureRegistry:registry
                                                       messenger:messenger];
    code = [view textureId];
    [views setObject:view forKey:[NSNumber numberWithInteger:code]];
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)destroy:(FlutterMethodCall *)call result:(FlutterResult)result {
    RCRTCView *view = [views objectForKey:call.arguments];
    if (view != nil) {
        [view destroy];
        [views removeObjectForKey:call.arguments];
    }
    dispatch_to_main_queue(^{
        result(nil);
    });
}

#pragma mark *************** [F] ***************

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [[RCRTCViewWrapper sharedInstance] initWithRegistrar:registrar];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [self unInit];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString* method = [call method];
    if ([method isEqualToString:@"create"]) {
        [self create:result];
    } else if ([method isEqualToString:@"destroy"]) {
        [self destroy:call result:result];
    } else {
        dispatch_to_main_queue(^{
            result(FlutterMethodNotImplemented);
        });
    }
}

@end
