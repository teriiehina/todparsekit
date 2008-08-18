//
//  TODMutableStringState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODTokenizerState.h"

@interface TODMutableStringState : TODTokenizerState {
	NSMutableString *stringbuf;
}
- (void)reset;

@property (nonatomic, retain) NSMutableString *stringbuf;
@end
