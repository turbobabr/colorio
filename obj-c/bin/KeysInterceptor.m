//
//  KeysInterceptor.m
//
//  Created by Andrey on 11/30/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import "KeysInterceptor.h"
#import <Carbon/Carbon.h>

#define HOT_KEY_ID_ESCAPE 10016

OSStatus onHotKeyEvent(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData)
{
    EventHotKeyID hotkey;
    GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotkey), NULL, &hotkey);
    
    int identifier = hotkey.id;
    [(__bridge KeysInterceptor*)userData handleKeyPress:identifier];
    
    return noErr;
}

@implementation KeysInterceptor

-(void)handleKeyPress:(int)identifier {
    switch (identifier) {
        case HOT_KEY_ID_ESCAPE:
            if(self.delegate) {
                [self.delegate interceptorDidRecieveCancelAction];
            }
            break;
    }
}

-(void)registerKeys {
    EventHotKeyRef gHotKeyRef;
    EventHotKeyID gHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    InstallApplicationEventHandler(&onHotKeyEvent,1,&eventType,(__bridge void*)self,NULL);
    
    gHotKeyID.signature='kir1';
    gHotKeyID.id = HOT_KEY_ID_ESCAPE;
    RegisterEventHotKey(kVK_Escape, 0, gHotKeyID, GetApplicationEventTarget(), 0, &gHotKeyRef);
}

@end


