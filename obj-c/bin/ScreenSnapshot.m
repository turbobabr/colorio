//
//  ScreenSnapshot.m
//
//  Created by Andrey on 11/28/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScreenSnapshot.h"
#import "NSScreen+Utils.h"

@implementation ScreenSnapshot

+(CGDirectDisplayID)displayIDAtScreenPoint:(CGPoint)point {
    return [NSScreen displayIDForMouseLocation];
}

+(instancetype)screenSnapshotForDisplay:(CGDirectDisplayID)displayID {
    CGImageRef displayImageRef = CGDisplayCreateImage(displayID);
    if(displayImageRef == NULL) {
        return nil;
    }
    
    NSBitmapImageRep* bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:displayImageRef];
    NSImage* image = [[NSImage alloc] initWithSize:bitmapRep.size];
    [image addRepresentation:bitmapRep];
    
    CGImageRelease(displayImageRef);
    
    ScreenSnapshot* snapshot = [[ScreenSnapshot alloc] init];
    snapshot.displayID = displayID;
    snapshot.image = image;
    snapshot.bitmapRep = bitmapRep;
    
    return snapshot;
}

-(CGPoint)pointRound:(CGPoint)point {
    return CGPointMake(floorf(point.x),floorf(point.y));
}

-(NSColor*)colorAtPoint:(NSPoint)point {
    NSScreen* currentScreen = [NSScreen currentScreenForMouseLocation];
    
    NSPoint screenPoint = [currentScreen flipPoint:[currentScreen convertPointToScreenCoordinates:[NSEvent mouseLocation]]];
    CGFloat scale = [currentScreen isRetina] ? 2 : 1;
    
    screenPoint.x = screenPoint.x * scale;
    screenPoint.y = screenPoint.y * scale;
    
    screenPoint = [self pointRound:screenPoint];
    NSColor* color = [self.bitmapRep colorAtX:screenPoint.x y:screenPoint.y];
    return [color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
}

@end
