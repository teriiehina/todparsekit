//
//  PKJSPattern.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 6/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDPattern_new(JSContextRef ctx, void *data);
JSClassRef TDPattern_class(JSContextRef ctx);
JSObjectRef TDPattern_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
