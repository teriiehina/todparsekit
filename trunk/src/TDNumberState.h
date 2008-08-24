//
//  TDNumberState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDMutableStringState.h>

@interface TDNumberState : TDMutableStringState {
	BOOL gotADigit;
	BOOL negative;
	NSInteger c;
	CGFloat floatValue;
}
@end
