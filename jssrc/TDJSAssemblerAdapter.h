//
//  TDJSAssemblerAdapter.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface TDJSAssemblerAdapter : NSObject {
    JSContextRef ctx;
    JSObjectRef jsAssembler;
    NSString *selectorString;
}
- (JSObjectRef)jsAssembler;
- (void)setJsAssembler:(JSObjectRef)a fromContext:(JSContextRef)c;

@property (nonatomic, copy) NSString *selectorString;
@end
