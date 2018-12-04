//
//  ScreenSnapshot.h
//
//  Created by Andrey on 11/28/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenSnapshot : NSObject

+(instancetype)screenSnapshotForDisplay:(CGDirectDisplayID)displayID;
+(CGDirectDisplayID)displayIDAtScreenPoint:(CGPoint)point;

-(NSColor*)colorAtPoint:(NSPoint)point;

@property CGDirectDisplayID displayID;
@property NSImage* image;
@property NSBitmapImageRep* bitmapRep;
@property CGRect screenBounds;

@end

NS_ASSUME_NONNULL_END
