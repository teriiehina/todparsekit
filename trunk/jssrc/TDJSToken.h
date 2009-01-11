//
//  TDJSToken.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDToken_new(JSContextRef ctx, void *data);
JSClassRef TDToken_class(JSContextRef ctx);
JSObjectRef TDToken_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);

// a JS Class method
//JSValueRef TDToken_EOFToken(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef* ex);

// a JS Class property
JSValueRef TDToken_getEOFToken(JSContextRef ctx);
