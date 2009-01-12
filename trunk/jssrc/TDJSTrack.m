//
//  TDJSTrack.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSTrack.h"
#import "TDJSUtils.h"
#import "TDJSSequence.h"
#import <TDParseKit/TDTrack.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTrack_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTrack_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDTrack_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDTrack_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDTrack_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDSequence_class(ctx);
        def.staticFunctions = TDTrack_staticFunctions;
        def.staticValues = TDTrack_staticValues;
        def.initialize = TDTrack_initialize;
        def.finalize = TDTrack_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDTrack_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDTrack_class(ctx), data);
}

JSObjectRef TDTrack_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDTrack *data = [[TDTrack alloc] init];
    return TDTrack_new(ctx, data);
}
