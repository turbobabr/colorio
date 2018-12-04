//
//  NSScreen+Utils.m
//
//  Created by Andrey on 12/3/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import "NSScreen+Utils.h"

@implementation NSScreen (Utils)

+ (NSScreen *)currentScreenForMouseLocation
{
    NSPoint mouseLocation = [NSEvent mouseLocation];
    
    NSEnumerator *screenEnumerator = [[NSScreen screens] objectEnumerator];
    NSScreen *screen;
    while ((screen = [screenEnumerator nextObject]) && !NSMouseInRect(mouseLocation, screen.frame, NO))
        ;
    
    return screen;
}

- (NSPoint)convertPointToScreenCoordinates:(NSPoint)aPoint
{
    float normalizedX = fabs(fabs(self.frame.origin.x) - fabs(aPoint.x));
    float normalizedY = aPoint.y - self.frame.origin.y;
    
    return NSMakePoint(normalizedX, normalizedY);
}

- (NSPoint)flipPoint:(NSPoint)aPoint
{
    return NSMakePoint(aPoint.x, self.frame.size.height - aPoint.y);
}

- (BOOL)isRetina {
    return self.backingScaleFactor > 1;
}

+ (CGDirectDisplayID)displayIDForMouseLocation {
    NSScreen* currentScreen = [NSScreen currentScreenForMouseLocation];
    return [currentScreen.deviceDescription[@"NSScreenNumber"] intValue];
}

@end
