//
//  PKJSTrack.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDTrack_new(JSContextRef ctx, void *data);
JSClassRef TDTrack_class(JSContextRef ctx);
JSObjectRef TDTrack_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
