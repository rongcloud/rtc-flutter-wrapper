//
//  ArgumentAdapter.m
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/11.
//

#import "ArgumentAdapter.h"

RCRTCIWMediaType toMediaType(int type) {
    return (RCRTCIWMediaType) type;
}

RCRTCIWCamera toCamera(int camera) {
    return (RCRTCIWCamera) (camera - 1);
}

RCRTCIWCameraCaptureOrientation toCameraCaptureOrientation(int orientation) {
    return (RCRTCIWCameraCaptureOrientation) (orientation + 1);
}

RCRTCIWLiveMixLayoutMode toLiveMixLayoutMode(int mode) {
    return (RCRTCIWLiveMixLayoutMode) (mode + 1);
}

RCRTCIWLiveMixRenderMode toLiveMixRenderMode(int mode) {
    return (RCRTCIWLiveMixRenderMode) (mode + 1);
}

RCRTCIWVideoResolution toVideoResolution(int resolution) {
    return (RCRTCIWVideoResolution) resolution;
}

RCRTCIWVideoFps toVideoFps(int fps) {
    return (RCRTCIWVideoFps) fps;
}

RCRTCIWAudioMixingMode toAudioMixingMode(int mode) {
    return (RCRTCIWAudioMixingMode) mode;
}

RCRTCIWAudioCodecType toAudioCodecType(int type) {
    switch (type) {
        case 1:
            return RCRTCIWAudioCodecTypeOPUS;
        default:
            return RCRTCIWAudioCodecTypePCMU;
    }
}

RCRTCIWRole toRole(int role) {
    return (RCRTCIWRole) role;
}

RCRTCIWAudioQuality toAudioQuality(int quality) {
    switch (quality) {
        case 1:
            return RCRTCIWAudioQualityMusic;
        case 2:
            return RCRTCIWAudioQualityMusicHigh;
        default:
            return RCRTCIWAudioQualitySpeech;
    }
}

RCRTCIWAudioScenario toAudioScenario(int scenario) {
    return (RCRTCIWAudioScenario) scenario;
}

RCRTCIWAudioSetup *toAudioSetup(NSDictionary *arguments) {
    int codec = [arguments[@"codec"] intValue];
    RCRTCIWAudioSetup *setup = [[RCRTCIWAudioSetup alloc] init];
    setup.type = toAudioCodecType(codec);
    return setup;
}

RCRTCIWVideoSetup *toVideoSetup(NSDictionary *arguments) {
    bool enableTinyStream = [arguments[@"enableTinyStream"] boolValue];
    RCRTCIWVideoSetup *setup = [[RCRTCIWVideoSetup alloc] init];
    setup.enableTinyStream = enableTinyStream;
    return setup;
}

RCRTCIWEngineSetup *toEngineSetup(NSDictionary *arguments) {
    bool reconnectable = [arguments[@"reconnectable"] boolValue];
    int statsReportInterval = [arguments[@"statsReportInterval"] intValue];
    id mediaUrl = arguments[@"mediaUrl"];
    id audioSetup = arguments[@"audioSetup"];
    id videoSetup = arguments[@"videoSetup"];
    RCRTCIWEngineSetup *setup = [[RCRTCIWEngineSetup alloc] init];
    setup.reconnectable = reconnectable;
    setup.statsReportInterval = statsReportInterval;
    if (![mediaUrl isEqual:[NSNull null]]) {
        setup.mediaUrl = mediaUrl;
    }
    if (![audioSetup isEqual:[NSNull null]]) {
        setup.audioSetup = toAudioSetup(audioSetup);
    }
    if (![videoSetup isEqual:[NSNull null]]) {
        setup.videoSetup = toVideoSetup(videoSetup);
    }
    return setup;
}

RCRTCIWRoomSetup *toRoomSetup(NSDictionary *arguments) {
    int type = [arguments[@"type"] intValue];
    int role = [arguments[@"role"] intValue];
    RCRTCIWRoomSetup *setup = [[RCRTCIWRoomSetup alloc] init];
    setup.type = toMediaType(type);
    setup.role = toRole(role);
    return setup;
}

RCRTCIWAudioConfig *toAudioConfig(NSDictionary *arguments) {
    int quality = [arguments[@"quality"] intValue];
    int scenario = [arguments[@"scenario"] intValue];
    RCRTCIWAudioConfig *config = [[RCRTCIWAudioConfig alloc] init];
    config.quality = toAudioQuality(quality);
    config.scenario = toAudioScenario(scenario);
    return config;
}

RCRTCIWVideoConfig *toVideoConfig(NSDictionary *arguments) {
    int minBitrate = [arguments[@"minBitrate"] intValue];
    int maxBitrate = [arguments[@"maxBitrate"] intValue];
    int fps = [arguments[@"fps"] intValue];
    int resolution = [arguments[@"resolution"] intValue];
    bool mirror = [arguments[@"mirror"] boolValue];
    RCRTCIWVideoConfig *config = [[RCRTCIWVideoConfig alloc] init];
    config.minBitrate = minBitrate;
    config.maxBitrate = maxBitrate;
    config.fps = toVideoFps(fps);
    config.resolution = toVideoResolution(resolution);
    config.mirror = mirror;
    return config;
}

RCRTCIWCustomLayout *toLiveMixCustomLayout(NSDictionary *arguments) {
    NSString *uid = arguments[@"id"];
    int x = [arguments[@"x"] intValue];
    int y = [arguments[@"y"] intValue];
    int width = [arguments[@"width"] intValue];
    int height = [arguments[@"height"] intValue];
    RCRTCIWCustomLayout *layout = [[RCRTCIWCustomLayout alloc] init];
    layout.userId = uid;
    layout.x = x;
    layout.y = y;
    layout.width = width;
    layout.height = height;
    return layout;
}

NSArray<RCRTCIWCustomLayout *> *toLiveMixCustomLayouts(NSArray<NSDictionary *> *arguments) {
    NSMutableArray *layouts = [NSMutableArray array];
    for (NSDictionary *argument in arguments) {
        [layouts addObject:toLiveMixCustomLayout(argument)];
    }
    return layouts;
}

NSDictionary *fromNetworkStats(RCRTCIWNetworkStats *stats) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@((int) stats.type) forKey:@"type"];
    [dictionary setObject:stats.ip forKey:@"ip"];
    [dictionary setObject:@(stats.sendBitrate) forKey:@"sendBitrate"];
    [dictionary setObject:@(stats.receiveBitrate) forKey:@"receiveBitrate"];
    [dictionary setObject:@(stats.rtt) forKey:@"rtt"];
    return dictionary;
}

int fromAudioCodecType(RCRTCIWAudioCodecType type) {
    switch (type) {
        case RCRTCIWAudioCodecTypePCMU:
            return 0;
        default:
            return 1;
    }
}

NSDictionary *fromLocalAudioStats(RCRTCIWLocalAudioStats *stats) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@(fromAudioCodecType(stats.codec)) forKey:@"codec"];
    [dictionary setObject:@(stats.bitrate) forKey:@"bitrate"];
    [dictionary setObject:@(stats.volume) forKey:@"volume"];
    [dictionary setObject:@(stats.packageLostRate) forKey:@"packageLostRate"];
    [dictionary setObject:@(stats.rtt) forKey:@"rtt"];
    return dictionary;
}

NSDictionary *fromLocalVideoStats(RCRTCIWLocalVideoStats *stats) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@(stats.tiny) forKey:@"tiny"];
    [dictionary setObject:@((int) stats.codec) forKey:@"codec"];
    [dictionary setObject:@(stats.bitrate) forKey:@"bitrate"];
    [dictionary setObject:@(stats.fps) forKey:@"fps"];
    [dictionary setObject:@(stats.width) forKey:@"width"];
    [dictionary setObject:@(stats.height) forKey:@"height"];
    [dictionary setObject:@(stats.packageLostRate) forKey:@"packageLostRate"];
    [dictionary setObject:@(stats.rtt) forKey:@"rtt"];
    return dictionary;
}

NSDictionary *fromRemoteAudioStats(RCRTCIWRemoteAudioStats *stats) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:stats.userId forKey:@"id"];
    [dictionary setObject:@(fromAudioCodecType(stats.codec)) forKey:@"codec"];
    [dictionary setObject:@(stats.bitrate) forKey:@"bitrate"];
    [dictionary setObject:@(stats.volume) forKey:@"volume"];
    [dictionary setObject:@(stats.packageLostRate) forKey:@"packageLostRate"];
    [dictionary setObject:@(stats.rtt) forKey:@"rtt"];
    return dictionary;
}

NSDictionary *fromRemoteVideoStats(RCRTCIWRemoteVideoStats *stats) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:stats.userId forKey:@"id"];
    [dictionary setObject:@((int) stats.codec) forKey:@"codec"];
    [dictionary setObject:@(stats.bitrate) forKey:@"bitrate"];
    [dictionary setObject:@(stats.fps) forKey:@"fps"];
    [dictionary setObject:@(stats.width) forKey:@"width"];
    [dictionary setObject:@(stats.height) forKey:@"height"];
    [dictionary setObject:@(stats.packageLostRate) forKey:@"packageLostRate"];
    [dictionary setObject:@(stats.rtt) forKey:@"rtt"];
    return dictionary;
}
