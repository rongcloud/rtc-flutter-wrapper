//
//  MainThreadPoster.m
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/11.
//

#import "MainThreadPoster.h"

void dispatch_to_main_queue(dispatch_block_t block) {
    if ([[NSThread currentThread] isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
          block();
        });
    }
}
