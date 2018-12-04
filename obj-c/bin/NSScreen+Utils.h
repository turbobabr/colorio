//
//  NSScreen+Utils.h
//
//  Created by Andrey on 12/3/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScreen (Utils)

+ (NSScreen *)currentScreenForMouseLocation;
+ (CGDirectDisplayID)displayIDForMouseLocation;
- (NSPoint)convertPointToScreenCoordinates:(NSPoint)aPoint;
- (NSPoint)flipPoint:(NSPoint)aPoint;
- (BOOL)isRetina;

@end

NS_ASSUME_NONNULL_END
