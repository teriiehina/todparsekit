//
//  TDJSParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSParser.h"
#import "TDJSUtils.h"
#import "TDJSAssemblerAdapter.h"
#import <TDParseKit/TDParser.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDParser_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDWordState_class, "toString");
    return TDNSStringToJSValue(ctx, @"[object TDParser]", ex);
}

//static JSValueRef TDParser_setWordChars(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
//    if (argc < 3) {
//        (*ex) = TDNSStringToJSValue(ctx, @"TDWordState.setWordChars() requires 3 arguments: yn, start, end", ex);
//        return JSValueMakeUndefined(ctx);
//    }
//    
//    BOOL yn = JSValueToBoolean(ctx, argv[0]);
//    NSString *start = TDJSValueGetNSString(ctx, argv[1], ex);
//    NSString *end = TDJSValueGetNSString(ctx, argv[2], ex);
//    
//    TDWordState *data = JSObjectGetPrivate(this);
//    [data setWordChars:yn from:[start characterAtIndex:0] to:[end characterAtIndex:0]];
//    
//    return JSValueMakeUndefined(ctx);
//}

#pragma mark -
#pragma mark Properties

static JSValueRef TDParser_getAssembler(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDParser *data = JSObjectGetPrivate(this);
    return [[data JSAdapter] assemblerFunction];
}

static bool TDParser_setAssembler(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    if (!JSValueIsObject(ctx, value) || !JSObjectIsFunction(ctx, (JSObjectRef)value)) {
        (*ex) = TDNSStringToJSValue(ctx, @"only a function object can be set as a parser's assembler property", ex);
        return false;
    }
    
    TDParser *data = JSObjectGetPrivate(this);
    TDJSAssemblerAdapter *adapter = [[TDJSAssemblerAdapter alloc] init];
    [adapter setAssemblerFunction:(JSObjectRef)value fromContext:ctx];
    data.JSAdapter = adapter;
    [adapter release];
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDParser_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDParser_finalize(JSObjectRef this) {
    TDParser *data = (TDParser *)JSObjectGetPrivate(this);
    [data autorelease];
}

static JSStaticFunction TDParser_staticFunctions[] = {
{ "toString", TDParser_toString, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDParser_staticValues[] = {        
{ "assembler", TDParser_getAssembler, TDParser_setAssembler, kJSPropertyAttributeDontDelete }, // Function
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDParser_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
//        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDParser_staticFunctions;
        def.staticValues = TDParser_staticValues;
        def.initialize = TDParser_initialize;
        def.finalize = TDParser_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDParser_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDParser_class(ctx), data);
}

JSObjectRef TDParser_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDParser *data = [[TDParser alloc] init];
    return TDParser_new(ctx, data);
}
