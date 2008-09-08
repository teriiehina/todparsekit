//
//  TDXmlSyntaxColoring.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TDTokenizer;
@class TDToken;

@interface TDXmlSyntaxColoring : NSObject {
	TDTokenizer *tokenizer;
	NSMutableArray *stack;
	TDToken *ltToken;
	TDToken *gtToken;
	TDToken *startCommentToken;
	TDToken *endCommentToken;
	NSMutableAttributedString *coloredString;
	NSDictionary *tagAttributes;
	NSDictionary *textAttributes;
	NSDictionary *attrNameAttributes;
	NSDictionary *attrValueAttributes;
	NSDictionary *eqAttributes;
	NSDictionary *commentAttributes;
}
- (NSAttributedString *)parse:(NSString *)s;

@property (nonatomic, retain) NSMutableAttributedString *coloredString;
@property (nonatomic, retain) NSDictionary *tagAttributes;
@property (nonatomic, retain) NSDictionary *textAttributes;
@property (nonatomic, retain) NSDictionary *attrNameAttributes;
@property (nonatomic, retain) NSDictionary *attrValueAttributes;
@property (nonatomic, retain) NSDictionary *eqAttributes;
@property (nonatomic, retain) NSDictionary *commentAttributes;
@end
