//
//  KeysInterceptor.h
//
//  Created by Andrey on 11/30/18.
//  Copyright © 2018 Turbobabr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeysInterceptorDelegate <NSObject>

-(void)interceptorDidRecieveCancelAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KeysInterceptor : NSObject

@property (nonatomic) id <KeysInterceptorDelegate> delegate;
-(void)registerKeys;
-(void)handleKeyPress:(int)identifier;

@end

NS_ASSUME_NONNULL_END
