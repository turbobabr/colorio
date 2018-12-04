//
//  AppDelegate.h
//
//  Created by Andrey on 11/29/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "KeysInterceptor.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : NSObject <NSApplicationDelegate,KeysInterceptorDelegate>

@end

NS_ASSUME_NONNULL_END
