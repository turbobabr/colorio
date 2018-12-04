//
//  EyeDropperWindow.h
//
//  Created by Andrey on 11/28/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ScreenSnapshot;

@interface EyeDropperWindow : NSWindow

@property ScreenSnapshot* snapshot;

-(instancetype)initWithScrenSnapshot:(ScreenSnapshot*)snapshot;
-(void)mouseMovedTo:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
