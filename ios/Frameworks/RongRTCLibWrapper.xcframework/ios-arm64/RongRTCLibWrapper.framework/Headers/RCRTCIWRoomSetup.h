//
//  RCRTCIWRoomConfig.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWRoomSetup : NSObject

/*!
 媒体类型, 默认: RCRTCIWMediaTypeAudioVideo
 */
@property (nonatomic, assign) RCRTCIWMediaType mediaType;

/*!
 用户角色, 默认: RCRTCIWRoleMeetingMember
 */
@property (nonatomic, assign) RCRTCIWRole role;

/**
 用户进行多端登录时的加入策略
 */
@property (nonatomic, assign) RCRTCIWJoinType joinType;

@end

NS_ASSUME_NONNULL_END
