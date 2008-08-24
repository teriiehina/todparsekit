//
//  TDSignificantWhitespaceState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDMutableStringState.h>

@interface TDSignificantWhitespaceState : TDMutableStringState {
	NSInteger c;
	NSMutableArray *whitespaceChars;
	NSNumber *yesFlag;
	NSNumber *noFlag;
}
- (BOOL)isWhitespaceChar:(NSInteger)cin;
- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;
@end
