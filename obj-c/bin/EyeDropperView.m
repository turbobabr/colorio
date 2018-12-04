//
//  EyeDropperView.m
//
//  Created by Andrey on 11/28/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import "EyeDropperView.h"
#import "ScreenSnapshot.h"
#import "NSScreen+Utils.h"

@implementation EyeDropperView

int blockSize = 10;

-(CGPoint)pointRound:(CGPoint)point {    
    return CGPointMake(floorf(point.x),floorf(point.y));
}

-(BOOL)isOpaque {
    return YES;
}

-(BOOL)isFlipped {
    return NO;
}

-(void)drawGrid:(NSGraphicsContext*)context {
    [context saveGraphicsState];
    [[[NSColor blackColor] colorWithAlphaComponent:0.1] set];
    
    for(int i=0;i<19;i++) {
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(i * blockSize+0.5, 0)];
        [path lineToPoint:NSMakePoint(i * blockSize+0.5, 190)];
        [path closePath];
        
        [path stroke];
    }
    
    for(int i=0;i<19;i++) {
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(0,i * blockSize + 0.5)];
        [path lineToPoint:NSMakePoint(19 * blockSize,i * blockSize + 0.5)];
        [path closePath];
        
        [path stroke];
    }
    
    [context restoreGraphicsState];
}

-(void)drawFocusPixel:(NSGraphicsContext*)context {
    [context saveGraphicsState];
    [[[NSColor blackColor] colorWithAlphaComponent:1] set];
    
    NSRect rect = NSMakeRect(9*blockSize+0.5, 9*blockSize+0.5, blockSize, blockSize);
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:rect];
    [path stroke];
    
    NSRect outerRect = NSMakeRect(rect.origin.x - 1, rect.origin.y - 1, rect.size.width + 2, rect.size.height + 2);
    NSBezierPath* outerPath = [NSBezierPath bezierPathWithRect:outerRect];
    [[[NSColor whiteColor] colorWithAlphaComponent:1] set];
    [outerPath stroke];
    
    [context restoreGraphicsState];
}

-(NSString*)colorToHumanRedableRGBRep:(NSColor*)color {
    NSString* hex = [NSString stringWithFormat:@"%02X%02X%02X",
     (int) (color.redComponent * 0xFF), (int) (color.greenComponent * 0xFF),
     (int) (color.blueComponent * 0xFF)];
    
    return [NSString stringWithFormat:@"R:%i G:%i B:%i #%@",(int)roundf(color.redComponent * 255),(int)roundf(color.greenComponent * 255),(int)roundf(color.blueComponent * 255),hex];
}

-(NSRect)rectExpand:(NSRect)rect cx:(CGFloat)cx cy:(CGFloat)cy {
    return NSMakeRect(rect.origin.x-cx, rect.origin.y-cy, rect.size.width + cx*2, rect.size.height + cy * 2);
}

-(void)drawInfoLabel:(NSGraphicsContext*)context {
    [context saveGraphicsState];
    
    NSString* str = [self colorToHumanRedableRGBRep:self.color];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* attrs = @{
                            NSParagraphStyleAttributeName: paragraphStyle,
                            NSFontAttributeName: [NSFont systemFontOfSize:11 weight:NSFontWeightRegular],
                            NSForegroundColorAttributeName: [NSColor whiteColor]
                            };
    
    NSSize size = [str sizeWithAttributes:attrs];
    
    NSRect textRect = NSMakeRect(self.frame.size.width / 2 - size.width / 2, 61, size.width, size.height);
    NSRect backgroundRect = [self rectExpand:textRect cx:5 cy:3];
    
    NSColor* backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.8];
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:backgroundRect xRadius:4 yRadius:4];
    [backgroundColor set];
    [path fill];
    
    [str drawInRect:textRect withAttributes:attrs];
    
    [context restoreGraphicsState];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    
    [[NSColor clearColor] set];
    NSRectFill(rect);
    
    NSGraphicsContext* context = [NSGraphicsContext currentContext];
    NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:self.frame];
    
    NSScreen* currentScreen = [NSScreen currentScreenForMouseLocation];
    NSPoint cursorPoint = [currentScreen convertPointToScreenCoordinates:[NSEvent mouseLocation]];
    
    CGFloat scale = [currentScreen isRetina] ? 2 : 1;
    cursorPoint.x = cursorPoint.x * scale;
    cursorPoint.y = cursorPoint.y * scale;
    
    cursorPoint = [self pointRound:cursorPoint];
    CGRect cropRect = CGRectMake(cursorPoint.x - 9, cursorPoint.y - 9, 19, 19);
    
    NSImage* image = self.snapshot.image;
    
    [context saveGraphicsState];
    [path setClip];
    context.imageInterpolation = NSImageInterpolationNone;
    context.shouldAntialias = NO;
    [image drawInRect:NSMakeRect(0, 0, 19 * blockSize, 19 * blockSize) fromRect:cropRect operation:NSCompositingOperationCopy fraction:1];
    [self drawGrid:context];
    context.shouldAntialias = YES;
    [context restoreGraphicsState];
    [self drawFocusPixel:context];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.5] set];
    [path stroke];
    
    if(self.color) {
        [self drawInfoLabel:context];
    }
}

@end
