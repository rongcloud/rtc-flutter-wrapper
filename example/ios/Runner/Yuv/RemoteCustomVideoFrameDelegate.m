#import "RemoteCustomVideoFrameDelegate.h"

@interface RemoteCustomVideoFrameDelegate()

@property (nonatomic, strong, nullable) NSOutputStream *yuvOutputStream;
@property (nonatomic, strong, nullable) NSFileHandle *timeWriter;
@property (nonatomic, strong, nullable) NSFileHandle *fpsWriter;
@property (nonatomic, strong, nullable) NSFileHandle *bitrateWriter;

@end

@implementation RemoteCustomVideoFrameDelegate

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
        
        NSString *yuv = [NSString stringWithFormat:@"%@%@", path, @"recv.yuv"];
        self.yuvOutputStream = [NSOutputStream outputStreamToFileAtPath:yuv append:YES];
        [self.yuvOutputStream open];
        
        NSString *time = [NSString stringWithFormat:@"%@%@", path, @"sendTime.txt"];
        if (![fileManager fileExistsAtPath:time]) {
            [fileManager createFileAtPath:time
                                 contents:nil
                               attributes:nil];
        }
        self.timeWriter = [NSFileHandle fileHandleForUpdatingAtPath:time];
        
        NSString *fps = [NSString stringWithFormat:@"%@%@", path, @"fps.txt"];
        if (![fileManager fileExistsAtPath:fps]) {
            [fileManager createFileAtPath:fps
                                 contents:nil
                               attributes:nil];
        }
        self.fpsWriter = [NSFileHandle fileHandleForUpdatingAtPath:fps];
        
        NSString *bitrate = [NSString stringWithFormat:@"%@%@", path, @"bitrate.txt"];
        if (![fileManager fileExistsAtPath:bitrate]) {
            [fileManager createFileAtPath:bitrate
                                 contents:nil
                               attributes:nil];
        }
        self.bitrateWriter = [NSFileHandle fileHandleForUpdatingAtPath:bitrate];
    }
    return self;
}

- (void)writeFps:(NSString *)fps {
    NSString *data = [NSString stringWithFormat:@",%@", fps];
    [self.fpsWriter writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)writeBitrate:(NSString *)bitrate {
    NSString *data = [NSString stringWithFormat:@",%@", bitrate];
    [self.bitrateWriter writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)destroy {
    if (self.yuvOutputStream) {
        [self.yuvOutputStream close];
        self.yuvOutputStream = nil;
    }
    if (self.timeWriter) {
        [self.timeWriter closeFile];
        self.timeWriter = nil;
    }
    if (self.fpsWriter) {
        [self.fpsWriter closeFile];
        self.fpsWriter = nil;
    }
    if (self.bitrateWriter) {
        [self.bitrateWriter closeFile];
        self.bitrateWriter = nil;
    }
}

- (void)onPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    NSLog(@"width = %ld, height = %ld", width, height);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
//    size_t bytesPerPixel = bytesPerRow / width;
    size_t length = bytesPerRow * height;
    void *address = CVPixelBufferGetBaseAddress(pixelBuffer);
    [self.yuvOutputStream write:address maxLength:length];
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    long current = (long) ([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *time = [NSString stringWithFormat:@",%ld,%ld,%ld", width, height, current];
    [self.timeWriter writeData:[time dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
