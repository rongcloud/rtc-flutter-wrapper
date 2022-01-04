//
//  RCRTCIWFlutterView.h
//  RongRTCLibWrapper
//
//  Created by 潘铭达 on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWFlutterViewDelegate <NSObject>

- (void)changeSize:(int)width height:(int)height;

- (void)changeRotation:(int)rotation;

- (void)firstFrameRendered;

- (void)frameRendered;

@end

@interface RCRTCIWFlutterView : NSObject

@property (nonatomic, weak) id<RCRTCIWFlutterViewDelegate> textureViewDelegate;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

+ (RCRTCIWFlutterView *)create;

@end

NS_ASSUME_NONNULL_END
