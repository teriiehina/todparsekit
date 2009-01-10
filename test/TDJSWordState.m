//
//  TDJSWordState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSWordState.h"
#import "TDJSUtils.h"
#import "TDJSTokenizerState.h"
#import <TDParseKit/TDWordState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDWordState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    return TDNSStringToJSValue(ctx, @"[object TDWordState]", ex);
}

//- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;
static JSValueRef TDWordState_setWordChars(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 3) {
        (*ex) = TDNSStringToJSValue(ctx, @"TDWordState.setWordChars() requires 3 arguments: yn, start, end", ex);
        return JSValueMakeUndefined(ctx);
    }

    BOOL yn = JSValueToBoolean(ctx, argv[0]);
    NSString *start = TDJSValueGetNSString(ctx, argv[1], ex);
    NSString *end = TDJSValueGetNSString(ctx, argv[2], ex);
    
    TDWordState *data = JSObjectGetPrivate(this);
    [data setWordChars:yn from:[start characterAtIndex:0] to:[end characterAtIndex:0]];
    
    return JSValueMakeUndefined(ctx);
}

//- (BOOL)isWordChar:(NSInteger)c;
static JSValueRef TDWordState_isWordChar(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 1) {
        (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizer.isWordChar() requires 1 argument: c", ex);
        return JSValueMakeUndefined(ctx);
    }
    
    NSInteger c = (NSInteger)JSValueToNumber(ctx, argv[0], ex);
    
    TDWordState *data = JSObjectGetPrivate(this);
    BOOL yn = [data isWordChar:c];
    
    return JSValueMakeBoolean(ctx, yn);
}

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDWordState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDWordState_finalize(JSObjectRef this) {
    TDTokenizer *data = (TDTokenizer *)JSObjectGetPrivate(this);
    [data release];
}

//- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;
//- (BOOL)isWordChar:(NSInteger)c;
static JSStaticFunction TDWordState_staticFunctions[] = {
{ "toString", TDWordState_toString, kJSPropertyAttributeDontDelete },
{ "setWordChars", TDWordState_setWordChars, kJSPropertyAttributeDontDelete },
{ "isWordChar", TDWordState_isWordChar, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDWordState_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDWordState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDWordState_staticFunctions;
        def.staticValues = TDWordState_staticValues;
        def.initialize = TDWordState_initialize;
        def.finalize = TDWordState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDWordState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDWordState_class(ctx), data);
}

JSObjectRef TDWordState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDWordState *data = [[TDWordState alloc] init];
    return TDWordState_new(ctx, data);
}
