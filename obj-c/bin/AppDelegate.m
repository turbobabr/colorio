//
//  AppDelegate.m
//
//  Created by Andrey on 11/27/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import "AppDelegate.h"
#import "ScreenSnapshot.h"
#import "EyeDropperWindow.h"

@interface AppDelegate ()

@property EyeDropperWindow* eyeDropperWindow;
@property CGDirectDisplayID currentDisplayID;

@property id globalEventMonitor;
@property id localEventMonitor;

@property (nonatomic) KeysInterceptor* keysInterceptor;

@end

@implementation AppDelegate

- (void)updateEyeDropperState {
    
    CGPoint point = [self globalPoint];
    
    [NSCursor hide];
    CGDirectDisplayID displayID = [ScreenSnapshot displayIDAtScreenPoint:point];
    if(self.currentDisplayID != displayID) {
        self.currentDisplayID = displayID;
        if(self.eyeDropperWindow == nil) {
            self.eyeDropperWindow = [[EyeDropperWindow alloc] initWithScrenSnapshot: [ScreenSnapshot screenSnapshotForDisplay:displayID]];
            self.eyeDropperWindow.level = kCGMaximumWindowLevel;
            [self.eyeDropperWindow orderFrontRegardless];
            [self.eyeDropperWindow makeKeyWindow];
        }
        
        self.eyeDropperWindow.snapshot = [ScreenSnapshot screenSnapshotForDisplay:displayID];
        self.eyeDropperWindow.snapshot.screenBounds = CGDisplayBounds(displayID);
    }
    
    [self.eyeDropperWindow mouseMovedTo:point];
}

- (CGPoint)globalPoint {
    NSPoint p = [NSEvent mouseLocation];
    return CGPointMake(roundf(p.x), roundf(p.y));
}

- (void)terminate {
    [[NSApplication sharedApplication] terminate:0];
}

- (void)hideCursorPermanently {
    CFStringRef propertyString = CFStringCreateWithCString(NULL, "SetsCursorInBackground", kCFStringEncodingMacRoman);
    CGSSetConnectionProperty(_CGSDefaultConnection(), _CGSDefaultConnection(), propertyString, kCFBooleanTrue);
    CFRelease(propertyString);
    CGDisplayHideCursor(kCGDirectMainDisplay);
}

- (void)initKeysInterceptor {
    self.keysInterceptor = [[KeysInterceptor alloc] init];
    self.keysInterceptor.delegate = self;
    [self.keysInterceptor registerKeys];
}

- (void)interceptorDidRecieveCancelAction {
    [self emitCancel];
    [self terminate];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    
    [self initKeysInterceptor];
    [self hideCursorPermanently];
    
    [self updateEyeDropperState];
    
    self.globalEventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler:^(NSEvent * event) {
        [NSCursor hide];
        [self updateEyeDropperState];
    }];
    
    self.localEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved|NSEventMaskLeftMouseDown handler:^NSEvent * _Nullable(NSEvent * event) {
        [self updateEyeDropperState];
        
        if(event.type == NSEventTypeLeftMouseDown) {
            [self.eyeDropperWindow orderOut:nil];
            [NSCursor unhide];
            
            [self emitCurrentColor];
            [self terminate];
        }
        
        return event;
    }];
}

- (void)emitCurrentColor {
    CGPoint point = [self globalPoint];
    NSColor* color = [self.eyeDropperWindow.snapshot colorAtPoint:point];
    NSDictionary* res = @{
                          @"result": @"picked",
                          @"color": @{
                                  @"r": @(color.redComponent),
                                  @"g": @(color.greenComponent),
                                  @"b": @(color.blueComponent)
                                  }
                          };
    
    [self emitResponse:res];
}

- (void)emitCancel {
    [self emitResponse:@{ @"result": @"canceled"}];
}

- (void)emitResponse:(NSDictionary*)res {
    NSString* json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:res options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    fprintf(stderr, "%s",[json UTF8String]);
}

@end
