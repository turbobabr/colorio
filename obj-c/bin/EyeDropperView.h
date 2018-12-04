//
//  EyeDropperView.h
//
//  Created by Andrey on 11/28/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScreenSnapshot;

NS_ASSUME_NONNULL_BEGIN

@interface EyeDropperView : NSView

@property(nonatomic) ScreenSnapshot *snapshot;
@property(nonatomic) NSColor* color;

@end

NS_ASSUME_NONNULL_END
