//
//  TDJSDelimitState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDDelimitState_new(JSContextRef ctx, void *data);
JSClassRef TDDelimitState_class(JSContextRef ctx);
JSObjectRef TDDelimitState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
