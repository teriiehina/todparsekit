//
//  TDJSTokenizerState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDTokenizerState_new(JSContextRef ctx, void *data);
JSClassRef TDTokenizerState_class(JSContextRef ctx);
JSObjectRef TDTokenizerState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
