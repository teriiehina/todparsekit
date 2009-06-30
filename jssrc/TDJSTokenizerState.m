//
//  TDJSTokenizerState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSTokenizerState.h"
#import "TDJSUtils.h"
#import "TDJSToken.h"
#import <ParseKit/TDTokenizerState.h>
#import <ParseKit/TDToken.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTokenizerState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTokenizerState_finalize(JSObjectRef this) {
    TDTokenizerState *data = (TDTokenizerState *)JSObjectGetPrivate(this);
    [data autorelease];
}

static JSStaticFunction TDTokenizerState_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDTokenizerState_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDTokenizerState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.staticFunctions = TDTokenizerState_staticFunctions;
        def.staticValues = TDTokenizerState_staticValues;
        def.initialize = TDTokenizerState_initialize;
        def.finalize = TDTokenizerState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDTokenizerState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDTokenizerState_class(ctx), data);
}
