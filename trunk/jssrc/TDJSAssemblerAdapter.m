//
//  TDJSAssemblerAdapter.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSAssemblerAdapter.h"
#import "TDJSUtils.h"
#import <TDParseKit/TDAssembly.h>
#import <TDParseKit/TDTokenAssembly.h>
#import <TDParseKit/TDCharacterAssembly.h>

@implementation TDJSAssemblerAdapter

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}


- (void)dealloc {
    [self setAssemblerFunction:NULL fromContext:NULL];
    [super dealloc];
}


- (void)workOn:(TDAssembly *)a {
    JSValueRef arg = NULL;
    if ([a isMemberOfClass:[TDTokenAssembly class]]) {
        arg = (JSValueRef)TDTokenAssembly_new(ctx, a);
    } else if ([a isMemberOfClass:[TDCharacterAssembly class]]) {
        arg = (JSValueRef)TDCharacterAssembly_new(ctx, a);
    } else {
        NSAssert(0, @"Should not reach here.");
    }
    
    JSValueRef argv[] = { arg };
    JSObjectRef globalObj = JSContextGetGlobalObject(ctx);
    JSValueRef ex = NULL;
    JSObjectCallAsFunction(ctx, assemblerFunction, globalObj, 1, argv, &ex);
    if (ex) {
        NSString *s = TDJSValueGetNSString(ctx, ex, NULL);
        [NSException raise:@"TDJSException" format:s];
    }
}


- (JSObjectRef)assemblerFunction {
    return assemblerFunction;
}


- (void)setAssemblerFunction:(JSObjectRef)f fromContext:(JSContextRef)c {
    if (assemblerFunction != f) {
        if (ctx && assemblerFunction) {
            JSValueUnprotect(ctx, assemblerFunction);
            JSGarbageCollect(ctx);
        }
        
        ctx = c;
        assemblerFunction = f;
        if (ctx && assemblerFunction) {
            JSValueProtect(ctx, assemblerFunction);
        }
    }
}

@end
