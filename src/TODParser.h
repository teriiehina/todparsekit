//
//  TODParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TODAssembly;

@interface NSString (TODParseKitAdditions)
- (NSString *)stringByRemovingFirstAndLastCharacters;
@end

@interface TODParser : NSObject {
	id assembler;
	SEL selector;
	NSString *name;
}
+ (id)parser;
- (void)setAssembler:(id)a selector:(SEL)sel;

- (TODAssembly *)bestMatchFor:(TODAssembly *)inAssembly;
- (TODAssembly *)completeMatchFor:(TODAssembly *)inAssembly;

@property (nonatomic, retain) id assembler;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSString *name;
@end
