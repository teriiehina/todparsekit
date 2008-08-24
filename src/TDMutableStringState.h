//
//  TDMutableStringState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizerState.h>

@interface TDMutableStringState : TDTokenizerState {
	NSMutableString *stringbuf;
}
- (void)reset;

@property (nonatomic, retain) NSMutableString *stringbuf;
@end
