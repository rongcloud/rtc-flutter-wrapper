//
//  RCRTCIWAudioFrame.h
//  RongRTCLibWrapper
//
//  Created by 潘铭达 on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWAudioFrame : NSObject

/*!
 音频数据
 */
@property (assign, nonatomic) uint8_t *_Nonnull bytes;
/*!
 音频数据长度（字节数）
 */
@property (assign, nonatomic) int32_t length;
/*!
 声道数
 */
@property (assign, nonatomic) int32_t channels;
/*!
 采样率
 */
@property (assign, nonatomic) int32_t sampleRate;
/*!
 位深
 */
@property (assign, nonatomic) int32_t bytesPerSample;
/*!
 帧数
 */
@property (assign, nonatomic) int32_t samples;
/*!
 时间戳
 */
@property (assign, nonatomic) uint64_t renderTimeMs;

@end

NS_ASSUME_NONNULL_END
