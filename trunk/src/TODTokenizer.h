//
//  TODParseKit.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TODToken;
@class TODTokenizerState;
@class TODNumberState;
@class TODQuoteState;
@class TODSlashState;
@class TODSymbolState;
@class TODWhitespaceState;
@class TODWordState;
@class TODReader;

@interface TODTokenizer : NSObject {
	NSString *string;
	TODReader *reader;
	
	NSMutableArray *tokenizerStates;
	
	//states
	TODNumberState *numberState;
	TODQuoteState *quoteState;
	TODSlashState *slashState;
	TODSymbolState *symbolState;
	TODWhitespaceState *whitespaceState;
	TODWordState *wordState;
}
+ (id)tokenizer;
+ (id)tokenizerWithString:(NSString *)s;

- (id)initWithString:(NSString *)s;
- (TODToken *)nextToken;
- (void)setCharacterState:(TODTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) TODReader *reader;

@property (nonatomic, readonly, retain) TODNumberState *numberState;
@property (nonatomic, readonly, retain) TODQuoteState *quoteState;
@property (nonatomic, readonly, retain) TODSlashState *slashState;
@property (nonatomic, readonly, retain) TODSymbolState *symbolState;
@property (nonatomic, readonly, retain) TODWhitespaceState *whitespaceState;
@property (nonatomic, readonly, retain) TODWordState *wordState;
@end
