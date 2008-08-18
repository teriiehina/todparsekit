//
//  TODWordState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODMutableStringState.h"

@interface TODWordState : TODMutableStringState {
	NSMutableArray *wordChars;
	NSNumber *yesFlag;
	NSNumber *noFlag;
}
- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;
- (BOOL)isWordChar:(NSInteger)c;
@end
