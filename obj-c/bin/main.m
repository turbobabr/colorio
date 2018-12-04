//
//  main.m
//
//  Created by Andrey on 11/29/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AppDelegate *delegate = [[AppDelegate alloc] init];
        
        NSApplication * application = [NSApplication sharedApplication];
        [application setDelegate:delegate];
        [NSApp run];
    }
    
    return 0;
}
