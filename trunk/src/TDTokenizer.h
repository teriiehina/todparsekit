//
//  TDParseKit.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;
@class TDTokenizerState;
@class TDNumberState;
@class TDQuoteState;
@class TDSlashState;
@class TDSymbolState;
@class TDWhitespaceState;
@class TDWordState;
@class TDReader;

@interface TDTokenizer : NSObject {
	NSString *string;
	TDReader *reader;
	
	NSMutableArray *tokenizerStates;
	
	//states
	TDNumberState *numberState;
	TDQuoteState *quoteState;
	TDSlashState *slashState;
	TDSymbolState *symbolState;
	TDWhitespaceState *whitespaceState;
	TDWordState *wordState;
}
+ (id)tokenizer;
+ (id)tokenizerWithString:(NSString *)s;

- (id)initWithString:(NSString *)s;
- (TDToken *)nextToken;
- (void)setCharacterState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;

@property (nonatomic, copy) NSString *string;

@property (nonatomic, readonly, retain) TDNumberState *numberState;
@property (nonatomic, readonly, retain) TDQuoteState *quoteState;
@property (nonatomic, readonly, retain) TDSlashState *slashState;
@property (nonatomic, readonly, retain) TDSymbolState *symbolState;
@property (nonatomic, readonly, retain) TDWhitespaceState *whitespaceState;
@property (nonatomic, readonly, retain) TDWordState *wordState;
@end
