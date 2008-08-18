//
//  TODNumberState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODMutableStringState.h"

@interface TODNumberState : TODMutableStringState {
	BOOL gotADigit;
	BOOL negative;
	NSInteger c;
	CGFloat floatValue;
}
@end
