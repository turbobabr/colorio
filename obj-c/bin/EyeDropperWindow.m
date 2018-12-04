//
//  EyeDropperWindow.m
//
//  Created by Andrey on 11/28/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import "EyeDropperWindow.h"
#import "EyeDropperView.h"
#import "ScreenSnapshot.h"

@implementation EyeDropperWindow

-(instancetype)initWithScrenSnapshot:(ScreenSnapshot*)snapshot {
    self = [super initWithContentRect:CGRectZero styleMask:0x2 backing:0 defer:YES];
    
    if(self) {
        self.snapshot = snapshot;
        
        self.backgroundColor = NSColor.clearColor;
        [self setOpaque:NO];
        [self setAcceptsMouseMovedEvents:YES];
        self.level = CGWindowLevelForKey(0xd);
        
        EyeDropperView* view = [[EyeDropperView alloc] initWithFrame:CGRectZero];
        view.snapshot = snapshot;
        self.contentView = view;        
    }
    
    return self;
}

-(void)mouseMovedTo:(CGPoint)point {
    int width = 190;
    int height = 190;
    
    EyeDropperView* view = (EyeDropperView*)self.contentView;
    view.snapshot = self.snapshot;
    view.color = [self.snapshot colorAtPoint:point];
    [view setNeedsDisplay:YES];
    
    NSPoint pt = [NSEvent mouseLocation];
    pt.x = floorf(pt.x);
    pt.y = floorf(pt.y);
    
    CGRect rect = CGRectMake(pt.x - width / 2, pt.y - height / 2, width, height);
    [self setFrame:NSRectFromCGRect(rect) display:YES];
}

-(BOOL)canBecomeMainWindow {
    return YES;
}

-(BOOL)canBecomeKeyWindow {
    return YES;
}

-(BOOL)acceptsFirstResponder {
    return TRUE;
}

-(void)mouseMoved:(NSEvent *)event {    
}

@end
