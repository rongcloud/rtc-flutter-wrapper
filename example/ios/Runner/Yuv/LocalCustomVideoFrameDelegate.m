//
//  LocalCustomVideoFrameDelegate.m
//  Runner
//
//  Created by 潘铭达 on 2021/9/23.
//

#import "LocalCustomVideoFrameDelegate.h"

@interface LocalCustomVideoFrameDelegate()

@property (nonatomic, strong, nullable) NSFileHandle *timeWriter;
@property (nonatomic, assign) NSInteger frameCount;

@end

@implementation LocalCustomVideoFrameDelegate

- (instancetype)initWithRoomId:(NSString *)roomId
                        hostId:(NSString *)hostId
                        userId:(NSString *)userId
                           tag:(NSString *)tag {
    self = [super init];
    if (self) {
        _roomId = roomId;
        _hostId = hostId;
        _userId = userId;
        _tag = tag;
        
        NSString *base = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        long current = (long) ([[NSDate date] timeIntervalSince1970] * 1000);
        NSString *path = [NSString stringWithFormat:@"%@/RongCloud/%@@%ld/%@/%@/",
                                            base, roomId, current, hostId, userId];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        NSString *time = [NSString stringWithFormat:@"%@%@", path, @"sendTime.txt"];
        if (![fileManager fileExistsAtPath:time]) {
            [fileManager createFileAtPath:time
                                 contents:nil
                               attributes:nil];
        }
        self.timeWriter = [NSFileHandle fileHandleForUpdatingAtPath:time];
        
        self.frameCount = 0;
    }
    return self;
}

- (void)destroy {
    if (self.timeWriter) {
        [self.timeWriter closeFile];
        self.timeWriter = nil;
    }
}

- (CMSampleBufferRef)onSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    self.frameCount++;
    long current = (long) ([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *data = [NSString stringWithFormat:@",%zd,%ld", self.frameCount, current];
    [self.timeWriter writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    return sampleBuffer;
}

@end
