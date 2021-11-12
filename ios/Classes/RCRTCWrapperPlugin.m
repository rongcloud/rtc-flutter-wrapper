#import "RCRTCWrapperPlugin.h"
#import "RCRTCEngineWrapper.h"
#import "RCRTCViewWrapper.h"

static NSString * const VER = @"5.1.2";

@implementation RCRTCWrapperPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [RCRTCEngineWrapper registerWithRegistrar:registrar];
    [RCRTCViewWrapper registerWithRegistrar:registrar];
}

+ (NSString *) getVersion {
    return VER;
}

@end
