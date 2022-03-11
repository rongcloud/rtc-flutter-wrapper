#import "RCRTCWrapperPlugin.h"
#import "RCRTCEngineWrapper.h"
#import "RCRTCViewWrapper.h"
#import <RongIMLibCore/RongIMLibCore.h>

static NSString * const VER = @"5.1.5+3";

@implementation RCRTCWrapperPlugin

+ (void)load {
    [RCUtilities setModuleName:@"rtcwrapperflutter" version:[self getVersion]];
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [RCRTCEngineWrapper registerWithRegistrar:registrar];
    [RCRTCViewWrapper registerWithRegistrar:registrar];
}

+ (NSString *) getVersion {
    return VER;
}

@end
