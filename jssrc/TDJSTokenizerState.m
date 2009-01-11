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
#import <TDParseKit/TDTokenizerState.h>
#import <TDParseKit/TDToken.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDTokenizerState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    return TDNSStringToJSValue(ctx, @"[object TDTokenizerState]", ex);
}

//- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t;
//static JSValueRef TDTokenizerState_nextToken(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
//    if (argc < 3) {
//        (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizerState.nextToken() requires 3 arguments: reader, cin, tokenizer", ex);
//        return JSValueToObject(ctx, JSValueMakeUndefined(ctx), ex);
//    }
//
//    JSValueRef v = argv[0];
//    if (!JSValueIsObjectOfClass(ctx, v, TDJSReader_class()) {
//        (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizerState.nextToken() requires a TDReader as the 1st argument", ex);
//    }
//    TDReader *r = JSObjectGetPrivate((JSObjectRef)v);
//
//    v = argv[1];
//
//    if (!TDJSValueIsInstanceOfClass(ctx, v, "String", ex)) {
//        (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizerState.nextToken() requires a string as the 2st argument", ex);
//    }
//                                                             
//    NSInteger cin = TDJSValueGetNSString(ctx, argv[1], ex)
//    TDTokenizer *t = JSObjectGetPrivate(argv[2]);
//    
//    TDTokenizerState *data = JSObjectGetPrivate(this);
//    
//    TDToken *eof = [TDToken EOFToken];
//    TDToken *tok = [data nextTokenFromReader:r startingWith:cin tokenizer:t];
//    
//    if (eof == tok) {
//        return TDToken_getEOFToken(ctx);
//    }
//    
//    return TDToken_new(ctx, tok);
//}

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
{ "toString", TDTokenizerState_toString, kJSPropertyAttributeDontDelete },
//{ "nextToken", TDTokenizerState_nextToken, kJSPropertyAttributeDontDelete },
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

JSObjectRef TDTokenizerState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizerState is an abstract class and may not be instantiated directly", ex);
    return NULL;
}
