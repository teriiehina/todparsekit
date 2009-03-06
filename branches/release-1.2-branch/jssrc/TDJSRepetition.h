//
//  TDJSRepetition.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDRepetition_new(JSContextRef ctx, void *data);
JSClassRef TDRepetition_class(JSContextRef ctx);
JSObjectRef TDRepetition_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
