//
//  TDJSNum.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDNum_new(JSContextRef ctx, void *data);
JSClassRef TDNum_class(JSContextRef ctx);
JSObjectRef TDNum_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
