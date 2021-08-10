//
//  MainThreadPoster.h
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/11.
//

#ifndef MainThreadPoster_h
#define MainThreadPoster_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

void dispatch_to_main_queue(dispatch_block_t block);

#ifdef __cplusplus
}
#endif

#endif /* MainThreadPoster_h */
