//
//  RCRTCIWCodeDefine.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/31.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, RCRTCWrapperCode) {
    RCRTCWrapperCodeSuccess = 0,                           // 成功
    RCRTCWrapperCodeEngineDestroy = -10,                   // 引擎已销毁
    RCRTCWrapperCodeRTCEngineNotInit = -11,                // RTCLib 未初始化
    RCRTCWrapperCodeSwitchCameraError = -12,               // 切换摄像头失败
    RCRTCWrapperCodeLocalUserNotJoinedRTCRoom = -13,       // 本地用户未加入房间
    RCRTCWrapperCodeRemoteUserNotJoinedRTCRoom = -14,      // 远端用户未加入房间
    RCRTCWrapperCodeStartAudioMixError = -15,              // 启动混音失败
    RCRTCWrapperCodeStreamNotExist = -16,                  // 流不存在
    RCRTCWrapperCodeParameterError = -17,                  // 参数错误
    RCRTCWrapperCodeCreateCustomStreamError = -18,         // 创建自定义流失败
    RCRTCWrapperCodeNotSupportYet = -19,                   // 暂不支持
    RCRTCWrapperCodeCustomFileOpenError = -20,             // 自定义视频文件打开失败
};


@interface RCRTCIWCodeDefine : NSObject

+ (NSString *)codeMessage:(NSInteger)code;

@end

