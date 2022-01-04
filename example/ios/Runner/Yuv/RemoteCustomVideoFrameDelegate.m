#import "RemoteCustomVideoFrameDelegate.h"

@interface RemoteCustomVideoFrameDelegate()

@property (nonatomic, strong, nullable) NSOutputStream *yuvOutputStream;
@property (nonatomic, strong, nullable) NSOutputStream *yuvTagOutputStream;
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
        
        NSString *yuvTag = [NSString stringWithFormat:@"%@%@", path, @"recvTag.yuv"];
        self.yuvTagOutputStream = [NSOutputStream outputStreamToFileAtPath:yuvTag append:YES];
        [self.yuvTagOutputStream open];
        
        NSString *time = [NSString stringWithFormat:@"%@%@", path, @"recvTime.txt"];
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
    if (self.yuvTagOutputStream) {
        [self.yuvTagOutputStream close];
        self.yuvTagOutputStream = nil;
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
    size_t length = width * height * 3 / 2;
    
    void *y = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    void *uv = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t yBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    size_t uvBytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);
    
    void *data = malloc(length);
    void *yOffset = data;
    void *uvOffset = yOffset + width * height;
    for (int i = 0; i < height; i++) {
        memcpy(yOffset + width * i, y + yBytesPerRow * i, width);
        if (i < height / 2) {
            memcpy(uvOffset + width * i, uv + uvBytesPerRow * i, width);
        }
    }
    [self.yuvOutputStream write:data maxLength:length];
    free(data);
    
    float zoomWidth = width / 1280.0f;
    if (zoomWidth > 1) {
        zoomWidth = 1.0f;
    }
    float zoomHeight = height / 720.0f;
    if (zoomHeight > 1) {
        zoomHeight = 1.0f;
    }
    int tagWidth = round(240 * zoomWidth);
    int tagHeight = round(60 * zoomHeight);
    int tagLength = tagWidth * tagHeight * 3 / 2;
    void *tagData = malloc(tagLength);
    void *tagYOffset = tagData;
    void *tagUvOffset = tagYOffset + tagWidth * tagHeight;
    for (int i = 0; i < tagHeight; i++) {
        memcpy(tagYOffset + tagWidth * i, y + yBytesPerRow * i, tagWidth);
        if (i < tagHeight / 2) {
            memcpy(tagUvOffset + tagWidth * i, uv + uvBytesPerRow * i, tagWidth);
        }
    }
    [self.yuvTagOutputStream write:tagData maxLength:tagLength];
    free(tagData);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    long current = (long) ([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *time = [NSString stringWithFormat:@",%ld,%ld,%ld", current, width, height];
    [self.timeWriter writeData:[time dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
