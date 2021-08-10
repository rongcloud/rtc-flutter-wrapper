#import <Foundation/Foundation.h>
#import "GPUImageBeautyFilter.h"
#import "GPUImageOutputCamera.h"


/*!
 GPUImage 的封装类
 在该类可以实现自己的美颜效果,返回 CMSampleBufferRef 对象
 */

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageHandle : NSObject

- (CMSampleBufferRef)onGPUFilterSource:(CMSampleBufferRef)sampleBuffer;

- (void)rotateWaterMark:(BOOL)isAdd;

// 切换美颜滤镜
- (void)onlyBeauty;

// 添加水印
- (void)onlyWaterMark;

// 添加水印的美颜
- (void)beautyAndWaterMark;

@end

NS_ASSUME_NONNULL_END
